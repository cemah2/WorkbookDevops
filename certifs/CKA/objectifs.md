---
code: CKA
titre: "CKA — mapping compétences → chapitres"
programme: "certifs/CKA/programme.md (Kubernetes 1.35, converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14)"
chapitres_existants: 0
generated: 2026-10-02
status: "aucun chapitre kubernetes rédigé ; couverture partielle par deux fiches gitops ; à mettre à jour à chaque PR de chapitre"
---

# CKA — objectifs et couverture

Mapping entre les 25 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : le dossier `fiches/kubernetes/` est vide. Deux fiches `gitops` (Argo CD, Argo Workflows)
touchent cinq compétences CKA en passant (RBAC, NodePort, Gateway API en variante, logs, limites de ressources) ;
elles sont citées comme couverture **partielle** et ne dispensent d'aucun chapitre.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices »
et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| CKA-01 Storage | 10 % | 3 | 3,3 % | 1 fiche |
| CKA-02 Workloads and Scheduling | 15 % | 5 | 3,0 % | 3 fiches |
| CKA-03 Servicing and Networking | 20 % | 6 | 3,3 % | 2 fiches |
| CKA-04 Troubleshooting | 30 % | 5 | 6,0 % | 2 fiches |
| CKA-05 Cluster Architecture, Installation and Configuration | 25 % | 8 | 3,1 % | 4 fiches |
| Transverse | — | 25 | — | 1 scénario + 1 examen blanc |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle. Les cinq compétences de dépannage pèsent chacune deux fois plus
qu'une compétence de stockage ou de réseau : le dépannage est le fil rouge de toutes les fiches, pas seulement des deux qui lui sont
dédiées.

Ordre de rédaction recommandé (socle débutant d'abord, puis du plus lourd au plus léger en respectant les prérequis) :
K1 kubectl/Pods/Deployments → K2 configuration et robustesse → K3 Services et CoreDNS → K4 stockage →
K5 cluster kubeadm HA → K11 dépannage nœuds et control plane → K12 dépannage applications et réseau →
K6 cycle de vie et etcd → K9 NetworkPolicy, Gateway API, Ingress → K8 ordonnancement et autoscaling →
K7 RBAC → K10 Helm, Kustomize, CRD, opérateurs → S1 scénario → E1 examen blanc.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : les clés `kubernetes`, `kubeadm`, `containerd`, `etcd`, `cilium`, `helm`, `kind`, `metallb`,
  `cert_manager`, `longhorn`, `rook`, `envoy_gateway` existent. Manquent, à ajouter par la veille (`prompts/07-veille.md`)
  ou par la PR du chapitre concerné :
  - `metrics_server` (`kubernetes-sigs/metrics-server`, datasource `github-releases`) : K8 (HPA) et K11 (`kubectl top`) ;
  - `gateway_api` (CRD du canal `standard`, `kubernetes-sigs/gateway-api`) : K9, Cilium ne les installe pas lui-même ;
  - `kube_vip` (`kube-vip/kube-vip`) : K5, VIP de l'API `10.10.40.220` du profil `kubernetes-ha` ;
  - `cri_tools` (`kubernetes-sigs/cri-tools`, `crictl`) : K5 et K11 ;
  - une entrée pour la version **précédente** de Kubernetes (par exemple `kubernetes_previous`, ligne `1.36.x` de `supported_lines`) :
    K6 installe n-1 puis met à niveau vers `kubernetes`. Sans cette clé, l'exercice de mise à niveau écrit une version en dur.
  - `kustomize` n'a pas besoin de clé : K10 utilise `kubectl kustomize` embarqué dans `kubernetes`, et le signale.
- `versions.yaml` : `kubernetes` vaut 1.37 alors que l'examen tourne en 1.35 (`exam_note`). Règle pour ces fiches : lab sur la version de
  `versions.yaml`, section « Points de vigilance (versions) » listant ce qui diffère en 1.35 (API, flags kubeadm, champs Gateway API).
  Pas de clé `exam` séparée tant que l'écart reste de deux mineures (à reconsidérer à la veille si l'examen reste en 1.35 quand le lab passe
  en 1.38).
- `labs/profiles/kubernetes-ha.yaml` : `lab up kubernetes-ha` doit pouvoir livrer les six VM **sans** Kubernetes installé
  (option `--bare` ou variante `bare` à ajouter) : K5, K6 et S1 construisent le cluster à la main, c'est l'objet de l'examen.
  Ajouter `metrics_server`, `gateway_api`, `kube_vip` à `components` une fois les clés créées.
- Décision à proposer dans `DECISIONS.md` (entrée datée, pas de réouverture) : **VIP du control plane par kube-vip**
  (static pod ARP sur le VLAN 40) plutôt que HAProxy + keepalived. Justification : un seul manifest, pas de VM supplémentaire,
  c'est la méthode documentée par kubeadm pour la HA « stacked etcd ». HAProxy + keepalived reste cité en lecture dans K5.
