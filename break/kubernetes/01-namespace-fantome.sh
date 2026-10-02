#!/usr/bin/env bash
# break/kubernetes/01-namespace-fantome.sh — fiche 01 kubectl, Pods et namespaces.
# Pointe le namespace par défaut du contexte courant sur un namespace qui n'existe pas.
# Usage : ./01-namespace-fantome.sh            injecte la panne (idempotent)
#         ./01-namespace-fantome.sh --undo     retire la panne
#         ./01-namespace-fantome.sh --reveal   explique la panne (ne touche à rien)
# Variables : KUBECONFIG (défaut ~/.kube/config), GHOST_NS (défaut shop-prod). État : <kubeconfig>.break01-ns
set -euo pipefail
CFG="${KUBECONFIG:-$HOME/.kube/config}"
STATE="${CFG}.break01-ns"
GHOST_NS="${GHOST_NS:-shop-prod}"

reveal() {
  cat <<'TXT'
Panne : le contexte courant du kubeconfig a un `namespace:` qui n'existe pas (shop-prod par défaut).
Pourquoi ça casse : sans `-n`, kubectl ajoute le namespace du contexte à chaque requête. Les Pods existent toujours,
dans leur namespace à eux : `kubectl get pods` répond « No resources found in shop-prod namespace. » et
`kubectl run` ou `apply` sans `-n` répondent « namespaces "shop-prod" not found ».
Diagnostic : lire la fin du message d'erreur (il nomme le namespace), `kubectl config get-contexts` (colonne NAMESPACE),
`kubectl get ns`, `kubectl get pods -A`.
Correction : `kubectl config set-context --current --namespace=<bon namespace>` (ou `kubectl config unset contexts.<ctx>.namespace`),
ou `--undo`.
TXT
}

ctx() { kubectl --kubeconfig "$CFG" config current-context; }

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    if [ ! -f "$STATE" ]; then echo "undo: pas d'état $STATE, rien à faire"; exit 0; fi
    prev=$(cat "$STATE")
    if [ -n "$prev" ]; then
      kubectl --kubeconfig "$CFG" config set-context --current --namespace="$prev" >/dev/null
    else
      kubectl --kubeconfig "$CFG" config unset "contexts.$(ctx).namespace" >/dev/null
    fi
    rm -f "$STATE"
    echo "undo: namespace du contexte $(ctx) remis à '${prev:-<aucun>}'"
    ;;
  "")
    if [ -f "$STATE" ]; then echo "panne déjà injectée (état $STATE présent)"; exit 0; fi
    kubectl --kubeconfig "$CFG" config view --minify -o jsonpath='{.contexts[0].context.namespace}' > "$STATE"
    kubectl --kubeconfig "$CFG" config set-context --current --namespace="$GHOST_NS" >/dev/null
    echo "panne injectée : contexte $(ctx) → namespace $GHOST_NS (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
