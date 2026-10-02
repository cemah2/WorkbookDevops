#!/usr/bin/env bash
# break/reseau/10-cilium-agent-crashloop.sh — fiche 10 Cilium.
# Pointe les agents vers une adresse d'API server injoignable (variable KUBERNETES_SERVICE_HOST du DaemonSet cilium) :
# tous les agents bloquent au démarrage. Le datapath eBPF déjà chargé continue de fonctionner.
# Usage : ./10-cilium-agent-crashloop.sh [--undo|--reveal]
# Variables : CILIUM_NS (kube-system), BAD_HOST (10.255.255.1).
set -euo pipefail
CILIUM_NS="${CILIUM_NS:-kube-system}"
BAD_HOST="${BAD_HOST:-10.255.255.1}"
DS="cilium"
ANNOT="break.workbook/10-orig-k8s-service-host"

reveal() {
  cat <<TXT
Panne : dans le DaemonSet ${CILIUM_NS}/${DS}, la variable KUBERNETES_SERVICE_HOST de tous les conteneurs (init compris)
vaut ${BAD_HOST} ; l'adresse d'origine est gardée dans l'annotation ${ANNOT} du DaemonSet. kubectl set env a
déclenché le redémarrage des agents.
Pourquoi ça casse : sans kube-proxy, le Service kubernetes (10.96.0.1) n'est joignable qu'une fois programmé par l'agent ;
l'agent lit donc l'adresse réelle de l'API dans KUBERNETES_SERVICE_HOST (valeur Helm k8sServiceHost). Adresse fausse =
l'init container « config » attend l'API sans fin : le Pod reste en Init:0/6, puis les init containers finissent par échouer.
Symptôme : Pods cilium-* en Init:0/6 longtemps, cilium status rouge (« pods of DaemonSet cilium are not ready »),
puis nœuds NotReady quand le kubelet perd le plugin. Les Pods applicatifs existants continuent de se parler ;
les nouveaux Pods restent en ContainerCreating.
Diagnostic : kubectl -n ${CILIUM_NS} logs <pod cilium> -c config ;
             kubectl -n ${CILIUM_NS} get ds ${DS} -o yaml | grep -A1 KUBERNETES_SERVICE_HOST | head -2.
Correction : kubectl -n ${CILIUM_NS} set env ds/${DS} KUBERNETES_SERVICE_HOST=<adresse réelle> (ou --undo) ; durable :
             cilium upgrade --reuse-values --set k8sServiceHost=<adresse réelle>.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    orig=$(kubectl -n "$CILIUM_NS" get ds "$DS" -o jsonpath="{.metadata.annotations.break\.workbook/10-orig-k8s-service-host}")
    if [ -z "$orig" ]; then echo "undo: rien à faire (annotation absente)"; exit 0; fi
    kubectl -n "$CILIUM_NS" set env "ds/$DS" "KUBERNETES_SERVICE_HOST=$orig"
    kubectl -n "$CILIUM_NS" annotate ds "$DS" "$ANNOT-"
    kubectl -n "$CILIUM_NS" rollout status "ds/$DS" --timeout=300s
    echo "undo: KUBERNETES_SERVICE_HOST remis à $orig, agents redémarrés"
    ;;
  "")
    if kubectl -n "$CILIUM_NS" get ds "$DS" -o jsonpath='{.metadata.annotations}' | grep -q "$ANNOT"; then
      echo "panne déjà injectée (annotation $ANNOT présente)"; exit 0
    fi
    orig=$(kubectl -n "$CILIUM_NS" get ds "$DS" \
      -o jsonpath='{.spec.template.spec.containers[?(@.name=="cilium-agent")].env[?(@.name=="KUBERNETES_SERVICE_HOST")].value}')
    if [ -z "$orig" ]; then
      echo "KUBERNETES_SERVICE_HOST absente du DaemonSet : l'installation n'est pas en kubeProxyReplacement avec API explicite" >&2
      exit 1
    fi
    kubectl -n "$CILIUM_NS" annotate ds "$DS" "$ANNOT=$orig"
    kubectl -n "$CILIUM_NS" set env "ds/$DS" "KUBERNETES_SERVICE_HOST=$BAD_HOST"
    echo "panne injectée : agents redémarrés avec KUBERNETES_SERVICE_HOST=$BAD_HOST (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
