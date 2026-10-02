#!/usr/bin/env bash
# break/kubernetes/01-kubeconfig-casse.sh — fiche 01 kubectl, Pods et namespaces.
# Casse le port du serveur API du cluster courant dans le kubeconfig. Le cluster, lui, va très bien.
# Usage : ./01-kubeconfig-casse.sh            injecte la panne (idempotent)
#         ./01-kubeconfig-casse.sh --undo     retire la panne
#         ./01-kubeconfig-casse.sh --reveal   explique la panne (ne touche à rien)
# Variables : KUBECONFIG (défaut ~/.kube/config). Sauvegarde : <kubeconfig>.break01.bak
set -euo pipefail
CFG="${KUBECONFIG:-$HOME/.kube/config}"
BAK="${CFG}.break01.bak"
BAD_PORT="6444"

reveal() {
  cat <<'TXT'
Panne : dans le kubeconfig, l'URL `server:` du cluster courant pointe sur le port 6444 au lieu du vrai port.
Pourquoi ça casse : kubectl ne « connaît » le cluster que par ce fichier. Un mauvais port, un mauvais hôte ou un
certificat qui ne correspond pas, et tout `kubectl` échoue avec `connection refused` ou un message TLS, alors que
le cluster tourne (Docker/kind ou kubelet n'ont rien).
Diagnostic : `kubectl config view --minify` (lire `server:`), comparer avec `docker port <nœud>-control-plane 6443/tcp`
sur kind ou avec `ss -ltnp | grep 6443` sur un control plane ; `kubectl config get-contexts` pour vérifier le contexte courant.
Correction : `kubectl config set-cluster <cluster> --server=https://<hôte>:<bon port>`, ou `--undo` (restaure la sauvegarde).
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    if [ ! -f "$BAK" ]; then echo "undo: pas de sauvegarde $BAK, rien à faire"; exit 0; fi
    cp "$BAK" "$CFG" && rm -f "$BAK"
    echo "undo: kubeconfig restauré depuis la sauvegarde"
    ;;
  "")
    if [ -f "$BAK" ]; then echo "panne déjà injectée (sauvegarde $BAK présente)"; exit 0; fi
    cluster=$(kubectl --kubeconfig "$CFG" config view --minify -o jsonpath='{.clusters[0].name}')
    server=$(kubectl --kubeconfig "$CFG" config view --minify -o jsonpath='{.clusters[0].cluster.server}')
    if [ -z "$cluster" ] || [ -z "$server" ]; then echo "aucun cluster courant dans $CFG" >&2; exit 1; fi
    cp "$CFG" "$BAK"
    if printf '%s' "$server" | grep -Eq ':[0-9]+/?$'; then
      bad=$(printf '%s' "$server" | sed -E "s#:[0-9]+(/?)\$#:${BAD_PORT}\1#")
    else
      bad="${server%/}:${BAD_PORT}"
    fi
    kubectl --kubeconfig "$CFG" config set-cluster "$cluster" --server="$bad" >/dev/null
    echo "panne injectée : cluster $cluster pointe sur $bad (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
