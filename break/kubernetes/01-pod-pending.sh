#!/usr/bin/env bash
# break/kubernetes/01-pod-pending.sh — fiche 01 kubectl, Pods et namespaces.
# Remplace le Pod `worker` par une version qui exige un nœud étiqueté disk=ssd, qu'aucun nœud ne porte.
# Usage : ./01-pod-pending.sh            injecte la panne (idempotent)
#         ./01-pod-pending.sh --undo     retire la panne (recrée le Pod sain)
#         ./01-pod-pending.sh --reveal   explique la panne (ne touche à rien)
# Variables : NS (défaut shop), POD (défaut worker), IMAGE (défaut busybox:1.37).
set -euo pipefail
NS="${NS:-shop}"
POD="${POD:-worker}"
IMAGE="${IMAGE:-busybox:1.37}"
ANNOT="break.workbook/01-pod-pending"

reveal() {
  cat <<'TXT'
Panne : le Pod `worker` a été recréé avec `spec.nodeSelector: {disk: ssd}`. Aucun nœud ne porte ce label : le
scheduler ne trouve pas de nœud, le Pod reste en phase Pending, aucun conteneur n'est créé, donc pas de logs.
Diagnostic : `kubectl describe pod worker` → Events : `FailedScheduling … 0/3 nodes are available: 3 node(s) didn't
match Pod's node affinity/selector`, et la section Node-Selectors. Un Pod Pending se lit dans describe/events,
jamais dans logs.
Correction : retirer le nodeSelector (`kubectl replace --force` d'un YAML corrigé, ou delete + run), ou étiqueter
un nœud (`kubectl label node <nœud> disk=ssd`, à éviter : on corrige le Pod, pas le cluster), ou `--undo`.
TXT
}

healthy() {
  kubectl -n "$NS" run "$POD" --image="$IMAGE" --labels="app=$POD,tier=backend" \
    -- sh -c 'while true; do date; sleep 5; done'
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    kubectl -n "$NS" delete pod "$POD" --ignore-not-found --now >/dev/null
    healthy >/dev/null
    echo "undo: Pod $NS/$POD recréé sain ($IMAGE)"
    ;;
  "")
    if [ "$(kubectl -n "$NS" get pod "$POD" -o jsonpath="{.metadata.annotations.break\.workbook/01-pod-pending}" 2>/dev/null)" = "true" ]; then
      echo "panne déjà injectée (annotation $ANNOT présente)"; exit 0
    fi
    kubectl get ns "$NS" >/dev/null 2>&1 || kubectl create ns "$NS" >/dev/null
    kubectl -n "$NS" delete pod "$POD" --ignore-not-found --now >/dev/null
    kubectl -n "$NS" run "$POD" --image="$IMAGE" --labels="app=$POD,tier=backend" --annotations="$ANNOT=true" \
      --overrides='{"spec":{"nodeSelector":{"disk":"ssd"}}}' \
      -- sh -c 'while true; do date; sleep 5; done' >/dev/null
    echo "panne injectée sur $NS/$POD (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
