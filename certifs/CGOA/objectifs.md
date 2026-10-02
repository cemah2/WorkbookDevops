---
code: CGOA
titre: "CGOA — mapping compétences → chapitres"
programme: "certifs/CGOA/programme.md (converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14)"
chapitres_existants: 3
generated: 2026-10-02
status: "3 chapitres rédigés (brouillons : 2 partagés avec CAPA, G1) ; 4 fiches CGOA à créer ; à mettre à jour à chaque PR de chapitre"
---

# CGOA — objectifs et couverture

Mapping entre les 25 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : trois fiches rédigées (brouillons) : vocabulaire et principes vus par Argo CD
(`fiches/gitops/01-argo-cd-fondamentaux.md`), lien CI / CD (`fiches/gitops/02-argo-workflows-fondamentaux.md`), et le
référentiel OpenGitOps lui-même (`fiches/gitops/08-opengitops-principes-et-vocabulaire.md`, G1). Le reste est un trou. Ce fichier sert de
plan de création ; chaque PR de chapitre remplit les colonnes
« chapitre » et « exercices » et marque le chapitre « rédigé » dans la section 4.

CGOA est **indépendant des outils** (le programme cite Argo CD et Flux comme exemples, pas comme objets d'examen).
Le workbook couvre donc le programme avec deux moteurs : Argo CD (chapitres partagés avec CAPA) et Flux (chapitres CGOA),
et consacre une fiche entière au référentiel OpenGitOps que l'examen suit mot pour mot (`examen.md` §1).

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Couverture actuelle | Chapitres à créer |
|---|---|---|---|---|---|
| CGOA-01 GitOps Terminology | 20 % | 9 | 2,2 % | 9 sur 9 (F1, G1, brouillons) | — (G1 rédigé) |
| CGOA-02 GitOps Principles | 30 % | 4 | 7,5 % | 4 sur 4 (F1, G1, brouillons) | G2 (côté Flux) |
| CGOA-03 Related Practices | 16 % | 4 | 4,0 % | 1 sur 4 (F3, brouillon) | G4, G5 |
| CGOA-04 GitOps Patterns | 20 % | 4 | 5,0 % | 0 sur 4 | G3 (+ CAPA F6, F7, S1) |
| CGOA-05 Tooling | 14 % | 4 | 3,5 % | 0 sur 4 | G2, G5 (+ CAPA F2) |
| Révision | — | 25 | — | — | R1 (quiz + examen blanc) |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle. Conséquence : une compétence « principe » (7,5 %) vaut plus de trois
compétences « terminologie » (2,2 %) ; la fiche G1 traite les deux ensemble parce que l'examen les évalue ensemble.

Ordre de rédaction recommandé (du plus lourd au plus léger, en respectant les prérequis et en entrelaçant les chapitres CAPA
du même bloc `gitops_conf`) :
G1 principes et vocabulaire → G2 Flux fondamentaux → CAPA F2 Argo CD Helm/Kustomize → G3 architectures et patrons →
G4 pratiques associées → G5 notifications, observabilité, CI → CAPA F6 Rollouts → CAPA F7 Events → CAPA S1 scénario → R1 révision.

Alerte programme : le dépôt `cncf/curriculum` contient, en plus du PDF à cinq domaines retranscrit dans `programme.md`,
un fichier `cgoa/README.md` (commit du 2025-11-28) qui annonce **quatre domaines à 25 %** (Fundamentals ;
Principles & Practices ; Tooling & Implementation ; Security & Observability). La page officielle de l'examen affichait
encore les cinq domaines dans les extraits consultés le 2026-10-02. Ce mapping suit le PDF ; la veille
(`prompts/07-veille.md`) doit trancher et, si le programme a changé, régénérer `programme.md` (voir `examen.md` §2).
Les cinq fiches ci-dessous couvrent les deux découpages : la sécurité est dans G4, l'observabilité dans G5.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre CGOA (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : les clés `argo_cd`, `argo_workflows`, `flux`, `helm`, `harbor`, `kyverno`, `opentofu`, `ansible`, `openbao`,
  `prometheus`, `grafana`, `kind` existent. À créer : `sops`, `age`, `cosign` (G4), `minio` ou réutilisation de Ceph RGW via `rook`
  (G2, même besoin que CAPA F4), `tofu_controller` (G4, variante). Passe par la veille ou par la PR du chapitre concerné.
- `labs/profiles/kubernetes-ha.yaml` : la liste `components` cite déjà `flux` et `argo_cd` ; ajouter `kyverno` quand G4 existera.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.2 (cette PR).
- Dépôt Git du lab : dépôt bare SSH sur `core-jump01` (DECISIONS.md, 2026-10-02). G1 a besoin d'y poser des hooks
  `pre-receive` (immutabilité) ; G3 et G5 ont besoin d'un hook `post-receive` (webhook). Aucun GitLab n'est requis avant CAPA S1.
- Pas de nouvelle décision à prendre : Helm 4, Gateway API Cilium et la numérotation des fiches s'appliquent.
  Les fiches CGOA prennent les numéros `08` à `12` à la suite des sept fiches CAPA, même pour les deux fiches débutant
  (DECISIONS.md, 2026-10-02 : un numéro attribué ne change plus, une insertion prend le numéro suivant).

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. « Chapitre cible » renvoie à la section 4 (G1 à G5)
ou à `certifs/CAPA/objectifs.md` §4 (F1 à F7, S1). Les sections des fiches sont notées S1, S2, S3.

### CGOA-01 — GitOps Terminology (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CGOA-01-01 | Continuous | 2,2 % | `fiches/gitops/08-opengitops-principes-et-vocabulaire.md` (brouillon) | S3 : concept, démo (deux rythmes, `timeout.reconciliation`), autonome 1-3, break-fix reconciliation-stalled, défi 10 min | G1 (rédigé), G2 (`interval` Flux) |
| CGOA-01-02 | Declarative Description | 2,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S2 : démo, autonome 1-3, break-fix repo-credentials, défi 10 min ; G1 S1 : grille, autonome 1-3, défi 10 min | F1, G1 (rédigés) |
| CGOA-01-03 | Desired State | 2,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S2 : démo, autonome 1-3, défi 10 min ; G1 S1 : grille, autonome 1-3 | F1, G1 (rédigés) |
| CGOA-01-04 | State Drift | 2,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S3 : démo (drift manuel, `argocd app diff`), autonome 1-3, break-fix app-degraded ; G1 S3 : démo (dérive vs commit), autonome 3 | F1, G1 (rédigés), G2 (drift côté Flux) |
| CGOA-01-05 | State Reconciliation | 2,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S3 : démo (`selfHeal`, `prune`), autonome 1-3, défi 10 min ; G1 S3 : démo, autonome 1-3 | F1, G1 (rédigés), G2 (`flux reconcile`) |
| CGOA-01-06 | GitOps Managed Software System | 2,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S1 : autonome 1-3 (composants), break-fix repo-server-down, défi 20 min ; G1 S1 : autonome 1-2 (trois parties sur le lab) | F1, G1 (rédigés) |
| CGOA-01-07 | State Store | 2,2 % | `fiches/gitops/08-opengitops-principes-et-vocabulaire.md` (brouillon) | S2 : démo (receive.deny*, clé lecture seule, reflog), autonome 1 (tableau de conformité), break-fix state-store-rewritten, défi 10 min | G1 (rédigé), G2 (OCI, Bucket) |
| CGOA-01-08 | Feedback Loop | 2,2 % | `fiches/gitops/08-opengitops-principes-et-vocabulaire.md` (brouillon) | S3 : concept (schéma), démo (conditions, événements, `argocd_app_info`), autonome 1-2 | G1 (rédigé), G5 (notifications, Prometheus) |
| CGOA-01-09 | Rollback | 2,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S3 : démo (`argocd app history` / `rollback`), autonome 3 ; G1 S2 : démo (revert), autonome 2, défi 10 min | F1, G1 (rédigés) |

### CGOA-02 — GitOps Principles (30 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CGOA-02-01 | Declarative | 7,5 % | `fiches/gitops/08-opengitops-principes-et-vocabulaire.md` (brouillon) | S1 : concept, grille (test 1), autonome 3, défi 10 min (textes A, B, C) | G1 (rédigé) |
| CGOA-02-02 | Versioned and Immutable | 7,5 % | `fiches/gitops/08-opengitops-principes-et-vocabulaire.md` (brouillon) | S1 : grille (test 2) ; S2 : démo complète, autonome 1-3 (option signature), break-fix, défi 10 min | G1 (rédigé) |
| CGOA-02-03 | Pulled Automatically | 7,5 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S3 : démo (`automated`, `selfHeal`), autonome 1-3 ; G1 S1 : grille (test 3), autonome 3, break-fix push-direct | F1, G1 (rédigés), G2 (Flux) |
| CGOA-02-04 | Continuously Reconciled | 7,5 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S3 : démo, autonome 1-3, défi 10 min ; G1 S1 : grille (test 4) ; G1 S3 : démo, autonome 1-3, break-fix | F1, G1 (rédigés), G2 (`interval`, `suspend`) |

### CGOA-03 — Related Practices (16 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CGOA-03-01 | Configuration as Code (CaC) | 4,0 % | — | — | G4 |
| CGOA-03-02 | Infrastructure as Code (IaC) | 4,0 % | — | — | G4 |
| CGOA-03-03 | DevOps and DevSecOps | 4,0 % | — | — | G4 |
| CGOA-03-04 | CI and CD | 4,0 % | `fiches/gitops/02-argo-workflows-fondamentaux.md` (brouillon) | S2 : démo, autonome 1-3, break-fix rbac, défi 10 min | F3 (rédigé), G5 (chaîne CI → dépôt de déploiement → CD) |

### CGOA-04 — GitOps Patterns (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CGOA-04-01 | Deployment and Release Patterns | 5,0 % | — | — | G3 (promotion d'environnements), F6 CAPA (rolling, blue-green, canary) |
| CGOA-04-02 | Progressive Delivery Patterns | 5,0 % | — | — | F6 CAPA (Argo Rollouts) ; Flagger en lecture dans G2 |
| CGOA-04-03 | Pull vs. Event-driven | 5,0 % | — | — | G3 (polling vs webhook, mesuré), F7 CAPA (Argo Events) |
| CGOA-04-04 | Architecture patterns (in-cluster and external reconciler, state store management, etc.) | 5,0 % | — | — | G3 ; F2 CAPA (app-of-apps, ApplicationSet) |

### CGOA-05 — Tooling (14 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CGOA-05-01 | Manifest Format and Packaging | 3,5 % | — | — | F2 CAPA (Helm, Kustomize dans Argo CD), G2 (`HelmRelease`, artefact OCI) |
| CGOA-05-02 | State Store Systems (Git and alternatives) | 3,5 % | — | — | G2 (Git, OCI, Bucket S3), G3 (gestion des dépôts) |
| CGOA-05-03 | Reconciliation Engines (ArgoCD, Flux, and alternatives) | 3,5 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon, Argo CD seul) | S1 : autonome 1-3 | F1 (rédigé), G2 (Flux, comparatif, alternatives en lecture) |
| CGOA-05-04 | Interoperability with Notifications, Observability, and Continuous Integration Tools | 3,5 % | — | — | G5 |

