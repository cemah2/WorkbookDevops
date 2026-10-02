# Solutions — 10 Cilium : installer avec le CLI, lire l'architecture, tester la connectivité

Trois indices progressifs par exercice, puis la correction commentée. Lis un indice, retourne manipuler, reviens si besoin.
Sauf mention `[non testé]`, les commandes ont été exécutées le 2026-10-02 sur le cluster `kind` décrit en tête de la fiche
(Cilium 1.20.2, CLI 0.20.1, Kubernetes 1.37.0) ; les sorties sont réelles.

## Section 1 — Exercice autonome

### Indices

1. Les images doivent être présentes sur les nœuds : sur `kind`, `kind load image-archive` après un `docker save --platform linux/amd64`.
   `podAntiAffinity` sur `kubernetes.io/hostname` garantit deux nœuds différents.
2. iptables est encore là (masquerading, règles `CILIUM_*`), mais les chaînes `KUBE-SVC-*` sont celles de kube-proxy. Compte-les.
   Côté agent, cherche une sous-commande de `cilium-dbg` qui contient le mot `service`.
3. Le bloc s'appelle `KubeProxyReplacement Details` dans `cilium-dbg status --verbose` ; il n'apparaît pas dans `cilium status`
   (le CLI), seulement dans l'agent.

### Correction commentée

**Point 1.** Déploiement et preuve (exécuté) :

```bash
kubectl apply -f fiches/reseau/10-cilium-installation-architecture/manifests/demo-web.yaml
kubectl -n demo-cilium wait --for=condition=Ready pod --all --timeout=180s
kubectl -n demo-cilium get pods -o wide
for ip in $(kubectl -n demo-cilium get pods -l app=web -o jsonpath='{.items[*].status.podIP}'); do
  kubectl -n demo-cilium exec client -- wget -qO- --timeout=3 "http://$ip/" | grep -o '<title>.*</title>'
done
kubectl -n demo-cilium exec client -- wget -qO- --timeout=3 http://web/ | grep -o '<title>.*</title>'
kubectl -n demo-cilium exec client -- nslookup web.demo-cilium.svc.cluster.local
```

```text
client               1/1   Running   10.244.2.172   cilium-lab-worker2
web-66c779c9-55qh2   1/1   Running   10.244.2.54    cilium-lab-worker2
web-66c779c9-g42ql   1/1   Running   10.244.1.110   cilium-lab-worker
<title>Welcome to nginx!</title>      # worker2 → worker2
<title>Welcome to nginx!</title>      # worker2 → worker (tunnel VXLAN entre les deux nœuds)
<title>Welcome to nginx!</title>      # par le Service : nom résolu par CoreDNS, ClusterIP 10.107.199.200
```

**Point 2.** Trois preuves (exécuté) :

```bash
kubectl -n kube-system get ds                                   # cilium seulement, pas de kube-proxy
docker exec cilium-lab-worker sh -c 'iptables-save | grep -c KUBE-SVC ; iptables-save | grep -c CILIUM'
kubectl -n kube-system exec ds/cilium -c cilium-agent -- cilium-dbg service list
kubectl -n kube-system exec ds/cilium -c cilium-agent -- cilium-dbg status --verbose | grep -A14 'KubeProxyReplacement Details'
```

```text
0        # aucune chaîne KUBE-SVC : kube-proxy n'a jamais tourné
42       # règles CILIUM_* : masquerading et marquage, pas les Services

ID   Frontend                Service Type   Backend
1    10.96.0.1:443/TCP       ClusterIP      1 => 172.18.0.2:6443/TCP (active)
3    10.96.0.10:53/TCP       ClusterIP      1 => 10.244.1.187:53/TCP (active)
                                            2 => 10.244.1.231:53/TCP (active)
6    10.107.199.200:80/TCP   ClusterIP      1 => 10.244.1.110:80/TCP (active)
                                            2 => 10.244.2.54:80/TCP (active)

KubeProxyReplacement Details:
  Status:               True
  Socket LB:            Enabled
  Socket LB Coverage:   Full
  Devices:              eth0  172.18.0.4 (Direct Routing)
  Mode:                 SNAT
  Backend Selection:    Random
  Services:
  - ClusterIP:      Enabled
  - NodePort:       Enabled (Range: 30000-32767)
  - LoadBalancer:   Enabled
```

`cilium-dbg bpf lb list` montre la même table telle qu'elle est dans la map eBPF (frontend → backends, slots).

