---
code: CCA
titre: "CCA — mapping compétences → chapitres"
programme: "certifs/CCA/programme.md (converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14)"
chapitres_existants: 1
generated: 2026-10-02
status: "1 chapitre rédigé (brouillon) sur 8 : fiches/reseau/10-cilium-installation-architecture.md ; arbitrages du §2 acceptés le 2026-10-02 ; à mettre à jour à chaque PR de chapitre"
---

# CCA — objectifs et couverture

Mapping entre les 28 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : une fiche rédigée (`fiches/reseau/10-cilium-installation-architecture.md`, statut brouillon, exécutée
sur un cluster `kind` 1.37 avec Cilium 1.20.2), les sept autres chapitres sont des trous. La variante Gateway API Cilium de
`fiches/gitops/01-argo-cd-fondamentaux.md` (un manifest `Gateway` + `HTTPRoute`, `[non testé]`) effleure CCA-03-01.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices »
et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| CCA-01 Architecture | 20 % | 5 | 4,0 % | F1, F2 |
| CCA-02 Network Policy | 18 % | 5 | 3,6 % | F3 |
| CCA-03 Service Mesh | 16 % | 5 | 3,2 % | F5 |
| CCA-04 Network Observability | 10 % | 3 | 3,3 % | F4 |
| CCA-05 Installation and Configuration | 10 % | 2 | 5,0 % | F1 |
| CCA-06 Cluster Mesh | 10 % | 2 | 5,0 % | F7 |
| CCA-07 eBPF | 10 % | 3 | 3,3 % | F2 |
| CCA-08 BGP and External Networking | 6 % | 2 | 3,0 % | F6 |
| Transverse | — | 28 | — | 1 scénario |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle.

Ordre de rédaction recommandé (du plus lourd au plus léger, en respectant les prérequis) :
installation et architecture (F1) → IPAM, datapath et eBPF (F2) → Network Policy (F3) → Hubble (F4) →
Gateway API et service mesh (F5) → BGP et egress (F6) → Cluster Mesh (F7) → scénario de bout en bout (S1).
F1 à F4 cumulent 68 % des points ; F1 et F3 seules en font 38 %.

## 2. Préalables au premier chapitre

Les trois arbitrages proposés par cette cartographie ont été acceptés le 2026-10-02 et appliqués dans la même PR :

- `versions.yaml` : `cilium` existait (1.20.x) ; `cilium_cli`, `hubble` (même numéro que `cilium` depuis la série 1.17) et
  `gateway_api` (version des CRD imposée par la documentation de la version `cilium`, lue dans `Documentation/conf.py`) sont ajoutés.
  `spire` (dépôt `spiffe/spire`) reste à créer par la PR de F5 si l'authentification mutuelle est retenue.
- `DECISIONS.md` (2026-10-02) : LoadBalancer sur `kubernetes-ha` = Cilium LB-IPAM + BGP vers `core-rtr01`, MetalLB en variante ;
  kube-proxy absent, Cilium en `kubeProxyReplacement`. `labs/profiles/kubernetes-ha.yaml` et `labs/profiles/core.yaml` (plugin `os-frr`)
  sont alignés.
- `DECISIONS.md` (2026-10-02) : la série Cilium prend les numéros `10` à `16` dans `fiches/reseau/`, les `01` à `09` restant aux fiches
  `reseau_deb` (ip/nftables, VLAN, OPNsense, DNS…) attendues par LFCS, RHCE et CKA.

Reste à faire **avant** la PR du premier chapitre :

