#!/usr/bin/env bash
# break/gitops/02-argo-workflows-rbac.sh — fiche 02 Argo Workflows.
# Usage : ./02-argo-workflows-rbac.sh            injecte la panne (idempotent)
#         ./02-argo-workflows-rbac.sh --undo     retire la panne
#         ./02-argo-workflows-rbac.sh --reveal   explique la panne (ne touche à rien)
# Variables : ARGO_NS (défaut argo), ROLE (défaut wf-executor, créé par manifests/rbac-executor.yaml).
set -euo pipefail
ARGO_NS="${ARGO_NS:-argo}"
ROLE="${ROLE:-wf-executor}"

reveal() {
  cat <<'TXT'
Panne : le Role wf-executor n'autorise plus que `get` sur workflowtaskresults (plus de `create` ni `patch`).
Pourquoi ça casse : depuis la 3.4, le conteneur `wait` (executor emissary) publie le résultat de chaque étape dans un
WorkflowTaskResult. Sans le droit de le créer, `main` termine bien (Completed) mais `wait` échoue : le nœud passe en Error,
les outputs.parameters ne remontent jamais et l'étape suivante ne reçoit rien.
Diagnostic : `argo get <wf>` (message du nœud : « workflowtaskresults.argoproj.io is forbidden »), puis
`kubectl -n argo logs <pod> -c wait` et `kubectl -n argo describe role wf-executor`.
Correction : `kubectl apply -f fiches/gitops/02-argo-workflows-fondamentaux/manifests/rbac-executor.yaml` (ou `--undo`),
puis `argo retry <wf>`.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    kubectl -n "$ARGO_NS" patch role "$ROLE" --type=json \
      -p='[{"op":"replace","path":"/rules/0/verbs","value":["create","patch"]}]'
    echo "undo: Role $ROLE rétabli (create, patch sur workflowtaskresults)"
    ;;
  "")
    kubectl -n "$ARGO_NS" get role "$ROLE" >/dev/null
    kubectl -n "$ARGO_NS" patch role "$ROLE" --type=json \
      -p='[{"op":"replace","path":"/rules/0/verbs","value":["get"]}]'
    echo "panne injectée : Role $ROLE sans create/patch (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