### Compétences partagées avec CAPA

CAPA et CGOA se passent dans le même bloc (`docs/prerequis.md`, parcours Golden Kubestronaut, jalon `gitops_conf`).
Les chapitres CAPA ci-dessous citent les deux programmes dans leur front matter ; les IDs CGOA de F1 et F3,
annoncés « à confirmer par la cartographie CGOA », sont confirmés par ce fichier.

| Chapitre CAPA | Statut | IDs CGOA couverts |
|---|---|---|
| F1 `fiches/gitops/01-argo-cd-fondamentaux.md` | rédigé (brouillon) | CGOA-01-02, 01-03, 01-04, 01-05, 01-06, 01-09, 02-03, 02-04, 05-03 (Argo CD) |
| F3 `fiches/gitops/02-argo-workflows-fondamentaux.md` | rédigé (brouillon) | CGOA-03-04 |
| F2 `fiches/gitops/04-argo-cd-helm-kustomize-reconciliation.md` | planifié | CGOA-04-04, 05-01, 05-02 |
| F6 `fiches/gitops/05-argo-rollouts.md` | planifié | CGOA-04-01, 04-02 |
| F7 `fiches/gitops/07-argo-events.md` | planifié | CGOA-04-03 |
| S1 `scenarios/NN-chaine-argo-bout-en-bout/` | planifié | CGOA-04-01 à 04-04 en situation |

