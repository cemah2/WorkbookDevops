#!/usr/bin/env bash
# break/gitops/08-gitops-reconciliation-stalled.sh — fiche 08 OpenGitOps.
# Porte timeout.reconciliation à 24h dans argocd-cm et redémarre le contrôleur : le pull périodique s'arrête.
# Usage : ./08-gitops-reconciliation-stalled.sh [--undo|--reveal]
# Variables : ARGOCD_NS (argocd).
set -euo pipefail
ARGOCD_NS="${ARGOCD_NS:-argocd}"
ANNOT="break.workbook/08-orig-timeout"
KEY="timeout.reconciliation"

reveal() {
  cat <<'TXT'
Panne : la clé timeout.reconciliation d'argocd-cm vaut 24h (la valeur d'origine, ou « absent » si la clé n'existait
pas, est gardée dans l'annotation break.workbook/08-orig-timeout de la ConfigMap) et le contrôleur a été redémarré.
Symptôme : un commit poussé n'est jamais déployé ; `argocd app get demo-pull --hard-refresh` le voit et le déploie
une fois, puis plus rien jusqu'au prochain refresh manuel. Les webhooks (fiche 10) sont une fausse piste : il n'y
en a pas sur le lab, c'est le pull périodique qui a été coupé.
Principe violé : « Continuously Reconciled » et « Pulled Automatically » : l'agent n'observe plus le store.
« Continuous » ne veut pas dire instantané, mais 24 h n'est plus continu au sens de l'exploitation.
Diagnostic : `kubectl -n argocd get cm argocd-cm -o yaml | grep timeout`, `argocd app get demo-pull` (champ
reconciledAt qui n'avance plus), logs du contrôleur.
Correction : remettre la clé (120s par défaut, ou la retirer) et redémarrer argocd-application-controller, ou --undo.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    orig=$(kubectl -n "$ARGOCD_NS" get cm argocd-cm -o jsonpath="{.metadata.annotations.break\.workbook/08-orig-timeout}")
    if [ -z "$orig" ]; then echo "undo: aucune annotation $ANNOT, rien à faire"; exit 0; fi
    if [ "$orig" = "absent" ]; then
      kubectl -n "$ARGOCD_NS" patch cm argocd-cm --type json -p "[{\"op\":\"remove\",\"path\":\"/data/$KEY\"}]"
    else
      kubectl -n "$ARGOCD_NS" patch cm argocd-cm --type merge -p "{\"data\":{\"$KEY\":\"$orig\"}}"
    fi
    kubectl -n "$ARGOCD_NS" annotate cm argocd-cm "$ANNOT-"
    kubectl -n "$ARGOCD_NS" rollout restart statefulset/argocd-application-controller
    echo "undo: $KEY restauré ($orig), contrôleur redémarré"
    ;;
  "")
    if [ -n "$(kubectl -n "$ARGOCD_NS" get cm argocd-cm -o jsonpath="{.metadata.annotations.break\.workbook/08-orig-timeout}")" ]; then
      echo "panne déjà injectée (annotation $ANNOT présente)"; exit 0
    fi
    orig=$(kubectl -n "$ARGOCD_NS" get cm argocd-cm -o jsonpath="{.data.timeout\.reconciliation}")
    kubectl -n "$ARGOCD_NS" annotate cm argocd-cm "$ANNOT=${orig:-absent}"
    kubectl -n "$ARGOCD_NS" patch cm argocd-cm --type merge -p "{\"data\":{\"$KEY\":\"24h\"}}"
    kubectl -n "$ARGOCD_NS" rollout restart statefulset/argocd-application-controller
    echo "panne injectée : pull périodique coupé (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