**Point 3.** Réponse attendue : (1) l'agent lit les Services et EndpointSlices depuis l'API server et les écrit dans des maps eBPF
(`cilium-dbg bpf lb list`) ; (2) la traduction ClusterIP → backend se fait dans le noyau, au plus près de l'application, par le
« socket LB » : au `connect()` du Pod, avant même que le paquet existe, l'adresse du Service est remplacée par celle d'un backend ;
(3) il n'y a donc ni chaîne iptables à parcourir ni DNAT par paquet, et le même code gère NodePort et LoadBalancer.
Piège d'examen : « Cilium remplace kube-proxy par des règles nftables » est faux ; c'est eBPF (TC/TCX et cgroup hooks).

## Section 1 — Break-fix (`10-cilium-cni-plugin-absent.sh`)

Observé (exécuté) : `probe-cni` reste `0/1 ContainerCreating` sur `cilium-lab-worker2`, événement
`FailedCreatePodSandBox … plugin type="cilium-cni" failed (add): failed to find plugin "cilium-cni" in path [/opt/cni/bin]`.
`cilium status` : `Cilium: OK`. Le client joint toujours `web`. Après `--undo` : `Running` en moins de 20 s.

Pourquoi l'agent ne voit rien : il surveille et réécrit `/etc/cni/net.d/05-cilium.conflist` (vérifié : le fichier renommé est
recréé dans la seconde), mais le binaire `/opt/cni/bin/cilium-cni` n'est posé qu'une fois, par l'init container
`install-cni-binaries`. Un `kubectl delete pod` de l'agent du nœud suffit donc à réparer, c'est la seconde correction du `--reveal`.

## Section 2 — Exercice autonome

### Indices

1. Le CLI n'est qu'un client Helm : `cilium install --dry-run-helm-values` te donne la liste exacte des `--set` à passer à `helm install`.
   Pense à `--namespace kube-system` et au nom de release `cilium`, sinon `cilium status` ne la retrouvera pas (`--helm-release-name`).
2. `cilium upgrade --reuse-values --set debug=false` réécrit la ConfigMap depuis les valeurs Helm. Compare `helm get values`,
   `cilium config view | grep '^debug '` et `cilium-dbg config` dans un agent, avant et après.
3. Clé Helm `ipam.mode`, clé ConfigMap `ipam`, ligne `IPAM:` de `cilium-dbg status`. Dans le sysdump : `cilium-configmap-*.yaml`
   et `cilium-bugtool-<pod>-*/cmd/cilium-dbg-status---verbose.md` (trois tirets, constaté avec le CLI 0.20.1).

### Correction commentée

**Point 1.** `[non testé : un seul cluster dans la session ; helm template du chart exécuté, helm install non]`

```bash
helm repo add cilium https://helm.cilium.io/ && helm repo update
helm install cilium cilium/cilium --version 1.20.2 --namespace kube-system \
  --set kubeProxyReplacement=true --set k8sServiceHost=<IP API> --set k8sServicePort=6443 \
  --set ipam.mode=kubernetes            # ce que le CLI choisit seul sur kind ; inutile sur kubernetes-ha
cilium status --wait --context kind-cilium-helm
helm -n kube-system get values cilium --kube-context kind-cilium-helm
```

Différences attendues avec le cluster installé par le CLI : `cluster.name` (le CLI le déduit du contexte `kind-…`, Helm laisse
`default`), `operator.replicas` (le CLI met 1 sur `kind`, le chart met 2 et le second Pod reste `Pending` sur un seul nœud
schedulable), et `ipam.mode`. Tout le reste est identique : le CLI ne fait rien que Helm ne fasse.