Inversement, les fiches CGOA G2 à G5 citent des IDs CAPA quand elles reprennent un objet Argo (G3 : CAPA-02-05 ;
G5 : CAPA-02-02 pour les notifications Argo CD).

## 4. Trous et chapitres à créer

Les fiches sont numérotées `08` à `12` dans l'ordre de lecture recommandé. Les deux fiches débutant (G1, G2) ont pour
chemin principal un cluster `kind` sur une VM du profil `linux-base` (8 vCPU / 16 Go / 180 Go), comme F1 et F3, et gardent
`kubernetes-ha` (16 vCPU / 48 Go / 300 Go) en variante ; les fiches confirmé attendent le profil complet.
Git du lab : dépôt bare SSH sur `core-jump01` derrière `git.lab.home.arpa`. Les durées sont des estimations
d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.

### G1 — `fiches/gitops/08-opengitops-principes-et-vocabulaire.md` — rédigé (brouillon, 2026-10-02)

- **Titre** : OpenGitOps — les quatre principes et le vocabulaire, prouvés sur le lab
- **Niveau** : débutant (`gitops_deb`)
- **Couvre** : CGOA-01-01, 01-06, 01-07, 01-08, 02-01, 02-02 ; consolide CGOA-01-02 à 01-05, 01-09, 02-03, 02-04 (vus en F1)
- **Prérequis** : F1 (Argo CD installé, dépôt du lab joignable), `gitops_deb` ; `iac_deb` recommandé (Git : branches, revert, tags)
- **Lab** : `kind` sur `linux-base` (réutilise le cluster de F1), variante `kubernetes-ha`. Clés `versions.yaml` : `argo_cd`, `kind`.
  Source de référence : `PRINCIPLES.md` et `GLOSSARY.md` du dépôt `open-gitops/documents`, version `v1.0.0` (lue en anglais :
  l'examen reprend ces définitions).
- **Plan validé** : `docs/plans/gitops-08-opengitops-principes-et-vocabulaire.md` (2026-10-02).
- **Temps** : 4 h
- **3 exercices clés** :
  1. Audit de conformité : un pipeline qui fait `kubectl apply` depuis la CI (push) et une `Application` Argo CD (pull) déploient
     la même app ; remplir une grille « principe → preuve observée » pour les deux (déclaratif, versionné et immuable, tiré
     automatiquement, réconcilié en continu) et expliquer en une phrase par principe ce que le push ne garantit pas — CGOA-02-01 à 02-04.
  2. State store immuable : sur le dépôt bare du lab, activer `receive.denyNonFastForwards` et `receive.denyDeletes`,
     tenter un `push --force`, puis comparer `git revert` (nouveau commit, historique complet) et `argocd app rollback`
     (état vivant seulement) ; rédiger la règle « un rollback GitOps est un commit » — CGOA-01-07, 01-09, 02-02.
  3. Boucle de contrôle : modifier `timeout.reconciliation` d'Argo CD, mesurer le délai de détection d'un drift à 3 min,
     30 s et avec `selfHeal` ; schématiser (Mermaid) la boucle état désiré → agent → état réel → retour d'information ;
     écrire le glossaire des neuf termes CGOA-01 avec ses propres mots, puis les comparer au glossaire OpenGitOps — CGOA-01-01, 01-06,
     01-08.
- **Break-fix** : `break/gitops/08-gitops-push-direct.sh` (un CronJob « de la CI » réapplique un manifest obsolète par `kubectl`
  toutes les minutes ; l'Application oscille entre `Synced` et `OutOfSync` ; trouver le push caché, pas seulement activer `selfHeal`).
- **Défi chronométré** : à partir d'une description libre d'un système (texte de 10 lignes), lister les violations des quatre
  principes et proposer la correction, en moins de 10 min, puis vérifier avec la grille de l'exercice 1.

### G2 — `fiches/gitops/09-flux-fondamentaux.md`

- **Titre** : Flux — un second moteur de réconciliation, trois magasins d'état
- **Niveau** : débutant (`gitops_deb`)
- **Couvre** : CGOA-05-03, 05-02, 05-01, 01-05, 01-07, 02-03, 02-04 ; CGOA-04-02 en lecture (Flagger)
- **Prérequis** : F1 (comparaison avec Argo CD), `kubernetes_deb` ; G1 recommandé ; `ceph_deb` recommandé pour le `Bucket` sur RGW, sinon
  MinIO
- **Lab** : `kind` sur `linux-base` (chemin principal), variante `kubernetes-ha` + `ceph-3n`. Clés `versions.yaml` : `flux`, `kind`,
  `kubernetes`, `helm` ; `harbor` sur la variante (registre OCI), `minio` ou `rook` (à créer) pour le `Bucket`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer Flux à la version `flux` de `versions.yaml` (`flux install` depuis un manifest versionné, pas `bootstrap` sur un
     dépôt qu'on ne contrôle pas), déclarer `GitRepository` + `Kustomization` vers le dépôt du lab, lire `flux get all`,
     `flux reconcile`, `flux suspend` / `resume`, provoquer un drift et observer `prune` et la réparation — CGOA-05-03, 01-05, 02-03, 02-04.
  2. Le même état désiré depuis trois magasins : `GitRepository`, `OCIRepository` (`flux push artifact` vers un registre local
     ou Harbor), `Bucket` (MinIO ou RGW) ; puis `HelmRepository` + `HelmRelease` avec `values` et `dependsOn` ;
     tableau « magasin → immutabilité, versionnage, contrôle d'accès, audit » — CGOA-05-01, 05-02, 01-07.
  3. Comparatif Argo CD / Flux sur la même application : modèle d'objets, intervalle, détection de drift, `prune`, santé,
     ordonnancement (`dependsOn` vs sync waves), multi-tenant ; en lecture : Flagger (livraison progressive côté Flux) et un
     tour des alternatives citées par les programmes (Rancher Fleet, kapp-controller, Kluctl, Jenkins X, PipeCD) — CGOA-05-03, 04-02.
- **Break-fix** : `break/gitops/09-flux-source-not-ready.sh` (secret de dépôt renommé : `GitRepository` `Ready=False`,
  `Kustomization` figée sur la dernière révision saine ; lire `flux events` et `flux logs`).
- **Défi chronométré** : du cluster vierge à une `Kustomization` `Ready` qui déploie l'app du lab depuis un artefact OCI,
  en moins de 15 min.

### G3 — `fiches/gitops/10-architectures-gitops-depots-reconciliateurs.md`

- **Titre** : Architectures GitOps — réconciliateur interne ou externe, organisation des dépôts, pull ou événement
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CGOA-04-04, 04-03, 04-01, 01-07, 05-02 ; CAPA-02-05 (ApplicationSet, cluster distant)
- **Prérequis** : G2, F2 CAPA (app-of-apps, ApplicationSet), `kubernetes_conf` (RBAC, kubeconfig multi-clusters)
- **Lab** : `kubernetes-ha` (hub) + un cluster `kind` sur `linux-base` (spoke) ; combinaison autorisée. Clés `versions.yaml` :
  `argo_cd`, `flux`, `kind`, `harbor`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Réconciliateur externe vs interne : Argo CD sur le hub gère le spoke (`argocd cluster add`, `ApplicationSet` générateur
     `cluster`) ; Flux installé dans le spoke se gère seul ; couper le hub, couper le réseau entre les deux, comparer ce qui
     continue de se réconcilier ; tableau des compromis (rayon d'impact, identifiants, bootstrap, mise à l'échelle) — CGOA-04-04.
  2. Gestion du magasin d'état : mono-dépôt vs multi-dépôts (app / config / infra), dossier par environnement vs branche par
     environnement, promotion `dev` → `staging` → `prod` par PR et par tag d'image, dépôt de déploiement séparé du dépôt applicatif ;
     écrire la convention du lab et la justifier — CGOA-04-01, 01-07, 05-02.
  3. Pull vs piloté par événement : mesurer le délai commit → déploiement en polling (3 min Argo CD, `interval` Flux) puis avec un
     hook `post-receive` du dépôt bare qui appelle `/api/webhook` d'Argo CD et un `Receiver` Flux ; comparer avec un déclenchement
     par image (`ImageRepository` / `ImagePolicy` / `ImageUpdateAutomation` Flux) ; expliquer pourquoi l'événement n'enlève pas le pull —
     CGOA-04-03.
- **Break-fix** : `break/gitops/10-argocd-cluster-secret-invalid.sh` (token du spoke révoqué : `ApplicationSet` génère des
  Applications `Unknown`, Flux du spoke continue ; diagnostiquer où est le réconciliateur).
- **Défi chronométré** : promouvoir une version de `staging` à `prod` par PR, webhook actif, sync vérifiée sur le spoke,
  en moins de 15 min.

### G4 — `fiches/gitops/11-pratiques-associees-iac-cac-devsecops.md`

- **Titre** : Pratiques associées — IaC, configuration as code et DevSecOps pilotés par Git
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CGOA-03-01, 03-02, 03-03 ; CGOA-03-04 en situation
- **Prérequis** : G2, F3 (un Workflow exécute OpenTofu), `iac_deb` (OpenTofu et Ansible : init, plan, apply, playbook),
  `kubernetes_conf` ; `securite_deb` recommandé (politiques d'admission, signature d'images)
- **Lab** : `kubernetes-ha` (+ accès API Proxmox pour l'exercice 1). Clés `versions.yaml` : `opentofu`, `ansible`, `kyverno`,
  `openbao`, `argo_workflows`, `flux` ; à créer : `sops`, `age`, `cosign`, `tofu_controller` (variante).
- **Temps** : 6 h
- **3 exercices clés** :
  1. IaC par Git : un `CronWorkflow` Argo (ou `tofu-controller` en variante) exécute `tofu plan` sur le dépôt `infra/` à chaque commit,
     poste le plan en commentaire de PR, applique après fusion ; état distant dans un bucket RGW ou MinIO, drift détecté par
     `tofu plan -detailed-exitcode` planifié ; dire où l'IaC s'arrête et où GitOps commence — CGOA-03-02.
  2. CaC : la configuration des VM (Ansible, `--check --diff` planifié) et celle des applications (ConfigMaps via Kustomize,
     `configMapGenerator` et hachage de nom) ; provoquer un drift des deux côtés et comparer réconciliation continue (Kustomize)
     et exécution planifiée (Ansible) — CGOA-03-01.
  3. DevSecOps dans la chaîne : politiques Kyverno versionnées dans le dépôt GitOps (`ClusterPolicy` qui refuse les images non
     signées), signature `cosign` dans le Workflow de build, secrets chiffrés `sops` + `age` déchiffrés par Flux
     (`decryption.provider: sops`) avec OpenBao comme alternative (lecture), revue de PR comme contrôle d'accès au magasin d'état —
     CGOA-03-03.
- **Break-fix** : `break/gitops/11-kyverno-policy-blocks-sync.sh` (une politique `Enforce` poussée par Git bloque la
  synchronisation de l'application elle-même ; lire `argocd app get` / `flux events`, corriger par Git sans désactiver la politique).
- **Défi chronométré** : chiffrer un secret avec `sops`, le pousser, obtenir le `Secret` déchiffré dans le cluster par Flux,
  en moins de 10 min.

### G5 — `fiches/gitops/12-notifications-observabilite-ci.md`

- **Titre** : Fermer la boucle — notifications, métriques et intégration CI des moteurs GitOps
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CGOA-05-04, 01-08, 03-04 ; CAPA-02-02 (notifications Argo CD)
- **Prérequis** : G2, F3 (pipeline CI avec Argo Workflows), `observabilite_deb` (Prometheus installé, PromQL de base), `kubernetes_conf`
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `argo_cd`, `flux`, `argo_workflows`, `prometheus`, `grafana`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Notifications : `argocd-notifications-cm` (triggers, templates, service `webhook`) et Flux `Provider` + `Alert`
     (`generic` webhook, `alertmanager`) vers un récepteur du lab ; filtrer par sévérité ; comparer avec un `Provider` de type
     commit status (lecture : nécessite GitLab / GitHub) — CGOA-05-04, 01-08.
  2. Observabilité : scraper `argocd-metrics` et les métriques `gotk_*` de Flux dans Prometheus, importer les tableaux de bord
     officiels dans Grafana, écrire deux alertes (`argocd_app_info{sync_status="OutOfSync"}` depuis 15 min,
     `gotk_reconcile_condition{status="False"}`) et les déclencher par un drift — CGOA-05-04, 01-08.
  3. Intégration CI : le Workflow de F3 construit une image, met à jour le tag dans le dépôt de déploiement (commit en retour),
     Argo CD / Flux déploient ; en pré-fusion, un Workflow vérifie `kustomize build`, `kubeconform`, `argocd app diff --local`
     ou `flux diff kustomization` ; expliquer la frontière CI (construit, teste) / CD GitOps (réconcilie) — CGOA-03-04, 05-04.
- **Break-fix** : `break/gitops/12-notifications-silent.sh` (secret du webhook vidé : les sync échouent sans aucune alerte ;
  retrouver la panne par les métriques avant de retrouver la cause dans les logs du contrôleur de notifications).
- **Défi chronométré** : du drift injecté à l'alerte reçue sur le récepteur du lab, avec la métrique qui le prouve, en moins de 10 min.

### R1 — `revision/quiz/cgoa.md` et `exams/cgoa-blanc/`

- **Titre** : CGOA — quiz par domaine et examen blanc à 90 min
- **Niveau** : révision (après G1 à G5 et F1, F2, F3)
- **Couvre** : les 25 compétences ; produit par `prompts/06-examen-blanc.md`, pas par un chapitre
- **Lab** : aucun (QCM sur papier ou dans le navigateur, sans documentation, comme à l'examen)
- **Temps** : 5 h (deux passages à ≥ 80 % avant de réserver l'examen)
- **Contenu** : 60 questions pondérées comme les domaines (12 terminologie, 18 principes, 10 pratiques, 12 patrons, 8 outillage),
  réponses justifiées par une citation du glossaire OpenGitOps ou du programme, flashcards des cinq fiches fusionnées
  (`revision/flashcards/gitops-08-*.csv` à `gitops-12-*.csv`).

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| G1 OpenGitOps principes et vocabulaire (rédigé, brouillon) | débutant | linux-base (kind) ou kubernetes-ha | 4 h |
| G2 Flux fondamentaux | débutant | linux-base (kind) ou kubernetes-ha + ceph-3n | 5 h |
| G3 Architectures GitOps | confirmé | kubernetes-ha + linux-base (kind) | 6 h |
| G4 Pratiques associées IaC / CaC / DevSecOps | confirmé | kubernetes-ha | 6 h |
| G5 Notifications, observabilité, CI | confirmé | kubernetes-ha | 5 h |
| R1 Quiz et examen blanc | révision | — | 5 h |
| **Total spécifique CGOA** | | | **31 h** |
| Partagé avec CAPA : F1, F3 (rédigés), F2, F6, F7, S1 (planifiés) | déb. → exp. | voir `certifs/CAPA/objectifs.md` §5 | 34 h (comptées dans CAPA) |

À 5 h par semaine, compter 6 à 7 semaines pour la part spécifique CGOA. Le bloc CGOA + CAPA complet (31 h + 51 h) tient
sur deux cycles de `docs/roadmap.md` §7 ; passer CGOA d'abord (plus conceptuel, 50 % des points sur le vocabulaire et les
principes), CAPA à la fin du second cycle.

## 6. Ce que le lab ne couvre pas

- Rien n'est `[lecture + simulation]` au sens matériel : Argo CD, Flux, Kyverno, OpenTofu et Prometheus tournent sur
  `kubernetes-ha` ou sur `kind`.
- Magasins d'état et fournisseurs Git hébergés (GitHub, GitLab.com, statuts de commit, règles de protection de branche SaaS) :
  remplacés par le dépôt bare du lab et ses hooks ; les noms des fonctions SaaS sont à connaître pour le QCM
  (section « à connaître pour l'examen » de G1 et G5, lecture seule).
- Alternatives aux deux moteurs (Rancher Fleet, kapp-controller, Kluctl, Jenkins X, PipeCD, Weave GitOps) : lecture seule
  dans G2, pas d'installation.
- Flagger et les feature flags : lecture seule ; la livraison progressive est pratiquée avec Argo Rollouts (CAPA F6).
- L'examen est un QCM sans documentation (`examen.md`) : les flashcards de chaque fiche et R1 sont la préparation
  directe, les manipulations servent la rétention.