- Décision à proposer : **stockage dynamique par défaut** sur `kubernetes-ha` = Longhorn (profil seul) ; Rook-Ceph quand `ceph-3n`
  est levé en même temps. Les deux sont des CSI et servent à K4 et K10 ; sur `kind`, le `local-path-provisioner` embarqué suffit.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.2 (cette PR). Les nœuds amont `linux_conf`, `reseau_deb`,
  `proxmox_deb` n'ont encore aucun chapitre rédigé : comme les fiches `gitops`, K1 à K4 citent le nœud et ce que l'apprenant doit déjà
  savoir, sans chemin de fiche.
- Décisions déjà prises qui s'appliquent : Gateway API avec Cilium par défaut, Ingress conservé uniquement pour CKA-03-05 ;
  Helm 4 ; Ubuntu 24.04 LTS pour les nœuds ; fiches numérotées `NN-` dans l'ordre de lecture.

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe ; « partiel » quand une fiche d'un autre domaine manipule
la compétence sans l'enseigner. La colonne « chapitre cible » renvoie à la section 4.

### CKA-01 — Storage (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKA-01-01 | Implement storage classes and dynamic volume provisioning | 3,3 % | — | — | K4 |
| CKA-01-02 | Configure volume types, access modes and reclaim policies | 3,3 % | — | — | K4 |
| CKA-01-03 | Manage persistent volumes and persistent volume claims | 3,3 % | — | — | K4 |

### CKA-02 — Workloads and Scheduling (15 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKA-02-01 | Understand application deployments and how to perform rolling update and rollbacks | 3,0 % | — | — | K1 |
| CKA-02-02 | Use ConfigMaps and Secrets to configure applications | 3,0 % | — | — | K2 |
| CKA-02-03 | Configure workload autoscaling | 3,0 % | — | — | K8 |
| CKA-02-04 | Understand the primitives used to create robust, self-healing, application deployments | 3,0 % | — | — | K2 |
| CKA-02-05 | Configure Pod admission and scheduling (limits, node affinity, etc.) | 3,0 % | partiel : `fiches/gitops/02-argo-workflows-fondamentaux.md` | S3 : limites de ressources d'un workflow, break-fix `break/gitops/02-argo-workflows-quota.sh` (ResourceQuota) | K8 |

### CKA-03 — Servicing and Networking (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKA-03-01 | Understand connectivity between Pods | 3,3 % | — | — | K3 |
| CKA-03-02 | Define and enforce Network Policies | 3,3 % | — | — | K9 |
| CKA-03-03 | Use ClusterIP, NodePort, LoadBalancer service types and endpoints | 3,3 % | partiel : `fiches/gitops/01-argo-cd-fondamentaux.md` | S1 autonome 1 : passer `argocd-server` en `NodePort` | K3 |
| CKA-03-04 | Use the Gateway API to manage Ingress traffic | 3,3 % | partiel (variante `kubernetes-ha`) : `fiches/gitops/01-argo-cd-fondamentaux.md`, `fiches/gitops/02-argo-workflows-fondamentaux.md` | `manifests/variante-gateway-argocd.yaml`, `manifests/variante-gateway-argo.yaml` (Gateway + HTTPRoute Cilium, certificat cert-manager) | K9 |
| CKA-03-05 | Know how to use Ingress controllers and Ingress resources | 3,3 % | — | — | K9 |
| CKA-03-06 | Understand and use CoreDNS | 3,3 % | — | — | K3 (+ K12 dépannage) |

### CKA-04 — Troubleshooting (30 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKA-04-01 | Troubleshoot clusters and nodes | 6,0 % | — | — | K11 |
| CKA-04-02 | Troubleshoot cluster components | 6,0 % | — | — | K11 (+ K6 etcd) |
| CKA-04-03 | Monitor cluster and application resource usage | 6,0 % | — | — | K11 |
| CKA-04-04 | Manage and evaluate container output streams | 6,0 % | partiel : `fiches/gitops/02-argo-workflows-fondamentaux.md` | S1-S2 : `kubectl logs -c wait`, `kubectl describe pod` ; break-fix `break/gitops/02-argo-workflows-image-pull.sh` | K12 (+ K1 bases) |
| CKA-04-05 | Troubleshoot services and networking | 6,0 % | — | — | K12 |

### CKA-05 — Cluster Architecture, Installation and Configuration (25 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKA-05-01 | Manage role based access control (RBAC) | 3,1 % | partiel : `fiches/gitops/02-argo-workflows-fondamentaux.md` | S1 autonome 1 : ServiceAccount `lab-ui` + RoleBinding sur `admin` + Secret de jeton ; S2 autonome 3 : droits minimum ; break-fix `break/gitops/02-argo-workflows-rbac.sh` | K7 |
| CKA-05-02 | Prepare underlying infrastructure for installing a Kubernetes cluster | 3,1 % | — | — | K5 |
| CKA-05-03 | Create and manage Kubernetes clusters using kubeadm | 3,1 % | — | — | K5 |
| CKA-05-04 | Manage the lifecycle of Kubernetes clusters | 3,1 % | — | — | K6 |
| CKA-05-05 | Implement and configure a highly-available control plane | 3,1 % | — | — | K5 |
| CKA-05-06 | Use Helm and Kustomize to install cluster components | 3,1 % | — | — | K10 |
| CKA-05-07 | Understand extension interfaces (CNI, CSI, CRI, etc.) | 3,1 % | — | — | K5 (CRI, CNI), K10 (CSI) |
| CKA-05-08 | Understand CRDs, install and configure operators | 3,1 % | partiel (exposition) : les deux fiches `gitops` installent des CRD (`Application`, `Workflow`) et leurs contrôleurs par manifests | aucun exercice sur les CRD elles-mêmes | K10 |