- Fiche Proxmox/OPNsense : F6 a besoin du plugin `os-frr` configuré (un AS, un voisin). Tant que `core` n'est pas levé, F6 contient
  la mise en place minimale et la marque `[non testé]`.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont en §6.2 (cette PR). Arête inter-domaines nouvelle :
  `kubernetes_deb` → F1 (Cilium s'installe sur un cluster existant ; il faut kubectl, Pods, Services, Deployments).
- Décisions déjà prises qui s'appliquent : Gateway API Cilium par défaut, Envoy Gateway en variante (DECISIONS.md, 2026-10-02) ;
  ingress-nginx retiré, Ingress gardé pour les objectifs d'examen qui le citent (CCA-03-01, CCA-03-03) ; Helm 4 pour l'installation
  Helm en variante du CLI ; Ubuntu 24.04 LTS comme image des nœuds (noyau 6.8, suffisant pour tout le programme).

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. La colonne « chapitre cible » renvoie à la section 4.

### CCA-01 — Architecture (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CCA-01-01 | Understand the Role of Cilium in Kubernetes Environments | 4,0 % | `fiches/reseau/10-cilium-installation-architecture.md` (brouillon) | S1 : démo (cluster sans CNI → Cilium), autonome 1 (trafic sans kube-proxy), défi 15 min | F1 (rédigé) |
| CCA-01-02 | Cilium Architecture | 4,0 % | `fiches/reseau/10-cilium-installation-architecture.md` (brouillon) | S3 : démo (composants, CRD, CNI sur le nœud), autonome 3 (operator et agent arrêtés), défi oral 5 min | F1 (rédigé) |
| CCA-01-03 | IP Address Management (IPAM) with Cilium | 4,0 % | — | — | F2 |
| CCA-01-04 | Cilium Component Roles | 4,0 % | `fiches/reseau/10-cilium-installation-architecture.md` (brouillon) | S3 : démo, autonome 3, break-fix operator-down, défi oral 5 min | F1 (rédigé) |
| CCA-01-05 | Datapath Models | 4,0 % | — | — | F2 |

### CCA-02 — Network Policy (18 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CCA-02-01 | Interpret Cilium Network Policies and Intent | 3,6 % | — | — | F3 |
| CCA-02-02 | Understand Cilium's Identity-based Network Security Model | 3,6 % | — | — | F3 |
| CCA-02-03 | Policy Enforcement Modes | 3,6 % | — | — | F3 |
| CCA-02-04 | Policy Rule Structure | 3,6 % | — | — | F3 |
| CCA-02-05 | Kubernetes Network Policies versus Cilium Network Policies | 3,6 % | — | — | F3 |

### CCA-03 — Service Mesh (16 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CCA-03-01 | Know How to use Ingress or Gateway API for Ingress Routing | 3,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (variante `kubernetes-ha`, `[non testé]`) : un `Gateway` + `HTTPRoute` Cilium pour l'UI Argo CD | S1, exercice autonome 1 (exposition de l'UI, variante Gateway API) — effleure la compétence, ne la couvre pas | F5 |
| CCA-03-02 | Service Mesh Use Cases | 3,2 % | — | — | F5 |
| CCA-03-03 | Understand the Benefits of Gateway API over Ingress | 3,2 % | — | — | F5 |
| CCA-03-04 | Encrypting Traffic in Transit with Cilium | 3,2 % | — | — | F5 |
| CCA-03-05 | Sidecar-based versus Sidecarless Architectures | 3,2 % | — | — | F5 |

### CCA-04 — Network Observability (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CCA-04-01 | Understand the Observability Capabilities of Hubble | 3,3 % | — | — | F4 |
| CCA-04-02 | Enabling Layer 7 Protocol Visibility | 3,3 % | — | — | F4 |
| CCA-04-03 | Know How to Use Hubble from the Command Line or the Hubble UI | 3,3 % | — | — | F4 |

### CCA-05 — Installation and Configuration (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CCA-05-01 | Know How to Use Cilium CLI to Query and Modify the Configuration | 5,0 % | `fiches/reseau/10-cilium-installation-architecture.md` (brouillon) | S2 : démo (config view/set, Helm, dry-run), autonome 2 (variante Helm), break-fix agent-crashloop, défi 10 min | F1 (rédigé) |
| CCA-05-02 | Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status | 5,0 % | `fiches/reseau/10-cilium-installation-architecture.md` (brouillon) | S1 : démo (cilium install, status --wait), S2 : démo (sysdump, connectivity test), break-fix cni-plugin-absent, défi 15 min | F1 (rédigé) |

### CCA-06 — Cluster Mesh (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CCA-06-01 | Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity | 5,0 % | — | — | F7 |
| CCA-06-02 | Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh | 5,0 % | — | — | F7 |

### CCA-07 — eBPF (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CCA-07-01 | Understand the Role of eBPF in Cilium | 3,3 % | — | — | F2 |
| CCA-07-02 | eBPF Key Benefits | 3,3 % | — | — | F2 |
| CCA-07-03 | eBPF-based Platforms versus IPtables-based Platforms | 3,3 % | — | — | F2 |

### CCA-08 — BGP and External Networking (6 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CCA-08-01 | Egress Connectivity Requirements | 3,0 % | — | — | F6 |
| CCA-08-02 | Understand Options to Connect Cilium-managed Clusters with External Networks | 3,0 % | — | — | F6 |

### Compétences partagées avec d'autres certifications

CCA se passe dans le bloc `reseau_conf` du parcours Golden Kubestronaut (`docs/prerequis.md` §3, avec ICA et KCA).
Les chapitres ci-dessous citent les autres programmes dans leur front matter pour éviter un doublon ;
les cartographies CKA, CKS, KCNA, KCSA et ICA restent à faire par leur propre session `prompts/01-cartographie-certification.md`.

| Chapitre | IDs CCA | IDs réutilisables (à confirmer par la cartographie de chaque certification) |
|---|---|---|
| F1 Installation et architecture | CCA-01-01, 01-02, 01-04, 05-01, 05-02 | CKA-05-07 (interfaces CNI), KCNA-02-01, KCSA-02-09 |
| F2 IPAM, datapath et eBPF | CCA-01-03, 01-05, 07-01 à 07-03 | CKA-04-05 (dépannage réseau), KCSA-02-09 |
| F3 Network Policy | CCA-02-01 à 02-05 | CKA-03-02, CKS-01-01, CKS-03-03, KCSA-03-07, KCSA-04-05 |
| F4 Hubble | CCA-04-01 à 04-03 | KCNA-04-01, KCSA-05-03, CKS-06-02 (détection réseau), CNPA-02-01 |
| F5 Gateway API et service mesh | CCA-03-01 à 03-05 | CKA-03-04, CKA-03-05, CKS-01-03, CKS-04-04, KCSA-05-04, ICA-02-01, ICA-03-02 (comparaison sidecar) |
| F6 BGP et egress | CCA-08-01, 08-02 | CKA-04-05, ICA-02-05 (sorties vers l'extérieur, comparaison) |
| F7 Cluster Mesh | CCA-06-01, 06-02 | CNPE-01-01 (architecture multi-cluster) |

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de rédaction recommandé à partir de `10` (DECISIONS.md, 2026-10-02 ; voir §2).
Domaine `reseau`, niveaux confirmé puis expert : les fiches Cilium exigent `reseau_deb` (modèle OSI, TCP/UDP, DNS, HTTP,
routage, VLAN du lab) et `kubernetes_deb` (kubectl, Pods, Services, Deployments, namespaces). Pas de fiche Cilium débutant :
`reseau_deb` est un prérequis de `kubernetes_deb` dans le graphe, une fiche Cilium ne peut donc pas s'y trouver.
Tous les chapitres ciblent le profil `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`, kubeadm
**sans** kube-proxy, Cilium en `kubeProxyReplacement`). Tant que `lab up kubernetes-ha` n'existe pas, F1 à F5 et F7 ont pour
chemin de repli un ou deux clusters `kind` sur une VM du profil `linux-base` (4 vCPU / 8 Go, comme `fiches/gitops/01`) ;
F6 exige les vraies VM (BGP vers `core-rtr01`, egress gateway sur un nœud).
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.

### F1 — `fiches/reseau/10-cilium-installation-architecture.md` — rédigé (brouillon, 2026-10-02)

- **Titre** : Cilium — installer avec le CLI, lire l'architecture, tester la connectivité
- **Niveau** : confirmé (`reseau_conf`)
- **Couvre** : CCA-01-01, CCA-01-02, CCA-01-04, CCA-05-01, CCA-05-02
- **Prérequis** : `reseau_deb`, `kubernetes_deb` (cluster kubeadm bootstrappé avec `--skip-phases=addon/kube-proxy`, sans CNI)
- **Lab** : `kubernetes-ha` ; repli `kind` (`disableDefaultCNI: true`, `kubeProxyMode: none`) sur `linux-base`.
  Clés `versions.yaml` : `cilium`, `cilium_cli`, `kubernetes`, `kubeadm`, `kind`, `helm`.
- **Plan validé** : `docs/plans/reseau-10-cilium-installation-architecture.md` (2026-10-02, recommandations des six questions retenues).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer Cilium avec `cilium install` sur le cluster sans CNI, lire `cilium status --wait`, `cilium config view`,
     `cilium sysdump` ; puis réinstaller en Helm 4 avec les mêmes valeurs et comparer (`helm get values`) — CCA-05-01, CCA-05-02.
  2. Cartographier les composants : `cilium-agent` (DaemonSet), `cilium-operator`, `cilium-envoy`, `clustermesh-apiserver`,
     `hubble-relay`, CRD `CiliumNode`, `CiliumEndpoint`, `CiliumIdentity` ; couper l'operator puis un agent et observer ce qui
     continue de fonctionner (nouveaux Pods, Pods existants, allocation d'IP) — CCA-01-01, CCA-01-02, CCA-01-04.
  3. Lancer `cilium connectivity test`, lire un échec provoqué (nœud sans route vers le VLAN 30), modifier la configuration
     avec `cilium config set` puis par Helm `--set`, mesurer l'impact d'un rollout de l'agent — CCA-05-01, CCA-05-02.
- **Break-fix** : `break/reseau/10-cilium-cni-plugin-absent.sh` (binaire CNI retiré d'un nœud), `10-cilium-agent-crashloop.sh`
  (adresse d'API fausse dans le DaemonSet, agents bloqués en `Init:0/6`), `10-cilium-operator-down.sh` (panne silencieuse).
- **Défi chronométré** : cluster sans CNI → Cilium installé, `cilium status` vert, `connectivity test` passé en moins de 15 min.

### F2 — `fiches/reseau/11-cilium-ipam-datapath-ebpf.md`

- **Titre** : Cilium — IPAM, modes de datapath et ce que fait eBPF à la place d'iptables
- **Niveau** : confirmé (`reseau_conf`)
- **Couvre** : CCA-01-03, CCA-01-05, CCA-07-01, CCA-07-02, CCA-07-03
- **Prérequis** : F1 ; `linux_conf` recommandé (namespaces réseau, `ip route`, `nft`, lecture d'un `tcpdump`)
- **Lab** : `kubernetes-ha` (VLAN 30 `overlay` pour VXLAN/Geneve, routage natif entre nœuds d'un même `/24`) ; repli `kind` pour l'IPAM
  et les commandes eBPF, `[lecture + simulation]` pour le routage natif. Clés `versions.yaml` : `cilium`, `cilium_cli`, `kubernetes`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Comparer l'IPAM `kubernetes` (PodCIDR du nœud), `cluster-pool` (défaut, `CiliumNode.spec.ipam.podCIDRs`) et `multi-pool`
     (`CiliumPodIPPool`, annotation de namespace) : allouer, épuiser un pool, lire `cilium-dbg ip list` — CCA-01-03.
  2. Passer du tunnel VXLAN à Geneve puis au routage natif (`routingMode: native`, `autoDirectNodeRoutes`, `ipv4NativeRoutingCIDR`),
     capturer sur le VLAN 30 avec `tcpdump`, comparer les tables de routage des nœuds et le masquerading eBPF vs iptables — CCA-01-05.
  3. Lire le datapath eBPF : `cilium-dbg bpf endpoint list`, `bpf lb list`, `bpf ct list`, `bpftool prog show`, `bpftool map`, hooks
     TC/XDP ; comparer avec un cluster kube-proxy (`iptables-save | wc -l`, latence d'une mise à jour de Service avec 1 000 Services)
     — CCA-07-01, CCA-07-02, CCA-07-03.
- **Break-fix** : `break/reseau/11-cilium-native-routing-sans-route.sh` (routage natif activé, route vers le PodCIDR d'un nœud supprimée,
  Pods d'un seul nœud injoignables).
- **Défi chronométré** : diagnostiquer et corriger une perte de connectivité inter-nœuds due au mode de datapath en moins de 15 min.

### F3 — `fiches/reseau/12-cilium-network-policy.md`

- **Titre** : Cilium — Network Policy par identité, L3/L4/L7, modes d'application
- **Niveau** : confirmé (`reseau_conf`)
- **Couvre** : CCA-02-01, CCA-02-02, CCA-02-03, CCA-02-04, CCA-02-05
- **Prérequis** : F1 ; `securite_deb` recommandé (principe du moindre privilège, zéro confiance)
- **Lab** : `kubernetes-ha` ; repli `kind`. Clés `versions.yaml` : `cilium`, `cilium_cli`, `hubble` (pour vérifier les verdicts).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Déployer une application à trois tiers, écrire `NetworkPolicy` Kubernetes puis `CiliumNetworkPolicy` équivalente et montrer ce que
     la première ne sait pas faire (DNS `toFQDNs`, L7 HTTP `toPorts.rules.http`, `toEntities: world/cluster/host`, `toServices`,
     `CiliumClusterwideNetworkPolicy`) — CCA-02-04, CCA-02-05.
  2. Observer le modèle par identité : `cilium identity list`, `CiliumIdentity`, labels pris en compte (`labels` prefix), même identité
     sur deux nœuds, effet d'un changement de label sur un Pod en cours ; lire les verdicts `hubble observe --verdict DROPPED` — CCA-02-02.
  3. Jouer les modes d'application `default`, `always`, `never` (`policyEnforcementMode`), le mode audit (`policy-audit-mode`) et
     l'annotation `policy.cilium.io/proxy-visibility` ; prédire, avant d'appliquer, l'effet d'une policy donnée (ingress seul, egress seul,
     `endpointSelector: {}`) puis vérifier — CCA-02-01, CCA-02-03.
- **Break-fix** : `break/reseau/12-cilium-policy-deny-dns.sh` (policy egress sans règle vers kube-dns : résolution cassée, HTTP semble
  « lent » puis échoue).
- **Défi chronométré** : isoler un namespace en « deny par défaut » avec exceptions DNS + une route HTTP `GET /api` en moins de 12 min,
  vérifié par `hubble observe`.

### F4 — `fiches/reseau/13-cilium-hubble-observabilite.md`

- **Titre** : Hubble — flux L3/L4, visibilité L7, CLI et UI
- **Niveau** : confirmé (`reseau_conf`)
- **Couvre** : CCA-04-01, CCA-04-02, CCA-04-03
- **Prérequis** : F3 (les verdicts de policy sont la matière des flux) ; `observabilite_deb` recommandé (Prometheus, Grafana)
- **Lab** : `kubernetes-ha` (Prometheus et Grafana du profil pour les métriques Hubble) ; repli `kind`.
  Clés `versions.yaml` : `cilium`, `cilium_cli`, `hubble`, `prometheus`, `grafana`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Activer Hubble (`cilium hubble enable --ui`), installer le CLI `hubble`, `hubble status`, `hubble observe` avec filtres
     `--namespace`, `--pod`, `--protocol`, `--verdict`, `--from-label`, `--to-fqdn`, `--http-status`, sortie `-o json` ;
     exposer l'UI par Gateway API (`hubble.apps.lab.home.arpa`, certificat de la CA interne) — CCA-04-01, CCA-04-03.
  2. Activer la visibilité L7 (HTTP, DNS, Kafka en lecture) par une `CiliumNetworkPolicy` avec `rules.http: [{}]` et par
     l'annotation de proxy-visibility ; comparer les flux avant/après, lire les métriques `hubble_http_requests_total`,
     `hubble_dns_responses_total` dans Prometheus, importer le tableau de bord Hubble dans Grafana — CCA-04-02.
  3. Diagnostiquer avec Hubble : policy qui bloque, Service sans endpoint, DNS qui échoue ; produire le flux exact qui prouve chaque cause
     et le comparer avec `cilium-dbg monitor` — CCA-04-01, CCA-04-03.
- **Break-fix** : `break/reseau/13-hubble-relay-down.sh` (`hubble-relay` scalé à 0 et TLS cassé : CLI en `unavailable`, UI vide).
- **Défi chronométré** : trouver, dans un namespace inconnu, quelle policy bloque quel flux et le prouver avec un seul filtre `hubble observe`,
  en moins de 8 min.

### F5 — `fiches/reseau/14-cilium-gateway-api-service-mesh.md`

- **Titre** : Cilium — Ingress et Gateway API, chiffrement en transit, mesh sans sidecar
- **Niveau** : confirmé (`reseau_conf`)
- **Couvre** : CCA-03-01, CCA-03-02, CCA-03-03, CCA-03-04, CCA-03-05
- **Prérequis** : F3, F4 ; `services_deb` recommandé (PKI interne cert-manager, DNS `*.apps.lab.home.arpa`)
- **Lab** : `kubernetes-ha` (pool LoadBalancer `10.10.40.200`–`.219`, cert-manager, CA interne) ; repli `kind` avec `port-forward`
  (DECISIONS.md, 2026-10-02). Clés `versions.yaml` : `cilium`, `cilium_cli`, `gateway_api`, `cert_manager`, `istio`
  (comparaison, lecture seule), `spire` (à créer si authentification mutuelle).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Exposer la même application en `Ingress` (`ingressClassName: cilium`, mode `dedicated` vs `shared`) puis en Gateway API
     (`GatewayClass cilium`, `Gateway`, `HTTPRoute` avec `matches`, `filters` de réécriture et d'en-têtes, pondération entre deux
     backends, `TLSRoute`/`GRPCRoute`) ; lister ce que Gateway API apporte (rôles, portabilité, expressivité) — CCA-03-01, CCA-03-03.
  2. Activer le chiffrement transparent WireGuard (`encryption.enabled`, `type: wireguard`), vérifier avec `cilium encrypt status`,
     `wg show` sur un nœud et un `tcpdump` sur le VLAN 30 ; comparer avec IPsec (rotation de clé) et avec le mTLS d'un mesh à sidecar —
     CCA-03-04, CCA-03-05.
  3. Cas d'usage service mesh sans sidecar : L7 par Envoy embarqué (`CiliumEnvoyConfig`), observabilité L7, authentification mutuelle
     (`authentication.mode: required` + SPIRE, variante), canary par poids d'`HTTPRoute` ; schéma Mermaid « sidecar vs sidecarless »
     et tableau Cilium / Istio ambient / Istio sidecar — CCA-03-02, CCA-03-05.
- **Break-fix** : `break/reseau/14-gateway-tls-secret-manquant.sh` (`certificateRefs` vers un Secret absent : `Gateway` `Programmed=False`,
  HTTPS en échec alors que HTTP passe).
- **Défi chronométré** : du Service à l'URL `https://app.apps.lab.home.arpa` avec certificat valide et répartition 90/10 en moins de 15 min.

### F6 — `fiches/reseau/15-cilium-bgp-egress-gateway.md`

- **Titre** : Cilium — BGP vers le routeur du lab, LB-IPAM, Egress Gateway
- **Niveau** : expert (`reseau_exp`)
- **Couvre** : CCA-08-01, CCA-08-02
- **Prérequis** : F2 (routage natif, masquerading), F5 (LoadBalancer pour la Gateway) ; `proxmox_conf` recommandé (OPNsense `core-rtr01`,
  plugin `os-frr`) ; `reseau_conf` acquis (BGP : AS, voisins, annonces)
- **Lab** : `kubernetes-ha` + socle `core` (OPNsense en AS 65000, nœuds en AS 65001 sur le VLAN 40 `provider`) ; **pas de repli `kind`**.
  Clés `versions.yaml` : `cilium`, `cilium_cli`, `opnsense`, `metallb` (variante comparée).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Activer le BGP control plane (`bgpControlPlane.enabled`), écrire `CiliumBGPClusterConfig`, `CiliumBGPPeerConfig`,
     `CiliumBGPAdvertisement` (PodCIDR et Services LoadBalancer), configurer le voisin FRR sur OPNsense, lire `cilium bgp peers`,
     `cilium bgp routes` et la table BGP du routeur — CCA-08-02.
  2. Remplacer MetalLB par `CiliumLoadBalancerIPPool` (`10.10.40.200`–`.219`) + annonce BGP, puis comparer avec l'annonce L2
     (`CiliumL2AnnouncementPolicy`) et avec MetalLB ; depuis le poste du LAN, joindre une `Gateway` sans NAT de port — CCA-08-02.
  3. Egress : masquerading par nœud vs `CiliumEgressGatewayPolicy` (IP de sortie fixe sur un nœud dédié du VLAN 40) ; vérifier
     l'adresse source vue par un serveur du VLAN 10, perdre le nœud egress et mesurer le basculement ; lister les besoins
     (`kubeProxyReplacement`, routage natif ou tunnel, exclusions de CIDR) — CCA-08-01.
- **Break-fix** : `break/reseau/15-bgp-session-idle.sh` (ASN du voisin faux dans `CiliumBGPPeerConfig` : session `idle`, Services LoadBalancer
  injoignables depuis le LAN).
- **Défi chronométré** : session BGP `established` et une IP LoadBalancer annoncée et joignable depuis le LAN en moins de 15 min.

### F7 — `fiches/reseau/16-cilium-cluster-mesh.md`

- **Titre** : Cilium Cluster Mesh — deux clusters, un service global
- **Niveau** : expert (`reseau_exp`)
- **Couvre** : CCA-06-01, CCA-06-02
- **Prérequis** : F2 (CIDR disjoints, routage), F3 (policies inter-clusters), F6 recommandé (BGP entre sites)
- **Lab** : chemin principal : deux clusters `kind` sur `linux-base-lx01` (4 vCPU / 8 Go, `cluster-name`/`cluster-id` distincts,
  PodCIDR `10.244.0.0/16` et `10.245.0.0/16`, Services `10.96.0.0/12` et `10.112.0.0/12`, `labs/network.md` §4).
  Variante expert : `kubernetes-ha` + cluster « site B » k3s dans le VLAN 60 `wan-sim` avec `tc netem` (latence, pertes), marquée
  `[lecture + simulation]` si le budget RAM ne le permet pas (`labs/network.md`). Clés `versions.yaml` : `cilium`, `cilium_cli`, `kind`, `k3s`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Préparer deux clusters mesh-compatibles (noms, IDs, CIDR disjoints, CA partagée), `cilium clustermesh enable --service-type NodePort`
     puis `cilium clustermesh connect`, `cilium clustermesh status --wait`, lire `clustermesh-apiserver` et les `CiliumNode` distants ;
     expliquer les bénéfices (HA, migration, partage de services, politiques globales) — CCA-06-01.
  2. Service global : annotation `service.cilium.io/global: "true"`, `service.cilium.io/affinity: local|remote|none`,
     `service.cilium.io/shared: "false"` ; couper les backends d'un cluster et observer la répartition avec `cilium-dbg service list`
     et `hubble observe` — CCA-06-02.
  3. Policy inter-clusters avec `matchLabels: {io.cilium.k8s.policy.cluster: site-b}` ; déconnecter le mesh (`clustermesh disconnect`),
     relancer, puis mesurer l'effet d'une latence `tc netem 80 ms` sur la synchronisation des identités — CCA-06-01, CCA-06-02.
- **Break-fix** : `break/reseau/16-clustermesh-cidr-chevauchement.sh` (second cluster recréé avec le même PodCIDR : mesh `connected` mais
  flux inter-clusters perdus).
- **Défi chronométré** : service global joignable depuis les deux clusters, avec basculement vérifié, en moins de 20 min.

### S1 — `scenarios/NN-plateforme-reseau-cilium/README.md`

- **Titre** : NN — Réseau zéro confiance de bout en bout avec Cilium sur le lab (numéro `NN` attribué à la création)
- **Niveau** : expert (`reseau_exp`) ; prérequis F1 à F7 complets, pas de saut direct
- **Couvre** : les 28 compétences CCA en situation, plus CKA-03-02, CKA-03-04, CKS-01-01, CKS-04-04 (à confirmer par leurs cartographies)
- **Lab** : `kubernetes-ha` + `core` (OPNsense BGP) + `linux-base` (cluster `kind` « site B »), Prometheus/Grafana du profil.
  Clés `versions.yaml` : `cilium`, `cilium_cli`, `hubble`, `gateway_api`, `cert_manager`, `opnsense`, `kind`.
- **Temps** : 6 h en deux séances
- **Livrable** : runbook « ouvrir un flux » (demande → policy → preuve Hubble) + ADR « routage natif + BGP vs tunnel + L2 »
- **3 exercices clés** :
  1. Construire la plateforme : Cilium sans kube-proxy, routage natif, BGP vers OPNsense, LB-IPAM, Gateway API avec TLS de la CA interne,
     WireGuard entre nœuds, Hubble exporté vers Prometheus.
  2. Déployer une application à trois tiers en « deny par défaut » cluster-wide, n'ouvrir que les flux prouvés par Hubble, exposer l'API
     en canary 90/10, publier un service global vers le cluster « site B ».
  3. Break-fix transverse injecté à l'aveugle (`break.sh random` sur `break/reseau/1*.sh`) : agent en crash, policy DNS, session BGP
     `idle`, Secret TLS manquant, CIDR en double ; diagnostiquer de bout en bout en moins de 30 min et rédiger le postmortem.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| F1 Installation et architecture (rédigé, brouillon) | confirmé | kubernetes-ha (ou kind sur linux-base) | 5 h |
| F2 IPAM, datapath et eBPF | confirmé | kubernetes-ha (kind partiel) | 6 h |
| F3 Network Policy | confirmé | kubernetes-ha (ou kind) | 6 h |
| F4 Hubble | confirmé | kubernetes-ha (ou kind) | 4 h |
| F5 Gateway API et service mesh | confirmé | kubernetes-ha (kind avec port-forward) | 6 h |
| F6 BGP, LB-IPAM, egress | expert | kubernetes-ha + core (OPNsense) | 6 h |
| F7 Cluster Mesh | expert | linux-base (2 × kind) ; variante kubernetes-ha + wan-sim | 5 h |
| S1 Plateforme réseau Cilium | expert | kubernetes-ha + core + linux-base | 6 h |
| Révision (flashcards, quiz, examen blanc `exams/`) | — | — | 6 h |
| **Total** | | | **50 h** |

À 5 h par semaine, compter 10 semaines, soit deux cycles de 4 à 6 semaines de `docs/roadmap.md` §7 ; le bloc `reseau_conf`
du parcours Golden Kubestronaut regroupe CCA avec ICA et KCA, à planifier sur trois cycles.

## 6. Ce que le lab ne couvre pas

- **Routage natif entre nœuds** sur `kind` : les nœuds partagent un bridge Docker, la démonstration n'a de sens que sur les VM de
  `kubernetes-ha` (VLAN 30). Sur `kind`, F2 marque cette section `[lecture + simulation]`.
- **BGP et Egress Gateway** (F6) : impossibles sur `kind` ; ils attendent `core-rtr01` (OPNsense + `os-frr`) et `kubernetes-ha`.
- **Cluster Mesh multi-site réel** : deux `kind` sur une VM pour le chemin principal ; la variante « site B » dans le VLAN 60 avec
  `tc netem` reste `[lecture + simulation]` si `kubernetes-ha` + un second cluster dépassent le budget RAM (`labs/network.md` §4).
- **XDP, DSR et Maglev** (datapath avancé, CCA-01-05) : XDP natif exige un pilote compatible ; sur des VM virtio le mode générique
  suffit pour la démonstration, les performances sont `[lecture + simulation]`.
- **Fonctionnalités d'entreprise** (Isovalent) et **intégrations cloud** (ENI AWS, Azure IPAM, GKE) citées par le programme CCA-01-03 :
  `[lecture]` dans F2, à connaître pour le QCM, non praticables sur Proxmox.
- L'examen est un QCM sans documentation (`examen.md`) : les flashcards de chaque fiche et le quiz `revision/quiz/` sont la préparation
  directe, les manipulations servent la rétention.
