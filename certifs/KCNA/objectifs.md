---
code: KCNA
titre: "KCNA — mapping compétences → chapitres"
programme: "certifs/KCNA/programme.md (converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14, PDF officiel mis à jour le 2025-11-24)"
chapitres_existants: 1
generated: 2026-10-02
status: "1 chapitre partiel (gitops/01, brouillon) sur 12 ; à mettre à jour à chaque PR de chapitre"
---

# KCNA — objectifs et couverture

Mapping entre les 13 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : aucune fiche du domaine `kubernetes` n'existe ; seule `fiches/gitops/01-argo-cd-fondamentaux.md`
(brouillon) couvre partiellement une compétence (KCNA-03-01). Les onze autres chapitres sont des trous.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices »
et marque le chapitre « rédigé » dans la section 4.

Le programme officiel ne donne que les 13 titres de compétences, sans sous-points. Les thèmes listés en section 3
sous chaque compétence sont une lecture du titre à la lumière de l'ancien programme KCNA (cinq domaines, retiré le
2025-11-24) et de la page officielle « KCNA Program Changes » (`examen.md`) ; ils sont à confirmer à la veille
(`prompts/07-veille.md`) en ouvrant cette page, bloquée depuis la session.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| KCNA-01 Kubernetes Fundamentals | 44 % | 4 | 11,0 % | 4 fiches |
| KCNA-02 Container Orchestration | 28 % | 4 | 7,0 % | 4 fiches |
| KCNA-03 Cloud Native Application Delivery | 16 % | 2 | 8,0 % | 1 fiche (+ gitops/01 existant) |
| KCNA-04 Cloud Native Architecture | 12 % | 3 | 4,0 % | 2 fiches |
| Transverse | — | 13 | — | 1 scénario, 1 examen blanc |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle. Le dépannage (KCNA-02-03 + KCNA-03-02) pèse 15 % à lui seul : une fiche
dédiée, pas une section de fin de chapitre.

Ordre de rédaction recommandé (du plus lourd au plus léger, en respectant les prérequis) :
conteneurs et images OCI → architecture, API et objets Kubernetes → administration kubeadm → ordonnancement →
réseau et Gateway API → dépannage cluster et applications → sécurité fondamentaux → stockage →
livraison applicative (Helm, Kustomize, stratégies) → observabilité fondamentaux → écosystème cloud native →
scénario application trois tiers → examen blanc `exams/kcna/`.

Ces fiches sont le socle du nœud `kubernetes_deb` (`docs/prerequis.md`) : elles servent aussi CKA, CKAD, KCSA, PCA et
OTCA, dont les cartographies réutiliseront les chemins ci-dessous au lieu d'en créer d'autres.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : les clés `kubernetes`, `kubeadm`, `containerd`, `kind`, `cilium`, `helm`, `metallb`, `cert_manager`,
  `prometheus`, `grafana`, `loki`, `opentelemetry_collector`, `harbor`, `argo_cd`, `rook`, `longhorn`, `kyverno`, `falco`
  existent. Ajouter `nerdctl` (CLI containerd, dépôt `containerd/nerdctl`), `podman` (dépôt `containers/podman`, aussi
  utile à RHCSA), `trivy` (dépôt `aquasecurity/trivy`), `metrics_server` (dépôt `kubernetes-sigs/metrics-server`) et
  `kube_prometheus_stack` (chart Helm `prometheus-community/kube-prometheus-stack`, datasource `helm`).
  Passe par la veille (`prompts/07-veille.md`) ou par la PR du chapitre concerné.
- `labs/profiles/kubernetes-ha.yaml` : la liste `components` ne cite pas `harbor` ni `cert_manager` ; les ajouter avec
  le scénario S1 (Harbor sur le cluster ou sur `core`, placement à décider dans `DECISIONS.md`).
- `labs/profiles/linux-base.yaml` : le chemin « `kind` sur une VM redimensionnée 4 vCPU / 8 Go » établi par
  `fiches/gitops/01-argo-cd-fondamentaux.md` est réutilisé par toutes les fiches débutant ; F3 et F8 (kubeadm) prennent
  deux VM du profil (`linux-base-lx01`, `linux-base-lx02`) réimagées en `ubuntu_lts`.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.2 (cette PR).
