#!/usr/bin/env bash
# break/kubernetes/01-pod-crashloop.sh — fiche 01 kubectl, Pods et namespaces.
# Remplace le Pod `api` par une version dont le conteneur sort en erreur au démarrage.
# Usage : ./01-pod-crashloop.sh            injecte la panne (idempotent)
#         ./01-pod-crashloop.sh --undo     retire la panne (recrée le Pod sain)
#         ./01-pod-crashloop.sh --reveal   explique la panne (ne touche à rien)
# Variables : NS (défaut shop), POD (défaut api), IMAGE (défaut nginx:1.29).
set -euo pipefail
NS="${NS:-shop}"
POD="${POD:-api}"
IMAGE="${IMAGE:-nginx:1.29}"
ANNOT="break.workbook/01-pod-crashloop"

reveal() {
  cat <<'TXT'
Panne : le Pod `api` a été recréé avec une commande qui écrit un message et sort avec le code 1. restartPolicy vaut
Always (défaut) : le kubelet relance le conteneur avec un délai qui double à chaque fois (10 s, 20 s, 40 s… plafonné
à 5 min). C'est l'état de conteneur CrashLoopBackOff ; la phase du Pod reste Running.
Diagnostic : `kubectl get pod api` (colonne RESTARTS qui monte), `kubectl describe pod api` (Last State: Terminated,
Reason: Error, Exit Code: 1), puis `kubectl logs api --previous` : la cause est écrite dans les logs du conteneur
précédent. Les événements ne disent que « Back-off restarting failed container ».
Correction : corriger la commande du Pod (un Pod ne se modifie pas : `kubectl replace --force -f` ou delete + run),
ou `--undo`.
TXT
}

healthy() {
  kubectl -n "$NS" run "$POD" --image="$IMAGE" --port=80 --labels="app=$POD,tier=backend" --env=MODE=dev
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    kubectl -n "$NS" delete pod "$POD" --ignore-not-found --now >/dev/null
    healthy >/dev/null
    echo "undo: Pod $NS/$POD recréé sain ($IMAGE)"
    ;;
  "")
    if [ "$(kubectl -n "$NS" get pod "$POD" -o jsonpath="{.metadata.annotations.break\.workbook/01-pod-crashloop}" 2>/dev/null)" = "true" ]; then
      echo "panne déjà injectée (annotation $ANNOT présente)"; exit 0
    fi
    kubectl get ns "$NS" >/dev/null 2>&1 || kubectl create ns "$NS" >/dev/null
    kubectl -n "$NS" delete pod "$POD" --ignore-not-found --now >/dev/null
    kubectl -n "$NS" run "$POD" --image="$IMAGE" --port=80 --labels="app=$POD,tier=backend" --env=MODE=dev \
      --annotations="$ANNOT=true" \
      --command -- sh -c 'echo "fatal: config file /etc/api/config.yaml not found (MODE=$MODE)"; exit 1' >/dev/null
    echo "panne injectée sur $NS/$POD (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