**Point 2.** (exécuté partiellement : `--dry-run-helm-values` oui, l'upgrade réel avec `debug=false` non, sans objet après la démo)

```bash
cilium upgrade --version 1.20.2 --reuse-values --set debug=false
helm -n kube-system get values cilium | grep debug         # debug: false, désormais dans la release
cilium config view | grep '^debug '                         # false, ConfigMap réécrite par Helm
kubectl -n kube-system exec ds/cilium -c cilium-agent -- cilium-dbg config | grep -i '^Debug'
```

Pourquoi le `config set` de la démo aurait été écrasé : `cilium config set` patche la ConfigMap **hors de Helm**. La release
ne connaît pas `debug=true`. Au prochain `cilium upgrade` ou `helm upgrade`, Helm rend la ConfigMap depuis ses valeurs (`debug`
absent, donc défaut `false`) et écrase le patch. `--reuse-values` conserve les valeurs **Helm**, pas les patchs de ConfigMap.
Réponse QCM : « `cilium config set` est un changement de dépannage, pas un changement de configuration ».

**Point 3.** Trois noms pour une chose :

| Couche | Nom | Valeur sur kind |
|---|---|---|
| valeurs Helm | `ipam.mode` | `kubernetes` |
| ConfigMap `cilium-config` | `ipam` | `kubernetes` |
| `cilium-dbg status` | `IPAM:` | `IPv4: 5/254 allocated from 10.244.1.0/24` |

Dans le sysdump (exécuté) : `cilium-configmap-20261002-223245.yaml` contient `ipam: kubernetes` ; le dossier
`cilium-bugtool-<pod>-…/cmd/` contient `cilium-dbg-status---verbose.md`, `cilium-health-status---verbose.md` et les autres
sorties de commandes, `conf/` la configuration vue par l'agent.

## Section 2 — Break-fix (`10-cilium-agent-crashloop.sh`)

Observé (exécuté) après 90 s :

```text
cilium-8vr2l   Init:0/6   1      # redémarré avec KUBERNETES_SERVICE_HOST=10.255.255.1
cilium-ddbfh   Running    0      # pas encore remplacé : le DaemonSet redémarre par vagues (maxUnavailable)
cilium-tnx5t   Init:0/6   1
Cilium:   2 errors, 2 warnings — 2 pods of DaemonSet cilium are not ready
```

Le client joint toujours `web` : le datapath eBPF reste chargé. Un Pod de test créé pendant la panne a tourné, parce qu'il a été
planifié sur le nœud dont l'agent n'était pas encore redémarré ; sur un nœud sans agent il serait resté en `ContainerCreating`.
Les nœuds restent `Ready` : le kubelet a toujours un plugin CNI et un fichier de configuration.

Le bon conteneur : `config` (premier init container), `kubectl -n kube-system logs <pod> -c config`. Il appelle l'API pour
construire la configuration et attend sans fin une adresse qui ne répond pas. La valeur fautive :
`kubectl -n kube-system get ds cilium -o yaml | grep -A1 KUBERNETES_SERVICE_HOST`.

Corrections : rapide, `kubectl -n kube-system set env ds/cilium KUBERNETES_SERVICE_HOST=172.18.0.2` (le `set env` déclenche le
rollout) ; durable, `cilium upgrade --reuse-values --set k8sServiceHost=172.18.0.2`, qui remet la release Helm d'accord avec
le DaemonSet. Après `--undo` : `cilium status --wait` vert en 30 s.

## Section 3 — Exercice autonome

### Indices

1. L'operator ne porte aucun flux : cherche ce qui est **unique** dans le cluster (allocation, ramassage, synchronisation).
   `cilium status` ment un peu : regarde la ligne `Deployment cilium-operator`.
2. Un DaemonSet ne se scale pas ; il se **sélectionne**. `nodeSelector` dans `spec.template.spec`, plus un label sur les nœuds
   à garder. Le Pod de l'agent du nœud exclu est supprimé par le contrôleur DaemonSet.
3. Pour « au bout de combien de temps », pense aux trois horloges : création d'un Pod (immédiat), ajout d'un nœud (IPAM),
   ramassage des identités (toutes les 15 min par défaut, `identity-gc-interval`).

### Correction commentée

**Point 1, operator à 0** (exécuté) :

```bash
break/reseau/10-cilium-operator-down.sh
kubectl run probe-op --image=docker.io/library/busybox:1.37 --restart=Never -- sleep 300   # Running en 12 s
cilium status | grep -E 'Operator|cilium-operator'
kubectl -n demo-cilium exec client -- wget -qO- http://web/ | grep -o '<title>.*</title>'   # OK
break/reseau/10-cilium-operator-down.sh --undo
```

```text
Operator:           OK                       # cilium status ne compte pas 0/0 comme une erreur
Deployment          cilium-operator          # Desired / Ready vides : c'est là que ça se voit
```

Marche : création de Pods (l'agent alloue dans son PodCIDR et crée identités et endpoints lui-même, mode `crd`), trafic, policies.
Casse plus tard : PodCIDR d'un **nouveau** nœud en `cluster-pool` (sur `kind` l'IPAM est `kubernetes`, le PodCIDR vient du Node :
pas d'effet), ramassage des `CiliumIdentity` orphelines (elles s'accumulent), `CiliumNode` d'un nœud supprimé (reste), LB-IPAM
et BGP (fiche 15), ClusterMesh (fiche 16).

Constat à retenir, obtenu en poussant l'exercice : un `CiliumNode` supprimé à la main **n'est pas recréé** par l'agent tant qu'il
n'est pas redémarré, operator présent ou non (vérifié 2026-10-02, mode `ipam: kubernetes`). Le trafic a continué (l'état est en
mémoire et dans eBPF). Ne supprime jamais un `CiliumNode` en production ; si c'est fait, redémarre l'agent du nœud.