- Pas de nouvelle décision à prendre : Gateway API (DECISIONS.md, 2026-10-02) s'applique à F5 ; Ingress y reste en
  « à connaître pour l'examen » ; Helm 4 s'applique à F9 ; `kubernetes` suit la version courante (KCNA n'annonce
  aucune version d'examen, `examen.md`).

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. La colonne « chapitre cible » renvoie à la section 4.

### KCNA-01 — Kubernetes Fundamentals (44 %)

| ID | Compétence | Poids | Thèmes attendus (lecture du titre, à confirmer) | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|---|
| KCNA-01-01 | Kubernetes Core Concepts | 11,0 % | control plane et nœuds, API server, etcd, kubelet, kube-proxy ; Pod, ReplicaSet, Deployment, Service, Namespace, ConfigMap, Secret ; labels et selectors ; déclaratif vs impératif ; CRD et opérateurs | — | — | F2 |
| KCNA-01-02 | Administration | 11,0 % | kubectl et kubeconfig, contextes ; installation (kubeadm, distributions), mise à jour, sauvegarde etcd ; RBAC et ServiceAccount ; quotas et LimitRange ; haute disponibilité du control plane | — | — | F2 (kubectl), F3 |
| KCNA-01-03 | Scheduling | 11,0 % | kube-scheduler, requests et limits, QoS, `nodeSelector`, affinités, taints et tolerations, topology spread, priorité et préemption, DaemonSet, static Pods | — | — | F4 |
| KCNA-01-04 | Containerization | 11,0 % | namespaces et cgroups, images et registres OCI, runtimes (containerd, CRI-O), CRI, Dockerfile et build, tags et digests | — | — | F1 |

### KCNA-02 — Container Orchestration (28 %)

| ID | Compétence | Poids | Thèmes attendus (lecture du titre, à confirmer) | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|---|
| KCNA-02-01 | Networking | 7,0 % | modèle réseau Kubernetes, CNI, Services (ClusterIP, NodePort, LoadBalancer), CoreDNS, Ingress et Gateway API, NetworkPolicy, service mesh (notion) | — | — | F5 |
| KCNA-02-02 | Security | 7,0 % | 4C, authentification et autorisation (RBAC), Pod Security Standards et Admission, `securityContext`, Secrets, NetworkPolicy, sécurité des images et chaîne d'approvisionnement | — | — | F7 |
| KCNA-02-03 | Troubleshooting | 7,0 % | `describe`, `logs`, `events`, `exec`, `debug` ; états de Pod (`Pending`, `CrashLoopBackOff`, `ImagePullBackOff`, `OOMKilled`) ; nœud `NotReady`, composants du control plane, journaux kubelet | — | — | F8 |
| KCNA-02-04 | Storage | 7,0 % | volumes éphémères, PersistentVolume et PersistentVolumeClaim, StorageClass et provisionnement dynamique, CSI, modes d'accès, politiques de récupération, StatefulSet | — | — | F6 |

### KCNA-03 — Cloud Native Application Delivery (16 %)

| ID | Compétence | Poids | Thèmes attendus (lecture du titre, à confirmer) | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|---|
| KCNA-03-01 | Application Delivery | 8,0 % | rolling update et rollback, stratégies (recreate, blue-green, canary), Helm, Kustomize, CI/CD, GitOps (push vs pull), Argo CD et Flux | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) — partiel : GitOps et synchronisation seulement | S1 : démo, autonome 1-3, break-fix repo-server-down, défi 20 min ; S3 : démo, autonome 1-3, break-fix app-degraded, défi 10 min | F9 (+ gitops/01 rédigé) |
| KCNA-03-02 | Debugging | 8,0 % | sondes liveness, readiness, startup ; `port-forward`, `exec`, conteneurs éphémères ; variables d'environnement et ConfigMap mal montés ; lecture des journaux applicatifs | — | — | F8 |

### KCNA-04 — Cloud Native Architecture (12 %)

| ID | Compétence | Poids | Thèmes attendus (lecture du titre, à confirmer) | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|---|
| KCNA-04-01 | Observability | 4,0 % | métriques, journaux, traces ; Prometheus et PromQL de base, metrics-server, Grafana, Fluentd et Loki, OpenTelemetry ; SLI, SLO, SLA ; coûts | — | — | F10 |
| KCNA-04-02 | Cloud Native Ecosystem and Principles | 4,0 % | définition cloud native, microservices, immutabilité, autoscaling (HPA, VPA, Cluster Autoscaler), serverless (Knative), standards ouverts (OCI, CRI, CNI, CSI, OpenTelemetry), paysage et maturité des projets CNCF | — | — | F11 |
| KCNA-04-03 | Cloud Native Community and Collaboration | 4,0 % | gouvernance CNCF (TOC, TAG, SIG), cycle de release Kubernetes et KEP, contribution, code de conduite, rôles et personas (SRE, DevOps, ingénierie de plateforme) | — | — | F11 |

