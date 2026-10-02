#!/usr/bin/env bash
# break/gitops/02-argo-workflows-controller-down.sh — fiche 02 Argo Workflows.
# Usage : ./02-argo-workflows-controller-down.sh            injecte la panne (idempotent)
#         ./02-argo-workflows-controller-down.sh --undo     retire la panne
#         ./02-argo-workflows-controller-down.sh --reveal   explique la panne (ne touche à rien)
# Variables : ARGO_NS (défaut argo).
set -euo pipefail
ARGO_NS="${ARGO_NS:-argo}"
DEPLOY="workflow-controller"

reveal() {
  cat <<'TXT'
Panne : le Deployment workflow-controller est à 0 réplica.
Pourquoi ça casse : c'est lui qui lit les Workflow et crée un pod par étape. Sans lui, `argo submit` est accepté
(l'objet Workflow est bien créé dans l'API Kubernetes) mais rien ne le prend en charge : phase vide ou Pending, aucun pod.
argo-server, lui, répond : l'UI affiche le workflow, ce qui rend le symptôme trompeur.
Diagnostic : `argo get <wf>` (pas de nœud, pas de pod), puis `kubectl -n argo get deploy` et `kubectl -n argo get events`.
Correction : `kubectl -n argo scale deploy workflow-controller --replicas=1` (ou `--undo`) ; les workflows en attente
démarrent tout seuls, rien à resoumettre.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    kubectl -n "$ARGO_NS" scale deploy "$DEPLOY" --replicas=1
    kubectl -n "$ARGO_NS" rollout status deploy "$DEPLOY" --timeout=120s
    echo "undo: $DEPLOY remis à 1 réplica"
    ;;
  "")
    kubectl -n "$ARGO_NS" scale deploy "$DEPLOY" --replicas=0
    echo "panne injectée : $DEPLOY à 0 réplica (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
