#!/usr/bin/env bash
# break/gitops/08-gitops-push-direct.sh — fiche 08 OpenGitOps.
# Installe un CronJob discret (« cache-warmer ») qui réapplique toutes les minutes un état obsolète sur le
# Deployment géré par Argo CD : un push caché à côté du pull.
# Usage : ./08-gitops-push-direct.sh [--undo|--reveal]
# Variables : APP_NS (demo-pull), DEPLOY (web), CI_NS (ci-legacy), KUBECTL_IMAGE (alpine/k8s:1.37.1).
set -euo pipefail
APP_NS="${APP_NS:-demo-pull}"
DEPLOY="${DEPLOY:-web}"
CI_NS="${CI_NS:-ci-legacy}"
KUBECTL_IMAGE="${KUBECTL_IMAGE:-alpine/k8s:1.37.1}"
NAME="cache-warmer"

reveal() {
  cat <<'TXT'
Panne : un CronJob nommé cache-warmer dans le namespace ci-legacy tourne toutes les minutes avec un ServiceAccount
autorisé à patcher les Deployments de demo-pull. Il force replicas=3 sur le Deployment web. Git n'a pas changé.
Symptôme : avec selfHeal, l'Application demo-pull alterne OutOfSync / Synced environ toutes les minutes et
`argocd app diff demo-pull` montre toujours le même écart (replicas) ; sans selfHeal elle reste OutOfSync et une
sync manuelle ne tient pas 60 s. Activer selfHeal ne règle rien : le push caché continue.
Principe violé : « Pulled Automatically » et « Continuously Reconciled » ne tiennent que si personne ne pousse à côté
de l'agent. Le système n'est plus « GitOps managed » : une partie de l'état désiré vit dans un CronJob, pas dans le store.
Diagnostic : `kubectl -n demo-pull get events --sort-by=.lastTimestamp`, `kubectl -n demo-pull get deploy web -o yaml`
(managedFields : qui a écrit replicas ?), `kubectl get cronjobs -A`, RoleBindings qui visent demo-pull.
Correction : supprimer le CronJob et son RBAC (ou --undo), puis laisser Argo CD réparer ; vérifier 5 min de Synced.
TXT
}

manifests() {
  cat <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: ${CI_NS}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${NAME}
  namespace: ${CI_NS}
  labels: {break.workbook/08: push-direct}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: ${NAME}
  namespace: ${APP_NS}
  labels: {break.workbook/08: push-direct}
rules:
  - apiGroups: [apps]
    resources: [deployments]
    verbs: [get, patch]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${NAME}
  namespace: ${APP_NS}
  labels: {break.workbook/08: push-direct}
subjects:
  - kind: ServiceAccount
    name: ${NAME}
    namespace: ${CI_NS}
roleRef:
  kind: Role
  name: ${NAME}
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: ${NAME}
  namespace: ${CI_NS}
  labels: {break.workbook/08: push-direct}
spec:
  schedule: "* * * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 1
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      backoffLimit: 0
      template:
        spec:
          serviceAccountName: ${NAME}
          restartPolicy: Never
          containers:
            - name: kubectl
              image: ${KUBECTL_IMAGE}
              command: [kubectl, -n, ${APP_NS}, scale, deployment, ${DEPLOY}, --replicas=3]
YAML
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    kubectl -n "$CI_NS" delete cronjob,serviceaccount -l break.workbook/08=push-direct --ignore-not-found
    kubectl -n "$APP_NS" delete rolebinding,role -l break.workbook/08=push-direct --ignore-not-found
    kubectl -n "$APP_NS" scale deployment "$DEPLOY" --replicas=1 >/dev/null 2>&1 || true
    echo "undo: CronJob $NAME et son RBAC supprimés ; Argo CD remet replicas depuis Git au prochain cycle"
    ;;
  "")
    if kubectl -n "$CI_NS" get cronjob "$NAME" >/dev/null 2>&1; then
      echo "panne déjà injectée (CronJob $NAME présent)"; exit 0
    fi
    if ! kubectl -n "$APP_NS" get deployment "$DEPLOY" >/dev/null 2>&1; then
      echo "pas de Deployment $DEPLOY dans $APP_NS : déploie demo-pull d'abord (section 1)" >&2; exit 1
    fi
    manifests | kubectl apply -f - >/dev/null
    kubectl -n "$CI_NS" create job --from=cronjob/"$NAME" "$NAME-now" >/dev/null 2>&1 || true
    echo "panne injectée : un push caché tourne toutes les minutes (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