### Compétences partagées avec d'autres certifications

Les fiches ci-dessous citent plusieurs programmes dans leur front matter pour éviter un doublon. Les IDs des autres
certifications sont indicatifs : chaque cartographie (`prompts/01-cartographie-certification.md`) les confirmera.

| Chapitre | IDs KCNA | IDs réutilisables (à confirmer par la cartographie concernée) |
|---|---|---|
| F1 Conteneurs et images OCI | KCNA-01-04 | KCSA-01-05, KCSA-02-05, LFCS et RHCSA (conteneurs Podman) |
| F2 Architecture, API et objets | KCNA-01-01, KCNA-01-02 | CKA-05-07, CKA-05-08, CKAD (core concepts), KCSA-02-01 à 02-08 |
| F3 Administration kubeadm | KCNA-01-02 | CKA-05-01 à 05-05 |
| F4 Ordonnancement | KCNA-01-03 | CKA-02-05, CKAD (scheduling) |
| F5 Réseau et Gateway API | KCNA-02-01 | CKA-03-01 à 03-06, CCA (réseau Cilium), KCSA-02-09 |
| F6 Stockage | KCNA-02-04 | CKA-01-01 à 01-03, KCSA-02-11 |
| F7 Sécurité fondamentaux | KCNA-02-02 | KCSA-01-01, KCSA-03-01 à 03-07, CKA-05-01 |
| F8 Dépannage | KCNA-02-03, KCNA-03-02 | CKA-04-01 à 04-05 |
| F9 Livraison applicative | KCNA-03-01 | CKA-02-01, CKA-05-06, CGOA-01 (principes GitOps) |
| F10 Observabilité fondamentaux | KCNA-04-01 | PCA-01 (observability concepts), OTCA-01 (fundamentals) |
| F11 Écosystème cloud native | KCNA-04-02, KCNA-04-03 | CNPA (plateforme, culture), CKA-02-03 (autoscaling) |

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de rédaction recommandé (DECISIONS.md, 2026-10-02) ; les numéros
`kubernetes/01` à `09`, `securite/01` et `observabilite/01` sont réservés par cette cartographie et confirmés à la création.
Toutes les fiches sont de niveau **débutant** : KCNA est le jalon de sortie du nœud `kubernetes_deb`
(`docs/prerequis.md` §3, parcours Kubestronaut). Le scénario S1 ouvre `kubernetes_conf` (débutant → confirmé, pas de saut).
Chemin de lab principal des fiches : un cluster `kind` sur une VM `linux-base` redimensionnée 4 vCPU / 8 Go / 60 Go
(établi par `fiches/gitops/01-argo-cd-fondamentaux.md`), variante `kubernetes-ha` (16 vCPU / 48 Go / 300 Go) quand le
profil sera levé ; F3 et F8 utilisent deux VM `linux-base` avec kubeadm, parce que `kind` cache l'installation et les
pannes de nœud. Gateway API : Cilium par défaut, sur `kind` exposition par `port-forward` (DECISIONS.md, 2026-10-02).
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.

### F1 — `fiches/kubernetes/01-conteneurs-et-images-oci.md`

- **Titre** : Conteneurs — namespaces, cgroups, images OCI et runtimes
- **Niveau** : débutant (`kubernetes_deb`, peut être commencée dès `linux_deb`)
- **Couvre** : KCNA-01-04 (+ KCSA-01-05, KCSA-02-05 à confirmer)
- **Prérequis** : `linux_deb` (processus, systèmes de fichiers, réseau local), `proxmox_deb` (une VM du profil)
- **Lab** : `linux-base`, 1 VM (`linux-base-lx01`, 2 vCPU / 4 Go). Clés `versions.yaml` : `containerd`, `nerdctl` (à créer),
  `podman` (à créer), `trivy` (à créer), `harbor` (registre du lab, variante).
- **Temps** : 4 h
- **3 exercices clés** :
  1. Lancer un processus isolé à la main avec `unshare` et `cgcreate`/`systemd-run`, observer `/proc/<pid>/ns` et
     `/sys/fs/cgroup`, puis le même conteneur avec `nerdctl run` ; comparer ce que le runtime ajoute — KCNA-01-04.
  2. Écrire un Dockerfile multi-étapes pour une petite application, construire l'image avec `nerdctl build` et `podman build`,
     lire le manifeste OCI (`skopeo inspect`), expliquer tag vs digest, pousser sur le registre du lab — KCNA-01-04.
  3. Scanner l'image avec `trivy`, la rendre non-root et en lecture seule, comparer `containerd` + `crictl` et Podman
     côté CRI ; schématiser en Mermaid la chaîne kubelet → CRI → containerd → runc — KCNA-01-04.
