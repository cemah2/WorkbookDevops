#!/usr/bin/env bash
# break/gitops/02-argo-workflows-quota.sh — fiche 02 Argo Workflows (panne optionnelle).
# Usage : ./02-argo-workflows-quota.sh            injecte la panne (idempotent)
#         ./02-argo-workflows-quota.sh --undo     retire la panne
#         ./02-argo-workflows-quota.sh --reveal   explique la panne (ne touche à rien)
# Variables : ARGO_NS (défaut argo).
set -euo pipefail
ARGO_NS="${ARGO_NS:-argo}"
QUOTA="break-no-pods"

reveal() {
  cat <<'TXT'
Panne : une ResourceQuota `break-no-pods` limite le namespace à 2 pods, déjà consommés par workflow-controller
et argo-server.
Pourquoi ça casse : le contrôleur tourne et prend bien le workflow, mais chaque création de pod est refusée par
l'API (« exceeded quota »). Le workflow reste Running avec des nœuds Pending ; le contrôleur réessaie en boucle.
Diagnostic : `argo get <wf>` (nœud Pending, message « exceeded quota » ou vide), `kubectl -n argo get events --sort-by=.lastTimestamp`
(FailedCreate … forbidden: exceeded quota), `kubectl -n argo describe quota`.
Correction : `kubectl -n argo delete resourcequota break-no-pods` (ou `--undo`) ; les nœuds en attente démarrent seuls.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    kubectl -n "$ARGO_NS" delete resourcequota "$QUOTA" --ignore-not-found
    echo "undo: ResourceQuota $QUOTA supprimée"
    ;;
  "")
    kubectl -n "$ARGO_NS" apply -f - <<YAML
apiVersion: v1
kind: ResourceQuota
metadata:
  name: $QUOTA
spec:
  hard:
    pods: "2"
YAML
    echo "panne injectée : ResourceQuota $QUOTA (pods: 2) (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