Supprimer un `CiliumEndpoint` à la main (exécuté) : l'agent le recrée en moins de 8 s avec la même identité (4273) et la même IP ;
le Pod ne perd pas sa connectivité, son endpoint eBPF existe toujours. Différence avec le `CiliumNode` : l'endpoint est
resynchronisé en continu par l'agent qui le possède, le nœud n'est écrit qu'au démarrage.

**Point 2, agent retiré d'un nœud** (exécuté) :

```bash
kubectl label node cilium-lab-control-plane cilium-lab-worker workbook/cilium=on --overwrite
kubectl -n kube-system patch ds cilium -p '{"spec":{"template":{"spec":{"nodeSelector":{"kubernetes.io/os":"linux","workbook/cilium":"on"}}}}}'
kubectl -n kube-system get pods -l k8s-app=cilium -o wide        # deux agents, plus rien sur worker2
kubectl -n demo-cilium exec client -- wget -qO- http://web/ | grep -o '<title>'   # client et un web sont sur worker2 : OK
kubectl run probe-noagent --image=docker.io/library/busybox:1.37 --restart=Never --overrides='{"spec":{"nodeName":"cilium-lab-worker2"}}' -- sleep 300
kubectl get pod probe-noagent        # 0/1 ContainerCreating, et le reste
kubectl get nodes                    # worker2 toujours Ready (plugin et fichier CNI présents)
cilium status | grep -E 'DaemonSet|Cluster Pods'   # Desired: 2, Ready: 2/2 ; Cluster Pods: 6/7 managed by Cilium
# retour
kubectl -n kube-system patch ds cilium --type json -p '[{"op":"remove","path":"/spec/template/spec/nodeSelector/workbook~1cilium"}]'
kubectl label node cilium-lab-control-plane cilium-lab-worker workbook/cilium-
kubectl -n kube-system rollout status ds/cilium     # probe-noagent passe Running dans la minute
```

Marche : tout ce qui existait sur le nœud (veth, maps eBPF, routes), y compris vers les autres nœuds. Casse : tout nouveau Pod
du nœud (le plugin `cilium-cni` ne joint plus l'agent), toute mise à jour de policy ou de Service sur ce nœud (les maps ne sont
plus mises à jour : un nouveau backend ailleurs n'est pas vu d'ici), les sondes de santé inter-nœuds. `cilium status` le dit
honnêtement (`6/7 managed`), le kubelet non.

**Point 3, tableau attendu** :

| Composant arrêté | Continue | S'arrête | Visible quand |
|---|---|---|---|
| `cilium-agent` d'un nœud | Pods existants du nœud, trafic, policies déjà programmées | nouveaux Pods du nœud, mise à jour des Services et policies sur ce nœud | immédiatement (premier Pod créé) |
| `cilium-operator` | tout le trafic, création de Pods, policies | PodCIDR des nouveaux nœuds (`cluster-pool`), GC identités/endpoints, LB-IPAM, BGP, ClusterMesh | à l'ajout d'un nœud, ou des minutes à des heures plus tard |
| `cilium-envoy` d'un nœud | trafic L3/L4 | tout ce qui passe par le proxy L7 sur ce nœud : policies HTTP, Ingress, Gateway API, visibilité L7 | immédiatement pour les flux L7 (lecture, fiche 14) |
| plugin `cilium-cni` du nœud | Pods existants, agent | nouveaux Pods du nœud | immédiatement |

## Section 3 — Break-fix (`10-cilium-operator-down.sh`)

Trois commandes : `kubectl -n kube-system get deploy cilium-operator` (0/0), `cilium status | grep -A1 Deployment`,
`kubectl -n kube-system get events --field-selector involvedObject.name=cilium-operator`. Ce qui cassera : voir le tableau
du point 3 et le `--reveal` du script. Correction : `kubectl -n kube-system scale deploy cilium-operator --replicas=1`
(2 sur `kubernetes-ha`, valeur par défaut du chart) ou `--undo`.
