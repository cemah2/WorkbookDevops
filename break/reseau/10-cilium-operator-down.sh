#!/usr/bin/env bash
# break/reseau/10-cilium-operator-down.sh — fiche 10 Cilium (panne optionnelle, « silencieuse »).
# Met cilium-operator à 0 réplica. Rien ne casse tout de suite : c'est le point.
# Usage : ./10-cilium-operator-down.sh [--undo|--reveal]
# Variables : CILIUM_NS (kube-system).
set -euo pipefail
CILIUM_NS="${CILIUM_NS:-kube-system}"
DEPLOY="cilium-operator"
ANNOT="break.workbook/10-orig-replicas"

reveal() {
  cat <<TXT
Panne : le Deployment ${CILIUM_NS}/${DEPLOY} est à 0 réplica (nombre d'origine dans l'annotation ${ANNOT}).
Pourquoi c'est trompeur : l'operator ne porte aucun flux. Les agents gardent leur état, le datapath eBPF reste chargé,
les Pods existants et nouveaux fonctionnent tant que leur nœud a encore des adresses et que les identités existent.
Ce qui s'arrête : l'allocation des PodCIDR aux nouveaux nœuds (IPAM cluster-pool), le ramassage des CiliumIdentity
et CiliumEndpoint orphelins, le LB-IPAM, le BGP, la synchronisation des Services KVStore/ClusterMesh, les CiliumNode
des nœuds qui disparaissent. Tout ça se voit plus tard, souvent au pire moment (ajout de nœud, montée en charge).
Symptôme immédiat : cilium status affiche « Operator: 0 errors » ou « Deployment cilium-operator Desired: 0 » ;
kubectl -n ${CILIUM_NS} get deploy ${DEPLOY} montre 0/0. Les tests de connectivité passent.
Correction : kubectl -n ${CILIUM_NS} scale deploy ${DEPLOY} --replicas=<origine> (ou --undo).
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    orig=$(kubectl -n "$CILIUM_NS" get deploy "$DEPLOY" -o jsonpath="{.metadata.annotations.break\.workbook/10-orig-replicas}")
    [ -z "$orig" ] && orig=1
    kubectl -n "$CILIUM_NS" scale deploy "$DEPLOY" --replicas="$orig"
    kubectl -n "$CILIUM_NS" annotate deploy "$DEPLOY" "$ANNOT-" >/dev/null 2>&1 || true
    kubectl -n "$CILIUM_NS" rollout status deploy "$DEPLOY" --timeout=120s
    echo "undo: $DEPLOY remis à $orig réplica(s)"
    ;;
  "")
    if kubectl -n "$CILIUM_NS" get deploy "$DEPLOY" -o jsonpath='{.metadata.annotations}' | grep -q "$ANNOT"; then
      echo "panne déjà injectée (annotation $ANNOT présente)"; exit 0
    fi
    orig=$(kubectl -n "$CILIUM_NS" get deploy "$DEPLOY" -o jsonpath='{.spec.replicas}')
    kubectl -n "$CILIUM_NS" annotate deploy "$DEPLOY" "$ANNOT=$orig"
    kubectl -n "$CILIUM_NS" scale deploy "$DEPLOY" --replicas=0
    echo "panne injectée : $DEPLOY à 0 réplica (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