- **Break-fix** : `break/kubernetes/01-image-digest-mismatch.sh` (tag réécrit vers une image cassée, le conteneur
  démarre puis sort en erreur ; l'apprenant doit épingler par digest).
- **Défi chronométré** : construire, scanner et pousser une image non-root en moins de 10 min.

### F2 — `fiches/kubernetes/02-architecture-api-et-objets-kubernetes.md`

- **Titre** : Kubernetes — architecture, API et objets de base avec kubectl
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : KCNA-01-01, KCNA-01-02 (kubectl, kubeconfig, namespaces)
- **Prérequis** : F1, `linux_conf`, `reseau_deb`, `proxmox_deb`
- **Lab** : `kind` sur `linux-base` (VM 4 vCPU / 8 Go), variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`, `cilium`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Créer un cluster `kind` à 3 nœuds, nommer chaque composant du control plane et des nœuds depuis `kubectl get pods -n kube-system`
     et `crictl ps` dans un nœud, suivre une requête `kubectl` jusqu'à etcd avec `-v=8` ; schéma Mermaid de l'architecture — KCNA-01-01.
  2. Déployer une application en impératif (`kubectl run`, `expose`) puis en déclaratif (manifests Pod, Deployment, Service,
     ConfigMap, Secret, Namespace) ; labels, selectors, `kubectl explain`, `api-resources`, `diff`, `apply` — KCNA-01-01.
  3. Gérer plusieurs contextes dans le kubeconfig, créer un ServiceAccount et un Role limités à un namespace, tester avec
     `kubectl auth can-i` ; installer une CRD et décrire ce qu'un opérateur ajoute — KCNA-01-01, KCNA-01-02.
- **Break-fix** : `break/kubernetes/02-selector-mismatch.sh` (Service dont le selector ne correspond à aucun Pod,
  `Endpoints` vide, application injoignable).
- **Défi chronométré** : déployer et exposer une application en déclaratif, avec ConfigMap, en moins de 10 min.

### F3 — `fiches/kubernetes/03-administration-kubeadm.md`

- **Titre** : Kubernetes — installer, mettre à jour et sauvegarder un cluster kubeadm
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : KCNA-01-02 (+ CKA-05-02 à 05-05 à confirmer)
- **Prérequis** : F2, `linux_conf` (systemd, paquets, pare-feu), `reseau_deb`
- **Lab** : `linux-base`, 2 VM (`linux-base-lx01` control plane, `linux-base-lx02` worker, réimagées `ubuntu_lts`),
  variante `kubernetes-ha` (3 control planes, VIP). Clés `versions.yaml` : `kubernetes`, `kubeadm`, `containerd`, `cilium`, `etcd`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Préparer les deux nœuds (modules noyau, sysctl, swap, containerd, paquets `pkgs.k8s.io`), `kubeadm init`, installer Cilium,
     `kubeadm join`, lire `kubeadm config print` et les certificats de `/etc/kubernetes/pki` — KCNA-01-02.
  2. Sauvegarder etcd avec `etcdctl snapshot save`, casser une ressource, restaurer et vérifier ; expliquer ce qu'un control
     plane HA ajoute (VIP, etcd empilé ou externe) avec un schéma Mermaid — KCNA-01-02.
  3. Mettre à jour le cluster d'une version mineure (`kubeadm upgrade plan`/`apply`, `drain`, kubelet, `uncordon`) ;
     appliquer une ResourceQuota et une LimitRange sur un namespace et observer un Pod refusé — KCNA-01-02.
- **Break-fix** : `break/kubernetes/03-kubelet-cert-expired.sh` (certificat kubelet d'un nœud remplacé par un certificat
  expiré, nœud `NotReady`).
- **Défi chronométré** : joindre un nœud supplémentaire et le vérifier `Ready` en moins de 10 min.

### F4 — `fiches/kubernetes/04-ordonnancement-des-pods.md`

- **Titre** : Kubernetes — ordonnancement : ressources, affinités, taints, DaemonSet
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : KCNA-01-03 (+ CKA-02-05 à confirmer)
- **Prérequis** : F2
- **Lab** : `kind` 3 nœuds sur `linux-base`, variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`, `metrics_server` (à créer).
- **Temps** : 4 h
- **3 exercices clés** :
  1. Déployer des Pods avec `requests`/`limits`, lire les classes QoS, saturer un nœud et observer `Pending` avec
     `kubectl describe` (`FailedScheduling`), installer metrics-server et lire `kubectl top` — KCNA-01-03.
  2. Placer des Pods par `nodeSelector`, `nodeAffinity`, `podAntiAffinity` et `topologySpreadConstraints` ; tainter un nœud,
     ajouter une toleration, vérifier avec `kubectl get pods -o wide` — KCNA-01-03.
  3. Déployer un DaemonSet, lire un static Pod dans `/etc/kubernetes/manifests` d'un nœud `kind`, créer une PriorityClass et
     provoquer une préemption — KCNA-01-03.
- **Break-fix** : `break/kubernetes/04-taint-noschedule.sh` (taint `NoSchedule` posée sur tous les workers, nouveaux Pods `Pending`).
- **Défi chronométré** : répartir 6 réplicas sur 3 nœuds, deux par nœud, sans affinité manuelle, en moins de 8 min.

### F5 — `fiches/kubernetes/05-reseau-services-et-gateway-api.md`

- **Titre** : Kubernetes — réseau : CNI, Services, CoreDNS, Gateway API
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : KCNA-02-01 (+ CKA-03-01 à 03-06, CCA à confirmer)
- **Prérequis** : F2, `reseau_deb` (adressage, routage, DNS)
- **Lab** : `kind` sans CNI par défaut + Cilium sur `linux-base` ; variante `kubernetes-ha` avec MetalLB et `Gateway` Cilium.
  Clés `versions.yaml` : `kubernetes`, `kind`, `cilium`, `metallb`, `cert_manager`, `envoy_gateway` (variante).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Créer le cluster sans CNI, constater les Pods `Pending`, installer Cilium, tracer un paquet Pod à Pod entre deux nœuds
     (`cilium connectivity test`, `tcpdump` dans le nœud) ; schéma Mermaid du modèle réseau — KCNA-02-01.
  2. Exposer une application en `ClusterIP`, `NodePort`, `LoadBalancer` (MetalLB en variante), résoudre les noms avec CoreDNS
     (`nslookup` depuis un Pod, lecture du ConfigMap `coredns`), lire les `EndpointSlices` — KCNA-02-01.
  3. Publier l'application par `Gateway` + `HTTPRoute` Cilium avec certificat cert-manager ; comparer avec un manifest
     `Ingress` (lecture seule, « à connaître pour l'examen ») ; appliquer une NetworkPolicy par défaut `deny` puis l'ouvrir — KCNA-02-01.
- **Break-fix** : `break/kubernetes/05-coredns-scaled-to-zero.sh` (CoreDNS à 0 réplica, résolution interne cassée,
  les IP répondent encore).
- **Défi chronométré** : exposer une application par HTTPRoute avec un nom DNS du lab en moins de 10 min.

### F6 — `fiches/kubernetes/06-stockage-volumes-pv-pvc.md`

- **Titre** : Kubernetes — stockage : volumes, PV, PVC, StorageClass, CSI
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : KCNA-02-04 (+ CKA-01-01 à 01-03 à confirmer)
- **Prérequis** : F2 ; `ceph_deb` recommandé pour la variante Rook
- **Lab** : `kind` sur `linux-base` (provisionneur `local-path` fourni par `kind`) ; variante `kubernetes-ha` + `ceph-3n`
  (Rook, combinaison autorisée) ou Longhorn. Clés `versions.yaml` : `kubernetes`, `kind`, `rook`, `longhorn`, `ceph`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Comparer `emptyDir`, `hostPath` et un volume ConfigMap ; détruire le Pod et observer ce qui survit — KCNA-02-04.
  2. Créer un PV statique puis un PVC dynamique via la StorageClass par défaut ; lire `accessModes`, `reclaimPolicy`,
     `volumeBindingMode` ; redimensionner un PVC ; schéma Mermaid du chemin PVC → PV → CSI — KCNA-02-04.
  3. Déployer un StatefulSet avec `volumeClaimTemplates`, supprimer un Pod et vérifier que ses données reviennent ;
     en variante, brancher Rook (RBD) et comparer les modes d'accès — KCNA-02-04.
- **Break-fix** : `break/kubernetes/06-pvc-pending-no-storageclass.sh` (StorageClass par défaut retirée, PVC `Pending`,
  Pod bloqué en `ContainerCreating`).
- **Défi chronométré** : fournir un volume persistant à une base de données et prouver la persistance en moins de 10 min.

### F7 — `fiches/securite/01-securite-kubernetes-fondamentaux.md`

- **Titre** : Sécurité Kubernetes — 4C, RBAC, Pod Security, Secrets, images
- **Niveau** : débutant (`securite_deb`)
- **Couvre** : KCNA-02-02 (+ KCSA-01-01, KCSA-03-01 à 03-07 à confirmer)
- **Prérequis** : F2, F1 ; `linux_deb`
- **Lab** : `kind` sur `linux-base`, variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`, `trivy` (à créer),
  `kyverno` (lecture, variante), `falco` (lecture).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Schématiser les 4C (cloud, cluster, conteneur, code) et y placer chaque contrôle du chapitre ; tracer une requête
     authentifiée (certificat, ServiceAccount token) et son autorisation RBAC ; `kubectl auth can-i --as` — KCNA-02-02.
  2. Appliquer les Pod Security Standards par label de namespace (`baseline`, `restricted`), corriger un Pod refusé avec
     `securityContext` (`runAsNonRoot`, `readOnlyRootFilesystem`, `capabilities`) ; monter un Secret et lire son encodage — KCNA-02-02.
  3. Isoler deux namespaces par NetworkPolicy, scanner une image avec `trivy`, vérifier la provenance d'une image
     (digest, signature : lecture) ; décrire ce qu'une politique d'admission (Kyverno) ajouterait — KCNA-02-02.
- **Break-fix** : `break/securite/01-rbac-too-broad.sh` (ClusterRoleBinding `cluster-admin` accordé au ServiceAccount
  `default` d'un namespace ; l'apprenant doit le détecter et le réduire).
- **Défi chronométré** : rendre un Deployment conforme au profil `restricted` en moins de 10 min.

### F8 — `fiches/kubernetes/07-depannage-cluster-et-applications.md`

- **Titre** : Kubernetes — dépanner le cluster, les nœuds et les applications
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : KCNA-02-03, KCNA-03-02 (+ CKA-04-01 à 04-05 à confirmer)
- **Prérequis** : F3 (cluster kubeadm pour les pannes de nœud), F5 (réseau)
- **Lab** : `linux-base`, 2 VM kubeadm (F3) ; les exercices applicatifs passent aussi sur `kind`. Clés `versions.yaml` :
  `kubernetes`, `kubeadm`, `containerd`, `cilium`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Méthode : `kubectl get events --sort-by`, `describe`, `logs --previous`, `exec`, `debug` (conteneur éphémère, copie de Pod,
     `debug node/`) ; diagnostiquer `ImagePullBackOff`, `CrashLoopBackOff`, `OOMKilled`, `Pending` sur des Pods préparés — KCNA-02-03, KCNA-03-02.
  2. Pannes de nœud et de control plane : kubelet arrêté, `containerd` en panne, disque plein, certificat expiré, API server
     injoignable ; lire `journalctl -u kubelet`, `crictl`, les logs des static Pods — KCNA-02-03.
  3. Pannes applicatives : sondes `liveness`/`readiness`/`startup` mal réglées, ConfigMap manquant, variable d'environnement
     absente, Service sans endpoints, `port-forward` pour isoler réseau et application — KCNA-03-02.
- **Break-fix** : `break/kubernetes/07-random.sh` (tire au sort une des pannes du chapitre, injectée à l'aveugle, `--reveal`
  pour la correction), conformément à `docs/roadmap.md` §1.
- **Défi chronométré** : trois pannes à l'aveugle, cluster et application rétablis en moins de 20 min.

### F9 — `fiches/kubernetes/08-livraison-applicative-helm-kustomize-strategies.md`

- **Titre** : Livraison applicative — rolling update, Helm, Kustomize, stratégies et principes GitOps
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : KCNA-03-01, avec `fiches/gitops/01-argo-cd-fondamentaux.md` pour la partie GitOps (+ CKA-02-01, CKA-05-06 à confirmer)
- **Prérequis** : F2 ; recommandée avant `fiches/gitops/01-argo-cd-fondamentaux.md`
- **Lab** : `kind` sur `linux-base`, variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`, `helm`,
  `argo_cd` (renvoi), `flux` (lecture).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Publier une nouvelle image par rolling update, régler `maxSurge`/`maxUnavailable`, suivre `rollout status`, revenir
     en arrière avec `rollout undo` ; réaliser à la main un blue-green (deux Deployments, bascule du selector) et un canary
     (deux Deployments derrière un Service) — KCNA-03-01.
  2. Installer un chart avec Helm 4 (`values`, `upgrade`, `rollback`, `history`), lire ce que Helm rend (`template`) ;
     refaire la même application en Kustomize (`base`, `overlays`, `images`, `configMapGenerator`) — KCNA-03-01.
  3. Décrire une chaîne CI/CD (build, test, image, déploiement) et les quatre principes GitOps ; comparer push et pull ;
     enchaîner sur `fiches/gitops/01-argo-cd-fondamentaux.md` pour la mise en pratique — KCNA-03-01.
- **Break-fix** : `break/kubernetes/08-rollout-stuck.sh` (readiness probe impossible sur la nouvelle version, rollout bloqué,
  `ProgressDeadlineExceeded`).
- **Défi chronométré** : livrer une version, constater l'échec, revenir à la précédente, en moins de 8 min.

### F10 — `fiches/observabilite/01-observabilite-fondamentaux.md`

- **Titre** : Observabilité — métriques, journaux, traces avec Prometheus, Grafana, Loki et OpenTelemetry
- **Niveau** : débutant (`observabilite_deb`)
- **Couvre** : KCNA-04-01 (+ PCA-01, OTCA-01 à confirmer)
- **Prérequis** : F2, F4 (metrics-server) ; `kubernetes_deb`
- **Lab** : `kind` sur `linux-base` (VM 4 vCPU / 8 Go, la pile complète tient juste), variante `kubernetes-ha`.
  Clés `versions.yaml` : `prometheus`, `grafana`, `loki`, `opentelemetry_collector`, `kube_prometheus_stack` (à créer), `helm`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer kube-prometheus-stack avec Helm, lire les cibles (`/targets`), écrire cinq requêtes PromQL de base
     (`rate`, `sum by`, `container_memory_working_set_bytes`), créer un tableau de bord Grafana minimal — KCNA-04-01.
  2. Collecter les journaux avec Loki (ou Fluent Bit vers Loki), corréler une erreur applicative entre métriques et journaux ;
     instrumenter une application de démonstration avec OpenTelemetry et envoyer une trace au Collector — KCNA-04-01.
  3. Définir un SLI, un SLO et un budget d'erreur pour l'application, écrire la règle d'alerte correspondante, la déclencher ;
     lire le coût (CPU, RAM, stockage) de la pile elle-même avec `kubectl top` — KCNA-04-01.
- **Break-fix** : `break/observabilite/01-servicemonitor-label-mismatch.sh` (ServiceMonitor sans le label attendu, cible absente de Prometheus).
- **Défi chronométré** : exposer une métrique applicative et la voir dans Grafana en moins de 12 min.

### F11 — `fiches/kubernetes/09-ecosysteme-cloud-native-et-communaute.md`

- **Titre** : Écosystème cloud native — principes, paysage CNCF, autoscaling, gouvernance et communauté
- **Niveau** : débutant (`kubernetes_deb`) ; en partie `[lecture + simulation]` (gouvernance, communauté)
- **Couvre** : KCNA-04-02, KCNA-04-03 (+ CNPA à confirmer)
- **Prérequis** : F2, F4
- **Lab** : `kind` sur `linux-base`. Clés `versions.yaml` : `kubernetes`, `kind`, `metrics_server` (à créer).
- **Temps** : 3 h
- **3 exercices clés** :
  1. Définir cloud native, microservices, infrastructure immuable et les douze facteurs sur l'application des fiches précédentes ;
     mettre en place un HPA sur CPU, générer de la charge et observer la montée en charge ; décrire VPA, Cluster Autoscaler et
     le serverless (Knative, lecture) — KCNA-04-02.
  2. Parcourir le paysage CNCF, classer dix projets par niveau de maturité (sandbox, incubating, graduated) et par standard
     ouvert (OCI, CRI, CNI, CSI, OpenTelemetry) ; vérifier avec `kubectl api-resources` lesquels sont déjà dans le cluster — KCNA-04-02.
  3. Lire une KEP et le calendrier d'une release Kubernetes, expliquer TOC, TAG et SIG, le code de conduite et le parcours
     d'une contribution ; décrire les personas (développeur, SRE, DevOps, ingénieur plateforme) et ce que KCNA, CKA, CKAD,
     KCSA et CKS attendent de chacun — KCNA-04-03.
- **Break-fix** : `break/kubernetes/09-hpa-no-metrics.sh` (metrics-server arrêté, HPA `<unknown>`, aucune montée en charge).
- **Défi chronométré** : quiz de 20 questions sur le paysage et la gouvernance en moins de 15 min (`revision/quiz/`).

### S1 — `scenarios/NN-application-trois-tiers-sur-kubernetes/README.md`

- **Titre** : NN — Une application trois tiers de l'image au tableau de bord sur le lab (numéro `NN` attribué à la création)
- **Niveau** : confirmé (`kubernetes_conf`, entrée) ; prérequis F1 à F11 et `fiches/gitops/01-argo-cd-fondamentaux.md`
- **Couvre** : les 13 compétences KCNA en situation ; prépare CKA-02, CKA-03, CKA-04
- **Lab** : `kubernetes-ha` (+ `ceph-3n` en option pour le stockage), Harbor, Argo CD, Prometheus. Clés `versions.yaml` :
  `kubernetes`, `cilium`, `helm`, `harbor`, `argo_cd`, `prometheus`, `grafana`, `rook` (option).
- **Temps** : 6 h en deux séances
- **Livrable** : runbook « déployer et dépanner l'application » + ADR sur le choix de stockage et d'exposition
- **3 exercices clés** :
  1. Conteneuriser frontend, API et base de données, pousser sur Harbor, écrire le chart Helm avec requests/limits, sondes,
     ConfigMap, Secret, PVC et affinités ; déployer par Argo CD.
  2. Exposer par Gateway API avec certificat interne, isoler par NetworkPolicy, appliquer le profil `restricted`, brancher
     ServiceMonitor et tableau de bord, définir un SLO.
  3. Break-fix transverse à l'aveugle (`break/kubernetes/07-random.sh` + pannes réseau et stockage) : rétablir le service
     et documenter en moins de 30 min.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| F1 Conteneurs et images OCI | débutant | linux-base (1 VM) | 4 h |
| F2 Architecture, API et objets | débutant | linux-base (kind) ou kubernetes-ha | 6 h |
| F3 Administration kubeadm | débutant | linux-base (2 VM) ou kubernetes-ha | 6 h |
| F4 Ordonnancement | débutant | linux-base (kind) | 4 h |
| F5 Réseau et Gateway API | débutant | linux-base (kind) ou kubernetes-ha | 6 h |
| F6 Stockage | débutant | linux-base (kind) ; variante kubernetes-ha + ceph-3n | 4 h |
| F7 Sécurité fondamentaux | débutant | linux-base (kind) | 5 h |
| F8 Dépannage | débutant | linux-base (2 VM kubeadm) | 6 h |
| F9 Livraison applicative | débutant | linux-base (kind) | 5 h |
| F10 Observabilité fondamentaux | débutant | linux-base (kind) ou kubernetes-ha | 5 h |
| F11 Écosystème cloud native | débutant | linux-base (kind) + lecture | 3 h |
| gitops/01 Argo CD fondamentaux (rédigé, brouillon) | débutant | linux-base (kind) | 5 h |
| S1 Application trois tiers | confirmé | kubernetes-ha | 6 h |
| Révision (flashcards, quiz `revision/quiz/kcna`, examen blanc `exams/kcna/`) | — | — | 6 h |
| **Total** | | | **71 h** |

À 5 h par semaine, compter 14 à 15 semaines, soit deux à trois cycles de 4 à 6 semaines de `docs/roadmap.md` §7.
C'est plus qu'un bloc : ces fiches constituent tout le nœud `kubernetes_deb` et sont réutilisées telles quelles par
CKA, CKAD et KCSA, qui n'ajouteront que des fiches confirmé. KCNA peut être passée après F1 à F11 et la révision (59 h) ;
S1 ouvre le bloc CKA.

## 6. Ce que le lab ne couvre pas

- `[lecture + simulation]` : gouvernance CNCF, contribution, personas (F11) ; Cluster Autoscaler et serverless (F11, pas de
  fournisseur de nœuds à la demande sur Proxmox, Knative en lecture) ; mesh de services (F5, notion seulement, ICA plus tard) ;
  signature d'images (F7, lecture, KCSA plus tard).
- Le control plane HA réel (3 control planes, VIP) attend le profil `kubernetes-ha` ; F3 l'explique sur un schéma et le
  pratique en variante.
- L'examen est un QCM sans documentation (`examen.md`) : les flashcards de chaque fiche, le quiz `revision/quiz/kcna` et
  l'examen blanc `exams/kcna/` (prompt `06-examen-blanc.md`, 60 questions en 90 min) sont la préparation directe ;
  les manipulations servent la rétention.