### Compétences partagées avec CKAD et CKS

CKA, CKAD et CKS forment le bloc Kubestronaut de `docs/prerequis.md` (jalons `kubernetes_conf` puis `securite_conf`).
Les chapitres ci-dessous citent les IDs CKAD et CKS réutilisables dans leur front matter pour éviter un doublon de fiche ;
les mappings CKAD et CKS eux-mêmes seront faits par leur propre session `prompts/01-cartographie-certification.md`.

| Chapitre | IDs CKA | IDs CKAD réutilisables | IDs CKS réutilisables |
|---|---|---|---|
| K1 kubectl, Pods, Deployments | CKA-02-01 | CKAD-01-02, CKAD-02-02, CKAD-03-03 | — |
| K2 configuration et robustesse | CKA-02-02, 02-04 | CKAD-03-02, CKAD-04-05, CKAD-04-06 | CKS-04-02 |
| K3 Services, EndpointSlices, CoreDNS | CKA-03-01, 03-03, 03-06 | CKAD-05-02 | — |
| K4 stockage | CKA-01-01 à 01-03 | CKAD-01-04 | — |
| K5 cluster kubeadm HA | CKA-05-02, 05-03, 05-05, 05-07 | — | CKS-01-05 |
| K6 cycle de vie, etcd | CKA-05-04 | — | CKS-02-04 |
| K7 RBAC | CKA-05-01 | CKAD-04-02, CKAD-04-07 | CKS-02-01, 02-02, 02-03 |
| K8 ordonnancement, admission, autoscaling | CKA-02-03, 02-05 | CKAD-04-03, CKAD-04-04 | — |
| K9 NetworkPolicy, Gateway API, Ingress | CKA-03-02, 03-04, 03-05 | CKAD-05-01, CKAD-05-03 | CKS-01-01, 01-03 |
| K10 Helm, Kustomize, CRD, opérateurs | CKA-05-06, 05-07, 05-08 | CKAD-02-03, CKAD-02-04, CKAD-04-01, CKAD-03-01 | — |
| K11 dépannage nœuds et control plane | CKA-04-01 à 04-03 | CKAD-03-03 | — |
| K12 dépannage applications et réseau | CKA-04-04, 04-05 | CKAD-03-04, CKAD-03-05 | — |

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de lecture recommandé (DECISIONS.md, 2026-10-02) ; l'ordre de **rédaction** (§1) diffère
pour les fiches confirmé, le numéro ne bouge pas.
Les fiches **débutant** (K1 à K4) ont pour chemin principal un cluster `kind` sur une VM du profil `linux-base`
(1 VM : 4 vCPU / 8 Go / 60 Go, comme les fiches `gitops`) et `kubernetes-ha` en variante.
Les fiches **confirmé** (K5 à K12) exigent le profil `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`),
levé **sans** Kubernetes pour K5, K6 et S1 (préalable §2), avec le cluster de K5 ensuite.
Toutes les compétences CKA sont praticables sur le lab : rien n'est `[lecture + simulation]`.
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.
Chaque fiche se termine par un défi chronométré en conditions d'examen : terminal seul, `kubernetes.io/docs` ouvert, minuteur.

### K1 — `fiches/kubernetes/01-kubectl-pods-deployments.md`

