#!/usr/bin/env bash
# break/reseau/10-cilium-cni-conf-absent.sh — fiche 10 Cilium.
# Fait disparaître le plugin CNI (binaire /opt/cni/bin/cilium-cni) sur UN nœud : les nouveaux Pods de ce nœud
# restent en ContainerCreating, les Pods existants continuent de fonctionner.
# (Le fichier /etc/cni/net.d/05-cilium.conflist, lui, est réécrit par l'agent dès qu'il disparaît : vérifié le 2026-10-02.)
# Usage : ./10-cilium-cni-conf-absent.sh            injecte la panne (idempotent)
#         ./10-cilium-cni-conf-absent.sh --undo     retire la panne
#         ./10-cilium-cni-conf-absent.sh --reveal   explique la panne (ne touche à rien)
# Variables : NODE (défaut : dernier worker par ordre alphabétique), CILIUM_NS (kube-system),
#             CNI_BIN_DIR (/opt/cni/bin), CNI_BIN (cilium-cni).
set -euo pipefail
CILIUM_NS="${CILIUM_NS:-kube-system}"
CNI_BIN_DIR="${CNI_BIN_DIR:-/opt/cni/bin}"
CNI_BIN="${CNI_BIN:-cilium-cni}"
OFF_SUFFIX=".workbook-off"
NODE="${NODE:-$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' \
  | grep -v -E 'control-plane|cp0' | sort | tail -1)}"
HELPER="break-10-cni-${NODE}"

reveal() {
  cat <<TXT
Panne : sur le nœud ${NODE}, le binaire ${CNI_BIN_DIR}/${CNI_BIN} a été renommé en ${CNI_BIN}${OFF_SUFFIX}.
Pourquoi ça casse : à chaque nouveau Pod, le kubelet demande à containerd de brancher le réseau ; containerd lit
/etc/cni/net.d/05-cilium.conflist, qui désigne le plugin « cilium-cni », et ne trouve plus ce binaire dans ${CNI_BIN_DIR}.
Les Pods déjà branchés gardent leur veth et leurs programmes eBPF : ils continuent de parler. L'agent, lui, ne
surveille que le fichier de configuration (qu'il réécrit s'il disparaît), pas le binaire, posé une fois par
l'init container install-cni-binaries.
Symptôme : nouveaux Pods du nœud en ContainerCreating, événement « failed to setup network for sandbox …
failed to find plugin "cilium-cni" in path [${CNI_BIN_DIR}] » (kubectl describe pod). cilium status reste vert.
Diagnostic : kubectl describe pod <pod> ; ls ${CNI_BIN_DIR} sur le nœud (docker exec sur kind, ssh ou Pod privilégié ailleurs).
Correction : remettre le binaire (--undo) ou redémarrer l'agent du nœud, dont l'init container réinstalle le plugin :
             kubectl -n ${CILIUM_NS} delete pod -l k8s-app=cilium --field-selector spec.nodeName=${NODE}
TXT
}

# Exécute une commande shell sur le nœud, via un Pod privilégié éphémère qui monte CNI_BIN_DIR (kind, kubeadm, Talos…).
on_node() {
  kubectl -n "$CILIUM_NS" delete pod "$HELPER" --ignore-not-found --wait=true >/dev/null
  kubectl -n "$CILIUM_NS" apply -f - >/dev/null <<YAML
apiVersion: v1
kind: Pod
metadata:
  name: ${HELPER}
spec:
  nodeName: ${NODE}
  restartPolicy: Never
  hostNetwork: true
  tolerations: [{operator: Exists}]
  containers:
    - name: sh
      image: docker.io/library/busybox:1.37
      command: ["sh", "-c", "$1"]
      securityContext: {privileged: true}
      volumeMounts: [{name: cni, mountPath: /host-cni-bin}]
  volumes:
    - name: cni
      hostPath: {path: ${CNI_BIN_DIR}, type: Directory}
YAML
  kubectl -n "$CILIUM_NS" wait --for=jsonpath='{.status.phase}'=Succeeded pod "$HELPER" --timeout=90s >/dev/null
  kubectl -n "$CILIUM_NS" logs "$HELPER"
  kubectl -n "$CILIUM_NS" delete pod "$HELPER" --wait=false >/dev/null
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    on_node "cd /host-cni-bin && if [ -f ${CNI_BIN}${OFF_SUFFIX} ]; then mv ${CNI_BIN}${OFF_SUFFIX} ${CNI_BIN} && echo restauré; else echo 'rien à faire'; fi; ls"
    echo "undo: plugin CNI remis en place sur $NODE"
    ;;
  "")
    on_node "cd /host-cni-bin && if [ -f ${CNI_BIN} ]; then mv ${CNI_BIN} ${CNI_BIN}${OFF_SUFFIX} && echo renommé; else echo 'déjà injecté ou binaire absent'; fi; ls"
    echo "panne injectée sur $NODE (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
