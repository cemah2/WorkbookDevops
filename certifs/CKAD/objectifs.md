---
code: CKAD
titre: "CKAD — mapping compétences → chapitres"
programme: "certifs/CKAD/programme.md (converti le 2026-10-02 depuis CKAD_v1.35.pdf ; le curriculum v1.37 publié le 2026-10-01 a le même texte, voir §7)"
chapitres_existants: 1
generated: 2026-10-02
status: "1 chapitre rédigé (brouillon) sur 13 fiches + 1 scénario planifiés ; à mettre à jour à chaque PR de chapitre"
---

# CKAD — objectifs et couverture

Mapping entre les 24 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : une fiche rédigée (`fiches/kubernetes/01-kubectl-pods-namespaces.md`, statut brouillon), les douze autres
fiches et le scénario sont des trous. Les deux fiches `fiches/gitops/01` et `02` (Argo CD et Argo Workflows, brouillons) touchent
trois compétences CKAD de façon indirecte, ce qui ne compte pas comme une couverture.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices » et marque
le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| CKAD-01 Application Design and Build | 20 % | 4 | 5,0 % | 4 fiches (K1 à K3, K5) |
| CKAD-02 Application Deployment | 20 % | 4 | 5,0 % | 2 fiches (K4, K11) |
| CKAD-03 Application Observability and Maintenance | 15 % | 5 | 3,0 % | 2 fiches (K9, K10) |
| CKAD-04 Application Environment, Configuration and Security | 25 % | 8 | 3,1 % | 4 fiches (K6, K7, K8, K10) |
| CKAD-05 Services and Networking | 20 % | 3 | 6,7 % | 2 fiches (K12, K13) |
| Transverse | — | 24 | — | 1 scénario + 1 examen blanc |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle. Les trois compétences réseau (6,7 % chacune) et les quatre de conception
(5 %) pèsent le plus lourd individuellement ; le domaine 04 pèse le plus lourd collectivement (25 %).