- **Titre** : kubectl, Pods et Deployments — déployer, mettre à jour, revenir en arrière
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKA-02-01 (+ bases de CKA-04-04 : `kubectl logs`, `describe`, `get events`)
- **Prérequis** : `linux_conf` (shell, systemd, SSH), `reseau_deb` (IP, ports), `proxmox_deb` (une VM Ubuntu prête) ; aucun chapitre rédigé
- **Lab** : `kind` sur `linux-base` ; variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`, `cilium`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer `kubectl` et `kind` à la version de `versions.yaml`, créer un cluster à trois nœuds, configurer l'autocomplétion,
     l'alias `k` et `kubectl explain` ; créer un Pod en impératif puis en YAML généré (`--dry-run=client -o yaml`) — CKA-02-01.
  2. Déployer une application en `Deployment` (3 replicas), observer le ReplicaSet, faire une mise à jour d'image en `RollingUpdate`
     (`maxSurge`, `maxUnavailable`), suivre `rollout status`, lire `rollout history` avec `--record` remplacé par une annotation
     `kubernetes.io/change-cause` — CKA-02-01.
  3. Provoquer un déploiement cassé (image inexistante), le détecter avec `kubectl get events --sort-by`, revenir à la révision précédente
     (`rollout undo --to-revision`), passer en stratégie `Recreate` et comparer ; lire les logs d'un conteneur précédent (`-p`) — CKA-02-01,
     CKA-04-04.
- **Break-fix** : `break/kubernetes/01-rollout-bloque.sh` (`maxUnavailable: 0` + image introuvable, rollout jamais terminé).
- **Défi chronométré** : déployer, mettre à jour et revenir en arrière une application en moins de 8 min,
  vérifié par `kubectl rollout history`.

### K2 — `fiches/kubernetes/02-configuration-probes-ressources.md`

- **Titre** : ConfigMaps, Secrets, probes et ressources — des applications qui se réparent seules
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKA-02-02, CKA-02-04
- **Prérequis** : K1
- **Lab** : `kind` sur `linux-base` ; variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Créer un ConfigMap et un Secret depuis des littéraux, des fichiers et un YAML ; les consommer en variables d'environnement
     (`envFrom`, `valueFrom`) et en volumes (`subPath`, `items`, mise à jour à chaud ou non) ; `immutable: true` — CKA-02-02.
  2. Ajouter `livenessProbe`, `readinessProbe`, `startupProbe` (HTTP, TCP, exec) à un Deployment, régler `initialDelaySeconds` et
     `failureThreshold`, observer les redémarrages et le retrait des Endpoints ; `restartPolicy` d'un Pod seul vs Job — CKA-02-04.
  3. Mettre en place `requests`/`limits`, un `PodDisruptionBudget`, un `DaemonSet` et un `Job`/`CronJob` avec `backoffLimit` ;
     tuer des Pods et un nœud `kind` pour vérifier que tout revient — CKA-02-04.
- **Break-fix** : `break/kubernetes/02-probe-trop-stricte.sh` (readiness qui échoue, Service sans Endpoints, Pods `Running` mais `0/1`).
- **Défi chronométré** : rendre une application « robuste » (probes, ressources, PDB, Secret monté) depuis un manifest nu en moins de 10
  min.

### K3 — `fiches/kubernetes/03-services-endpoints-coredns.md`

- **Titre** : Services, EndpointSlices et CoreDNS — la connectivité entre Pods
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKA-03-01, CKA-03-03, CKA-03-06
- **Prérequis** : K1 ; `reseau_deb`
- **Lab** : `kind` sur `linux-base` (MetalLB en mode L2 sur le réseau Docker) ; variante `kubernetes-ha` (pool `10.10.40.200-219`).
  Clés `versions.yaml` : `kubernetes`, `kind`, `cilium`, `metallb`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Tracer le chemin Pod → Pod (IP de Pod, `podCIDR` par nœud, route via le CNI) avec `kubectl exec` et un Pod `netshoot` ;
     expliquer ce que fait Cilium quand `kube-proxy` est remplacé — CKA-03-01.
  2. Exposer un Deployment en `ClusterIP`, `NodePort`, `LoadBalancer` (MetalLB) et `headless` ; lire les `EndpointSlices`,
     comparer `targetPort`/`port`/`nodePort`, créer un Service sans selector avec un Endpoint manuel vers un service externe — CKA-03-03.
  3. Résoudre `svc.ns.svc.cluster.local` depuis un Pod, lire `/etc/resolv.conf` (`ndots`, `searches`), éditer le ConfigMap `coredns`
     (zone `lab.home.arpa` en `forward` vers `core-dns01`), ajouter un `rewrite`, redémarrer et vérifier avec
     `kubectl logs -n kube-system -l k8s-app=kube-dns` — CKA-03-06.
- **Break-fix** : `break/kubernetes/03-selector-service.sh` (label du selector modifié, Service sans Endpoints, DNS répond pourtant).
- **Défi chronométré** : exposer une application en `NodePort` et en `LoadBalancer` et prouver la résolution DNS depuis un autre namespace
  en moins de 8 min.

### K4 — `fiches/kubernetes/04-stockage-pv-pvc-storageclass.md`

- **Titre** : Stockage — PV, PVC, StorageClass et provisionnement dynamique
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKA-01-01, CKA-01-02, CKA-01-03
- **Prérequis** : K1 ; `ceph_deb` recommandé pour la variante Rook-Ceph
- **Lab** : `kind` sur `linux-base` (`local-path-provisioner` embarqué, `hostPath` pour les PV statiques) ; variante `kubernetes-ha`
  avec Longhorn, ou Rook-Ceph si `ceph-3n` est levé (combinaison autorisée). Clés `versions.yaml` : `kubernetes`, `kind`, `longhorn`,
  `rook`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Créer un PV statique `hostPath` puis un PVC qui s'y lie ; jouer les trois `accessModes` (RWO, ROX, RWX) et les `reclaimPolicy`
     `Retain`/`Delete` ; supprimer le PVC et observer `Released` puis le rendre réutilisable (`claimRef`) — CKA-01-02, CKA-01-03.
  2. Lire les StorageClass existantes, en créer une (`provisioner`, `parameters`, `volumeBindingMode: WaitForFirstConsumer`,
     `allowVolumeExpansion`), la marquer par défaut, provisionner dynamiquement un PVC et l'agrandir à chaud — CKA-01-01.
  3. Sur `kubernetes-ha`, installer Longhorn (ou Rook-Ceph) par Helm, comparer `volumes` éphémères (`emptyDir`, `ephemeral` CSI) et
     persistants, déplacer un Pod avec son PVC d'un nœud à l'autre, lire les événements `ProvisioningFailed` — CKA-01-01, CKA-01-02.
- **Break-fix** : `break/kubernetes/04-pvc-pending.sh` (StorageClass référencée inexistante, PVC `Pending`, Pod bloqué `ContainerCreating`).
- **Défi chronométré** : créer StorageClass + PVC + Pod qui écrit un fichier, le retrouver après suppression du Pod, en moins de 8 min.

### K5 — `fiches/kubernetes/05-kubeadm-cluster-ha.md`

- **Titre** : Construire un cluster HA avec kubeadm — préparer les nœuds, trois control planes, Cilium
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKA-05-02, CKA-05-03, CKA-05-05, CKA-05-07 (CRI, CNI)
- **Prérequis** : K1 à K4 ; `linux_conf` (systemd, sysctl, paquets, pare-feu) ; `reseau_conf` (VLAN 10/30/40, VIP) ; `iac_deb` recommandé
  (`lab up`)
- **Lab** : `kubernetes-ha` levé **sans** Kubernetes (6 VM Ubuntu 24.04). Clés `versions.yaml` : `kubernetes`, `kubeadm`, `containerd`,
  `cri_tools` (à créer), `etcd`, `cilium`, `kube_vip` (à créer), `ubuntu_lts`.
- **Temps** : 8 h
- **3 exercices clés** :
  1. Préparer les six nœuds de façon reproductible (script puis rôle Ansible) : swap, modules `overlay`/`br_netfilter`, sysctl, containerd
     avec `SystemdCgroup`, dépôt `pkgs.k8s.io` épinglé sur la mineure de `versions.yaml`, `kubelet` en `hold`, ports ouverts ; vérifier avec
     `crictl info` et `kubeadm init phase preflight` — CKA-05-02, CKA-05-07.
  2. Déployer kube-vip en static pod sur `cp01`, `kubeadm init --control-plane-endpoint 10.10.40.220:6443 --upload-certs` avec un fichier
     `ClusterConfiguration` (`podSubnet` 10.244.0.0/16, `serviceSubnet` 10.96.0.0/12), installer Cilium avec `kubeProxyReplacement`,
     joindre `cp02`/`cp03` en control plane et les trois workers ; lire les certificats et les manifests de `/etc/kubernetes` — CKA-05-03,
     CKA-05-05.
  3. Prouver la HA : arrêter `cp01`, vérifier que l'API répond via la VIP, lire le quorum etcd (`etcdctl endpoint status`), remettre le
     nœud,
     retirer proprement un control plane (`kubeadm reset`, `etcdctl member remove`) et le rejoindre — CKA-05-05.
- **Break-fix** : `break/kubernetes/05-join-token-expire.sh` (token de jonction expiré et hash CA faux, `kubeadm join` échoue).
- **Défi chronométré** : à partir de trois VM préparées, cluster à 1 control plane + 2 workers `Ready` avec Cilium en moins de 20 min.

### K6 — `fiches/kubernetes/06-cycle-de-vie-etcd-upgrade.md`

- **Titre** : Cycle de vie du cluster — sauvegarde et restauration etcd, mise à niveau kubeadm, certificats
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKA-05-04 (+ CKA-04-02 pour etcd)
- **Prérequis** : K5
- **Lab** : `kubernetes-ha` construit par K5 **en version n-1** (`kubernetes_previous`, préalable §2). Clés `versions.yaml` : `kubernetes`,
  `kubernetes_previous` (à créer), `kubeadm`, `etcd`, `containerd`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. `etcdctl snapshot save` avec les certificats du static pod, vérifier (`snapshot status`), détruire un namespace, restaurer
     (`etcdutl snapshot restore --data-dir`), re-pointer le manifest etcd, vérifier le retour des objets ; même chose sur un etcd à trois
     membres — CKA-05-04, CKA-04-02.
  2. Mettre à niveau le cluster d'une mineure : `kubeadm upgrade plan`, `apply` sur le premier control plane, `upgrade node` sur les autres,
     `drain`/`uncordon` et paquets `kubelet`/`kubectl` nœud par nœud, vérifier la version et les `PodDisruptionBudget` qui bloquent le drain
     — CKA-05-04.
  3. Lire l'expiration des certificats (`kubeadm certs check-expiration`), les renouveler, régénérer un kubeconfig, ajouter un worker
     puis le retirer (`drain`, `delete node`, `kubeadm reset`) — CKA-05-04.
- **Break-fix** : `break/kubernetes/06-etcd-data-dir.sh` (manifest etcd pointant vers un `--data-dir` vide, API qui répond avec un cluster «
  neuf »).
- **Défi chronométré** : sauvegarde etcd, suppression d'un Deployment, restauration et preuve du retour en moins de 12 min.

### K7 — `fiches/kubernetes/07-rbac-comptes-de-service.md`

- **Titre** : RBAC, ServiceAccounts et accès à l'API
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKA-05-01
- **Prérequis** : K1, K5 (accès au CA du cluster) ; `fiches/gitops/02-argo-workflows-fondamentaux.md` recommandé (premier contact RBAC)
- **Lab** : `kubernetes-ha` (ou `kind` pour les exercices 1 et 2). Clés `versions.yaml` : `kubernetes`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Créer `Role`/`RoleBinding` puis `ClusterRole`/`ClusterRoleBinding`, agréger des ClusterRoles, vérifier avec `kubectl auth can-i`
     (`--as`, `--as-group`, `--list`), lire les rôles par défaut (`view`, `edit`, `admin`, `cluster-admin`) — CKA-05-01.
  2. Créer un utilisateur humain : clé + CSR, `CertificateSigningRequest` approuvée par l'API, kubeconfig dédié avec contexte ;
     puis un ServiceAccount avec jeton projeté, `automountServiceAccountToken: false`, appel direct de l'API avec `curl` — CKA-05-01.
  3. Auditer : lister qui peut faire `delete` sur les `secrets` dans tout le cluster (`kubectl-who-can` ou boucle sur les bindings),
     corriger une liaison trop large, documenter le minimum nécessaire pour un contrôleur (exemple Argo Workflows) — CKA-05-01.
- **Break-fix** : `break/kubernetes/07-rolebinding-mauvais-sujet.sh` (RoleBinding sur un ServiceAccount d'un autre namespace, `forbidden`
  inexpliqué).
- **Défi chronométré** : donner à un nouvel utilisateur la lecture des Pods dans un namespace et rien d'autre, prouvé par `auth can-i`, en
  moins de 6 min.

### K8 — `fiches/kubernetes/08-ordonnancement-admission-autoscaling.md`

- **Titre** : Ordonnancement et admission — quotas, affinités, taints, priorités et autoscaling
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKA-02-03, CKA-02-05
- **Prérequis** : K2, K5 (plusieurs nœuds réels)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `metrics_server` (à créer), `helm`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. `LimitRange` et `ResourceQuota` par namespace, classes QoS, `PriorityClass` et préemption ; observer un Pod `Pending` pour quota et
     lire le message exact dans les événements — CKA-02-05.
  2. Placer des Pods : `nodeSelector`, `nodeName`, `nodeAffinity` (`required`/`preferred`), `podAffinity`/`podAntiAffinity`,
     `topologySpreadConstraints`, `taints`/`tolerations` (dont `NoExecute` et `tolerationSeconds`), static pods ; comprendre
     les admission controllers activés (`--enable-admission-plugins`) et Pod Security Admission par label de namespace — CKA-02-05.
  3. Installer metrics-server par Helm, créer un `HorizontalPodAutoscaler` v2 (CPU puis métrique mémoire), générer de la charge, lire
     `kubectl get hpa --watch`, régler `behavior` (stabilisation) ; comparer avec le redimensionnement manuel et évoquer VPA en lecture —
     CKA-02-03.
- **Break-fix** : `break/kubernetes/08-taint-sans-toleration.sh` (taint `NoSchedule` posé sur tous les workers, nouveaux Pods `Pending`).
- **Défi chronométré** : contraindre un Deployment à un nœud étiqueté, avec anti-affinité entre replicas et HPA 2→5, en moins de 10 min.

### K9 — `fiches/kubernetes/09-network-policies-gateway-api-ingress.md`

- **Titre** : NetworkPolicy, Gateway API et Ingress — filtrer et router le trafic
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKA-03-02, CKA-03-04, CKA-03-05
- **Prérequis** : K3, K5 (Cilium en CNI) ; `reseau_conf` ; `fiches/gitops/01-argo-cd-fondamentaux.md` recommandé (variante Gateway déjà vue)
- **Lab** : `kubernetes-ha` (Gateway API Cilium par défaut, Envoy Gateway en variante justifiée ; un contrôleur Ingress léger uniquement
  pour CKA-03-05). Clés `versions.yaml` : `kubernetes`, `cilium`, `gateway_api` (à créer), `cert_manager`, `envoy_gateway`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Partir d'un namespace « deny all » (ingress et egress), rouvrir progressivement : par `podSelector`, `namespaceSelector`, `ipBlock`,
     port et protocole, egress DNS ; tester chaque règle avec un Pod client, lire les verdicts dans Hubble — CKA-03-02.
  2. Installer les CRD Gateway API, créer `GatewayClass`/`Gateway`/`HTTPRoute` (hôte, chemin, en-têtes, répartition pondérée entre deux
     Services, redirection HTTP→HTTPS, TLS cert-manager), lire les `status.conditions` — CKA-03-04.
  3. Écrire les mêmes règles en `Ingress` (`ingressClassName`, `pathType`, TLS, `defaultBackend`) avec un contrôleur Ingress minimal,
     tableau de correspondance Ingress ↔ HTTPRoute pour l'examen ; comparer les deux objets côté `status` — CKA-03-05, CKA-03-04.
- **Break-fix** : `break/kubernetes/09-netpol-egress-dns.sh` (NetworkPolicy egress sans exception UDP 53, application qui ne résout plus
  rien).
- **Défi chronométré** : isoler un namespace sauf le trafic d'un frontend et exposer ce frontend par HTTPRoute avec TLS en moins de 12 min.

### K10 — `fiches/kubernetes/10-helm-kustomize-crd-operateurs.md`

- **Titre** : Helm, Kustomize, CRD et opérateurs — installer et étendre les composants du cluster
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKA-05-06, CKA-05-07 (CSI), CKA-05-08
- **Prérequis** : K4, K5 ; les deux fiches `gitops` recommandées (CRD déjà rencontrées)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `helm`, `cert_manager`, `longhorn` ou `rook`, `cloudnative_pg`,
  `metrics_server` (à créer).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Helm 4 : `repo add`, `search`, `show values`, `install` avec `--set` et `-f`, `upgrade`, `rollback`, `history`, `template`,
     chart OCI depuis Harbor ; installer metrics-server et cert-manager ainsi ; différences Helm 3 à connaître pour l'examen — CKA-05-06.
  2. Kustomize avec `kubectl kustomize`/`apply -k` : base + overlays, `namePrefix`, `commonLabels`, `images`, `patches`
     (strategic merge et JSON 6902), `configMapGenerator` ; appliquer un overlay `prod` et lire le diff — CKA-05-06.
  3. Lire une CRD (`kubectl get crd`, `explain`, versions et conversion, `scope`), installer un opérateur (CloudNativePG par Helm), créer sa
     ressource personnalisée, observer la boucle de réconciliation ; cartographier CRI/CNI/CSI du cluster (`crictl`, Cilium, Longhorn CSI
     driver,
     `csidrivers`, `csinodes`) — CKA-05-08, CKA-05-07.
- **Break-fix** : `break/kubernetes/10-crd-absente.sh` (CRD supprimée, ressources orphelines, contrôleur en `CrashLoopBackOff`).
- **Défi chronométré** : installer un chart avec des valeurs personnalisées, le mettre à niveau puis revenir en arrière, en moins de 8 min.

### K11 — `fiches/kubernetes/11-depannage-noeuds-control-plane.md`

- **Titre** : Dépanner les nœuds et le control plane
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKA-04-01, CKA-04-02, CKA-04-03
- **Prérequis** : K5, K6 ; `linux_conf` (journald, systemd)
- **Lab** : `kubernetes-ha` (cluster de K5). Clés `versions.yaml` : `kubernetes`, `kubeadm`, `containerd`, `cri_tools` (à créer), `etcd`,
  `metrics_server` (à créer).
- **Temps** : 7 h
- **3 exercices clés** :
  1. Méthode de diagnostic d'un nœud `NotReady` : `kubectl describe node` (conditions, pression), `journalctl -u kubelet`,
     `systemctl status containerd`,     `crictl ps/logs`, certificats kubelet, `/var/lib/kubelet/config.yaml`, espace disque, `kubelet` arrêté ou mal configuré — CKA-04-01.
  2. Composants du control plane : static pods de `/etc/kubernetes/manifests` (mauvais flag, mauvais port, image erronée),
     `kube-scheduler` absent (Pods `Pending` sans événement), `controller-manager` arrêté (Deployments sans ReplicaSet), etcd injoignable ;
     lire les logs avec `crictl` quand `kubectl` ne répond plus — CKA-04-02.
  3. Mesurer : `kubectl top nodes/pods` (metrics-server), `--containers`, tri, `kubectl describe node` (Allocated resources), événements
     `OOMKilled`/`Evicted`, seuils d'éviction du kubelet ; corréler avec `kubectl get --raw /metrics` — CKA-04-03.
- **Break-fix** : `break/kubernetes/11-kubelet-cgroup.sh`, `11-scheduler-manifest.sh`, `11-apiserver-etcd-endpoint.sh`
  (trois pannes injectées à l'aveugle par `break.sh random`, mode examen).
- **Défi chronométré** : nœud `NotReady` + scheduler cassé, les deux réparés et prouvés en moins de 15 min.

### K12 — `fiches/kubernetes/12-depannage-applications-reseau.md`

- **Titre** : Dépanner les applications, les Services et le DNS
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKA-04-04, CKA-04-05
- **Prérequis** : K3, K9, K11
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `cilium`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Flux de sortie : `kubectl logs` (`-c`, `--all-containers`, `-p`, `--since`, `-f`, `-l`), sidecar de logs, conteneur `init` qui échoue,
     `kubectl debug` (conteneur éphémère, copie de Pod, `node/`), `kubectl events`, états
     `CrashLoopBackOff`/`ImagePullBackOff`/`CreateContainerConfigError` — CKA-04-04.
  2. Service injoignable : selector, `targetPort`, `EndpointSlices` vides, NetworkPolicy qui bloque, `kube-proxy` remplacé par Cilium
     (`cilium status`,
     `cilium service list`), NodePort depuis l'extérieur, MetalLB sans pool — CKA-04-05.
  3. DNS : CoreDNS en `CrashLoopBackOff` (Corefile cassé), `ndots` et noms courts, `dnsPolicy`/`dnsConfig` d'un Pod, résolution externe via
     `core-dns01`, mesure de latence ; checklist de dépannage réseau en une page (livrable) — CKA-04-05.
- **Break-fix** : `break/kubernetes/12-corefile-casse.sh`, `12-service-targetport.sh`, `12-netpol-silencieuse.sh`.
- **Défi chronométré** : trois pannes applicatives/réseau injectées à l'aveugle, réparées en moins de 15 min.

### S1 — `scenarios/NN-cluster-kubeadm-de-zero-a-l-exploitation/README.md`

- **Titre** : NN — Du nœud vierge au cluster exploité : kubeadm HA, stockage, trafic, pannes en cascade (numéro `NN` attribué à la création)
- **Niveau** : expert (`kubernetes_exp`) ; prérequis K1 à K12 complets, pas de saut direct
- **Couvre** : les 25 compétences CKA en situation
- **Lab** : `kubernetes-ha` levé sans Kubernetes + `ceph-3n` (Rook-Ceph en CSI). Clés `versions.yaml` : `kubernetes`, `kubernetes_previous`,
  `kubeadm`, `containerd`, `cilium`, `kube_vip`, `gateway_api`, `helm`, `rook`, `metrics_server`, `cert_manager`.
- **Temps** : 8 h en deux séances
- **Livrable** : runbook « construire et mettre à niveau le cluster » + postmortem d'une panne en cascade
- **3 exercices clés** :
  1. Construire le cluster HA en n-1 depuis des VM nues avec Ansible (rôle écrit en K5), Cilium, Rook-Ceph, Gateway API, metrics-server par
     Helm,
     RBAC d'équipe, quotas par namespace ; déployer une application avec PVC, HTTPRoute TLS et HPA.
  2. Sauvegarder etcd, mettre à niveau vers `kubernetes` nœud par nœud sans interruption mesurable de l'application (sonde externe toutes
     les secondes).
  3. Pannes en cascade injectées à l'aveugle (certificat expiré, etcd membre perdu, NetworkPolicy, StorageClass supprimée, Corefile) :
     diagnostiquer et réparer en moins de 45 min, rédiger le postmortem.

### E1 — `exams/cka-blanc-01/`

- **Titre** : Examen blanc CKA n° 1 (prompt `06-examen-blanc.md`)
- **Niveau** : confirmé → expert ; après K12
- **Couvre** : échantillon pondéré des 25 compétences (6 tâches dépannage, 5 cluster, 4 réseau, 3 workloads, 2 stockage)
- **Lab** : `kubernetes-ha` + `kind` sur `linux-base` pour les tâches à cluster jetable ; `setup.sh` injecte l'état initial, `grade.sh`
  note.
- **Temps** : 2 h d'épreuve + 2 h de correction
- **Format** : 15 à 20 tâches, 120 min, terminal seul, seule la documentation autorisée (`examen.md`), seuil 66 %.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| K1 kubectl, Pods, Deployments | débutant | linux-base (kind) ou kubernetes-ha | 5 h |
| K2 ConfigMaps, Secrets, probes, ressources | débutant | linux-base (kind) ou kubernetes-ha | 4 h |
| K3 Services, EndpointSlices, CoreDNS | débutant | linux-base (kind) ou kubernetes-ha | 5 h |
| K4 Stockage PV/PVC/StorageClass | débutant | linux-base (kind) ; variante kubernetes-ha (+ ceph-3n) | 5 h |
| K5 Cluster kubeadm HA | confirmé | kubernetes-ha (sans Kubernetes) | 8 h |
| K6 Cycle de vie, etcd, upgrade | confirmé | kubernetes-ha | 6 h |
| K7 RBAC, ServiceAccounts | confirmé | kubernetes-ha | 4 h |
| K8 Ordonnancement, admission, autoscaling | confirmé | kubernetes-ha | 6 h |
| K9 NetworkPolicy, Gateway API, Ingress | confirmé | kubernetes-ha | 6 h |
| K10 Helm, Kustomize, CRD, opérateurs | confirmé | kubernetes-ha | 5 h |
| K11 Dépannage nœuds et control plane | confirmé | kubernetes-ha | 7 h |
| K12 Dépannage applications et réseau | confirmé | kubernetes-ha | 5 h |
| S1 Scénario cluster de zéro à l'exploitation | expert | kubernetes-ha + ceph-3n | 8 h |
| E1 Examen blanc n° 1 | confirmé → expert | kubernetes-ha + linux-base | 4 h |
| Révision (flashcards, `break.sh random`, deux sessions killer.sh, second examen blanc) | — | — | 10 h |
| **Total** | | | **88 h** |

À 5 h par semaine, compter 17 à 18 semaines ; à 8 h par semaine, 11 semaines. C'est deux à trois cycles de 4 à 6 semaines
de `docs/roadmap.md` §7, ce qui est cohérent avec le poids de la CKA dans le bloc Kubestronaut (les fiches K1 à K4 et K7 à K10
servent aussi la CKAD, qui en réutilisera la majorité).

## 6. Ce que le lab ne couvre pas

- Rien n'est `[lecture + simulation]` : les 25 compétences se pratiquent sur `kind` ou `kubernetes-ha`.
- Le programme retire « provisionner l'infrastructure » (révision de février 2025, voir `examen.md`) : K5 prépare quand même les nœuds
  (CKA-05-02 « prepare ») avec un script puis un rôle Ansible, ce qui sert aussi RHCE et le lab ; l'automatisation OpenTofu des VM reste
  dans `labs/`.
- Le lab tourne en Kubernetes 1.37 (`versions.yaml`) quand l'examen est en 1.35 : chaque fiche signale dans « Points de vigilance (versions)
  »
  les écarts utiles (par exemple champs Gateway API ou sorties `kubeadm`), sans maintenir deux labs.
- L'examen est pratique avec documentation officielle autorisée (`examen.md`) : les défis chronométrés et les examens blancs se font
  avec `kubernetes.io/docs` ouvert et rien d'autre, pour apprendre à y naviguer vite ; les flashcards servent les commandes et chemins
  (`/etc/kubernetes/manifests`, `/var/lib/kubelet`, options `etcdctl`) qu'on n'a pas le temps de chercher.
