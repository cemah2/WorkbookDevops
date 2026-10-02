---
chapitre: "fiches/reseau/10-cilium-installation-architecture.md"
domaine: "reseau"
niveau: "confirmé"
statut: "réalisé le 2026-10-02 — plan validé (recommandations des six questions retenues), chapitre en brouillon, relecture critique à faire (prompts/04)"
duree_estimee: "5 h"
profil_lab: "linux-base (kind sur une VM) ; variante kubernetes-ha (kubeadm sans kube-proxy)"
versions: "cilium, cilium_cli, hubble, kubernetes, kubeadm, kind, helm"
certifications:
  - "CCA-01-01"
  - "CCA-01-02"
  - "CCA-01-04"
  - "CCA-05-01"
  - "CCA-05-02"
  - "CKA-05-07 (à confirmer par la cartographie CKA)"
  - "KCNA-02-01 (à confirmer par la cartographie KCNA)"
  - "KCSA-02-09 (à confirmer par la cartographie KCSA)"
---

# Plan — 10 Cilium : installer avec le CLI, lire l'architecture, tester la connectivité

Réalisé : `fiches/reseau/10-cilium-installation-architecture.md` (2026-10-02). Écarts constatés à la rédaction :
la panne CNI vise le binaire `cilium-cni` et non le fichier de configuration (que l'agent réécrit) ; la panne « agent »
passe par la variable `KUBERNETES_SERVICE_HOST` du DaemonSet, pas par la ConfigMap ; l'exercice 3.2 ne supprime plus
de `CiliumNode` (l'agent ne le recrée pas sans redémarrage, constaté) mais retire l'agent d'un nœud par `nodeSelector`.

Chapitre `F1` de `certifs/CCA/objectifs.md` §4, nœud `reseau/10-cilium-installation-architecture` de `docs/prerequis.md` §6.5
(numéro `10` attribué par la cartographie CCA, DECISIONS.md 2026-10-02 « série Cilium numérotée 10 à 16 »).
Pourquoi lui en premier : il couvre 5 compétences dont les deux d'Installation and Configuration (5 % chacune, le poids
le plus élevé du programme), et les six autres fiches Cilium en dépendent.

Arbitrages hérités (DECISIONS.md, 2026-10-02) : chemin principal `kind` sur `linux-base` tant que `lab up kubernetes-ha`
n'existe pas, `kubernetes-ha` en variante ; kube-proxy absent et Cilium en `kubeProxyReplacement` ; installation par le CLI
`cilium` à la version exacte de `versions.yaml`, jamais `latest` ; Helm 4 pour la variante Helm ; Gateway API Cilium
pour exposer les UI (pas d'UI dans cette fiche, Hubble UI arrive en fiche 13).

## 1. Objectifs mesurables

À la fin de la fiche tu sais :

- expliquer sans notes, en trois phrases, ce que Cilium remplace dans un cluster Kubernetes (CNI, kube-proxy, NetworkPolicy,
  observabilité) et ce qu'il ne remplace pas (API server, CoreDNS, runtime) ;
- installer le CLI `cilium` à la version `cilium_cli`, installer Cilium à la version `cilium` sur un cluster sans CNI
  et obtenir `cilium status --wait` sans erreur en moins de 15 min ;
- nommer sans notes les composants (`cilium-agent`, `cilium-operator`, `cilium-envoy`, `cilium-cni`, `hubble-relay`,
  `clustermesh-apiserver`) et les CRD de base (`CiliumNode`, `CiliumEndpoint`, `CiliumIdentity`, `CiliumNetworkPolicy`)
  et dire en une phrase ce que fait chacun ;
- lire et modifier la configuration avec `cilium config view`, `cilium config set` et `helm get values`, et prédire
  si un changement demande un redémarrage des agents, en moins de 5 min ;
- lancer `cilium connectivity test`, lire un rapport d'échec et remonter à la cause en moins de 10 min ;
- produire un `cilium sysdump` et y retrouver la configuration effective d'un agent et ses logs en moins de 5 min ;
- dire ce qui continue de fonctionner quand `cilium-operator` est arrêté, et quand un `cilium-agent` est arrêté,
  après l'avoir vérifié sur le cluster.

## 2. Niveau et prérequis

- Confirmé, nœud `reseau_conf` (`docs/prerequis.md` §6.5). Pas de fiche Cilium débutant : `reseau_deb` est un prérequis
  de `kubernetes_deb`, dont Cilium a besoin.
- Prérequis : nœuds `reseau_deb` (modèle OSI, TCP/UDP, DNS, HTTP, routage, VLAN du lab) et `kubernetes_deb` (kubectl, Pods,
  Deployments, Services, namespaces, DaemonSet, ConfigMap). Aucun chapitre n'existe pour ces nœuds au 2026-10-02 :
  le front matter cite les nœuds, pas des fichiers.
- Arête inter-domaines nouvelle : `kubernetes_deb` → cette fiche (justifiée dans `certifs/CCA/objectifs.md` §2).
- Infrastructure : une VM Ubuntu du profil `linux-base` avec Docker et `kind` ; en variante, `kubernetes-ha` bootstrappé
  avec `kubeadm init --skip-phases=addon/kube-proxy` (doc officielle Cilium, `Documentation/installation/k8s-install-kubeadm.rst`).

## 3. Compétences couvertes

| Section | CCA | Autres (à confirmer par leur cartographie) |
|---|---|---|
| 1 Le rôle de Cilium, cluster sans CNI → cluster qui marche | CCA-01-01, CCA-05-02 | CKA-05-07, KCNA-02-01 |
| 2 Le CLI : status, config, sysdump, connectivity test | CCA-05-01, CCA-05-02 | — |
| 3 Architecture et rôle des composants | CCA-01-02, CCA-01-04 | KCSA-02-09 |

CCA-01-03 (IPAM) et CCA-01-05 (datapath) sont volontairement renvoyés à la fiche 11 : cette fiche montre seulement
le mode IPAM par défaut (`cluster-pool`) et le tunnel VXLAN par défaut, sans les comparer.

## 4. Sections et exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Créer un cluster `kind` 1 control plane + 2 workers avec `disableDefaultCNI: true` et `kubeProxyMode: none` (variante : `kubeadm init --skip-phases=addon/kube-proxy`) ; constater nœuds `NotReady`, CoreDNS `Pending`, aucun fichier dans `/etc/cni/net.d` ; installer le CLI à la version `cilium_cli` ; `cilium install --version <cilium>` avec `kubeProxyReplacement=true`, `k8sServiceHost`/`k8sServicePort` ; `cilium status --wait` | nœuds `Ready`, CoreDNS `Running`, `KubeProxyReplacement: True` dans `cilium status --verbose` |
| 1.2 | 1 | autonome | Déployer deux Pods sur deux nœuds et un Service `ClusterIP` ; prouver que le trafic Pod→Pod inter-nœuds et Pod→Service passe sans kube-proxy (`kubectl get ds -n kube-system`, `iptables-save \| grep -c KUBE-SVC` ≈ 0, `cilium-dbg service list`) ; écrire en trois phrases ce que Cilium fait à la place | tableau rempli, commandes jointes |
| 1.3 | 1 | break-fix | `break/reseau/10-cilium-cni-conf-absent.sh` | nouveaux Pods `Running` sur le nœud touché |
| 1.4 | 1 | chronométré | Cluster `kind` sans CNI → `cilium status` vert et deux Pods qui se pinguent | 15 min |
| 2.1 | 2 | guidé | `cilium status --verbose`, `cilium config view`, `cilium config set debug true` (observer le redémarrage des agents et l'option `--restart=false`), `cilium config view` vs `kubectl -n kube-system get cm cilium-config`, `cilium sysdump` et lecture de l'archive, `cilium connectivity test` complet puis `--test` ciblé | sysdump produit, test `OK` |
| 2.2 | 2 | autonome | Même installation en Helm 4 (`helm install cilium cilium/cilium --version <cilium>` avec les mêmes valeurs) sur un second cluster `kind`, `helm get values`, puis `cilium upgrade --reuse-values` sur le premier ; expliquer ce que le CLI a généré comme valeurs Helm (`cilium install --dry-run-helm-values`) | valeurs équivalentes, différences expliquées |
| 2.3 | 2 | break-fix | `break/reseau/10-cilium-agent-crashloop.sh` | agents `Running`, `cilium status` vert |
| 2.4 | 2 | chronométré | Lire un `connectivity test` qui échoue (panne injectée à l'aveugle parmi les scripts de la fiche) et nommer la cause | 10 min |
| 3.1 | 3 | guidé | Cartographier les composants : `kubectl -n kube-system get ds,deploy`, `cilium-dbg status` dans un agent, `CiliumNode`, `CiliumEndpoint` et `CiliumIdentity` d'un Pod, `cilium-envoy` (DaemonSet séparé), `cilium-cni` sur le nœud (`/opt/cni/bin`, `/etc/cni/net.d/05-cilium.conflist`) ; schéma Mermaid agent / operator / envoy / CRD / API server | schéma complété par l'apprenant |
| 3.2 | 3 | autonome | Scaler `cilium-operator` à 0 : créer des Pods, un nouveau nœud `kind` (`kind` ne sait pas ajouter un nœud : variante `kubernetes-ha` avec `kubeadm join`, sinon simuler en supprimant le `CiliumNode` d'un worker), observer ce qui bloque et ce qui continue ; puis arrêter un seul agent (`nodeSelector` temporaire) et refaire le même tableau | tableau « qui fait quoi » rempli et vérifié |
| 3.3 | 3 | break-fix | `break/reseau/10-cilium-operator-down.sh` (optionnel, panne silencieuse) | `cilium status` sans avertissement |
| 3.4 | 3 | chronométré | Expliquer à l'oral (enregistrement ou pair) les composants et ce qui se passe à la création d'un Pod, sans notes | 5 min, 6 composants nommés |

Lecture ≤ 20 % : le concept de chaque section tient en dix lignes et un schéma ; les comparaisons (eBPF vs iptables,
tunnel vs natif) sont renvoyées à la fiche 11.

## 5. Scénarios de panne (`break/reseau/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `10-cilium-cni-conf-absent.sh` | supprime `/etc/cni/net.d/05-cilium.conflist` sur un worker (Pod privilégié + `nsenter`, ou `docker exec` sur `kind`) | nouveaux Pods du nœud en `ContainerCreating`, événement « no network config found », les Pods existants continuent |
| `10-cilium-agent-crashloop.sh` | `k8s-service-host` pointé vers une adresse injoignable dans `cilium-config` + `rollout restart` du DaemonSet | agents `CrashLoopBackOff`, logs « unable to connect to API server », nœuds `NotReady` après le délai, `cilium status` rouge |
| `10-cilium-operator-down.sh` (optionnel) | `cilium-operator` à 0 réplica | tout semble marcher ; `cilium status` affiche l'operator indisponible ; un `CiliumNode` supprimé ne reçoit plus de PodCIDR, les Pods du nœud passent `ContainerCreating` |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck ; variable `KIND_CLUSTER` ou `NODE` pour cibler le nœud.
Le `--undo` de la panne CNI redémarre l'agent du nœud, qui réécrit le fichier (comportement à vérifier à la rédaction).

## 6. Profil de lab et budget

- Chemin principal : `linux-base`, une VM (4 vCPU / 8 Go / 60 Go pris sur le budget 8 vCPU / 16 Go / 180 Go), Docker + `kind`
  0.33.0, image de nœud `kindest/node:v1.37.0` avec son digest (seule image 1.37 publiée avec `kind` 0.33.0 ; Kubernetes
  1.37.1 de `versions.yaml` n'a pas d'image `kind`). Cluster 1 + 2 nœuds ; un second cluster éphémère pour l'exercice 2.2
  (environ 1 vCPU / 1,5 Go de plus). Deux clusters `kind` + Cilium : environ 3 vCPU / 5 Go.
- Variante : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go), kubeadm 1.37.1 sans kube-proxy, `k8sServiceHost=10.10.40.220`
  (VIP API, `labs/network.md` §5), `k8sServicePort=6443`, VLAN 30 `overlay` pour le tunnel.
- Rien ne touche `core` ni le routeur : pas de BGP, pas de Gateway, pas de DNS interne dans cette fiche.

## 7. Points de vigilance `versions.yaml`

- `cilium` 1.20.2 : les notes de version 1.20.0 annoncent le support de Kubernetes **1.36** ; le lab est en **1.37.1**.
  À vérifier dans `Documentation/network/kubernetes/compatibility.rst` de la version 1.20.2 avant rédaction ; si 1.37 n'est pas
  listé, la fiche le signale et la variante `kubernetes-ha` reste sur 1.37 avec un `[non testé : hors matrice]`, ou le lab
  Cilium épingle 1.36 (question Q4).
- `cilium` 1.20 : version de configuration CNI passée de 0.3.1 à 1.0.0, `cilium-envoy` en DaemonSet séparé, `hubble.enabled: true`
  par défaut dans les valeurs Helm (mais pas `hubble-relay`), `kubeProxyReplacement: "false"` par défaut Helm (le CLI ne le force pas :
  toujours le passer explicitement), `ipam.mode: cluster-pool`, `operator.replicas: 2` (le CLI le ramène à 1 sur `kind`, à vérifier).
- `cilium_cli` 0.20.1 : numérotation indépendante de Cilium ; la version de Cilium installée par défaut par le CLI n'est pas
  forcément 1.20.2, donc toujours `cilium install --version 1.20.2`. Vérifier que `cilium config set` déclenche bien un
  redémarrage des agents par défaut (`--restart`) dans cette version.
- `hubble` 1.20.2 : non installé dans cette fiche (fiche 13) ; la fiche indique seulement que la CLI suit le numéro de Cilium.
- `kind` 0.33.0 : utiliser le digest de l'image publié avec la release ; vérifier que `kubeProxyMode: none` est toujours accepté.
- `helm` 4.3.0 : dépôt `https://helm.cilium.io/` ; vérifier que le chart 1.20.2 s'installe avec Helm 4 (variante 2.2 seulement).
- Noyau : Cilium 1.20 exige ≥ 5.10 (`Documentation/operations/system_requirements.rst`) ; Ubuntu 24.04 (6.8) convient,
  `kind` utilise le noyau de la VM.

## 8. `[lecture + simulation]`

- IPAM cloud (ENI AWS, Azure, GKE) cité par CCA-01-03 : lecture seule, renvoyé à la fiche 11, non praticable sur Proxmox.
- Ajout d'un nœud à chaud (exercice 3.2) : `kind` ne sait pas ajouter un nœud ; simulation par suppression du `CiliumNode`,
  manipulation réelle sur `kubernetes-ha` (`kubeadm join`).
- Mode datapath `netkit` (`bpf.datapathMode=auto`, nouveauté 1.20) : mentionné en une ligne, démontré en fiche 11 si le noyau
  6.8 le permet.
- Hors périmètre, lecture seule avec renvoi vers les fiches suivantes : IPAM et datapath (11), policies (12), Hubble (13),
  Gateway API, chiffrement et ztunnel (14), BGP (15), Cluster Mesh (16). Trois à cinq flashcards les couvrent car l'examen
  les cite dans le domaine Architecture.

## 9. Livrables attendus de la session de rédaction

- `fiches/reseau/10-cilium-installation-architecture.md` (gabarit `templates/fiche.md`) et `fiches/reseau/10-cilium-installation-architecture/manifests/`
  (config `kind`, valeurs Helm, Pods de test ; validés `kubeconform`)
- `solutions/fiches/reseau/10-cilium-installation-architecture.md` (3 indices puis correction)
- `break/reseau/10-*.sh` (2 scripts, 1 optionnel)
- `revision/flashcards/reseau-10-cilium-installation-architecture.csv` (10 à 20 cartes)
- mise à jour de `certifs/CCA/objectifs.md` §3 et §4, de `docs/prerequis.md` §6.5 (nœud `rédigé`), de `docs/plans/README.md`
  et de ce plan (`statut: réalisé`)

## 10. Questions posées à la validation (réponses du 2026-10-02 : recommandation retenue dans les six cas)

Recommandation en premier dans chaque cas.

- **Q1 — Chemin principal.** `kind` sur une VM `linux-base` (recommandé : même choix que les fiches Argo, exécutable en session
  de rédaction si Docker est disponible) ou kubeadm à la main sur trois VM `linux-base` (plus proche de l'examen et du profil
  `kubernetes-ha`, mais consomme le profil entier et n'est pas scriptable en session) ?
- **Q2 — kube-proxy absent dès cette fiche.** Oui (recommandé : c'est la décision du 2026-10-02 pour `kubernetes-ha`, et le
  programme CCA parle de « kube-proxy replacement » dès l'architecture) ou installer d'abord avec kube-proxy et ne retirer
  kube-proxy qu'en fiche 11 avec le datapath ?
- **Q3 — Variante Helm.** Dans cette fiche en exercice autonome 2.2 (recommandé : CCA-05-01 attend qu'on sache lire la
  configuration par les deux voies, et Helm 4 est la décision du dépôt) ou reportée en fiche 11 pour alléger ?
- **Q4 — Version de Kubernetes du lab Cilium.** Rester sur 1.37.x avec un `[non testé : hors matrice]` si Cilium 1.20 ne le liste
  pas (recommandé : une seule version de Kubernetes dans `versions.yaml`, écart signalé) ou épingler 1.36 pour la série Cilium
  via une clé `exam_note` ?
- **Q5 — Hubble.** Rien dans cette fiche (recommandé : la fiche 13 l'installe et le CLI `hubble` n'est pas un prérequis de
  l'installation) ou `cilium hubble enable` dès 2.1 pour que les fiches 11 et 12 puissent lire des flux ?
- **Q6 — Panne optionnelle.** Garder `10-cilium-operator-down.sh` (recommandé : c'est la seule panne « silencieuse » de la fiche,
  et le QCM pose la question « que se passe-t-il sans operator ») ou la remplacer par une panne d'image (`ImagePullBackOff`
  sur `cilium-agent`), plus simple mais moins instructive ?
