#!/usr/bin/env bash
# break/gitops/01-argocd-repo-server-down.sh — fiche 01 Argo CD.
# Usage : ./01-argocd-repo-server-down.sh            injecte la panne (idempotent)
#         ./01-argocd-repo-server-down.sh --undo     retire la panne
#         ./01-argocd-repo-server-down.sh --reveal   explique la panne (ne touche à rien)
# Variables : ARGOCD_NS (défaut argocd).
set -euo pipefail
ARGOCD_NS="${ARGOCD_NS:-argocd}"
DEPLOY="argocd-repo-server"

reveal() {
  cat <<'TXT'
Panne : le Deployment argocd-repo-server est à 0 réplica.
Pourquoi ça casse : c'est lui qui clone les dépôts et rend les manifests. Sans lui, le contrôleur ne peut plus
comparer Git au cluster : refresh en échec, ComparisonError, `argocd app manifests` KO. L'UI et l'API (argocd-server)
répondent toujours, le cluster applicatif n'est pas touché : c'est ce qui rend le symptôme trompeur.
Diagnostic : `argocd app get <app> --refresh` (condition ComparisonError), puis `kubectl -n argocd get deploy`.
Correction : `kubectl -n argocd scale deploy argocd-repo-server --replicas=1` (ou `--undo`).
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    kubectl -n "$ARGOCD_NS" scale deploy "$DEPLOY" --replicas=1
    kubectl -n "$ARGOCD_NS" rollout status deploy "$DEPLOY" --timeout=120s
    echo "undo: $DEPLOY remis à 1 réplica"
    ;;
  "")
    kubectl -n "$ARGOCD_NS" scale deploy "$DEPLOY" --replicas=0
    echo "panne injectée : $DEPLOY à 0 réplica (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
