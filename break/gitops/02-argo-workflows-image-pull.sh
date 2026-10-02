#!/usr/bin/env bash
# break/gitops/02-argo-workflows-image-pull.sh — fiche 02 Argo Workflows.
# Usage : ./02-argo-workflows-image-pull.sh            injecte la panne : soumet un workflow dont la première
#                                                      étape utilise une image inexistante (idempotent)
#         ./02-argo-workflows-image-pull.sh --undo     supprime ce workflow
#         ./02-argo-workflows-image-pull.sh --reveal   explique la panne (ne touche à rien)
# Variables : ARGO_NS (défaut argo), WF_NAME (défaut lifecycle-broken).
set -euo pipefail
ARGO_NS="${ARGO_NS:-argo}"
WF_NAME="${WF_NAME:-lifecycle-broken}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$HERE/../../fiches/gitops/02-argo-workflows-fondamentaux/manifests/wf-04-lifecycle.yaml"

reveal() {
  cat <<'TXT'
Panne : un workflow `lifecycle-broken` dont le template `slow` référence l'image busybox:does-not-exist.
Pourquoi ça casse : le contrôleur crée le pod, mais kubelet ne peut pas tirer l'image : le pod reste en
ImagePullBackOff, le nœud est Pending puis Error après le délai de l'executor ; le workflow reste Running.
`argo get` ne montre pas la cause : elle est côté pod.
Diagnostic : `argo get lifecycle-broken` (nœud step-a Pending/Error), puis `kubectl -n argo get pods` (ImagePullBackOff),
`kubectl -n argo describe pod <pod>` (événement « Failed to pull image »).
Correction : corriger le tag dans le manifest (jamais en patchant le pod) et resoumettre : `argo resubmit` ne suffit pas,
le spec du workflow est faux. `--undo` supprime le workflow cassé.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    kubectl -n "$ARGO_NS" delete workflow "$WF_NAME" --ignore-not-found
    echo "undo: workflow $WF_NAME supprimé"
    ;;
  "")
    test -f "$MANIFEST"
    kubectl -n "$ARGO_NS" delete workflow "$WF_NAME" --ignore-not-found >/dev/null
    sed -e 's/^  generateName: lifecycle-$/  name: '"$WF_NAME"'/' \
        -e '0,/image: busybox:1.37/s//image: busybox:does-not-exist/' "$MANIFEST" \
      | kubectl -n "$ARGO_NS" create -f -
    echo "panne injectée : workflow $WF_NAME soumis (--reveal pour l'explication, --undo pour nettoyer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
