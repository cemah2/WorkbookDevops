#!/usr/bin/env bash
# break/gitops/01-argocd-app-degraded.sh — fiche 01 Argo CD.
# Coupe la sync automatique de l'Application, puis casse l'image du Deployment vivant (drift manuel).
# Usage : ./01-argocd-app-degraded.sh [--undo|--reveal]
# Variables : ARGOCD_NS (argocd), APP (guestbook), APP_NS (guestbook), DEPLOY (guestbook-ui), CONTAINER (guestbook-ui).
set -euo pipefail
ARGOCD_NS="${ARGOCD_NS:-argocd}"
APP="${APP:-guestbook}"
APP_NS="${APP_NS:-guestbook}"
DEPLOY="${DEPLOY:-guestbook-ui}"
CONTAINER="${CONTAINER:-guestbook-ui}"
ANNOT="break.workbook/01-orig-syncpolicy"

reveal() {
  cat <<'TXT'
Panne : (1) la syncPolicy de l'Application a été mise à vide (sync manuelle), la politique d'origine est gardée dans
l'annotation break.workbook/01-orig-syncpolicy ; (2) l'image du Deployment vivant a été remplacée par un tag inexistant
et progressDeadlineSeconds abaissé à 30 s. Git n'a pas changé.
Symptôme : OutOfSync (le cluster a dérivé de Git) et Degraded (ProgressDeadlineExceeded, pods en ImagePullBackOff).
Une sync manuelle remet l'image de Git et répare la health, mais l'auto-sync/selfHeal reste coupée : c'est le
second problème à voir.
Diagnostic : `argocd app get <app>` (sync + health + conditions), `argocd app diff <app>`, `kubectl -n <ns> get pods`.
Correction : `argocd app sync <app>` puis restaurer la syncPolicy (`argocd app set <app> --sync-policy automated …`
selon ce qui était en place), ou `--undo`.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    orig=$(kubectl -n "$ARGOCD_NS" get application "$APP" -o jsonpath="{.metadata.annotations.$(printf '%s' "$ANNOT" | sed 's/\./\\./g')}")
    kubectl -n "$APP_NS" rollout undo deployment "$DEPLOY" || true
    kubectl -n "$APP_NS" patch deployment "$DEPLOY" --type json \
      -p '[{"op":"remove","path":"/spec/progressDeadlineSeconds"}]' || true
    if [ -n "$orig" ]; then
      kubectl -n "$ARGOCD_NS" patch application "$APP" --type merge -p "{\"spec\":{\"syncPolicy\":$orig}}"
      kubectl -n "$ARGOCD_NS" annotate application "$APP" "$ANNOT-"
    fi
    echo "undo: image restaurée, syncPolicy d'origine remise sur $APP ; lance 'argocd app sync $APP' pour finir"
    ;;
  "")
    if kubectl -n "$ARGOCD_NS" get application "$APP" -o jsonpath="{.metadata.annotations}" | grep -q "$ANNOT"; then
      echo "panne déjà injectée (annotation $ANNOT présente)"; exit 0
    fi
    orig=$(kubectl -n "$ARGOCD_NS" get application "$APP" -o jsonpath='{.spec.syncPolicy}')
    [ -z "$orig" ] && orig='{}'
    kubectl -n "$ARGOCD_NS" annotate application "$APP" "$ANNOT=$orig"
    kubectl -n "$ARGOCD_NS" patch application "$APP" --type merge -p '{"spec":{"syncPolicy":{}}}'
    kubectl -n "$APP_NS" patch deployment "$DEPLOY" --type merge -p '{"spec":{"progressDeadlineSeconds":30}}'
    kubectl -n "$APP_NS" set image deployment "$DEPLOY" "$CONTAINER=gcr.io/google-samples/gb-frontend:does-not-exist"
    echo "panne injectée sur $APP / $APP_NS/$DEPLOY (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