Ordre de rédaction recommandé (prérequis d'abord, puis du plus lourd au plus léger) :
kubectl et Pods → workloads → ConfigMaps/Secrets/ServiceAccounts → Pods multi-conteneurs et volumes → images →
ressources et quotas → Deployments et stratégies → Services et Ingress → NetworkPolicies → probes et debugging →
Helm et Kustomize → sécurité applicative → CRD, opérateurs et dépréciations → scénario → examen blanc.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : les clés `kubernetes`, `kind`, `cilium`, `helm`, `harbor`, `cert_manager`, `cloudnative_pg`, `kyverno`,
  `prometheus` existent. Ajouter `podman` (K2, dépôt `containers/podman`), `metrics_server` (K7, K9, dépôt
  `kubernetes-sigs/metrics-server`) et `kustomize` (K11 ; `kubectl` embarque une version de Kustomize, la clé sert à
  documenter l'écart avec le binaire autonome `kubernetes-sigs/kustomize`). Passe par la veille (`prompts/07-veille.md`)
  ou par la PR du chapitre concerné.
- `versions.yaml` : la clé `kubernetes` porte `exam_note: CKA/CKAD en 1.35`. La page d'examen et le curriculum annoncent
  **1.37** depuis le 2026-10-01 (`examen.md` §1). Les fiches CKAD suivent la version d'examen : aligner `exam_note` et
  `certifs/CKAD/programme.md` (`version`, `source_file`) à la veille, via `certifs/_sources_pdf/generer_programmes.py`,
  jamais à la main. Le texte des compétences est identique entre v1.35 et v1.37 (§7) : les IDs ne bougent pas.
- `labs/profiles/kubernetes-ha.yaml` : `components` cite déjà `kubernetes`, `cilium`, `metallb`, `envoy_gateway`, `prometheus` ;
  ajouter `metrics_server` et `harbor` (K2 pousse vers `registry.lab.home.arpa`, `labs/network.md` §DNS) une fois les clés créées.
  Le placement de Harbor sur un profil n'est pas décidé : proposer une entrée `DECISIONS.md` dans la PR de K2
  (candidat : VM dédiée sur `kubernetes-ha` ou rôle supplémentaire de `core-jump01`, budget à vérifier).
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.2 (cette PR).
- Décisions existantes qui s'appliquent, à ne pas rouvrir : Helm 4 partout (K11 signale les différences Helm 3 utiles
  à l'examen) ; Gateway API par défaut, Ingress conservé « pour les objectifs d'examen qui le citent encore »
  (CKAD-05-03 le cite : K12 enseigne Ingress sur l'implémentation Cilium et renvoie vers Gateway API pour le lab) ;
  fiches numérotées par série (`NN-`) ; Ubuntu 24.04 LTS comme image de référence.
- Numérotation : `fiches/kubernetes/` est vide, cette cartographie attribue les numéros 01 à 13. La cartographie CKA
  (session séparée) prend les numéros suivants et **réutilise** K1, K3, K4, K6, K7, K12, K13 pour ses compétences communes
  (voir §3, colonne « partagé avec »).

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe ; « indirect » quand une fiche d'un autre domaine
manipule l'objet sans l'enseigner. La colonne « chapitre cible » renvoie à la section 4.

### CKAD-01 — Application Design and Build (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible | Partagé avec |
|---|---|---|---|---|---|---|
| CKAD-01-01 | Define, build and modify container images | 5,0 % | — | — | K2 | CKS-05-01, KCNA-01-04 |
| CKAD-01-02 | Choose and use the right workload resource (Deployment, DaemonSet, CronJob, etc.) | 5,0 % | `fiches/kubernetes/01-kubectl-pods-namespaces.md` (brouillon), Pods seulement | S2 : démo, autonome 1-4, défi 6 min | K1 (rédigé, Pods), K3 | CKA-02-04, KCNA-01-01 |
| CKAD-01-03 | Understand multi-container Pod design patterns (e.g. sidecar, init and others) | 5,0 % | — | — | K5 | — |
| CKAD-01-04 | Utilize persistent and ephemeral volumes | 5,0 % | — | — | K5 | CKA-01-02, CKA-01-03 |

### CKAD-02 — Application Deployment (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible | Partagé avec |
|---|---|---|---|---|---|---|
| CKAD-02-01 | Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary) | 5,0 % | — | — | K4 | CAPA-03-02 (Argo Rollouts, `gitops/05`, approche inverse) |
| CKAD-02-02 | Understand Deployments and how to perform rolling updates | 5,0 % | — | — | K4 | CKA-02-01 |
| CKAD-02-03 | Use the Helm package manager to deploy existing packages | 5,0 % | — | — | K11 | CKA-05 (Helm, compétence à confirmer à la cartographie CKA), CAPA-02-04 |
| CKAD-02-04 | Kustomize | 5,0 % | — | — | K11 | CAPA-02-04, CGOA-05 (à confirmer) |

### CKAD-03 — Application Observability and Maintenance (15 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible | Partagé avec |
|---|---|---|---|---|---|---|
| CKAD-03-01 | Understand API deprecations | 3,0 % | — | — | K10 | CKA-05 (à confirmer) |
| CKAD-03-02 | Implement probes and health checks | 3,0 % | — | — | K9 | CKA-02-04 |
| CKAD-03-03 | Use built-in CLI tools to monitor Kubernetes applications | 3,0 % | `fiches/kubernetes/01-kubectl-pods-namespaces.md` (brouillon) | S1 : démo, autonome 1-3, break-fix kubeconfig, défi 15 min ; S2 : démo (formats de sortie), break-fix namespace ; S3 : démo (describe, events), autonome 1-4, défi 10 min | K1 (rédigé, bases), K9 | CKA-04-04 (à confirmer) |
| CKAD-03-04 | Utilize container logs | 3,0 % | `fiches/kubernetes/01-kubectl-pods-namespaces.md` (brouillon) ; indirect : `fiches/gitops/02` (brouillon) | S3 : démo (`logs` et ses drapeaux, `[non testé]` sans nœud), autonome 1-3, break-fix crashloop (logs --previous) | K1 (rédigé, bases), K9 | CKA-04 |
| CKAD-03-05 | Debugging in Kubernetes | 3,0 % | indirect : `fiches/gitops/02` break-fix `image-pull` (ImagePullBackOff) et `quota` (pod jamais créé) | S3 break-fix : diagnostic guidé, sans la méthode générale | K9 | CKA-04-03, CKA-04-04 (à confirmer) |

### CKAD-04 — Application Environment, Configuration and Security (25 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible | Partagé avec |
|---|---|---|---|---|---|---|
| CKAD-04-01 | Discover and use resources that extend Kubernetes (CRD, Operators) | 3,1 % | indirect : `fiches/gitops/01` et `02` consomment les CRD `Application`, `Workflow` | aucun exercice sur la découverte de CRD | K10 | CKA-05 (à confirmer), CAPA |
| CKAD-04-02 | Understand authentication, authorization and admission control | 3,1 % | indirect : `fiches/gitops/02` S2 (Role/RoleBinding de l'executor, break-fix `rbac`) | S2 break-fix `02-argo-workflows-rbac.sh` : RBAC d'un ServiceAccount, cas particulier | K6 (RBAC, `auth can-i`), K8 (admission) | CKS-02-01, CKS-02-03, CKA-05 |
| CKAD-04-03 | Understand requests, limits, quotas | 3,1 % | indirect : `fiches/gitops/02` break-fix optionnel `02-argo-workflows-quota.sh` (ResourceQuota saturé) | symptôme observé, concept non enseigné | K7 | CKA-02-05 |
| CKAD-04-04 | Define resource requirements | 3,1 % | — | — | K7 | CKA-02-05 |
| CKAD-04-05 | Understand ConfigMaps | 3,1 % | — | — | K6 | CKA-02-02 |
| CKAD-04-06 | Create & consume Secrets | 3,1 % | — | — | K6 | CKA-02-02, CKS-04-02 |
| CKAD-04-07 | Understand ServiceAccounts | 3,1 % | indirect : `fiches/gitops/02` S1 et S2 (ServiceAccount `wf-runner`, token d'UI) | création d'un ServiceAccount dédié et de son RoleBinding, sans le cycle concept → exercice | K6 | CKS-02-02 |
| CKAD-04-08 | Understand Application Security (SecurityContexts, Capabilities, etc.) | 3,1 % | — | — | K8 | CKS-04-01, CKS-03-04 |

### CKAD-05 — Services and Networking (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible | Partagé avec |
|---|---|---|---|---|---|---|
| CKAD-05-01 | Demonstrate basic understanding of NetworkPolicies | 6,7 % | — | — | K13 | CKA-03-02, CKS-01-01, CCA (à confirmer) |
| CKAD-05-02 | Provide and troubleshoot access to applications via services | 6,7 % | — | — | K12 | CKA-03-03, CKA-03-06 |
| CKAD-05-03 | Use Ingress rules to expose applications | 6,7 % | indirect : `fiches/gitops/01` variante Gateway API (`Gateway` + `HTTPRoute`), pas d'Ingress | aucun objet `Ingress` dans le dépôt | K12 | CKA-03-05, CKS-01-03 |

### Compétences partagées avec CKA, CKS et les associées

CKAD se passe dans le bloc Kubestronaut (`docs/prerequis.md` §3, parcours P1, jalon `kubernetes_conf`, juste après CKA).
Les treize fiches citent dans leur front matter les IDs CKA et CKS qu'elles couvrent, pour éviter un doublon à la
cartographie CKA. La colonne « partagé avec » ci-dessus est indicative : la cartographie CKA (session séparée) la confirme,
`certifs/CKA/programme.md` compte 25 compétences dont plusieurs ne sont pas encore recoupées ici.

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de lecture recommandé (DECISIONS.md, 2026-10-02).
Fiches **débutant** : chemin principal sur un cluster `kind` (version `kind` de `versions.yaml`, Kubernetes à la version
d'examen) hébergé sur `linux-base-lx01` (profil `linux-base`, 8 vCPU / 16 Go / 180 Go, la VM `kind` en prend 4 vCPU / 8 Go / 60 Go),
variante `kubernetes-ha` ; même convention que les fiches `gitops/01` et `02`. Fiches **confirmé** : profil `kubernetes-ha`
(16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`, Cilium en CNI). Le scénario demande `kubernetes-ha` et Harbor.
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.

Fil rouge de la série : la même application `lab-shop` (API HTTP + worker + base PostgreSQL) traverse les treize fiches ;
chaque fiche ajoute un objet. Le scénario S1 la reconstruit de zéro sous contrainte de temps.

Règle d'examen rappelée dans chaque fiche : tout se fait au terminal avec `kubectl`, la documentation `kubernetes.io/docs`
ouverte dans un seul onglet (`examen.md` §1) ; les défis chronométrés interdisent tout autre outil (pas de `k9s`, pas d'IDE).

### K1 — `fiches/kubernetes/01-kubectl-pods-namespaces.md` — rédigé (brouillon, 2026-10-02)

- **Titre** : kubectl, Pods et namespaces — le poste de travail de l'examen
- **Niveau** : débutant (`kubernetes_deb`, première fiche du domaine)
- **Couvre** : CKAD-01-02 (Pods seulement), CKAD-03-03 (bases), CKAD-03-04 (bases) ; aussi KCNA-01-01, CKA-02-04 (partiel)
- **Prérequis** : `linux_conf` (shell, vim, SSH, systemd), `reseau_deb` (IP, ports, DNS) ; aucune fiche Kubernetes
- **Lab** : `kind` sur `linux-base-lx01` (4 vCPU / 8 Go / 60 Go depuis DECISIONS.md 2026-10-02). Clés `versions.yaml` :
  `kubernetes`, `kind`, `cilium` (CNI de la VM `kind`, nécessaire dès K13 ; installé ici pour ne pas recréer le cluster).
- **Plan validé** : `docs/plans/kubernetes-01-kubectl-pods-namespaces.md` (2026-10-02).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Créer le cluster `kind` à la version d'examen, configurer `~/.kube/config`, `alias k=kubectl`, complétion bash,
     `~/.vimrc` (`expandtab`, `shiftwidth=2`) ; vérifier avec `kubectl version`, `kubectl get nodes -o wide` — CKAD-03-03.
  2. Pods en impératif puis en déclaratif : `kubectl run`, `--dry-run=client -o yaml`, `kubectl create`/`apply`/`replace`,
     `kubectl explain pod.spec.containers --recursive`, `kubectl get -o jsonpath`/`custom-columns`, namespaces et
     `kubectl config set-context --current --namespace` — CKAD-01-02, CKAD-03-03.
  3. Lire un Pod : `describe`, `logs` (`-c`, `--previous`, `-f`, `--since`), `events --for`, `exec`, `cp`, `port-forward`,
     `delete --force --grace-period=0` ; chronométrer chaque geste — CKAD-03-03, CKAD-03-04.
- **Break-fix** : `break/kubernetes/01-kubeconfig-casse.sh` (port du serveur faux, `connection refused`),
  `01-namespace-fantome.sh` (namespace du contexte inexistant), `01-pod-crashloop.sh` (commande qui sort en erreur,
  `CrashLoopBackOff`), `01-pod-pending.sh` (`nodeSelector` sans nœud, `Pending`).
- **Défi chronométré** : créer un namespace, y lancer trois Pods avec labels et images précises, récupérer les logs
  du second dans un fichier, en moins de 6 min, sans `-h` ni documentation.

### K2 — `fiches/kubernetes/02-images-conteneurs-podman.md`

- **Titre** : Images de conteneurs — construire, modifier, pousser avec Podman
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKAD-01-01 ; aussi CKS-05-01, KCNA-01-04
- **Prérequis** : `linux_deb` ; K1 recommandé (pour `kind load` et le test dans un Pod)
- **Lab** : `linux-base-lx01` (Podman sans démon, rootless) + le cluster `kind` de K1 ; registre : `kind` local via
  `kind load docker-image` en chemin principal, `registry.lab.home.arpa` (Harbor, `versions.yaml` clé `harbor`) en variante
  quand le placement est décidé (§2). Clés `versions.yaml` : `podman` (à créer), `kind`, `harbor`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Écrire un `Containerfile` (base, `COPY`, `RUN`, `USER` non root, `EXPOSE`, `ENTRYPOINT` vs `CMD`, `HEALTHCHECK`),
     `podman build -t`, `podman run`, `podman inspect`, `podman image history` ; mesurer la taille, passer en multi-stage — CKAD-01-01.
  2. Modifier une image existante sans son `Containerfile` : `podman run` + `podman commit`, puis la bonne pratique
     (`FROM` + couche), tag sémantique, `podman tag`, `podman save -o`/`podman load`, `kind load image-archive` — CKAD-01-01.
  3. Pousser vers un registre : `podman login`, `podman push` (Harbor en variante), `imagePullSecrets` dans un Pod,
     digest vs tag (`imagePullPolicy`), tester l'image dans le cluster — CKAD-01-01.
- **Break-fix** : `break/kubernetes/02-image-tag-introuvable.sh` (Pod en `ErrImagePull` : tag inexistant, puis registre
  non résolu).
- **Défi chronométré** : à partir d'un `Containerfile` fourni, construire l'image, la taguer `v2`, l'exporter en archive
  et la faire tourner dans un Pod en moins de 8 min.

### K3 — `fiches/kubernetes/03-workloads-deployment-daemonset-job-cronjob.md`

- **Titre** : Choisir le bon workload — Deployment, ReplicaSet, DaemonSet, StatefulSet, Job, CronJob
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKAD-01-02 ; aussi CKA-02-04, KCNA-01-01
- **Prérequis** : K1
- **Lab** : `kind` sur `linux-base-lx01` (cluster à 3 nœuds pour le DaemonSet). Clés `versions.yaml` : `kubernetes`, `kind`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. `kubectl create deployment --replicas --image --dry-run=client -o yaml`, ReplicaSet et sélecteurs, `scale`,
     labels/annotations, `kubectl set image`, suppression en cascade ou orpheline (`--cascade=orphan`) — CKAD-01-02.
  2. DaemonSet (un agent par nœud, `nodeSelector`, tolérances pour le control plane) et StatefulSet (identité stable,
     Service headless, `volumeClaimTemplates`, ordre de démarrage) : quand les choisir plutôt qu'un Deployment — CKAD-01-02.
  3. Job (`completions`, `parallelism`, `backoffLimit`, `activeDeadlineSeconds`, `restartPolicy`) et CronJob
     (`schedule`, `concurrencyPolicy`, `startingDeadlineSeconds`, `successfulJobsHistoryLimit`, `kubectl create job --from=cronjob/`)
     — CKAD-01-02.
- **Break-fix** : `break/kubernetes/03-selector-mismatch.sh` (Deployment dont le `selector` ne couvre pas le template :
  rejeté à la création, puis ReplicaSet qui ne monte jamais), `break/kubernetes/03-cronjob-jamais-lance.sh` (`suspend: true`
  et fuseau de `schedule`).
- **Défi chronométré** : à partir d'un énoncé « un collecteur sur chaque nœud, une tâche de nettoyage toutes les 5 min,
  une API en 3 réplicas », créer les trois objets en moins de 10 min.

### K4 — `fiches/kubernetes/04-rolling-update-blue-green-canary.md`

- **Titre** : Déploiements — rolling update, rollback, blue/green et canary avec les primitives Kubernetes
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKAD-02-01, CKAD-02-02 ; aussi CKA-02-01
- **Prérequis** : K3, K12 (Services, pour le bascule blue/green et le canary par sélecteur)
- **Lab** : `kubernetes-ha` ; variante `kind`. Clés `versions.yaml` : `kubernetes`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Stratégies `RollingUpdate` (`maxSurge`, `maxUnavailable`, `minReadySeconds`, `progressDeadlineSeconds`) et `Recreate` ;
     `kubectl rollout status/history/undo --to-revision/pause/resume`, `kubernetes.io/change-cause`, `revisionHistoryLimit` — CKAD-02-02.
  2. Blue/green : deux Deployments `version: blue` / `version: green` derrière un Service dont on change le sélecteur
     (`kubectl patch`), vérification par `curl` en boucle depuis un Pod client, retour arrière en une commande — CKAD-02-01.
  3. Canary : Service sélectionnant `app=api` sans la version, Deployment canary à 1 réplica sur 10, montée progressive
     par `scale`, mesure de la répartition réelle ; comparer avec Argo Rollouts (`gitops/05`, planifié) et noter
     la limite (pas de pondération fine sans Gateway API ou mesh) — CKAD-02-01.
- **Break-fix** : `break/kubernetes/04-rollout-bloque.sh` (nouvelle image introuvable, rollout figé à `maxSurge`,
  `progressDeadlineExceeded`), `break/kubernetes/04-service-selector-vide.sh` (sélecteur du Service ne correspond à aucune version,
  `Endpoints` vide).
- **Défi chronométré** : passer `lab-shop-api` de `v1` à `v2` sans interruption, revenir à `v1` sur incident, puis
  basculer en blue/green, le tout en moins de 12 min.

### K5 — `fiches/kubernetes/05-pods-multi-conteneurs-volumes.md`

- **Titre** : Pods multi-conteneurs (init, sidecar, ambassador, adapter) et volumes persistants ou éphémères
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKAD-01-03, CKAD-01-04 ; aussi CKA-01-02, CKA-01-03
- **Prérequis** : K3 ; `ceph_deb` recommandé pour la variante CSI Rook sur `kubernetes-ha` (pas sur le chemin `kind`)
- **Lab** : `kind` sur `linux-base-lx01` (StorageClass `standard` de `kind`, provisionnement local) ; variante `kubernetes-ha` + `ceph-3n`
  (StorageClass RBD via Rook). Clés `versions.yaml` : `kubernetes`, `kind`, `rook` (variante).
- **Temps** : 5 h
- **3 exercices clés** :
  1. `initContainers` (attendre une dépendance, préparer un fichier), sidecar natif (`initContainers` avec `restartPolicy: Always`,
     stable depuis 1.33) pour un expéditeur de logs, ambassador (proxy local) et adapter (reformatage de métriques) ;
     `kubectl logs -c`, ordre de démarrage, partage de `emptyDir` et de réseau (`localhost`) — CKAD-01-03.
  2. Volumes éphémères : `emptyDir` (`medium: Memory`, `sizeLimit`), `configMap`/`secret`/`downwardAPI`/`projected`,
     volume éphémère générique (`ephemeral.volumeClaimTemplate`) ; cycle de vie lié au Pod, vérifié par suppression — CKAD-01-04.
  3. Volumes persistants : PV statique `hostPath` (démonstration seulement) puis PVC dynamique avec StorageClass,
     `accessModes`, `reclaimPolicy`, `volumeMode`, redimensionnement, `kubectl get pv,pvc` et statut `Bound`/`Pending`,
     montage dans un StatefulSet — CKAD-01-04.
- **Break-fix** : `break/kubernetes/05-pvc-pending.sh` (StorageClass inexistante dans le PVC, Pod en `Pending`
  `unbound immediate PersistentVolumeClaims`), `break/kubernetes/05-init-bloque.sh` (init container qui attend un Service
  absent, Pod en `Init:0/1`).
- **Défi chronométré** : Pod avec init qui télécharge une page, sidecar qui la sert, volume `emptyDir` partagé, plus un PVC
  de 1 Gi monté dans le conteneur principal, en moins de 10 min.

### K6 — `fiches/kubernetes/06-configmaps-secrets-serviceaccounts-rbac.md`

- **Titre** : ConfigMaps, Secrets, ServiceAccounts et RBAC — configurer et identifier une application
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKAD-04-05, CKAD-04-06, CKAD-04-07, CKAD-04-02 (authn/authz : RBAC, `auth can-i` ; l'admission est en K8) ;
  aussi CKA-02-02, CKS-02-01, CKS-02-02, CKS-04-02
- **Prérequis** : K3
- **Lab** : `kind` sur `linux-base-lx01` ; variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. ConfigMap depuis littéraux, fichier, dossier et `envFrom` ; consommation par variable (`valueFrom.configMapKeyRef`),
     par volume (`items`, `subPath`, mise à jour à chaud vs `subPath` figé), `immutable: true` ; redémarrage contrôlé
     après changement — CKAD-04-05.
  2. Secrets `Opaque`, `kubernetes.io/tls`, `kubernetes.io/dockerconfigjson` ; `--from-literal` vs `data` base64 vs `stringData` ;
     montage en volume avec `defaultMode`, `imagePullSecrets` ; ce qu'un Secret n'est pas (encodage ≠ chiffrement, renvoi
     vers CKS pour le chiffrement au repos) — CKAD-04-06.
  3. ServiceAccount dédié, `automountServiceAccountToken: false`, token projeté (`TokenRequest`, expiration), appel de l'API
     depuis un Pod avec `curl` et le token ; Role/RoleBinding et ClusterRole/ClusterRoleBinding, `kubectl auth can-i --as
     system:serviceaccount:ns:sa`, `kubectl create role/rolebinding` en impératif ; chaîne authentification → autorisation →
     admission expliquée sur une requête — CKAD-04-07, CKAD-04-02.
- **Break-fix** : `break/kubernetes/06-configmap-cle-absente.sh` (Pod en `CreateContainerConfigError`, clé renommée),
  `break/kubernetes/06-sa-forbidden.sh` (application qui liste des Pods avec un ServiceAccount sans RoleBinding, `403 Forbidden`).
- **Défi chronométré** : rendre une application fonctionnelle à partir d'un énoncé « lit `DB_URL` depuis une ConfigMap,
  `DB_PASSWORD` depuis un Secret, doit pouvoir lister les ConfigMaps de son namespace », en moins de 10 min.

### K7 — `fiches/kubernetes/07-requests-limits-quotas-limitrange.md`

- **Titre** : Ressources — requests, limits, classes QoS, ResourceQuota et LimitRange
- **Niveau** : débutant (`kubernetes_deb`)
- **Couvre** : CKAD-04-03, CKAD-04-04 ; aussi CKA-02-05
- **Prérequis** : K3
- **Lab** : `kind` sur `linux-base-lx01` (metrics-server installé, clé `metrics_server` à créer) ; variante `kubernetes-ha`.
  Clés `versions.yaml` : `kubernetes`, `metrics_server` (à créer).
- **Temps** : 3 h
- **3 exercices clés** :
  1. Définir `requests`/`limits` CPU et mémoire (unités `m`, `Mi`), lire la classe QoS (`Guaranteed`, `Burstable`,
     `BestEffort`) dans `kubectl describe`, provoquer un `OOMKilled` avec un conteneur qui alloue, observer le throttling CPU
     avec `kubectl top pod --containers` — CKAD-04-04.
  2. ResourceQuota par namespace (CPU, mémoire, nombre d'objets, `scopeSelector` par classe de priorité) ; Pod refusé
     à l'admission (`exceeded quota`), lecture de `kubectl describe quota` — CKAD-04-03.
  3. LimitRange (`default`, `defaultRequest`, `min`, `max`, `maxLimitRequestRatio`) : injection des valeurs par défaut,
     interaction avec la ResourceQuota (Pod sans requests refusé tant que le LimitRange n'existe pas) — CKAD-04-03.
- **Break-fix** : `break/kubernetes/07-quota-sature.sh` (Deployment dont les réplicas n'apparaissent pas, l'erreur est sur
  le ReplicaSet, pas sur le Pod), `break/kubernetes/07-pod-pending-insufficient.sh` (`requests` supérieurs à tout nœud,
  `Insufficient cpu`).
- **Défi chronométré** : encadrer le namespace `lab-shop` (quota 2 CPU / 4 Gi / 10 Pods, LimitRange par défaut 100m / 128Mi)
  et faire rentrer un Deployment de 3 réplicas dedans, en moins de 8 min.

### K8 — `fiches/kubernetes/08-securite-applicative-securitycontext-admission.md`

- **Titre** : Sécurité applicative — SecurityContext, capabilities, Pod Security Admission et politiques d'admission
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKAD-04-08, CKAD-04-02 (admission) ; aussi CKS-04-01, CKS-03-04, CKS-02-01
- **Prérequis** : K6, K7 ; `securite_deb` recommandé (utilisateurs, capabilities Linux, seccomp côté hôte)
- **Lab** : `kubernetes-ha` ; variante `kind`. Clés `versions.yaml` : `kubernetes`, `kyverno` (variante, 3e exercice).
- **Temps** : 5 h
- **3 exercices clés** :
  1. `securityContext` Pod et conteneur : `runAsUser`/`runAsGroup`/`fsGroup`, `runAsNonRoot`, `readOnlyRootFilesystem`,
     `allowPrivilegeEscalation`, `privileged`, `capabilities.add/drop` (`NET_BIND_SERVICE`, `drop: [ALL]`), `seccompProfile`
     `RuntimeDefault` ; vérifier depuis le conteneur (`id`, `capsh --print`, écriture sur `/`) — CKAD-04-08.
  2. Pod Security Admission : labels de namespace `enforce`/`audit`/`warn` et niveaux `privileged`/`baseline`/`restricted` ;
     faire passer `lab-shop` en `restricted` en corrigeant chaque refus lu dans l'erreur `kubectl apply` — CKAD-04-02, CKAD-04-08.
  3. Chaîne d'admission : webhooks mutants/validants vus par `kubectl get mutatingwebhookconfigurations`, `ValidatingAdmissionPolicy`
     en CEL (interdire `latest`), puis variante Kyverno (une `ClusterPolicy` équivalente) ; `kubectl auth whoami`, `--as`,
     `--as-group` pour tester l'autorisation — CKAD-04-02.
- **Break-fix** : `break/kubernetes/08-psa-restricted-refuse.sh` (namespace passé en `restricted`, Deployment dont les Pods ne
  sont plus créés : l'erreur est dans les événements du ReplicaSet), `break/kubernetes/08-readonly-rootfs.sh` (application qui
  écrit dans `/tmp` avec `readOnlyRootFilesystem: true`).
- **Défi chronométré** : rendre un Pod fourni conforme au niveau `restricted` sans casser l'application (port 80 → 8080
  ou `NET_BIND_SERVICE`), en moins de 10 min.

### K9 — `fiches/kubernetes/09-probes-monitoring-logs-debugging.md`

- **Titre** : Observabilité applicative — probes, `kubectl top`, logs et méthode de debugging
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKAD-03-02, CKAD-03-03, CKAD-03-04, CKAD-03-05 ; aussi CKA-04-03, CKA-04-04 (à confirmer)
- **Prérequis** : K5, K6, K7, K12 (les pannes réseau font partie de la méthode)
- **Lab** : `kubernetes-ha` (metrics-server, Prometheus déjà dans le profil, utilisé en lecture) ; variante `kind`.
  Clés `versions.yaml` : `kubernetes`, `metrics_server` (à créer).
- **Temps** : 6 h
- **3 exercices clés** :
  1. `livenessProbe`, `readinessProbe`, `startupProbe` (`httpGet`, `tcpSocket`, `exec`, `grpc`), `initialDelaySeconds`,
     `periodSeconds`, `failureThreshold` ; effet sur les `Endpoints` d'une readiness en échec, redémarrage sur liveness,
     startup pour une application lente — CKAD-03-02.
  2. Outils intégrés : `kubectl get --watch`, `-o wide`, `describe`, `events --types=Warning`, `top node/pod`, `rollout status`,
     `kubectl logs` (`-l`, `--all-containers`, `--previous`, `--tail`, `--timestamps`), `kubectl debug` (conteneur éphémère,
     copie de Pod, `node/`), `kubectl exec` ; distinguer logs du conteneur et sortie de l'application — CKAD-03-03, CKAD-03-04.
  3. Méthode de debugging en 6 questions (le Pod existe-t-il ? est-il planifié ? démarre-t-il ? est-il prêt ? répond-il ?
     est-il joignable ?) appliquée à 8 pannes injectées à l'aveugle (`break.sh random`) ; fiche réflexe d'une page — CKAD-03-05.
- **Break-fix** : `break/kubernetes/09-liveness-trop-agressive.sh` (application saine redémarrée en boucle),
  `break/kubernetes/09-readiness-mauvais-port.sh` (Deployment `Running` mais Service sans endpoint), plus réutilisation
  aléatoire des pannes K1 à K8.
- **Défi chronométré** : trois pannes injectées à l'aveugle sur `lab-shop`, diagnostic et correction en moins de 15 min
  avec la cause écrite en une phrase pour chacune.

### K10 — `fiches/kubernetes/10-crd-operateurs-deprecations-api.md`

- **Titre** : Étendre Kubernetes — CRD, opérateurs, découverte d'API et dépréciations
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKAD-04-01, CKAD-03-01 ; aussi CKA-05 (à confirmer), prépare CAPA et KCA
- **Prérequis** : K6, K9
- **Lab** : `kubernetes-ha` ; variante `kind`. Clés `versions.yaml` : `kubernetes`, `cert_manager`, `cloudnative_pg`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Découverte : `kubectl api-resources`, `api-versions`, `explain` sur une ressource custom, `kubectl get crd`,
     `kubectl get <cr> -o yaml` et son `status` ; écrire une CRD minimale (`openAPIV3Schema`, `versions`, `served`/`storage`,
     `additionalPrinterColumns`) et créer une instance — CKAD-04-01.
  2. Opérateurs : installer cert-manager puis CloudNativePG à leur version de `versions.yaml`, créer un `Certificate` et un
     `Cluster` PostgreSQL pour `lab-shop`, lire la réconciliation dans les logs du contrôleur, supprimer la CR et observer
     la cascade (`ownerReferences`) — CKAD-04-01.
  3. Dépréciations : politique de dépréciation des API (`kubernetes.io/docs/reference/using-api/deprecation-policy`),
     lire la liste « deprecated API migration guide » de la version d'examen, repérer un manifest obsolète par
     `kubectl apply --warnings-as-errors`, le convertir (`kubectl convert`, plugin séparé), vérifier `kubectl get --raw /metrics
     | grep apiserver_requested_deprecated_apis` — CKAD-03-01.
- **Break-fix** : `break/kubernetes/10-cr-schema-invalide.sh` (instance refusée par le schéma de la CRD, message à lire),
  `break/kubernetes/10-apiversion-obsolete.sh` (manifest avec `apiVersion` retirée : `no matches for kind`).
- **Défi chronométré** : installer un opérateur depuis son manifest officiel, créer une CR, prouver qu'elle est réconciliée,
  et corriger un manifest obsolète fourni, en moins de 12 min.

### K11 — `fiches/kubernetes/11-helm-kustomize.md`

- **Titre** : Helm et Kustomize — déployer et adapter des paquets existants
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKAD-02-03, CKAD-02-04 ; aussi CAPA-02-04 (prépare `gitops/04`), CKA-05 (à confirmer)
- **Prérequis** : K4, K6
- **Lab** : `kubernetes-ha` ; variante `kind`. Clés `versions.yaml` : `helm`, `kustomize` (à créer), `kubernetes`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Helm 4 : `helm repo add/update`, `search repo`, `show values`, `install -f values.yaml --set`, `upgrade --install`,
     `history`, `rollback`, `uninstall`, `helm template`/`--dry-run`, `helm get manifest`, dépôt OCI ; section « ce qui
     change si l'examen tourne en Helm 3 » (commandes identiques, différences à connaître listées) — CKAD-02-03.
  2. Kustomize : `kustomization.yaml` avec `resources`, `namespace`, `namePrefix`, `commonLabels`/`labels`, `images`,
     `configMapGenerator`/`secretGenerator` (suffixe de hash, `disableNameSuffixHash`), `replicas` ; `kubectl kustomize`
     et `kubectl apply -k` — CKAD-02-04.
  3. Overlays `dev`/`prod` avec `patches` (stratégique et JSON 6902), `components`, et un chart Helm consommé via
     `helmCharts` en Kustomize ; comparer le rendu des deux outils sur `lab-shop`
     (`diff <(kubectl kustomize) <(helm template)`) — CKAD-02-03, CKAD-02-04.
- **Break-fix** : `break/kubernetes/11-helm-release-failed.sh` (`upgrade` échoué, release en `failed`, `rollback` attendu),
  `break/kubernetes/11-kustomize-patch-cible-absente.sh` (patch dont la cible ne matche rien, `kubectl apply -k` en erreur).
- **Défi chronométré** : installer un chart avec trois valeurs surchargées, puis produire un overlay Kustomize `prod`
  qui change l'image et le nombre de réplicas d'un Deployment fourni, en moins de 10 min.

### K12 — `fiches/kubernetes/12-services-dns-ingress.md`

- **Titre** : Services, DNS du cluster et Ingress — exposer et dépanner l'accès à une application
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKAD-05-02, CKAD-05-03 ; aussi CKA-03-03, CKA-03-05, CKA-03-06, CKS-01-03
- **Prérequis** : K3, K6 ; `reseau_conf` (déjà prérequis de `kubernetes_conf`)
- **Lab** : `kubernetes-ha` (MetalLB pour `LoadBalancer`, contrôleur Ingress de Cilium, cert-manager) ; variante `kind`
  (`NodePort` + `extraPortMappings`). Clés `versions.yaml` : `kubernetes`, `cilium`, `metallb`, `cert_manager`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Services `ClusterIP`, `NodePort`, `LoadBalancer`, `ExternalName`, headless ; `kubectl expose`, `targetPort` nommé,
     `EndpointSlice`, `sessionAffinity` ; résolution `svc.ns.svc.cluster.local` depuis un Pod, `kubectl get svc -o wide`,
     dépannage dans l'ordre sélecteur → endpoints → port → politique réseau → DNS — CKAD-05-02.
  2. Ingress : `ingressClassName`, règles `host`/`path` (`Prefix`, `Exact`), `defaultBackend`, TLS avec un Secret
     `kubernetes.io/tls` émis par cert-manager, `kubectl create ingress` en impératif ; implémentation Cilium
     (`ingressController.enabled`, DECISIONS.md : Ingress conservé pour l'examen) — CKAD-05-03.
  3. Même exposition en Gateway API (`Gateway`, `HTTPRoute`) pour relier à `gitops/01` et à CKA-03-04 ; lire les
     différences de modèle en 10 lignes, pas plus (hors programme CKAD) — CKAD-05-03 (contexte).
- **Break-fix** : `break/kubernetes/12-service-targetport.sh` (Service qui cible le mauvais port, `connection refused`
  depuis le cluster), `break/kubernetes/12-ingress-classe-absente.sh` (Ingress sans `ingressClassName`, jamais d'adresse),
  `break/kubernetes/12-coredns-arrete.sh` (résolution interne cassée).
- **Défi chronométré** : exposer `lab-shop-api` en `ClusterIP`, le publier sur `shop.lab.home.arpa` avec TLS par Ingress,
  et prouver l'accès par `curl` depuis l'extérieur du cluster, en moins de 10 min.

### K13 — `fiches/kubernetes/13-networkpolicies.md`

- **Titre** : NetworkPolicies — isoler une application par défaut, ouvrir le strict nécessaire
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CKAD-05-01 ; aussi CKA-03-02, CKS-01-01, CKS-03-03, prépare CCA
- **Prérequis** : K12 ; `reseau_conf`
- **Lab** : `kubernetes-ha` (Cilium applique les politiques) ; sur `kind`, le CNI par défaut **n'applique pas** les
  NetworkPolicies : la VM `kind` de K1 est créée avec Cilium pour cette raison. Clés `versions.yaml` : `kubernetes`, `cilium`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Modèle : `podSelector`, `policyTypes`, `ingress`/`egress`, sémantique OR/AND des `from`/`to` (`podSelector`,
     `namespaceSelector`, `ipBlock` avec `except`), `ports` ; politique « deny all » du namespace, puis autorisations
     ciblées ; tests avec un Pod client (`curl --max-time 2`, `nc -zv`) — CKAD-05-01.
  2. Cas CKAD classiques : autoriser `api` → `db` sur 5432 seulement, autoriser l'egress DNS (port 53 UDP/TCP vers
     `kube-system`), laisser entrer depuis un autre namespace par label, isoler une application du reste du cluster — CKAD-05-01.
  3. Lire ce que fait réellement la politique : `cilium policy get` / Hubble (`hubble observe --verdict DROPPED`) en
     variante, `kubectl describe netpol` ; piège du sélecteur vide (`{}`) et de `ingress: []` — CKAD-05-01.
- **Break-fix** : `break/kubernetes/13-deny-all-sans-dns.sh` (egress `deny all` qui casse la résolution DNS, application
  en timeout), `break/kubernetes/13-namespace-label-absent.sh` (politique correcte, namespace source sans le label attendu).
- **Défi chronométré** : isoler le namespace `lab-shop` (deny all ingress/egress), rouvrir `api → db`, `ingress → api`
  et le DNS, prouver chaque règle par un test, en moins de 10 min.

### S1 — `scenarios/NN-lab-shop-de-l-image-au-canary/README.md`

- **Titre** : NN — `lab-shop` de zéro : image, déploiement, configuration, exposition, isolation, diagnostic
  (numéro `NN` attribué à la création)
- **Niveau** : expert (`kubernetes_exp`) ; prérequis K1 à K13 complets, pas de saut direct
- **Couvre** : les 24 compétences CKAD en situation ; aussi CKA-02-01, CKA-03-02, CKA-03-03, CKS-04-01, CKS-05-01
- **Lab** : `kubernetes-ha` + Harbor (`registry.lab.home.arpa`), cert-manager, Cilium, MetalLB ; `ceph-3n` recommandé pour
  le PVC de la base. Clés `versions.yaml` : `kubernetes`, `podman`, `harbor`, `helm`, `cilium`, `metallb`, `cert_manager`, `cloudnative_pg`.
- **Temps** : 8 h en deux séances
- **Livrable** : runbook « déployer `lab-shop` sur un cluster vierge en 45 min » + postmortem d'une des pannes injectées
- **3 exercices clés** :
  1. Construire les deux images (API, worker) non root, les pousser sur Harbor, packager en chart Helm avec overlays
     Kustomize `dev`/`prod`, déployer en `restricted` avec quotas, probes, ConfigMaps, Secrets et ServiceAccount dédié.
  2. Exposer par Ingress TLS, isoler par NetworkPolicies, publier `v2` en canary puis blue/green, revenir en arrière
     sur un échec de probe.
  3. Break-fix transverse : cinq pannes injectées à l'aveugle (`break.sh random` sur K1 à K13), diagnostic et correction
     en moins de 30 min, chaque cause consignée en une phrase.

### E1 — `exams/ckad-01/`

- **Format** : examen blanc en conditions réelles (`setup.sh`, `grade.sh`, barème), 2 h, 16 tâches pondérées selon §1,
  un seul onglet `kubernetes.io/docs` autorisé, produit par `prompts/06-examen-blanc.md` une fois K1 à K13 rédigées.
  Objectif : deux passages à ≥ 80 % (marge sur le seuil de 66 %, `examen.md` §1) avant de consommer les deux sessions killer.sh.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| K1 kubectl, Pods et namespaces (rédigé, brouillon) | débutant | linux-base (kind) | 5 h |
| K2 Images de conteneurs avec Podman | débutant | linux-base (+ kind) | 4 h |
| K3 Workloads | débutant | linux-base (kind) | 5 h |
| K4 Rolling update, blue/green, canary | confirmé | kubernetes-ha | 5 h |
| K5 Pods multi-conteneurs et volumes | débutant | linux-base (kind), variante kubernetes-ha + ceph-3n | 5 h |
| K6 ConfigMaps, Secrets, ServiceAccounts, RBAC | débutant | linux-base (kind) | 5 h |
| K7 Requests, limits, quotas | débutant | linux-base (kind) | 3 h |
| K8 Sécurité applicative et admission | confirmé | kubernetes-ha | 5 h |
| K9 Probes, monitoring, logs, debugging | confirmé | kubernetes-ha | 6 h |
| K10 CRD, opérateurs, dépréciations | confirmé | kubernetes-ha | 4 h |
| K11 Helm et Kustomize | confirmé | kubernetes-ha | 5 h |
| K12 Services, DNS, Ingress | confirmé | kubernetes-ha | 6 h |
| K13 NetworkPolicies | confirmé | kubernetes-ha | 4 h |
| S1 `lab-shop` de zéro | expert | kubernetes-ha (+ ceph-3n) | 8 h |
| E1 Examen blanc (deux passages) + killer.sh (deux sessions) | — | kubernetes-ha ou kind | 8 h |
| Révision (flashcards des 13 fiches, quiz, checklists chronométrées) | — | — | 6 h |
| **Total** | | | **84 h** |

À 5 h par semaine, compter 17 semaines, soit trois cycles de `docs/roadmap.md` §7 (4 à 6 semaines par bloc).
Les sept fiches débutant (K1, K2, K3, K5, K6, K7 : 27 h) forment le socle `kubernetes_deb` partagé avec CKA et KCNA ;
si la cartographie CKA est traitée dans le même bloc, ces heures ne se comptent qu'une fois.
Ordre de passage retenu dans `docs/prerequis.md` §4 : CKA avant CKAD ; les fiches confirmé CKAD (K4, K8 à K13) se font
après le socle, l'examen CKAD se fixe à la fin du troisième cycle.

## 6. Ce que le lab ne couvre pas

- Rien n'est `[lecture + simulation]` : tout le programme CKAD tourne sur `kind` ou `kubernetes-ha` sans matériel particulier.
- L'environnement d'examen (bureau distant PSI, un seul onglet de documentation, `kubectl` déjà configuré avec plusieurs
  contextes) n'est pas reproduit à l'identique : `exams/ckad-01/setup.sh` crée les contextes et impose le minuteur, le
  navigateur unique reste une discipline personnelle. Les deux sessions killer.sh incluses dans l'inscription (`examen.md` §1)
  sont la seule répétition dans l'interface réelle : les garder pour les deux dernières semaines.
- La version Kubernetes du lab (`versions.yaml`, 1.37 au 2026-10-02) et celle de l'examen (1.37 annoncé le 2026-10-01)
  coïncident aujourd'hui ; l'examen suit la dernière mineure 4 à 8 semaines après sa sortie (`examen.md` §1), le lab
  suit Renovate. Vérifier l'écart à la veille avant chaque jalon et épingler `kind` sur l'image de la version d'examen.
- Ingress est enseigné (CKAD-05-03) sur l'implémentation Cilium, pas sur ingress-nginx (retiré, DECISIONS.md) : les
  annotations spécifiques à nginx (`rewrite-target`, etc.) sont citées en lecture seule dans K12 au cas où une tâche
  d'examen les suppose.

## 7. Veille : curriculum v1.37 publié le 2026-10-01

Le dépôt `cncf/curriculum` contient `CKAD_Curriculum_v1.37.pdf` (commit `f423fa4` du 2026-10-01, « Update CKAD to v1.37 + Add CKNE »)
à côté de `CKAD_Curriculum_v1.35.pdf` (commit du 2026-02-25). Le texte extrait des deux PDF est **identique** mot pour mot
(vérifié le 2026-10-02 avec `pdftotext`, diff vide) : mêmes cinq domaines, mêmes poids, mêmes 24 compétences.
Conséquences : les IDs `CKAD-DD-CC` de ce fichier restent valables ; seule l'en-tête `version` de `programme.md` est à passer
en 1.37 par le générateur à la prochaine veille (hors périmètre de cette PR, `CLAUDE.md` : `programme.md` n'est modifié que
par la tâche de veille). Le dépôt annonce aussi une nouvelle certification **CKNE** (Certified Kubernetes Network Engineer),
à évaluer pour `certifs/README.md` et le parcours Golden Kubestronaut lors de la même veille.
