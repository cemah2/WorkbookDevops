#!/usr/bin/env bash
# break/gitops/01-argocd-destination-forbidden.sh — fiche 01 Argo CD (panne optionnelle).
# Remplace les destinations de l'AppProject par une destination qui ne correspond à aucune Application.
# Usage : ./01-argocd-destination-forbidden.sh [--undo|--reveal]
# Variables : ARGOCD_NS (argocd), PROJECT (lab).
set -euo pipefail
ARGOCD_NS="${ARGOCD_NS:-argocd}"
PROJECT="${PROJECT:-lab}"
ANNOT="break.workbook/01-orig-destinations"

reveal() {
  cat <<'TXT'
Panne : spec.destinations de l'AppProject ne contient plus que le namespace « nowhere ». Les destinations d'origine
sont gardées dans l'annotation break.workbook/01-orig-destinations du projet.
Symptôme : chaque Application du projet affiche une condition InvalidSpecError disant que sa destination
(serveur + namespace) n'est pas permise dans le projet ; la sync est refusée. Rien n'a changé dans les Applications
ni dans Git : c'est la politique qui a bougé.
Diagnostic : `argocd app get <app>` (CONDITIONS), puis `argocd proj get <projet>` ou `kubectl -n argocd get appproject <projet> -o yaml`.
Correction : remettre les destinations dans le projet (jamais en passant l'Application dans le projet default), ou `--undo`.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    orig=$(kubectl -n "$ARGOCD_NS" get appproject "$PROJECT" -o jsonpath="{.metadata.annotations.$(printf '%s' "$ANNOT" | sed 's/\./\\./g')}")
    if [ -z "$orig" ]; then echo "undo: pas d'annotation $ANNOT, rien à faire"; exit 0; fi
    kubectl -n "$ARGOCD_NS" patch appproject "$PROJECT" --type merge -p "{\"spec\":{\"destinations\":$orig}}"
    kubectl -n "$ARGOCD_NS" annotate appproject "$PROJECT" "$ANNOT-"
    echo "undo: destinations d'origine restaurées sur le projet $PROJECT"
    ;;
  "")
    if kubectl -n "$ARGOCD_NS" get appproject "$PROJECT" -o jsonpath="{.metadata.annotations}" | grep -q "$ANNOT"; then
      echo "panne déjà injectée (annotation $ANNOT présente)"; exit 0
    fi
    orig=$(kubectl -n "$ARGOCD_NS" get appproject "$PROJECT" -o jsonpath='{.spec.destinations}')
    [ -z "$orig" ] && orig='[]'
    kubectl -n "$ARGOCD_NS" annotate appproject "$PROJECT" "$ANNOT=$orig"
    kubectl -n "$ARGOCD_NS" patch appproject "$PROJECT" --type merge \
      -p '{"spec":{"destinations":[{"server":"https://kubernetes.default.svc","namespace":"nowhere"}]}}'
    echo "panne injectée sur le projet $PROJECT (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
