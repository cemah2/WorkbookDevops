---
code: CAPA
titre: "CAPA — mapping compétences → chapitres"
programme: "certifs/CAPA/programme.md (converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14)"
chapitres_existants: 2
generated: 2026-10-02
status: "2 chapitres rédigés (brouillons) sur 8 ; à mettre à jour à chaque PR de chapitre"
---

# CAPA — objectifs et couverture

Mapping entre les 16 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : une fiche rédigée (`fiches/gitops/01-argo-cd-fondamentaux.md`, statut brouillon),
les sept autres chapitres sont des trous. Ce fichier sert de plan de création ; chaque PR de chapitre
remplit les colonnes « chapitre » et « exercices » et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| CAPA-01 Argo Workflows | 36 % | 6 | 6,0 % | 3 fiches |
| CAPA-02 Argo CD | 34 % | 5 | 6,8 % | 2 fiches |
| CAPA-03 Argo Rollouts | 18 % | 3 | 6,0 % | 1 fiche |
| CAPA-04 Argo Events | 12 % | 2 | 6,0 % | 1 fiche |
| Transverse | — | 16 | — | 1 scénario |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle.

Ordre de rédaction recommandé (du plus lourd au plus léger, en respectant les prérequis) :
Argo CD fondamentaux → Argo Workflows fondamentaux → Argo Workflows artefacts/templates/DAG →
Argo CD Helm/Kustomize/réconciliation → Argo Rollouts → Argo Workflows traitement de données →
Argo Events → scénario de bout en bout.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : les clés `argo_cd` et `argo_workflows` existent (la seconde depuis la PR de F3). Ajouter `argo_rollouts`, `argo_events`
  (dépôts `argoproj/argo-workflows`, `argoproj/argo-rollouts`, `argoproj/argo-events`, datasource `github-releases`)
  et une clé pour le dépôt d'artefacts S3 des Workflows (`minio`, ou réutiliser Ceph RGW via `rook`).
  Passe par la veille (`prompts/07-veille.md`) ou par la PR du chapitre concerné.
- `labs/profiles/kubernetes-ha.yaml` : la liste `components` cite `argo_cd` ; ajouter les trois autres clés une fois créées.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6 (cette PR).
- Pas de nouvelle décision à prendre : Gateway API (DECISIONS.md, 2026-10-02) s'applique au routage de trafic
  d'Argo Rollouts ; Helm 4 s'applique aux sources Helm d'Argo CD.

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. La colonne « chapitre cible » renvoie à la section 4.

### CAPA-01 — Argo Workflows (36 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CAPA-01-01 | Understand Argo Workflow Fundamentals | 6,0 % | `fiches/gitops/02-argo-workflows-fondamentaux.md` (brouillon) | S1 : démo, autonome 1-3, break-fix controller-down, défi 15 min ; S3 : break-fix image-pull et quota | F3 (rédigé) |
| CAPA-01-02 | Generating and Consuming Artifacts | 6,0 % | — | — | F4 |
| CAPA-01-03 | Understand Argo Workflow Templates | 6,0 % | — | — | F4 |
| CAPA-01-04 | Understand the Argo Workflow Spec | 6,0 % | `fiches/gitops/02-argo-workflows-fondamentaux.md` (brouillon) | S2 : démo, autonome 1-3, break-fix rbac, défi 10 min ; S3 : démo, autonome 1-3, défi 10 min | F3 (rédigé) |
| CAPA-01-05 | Work with DAG (Directed-Acyclic Graphs) | 6,0 % | — | — | F4 |
| CAPA-01-06 | Run Data Processing Jobs with Argo Workflows | 6,0 % | — | — | F5 |

### CAPA-02 — Argo CD (34 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CAPA-02-01 | Understand Argo CD Fundamentals | 6,8 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S1 : démo, autonome 1-3, break-fix repo-server-down, défi 20 min | F1 (rédigé) |
| CAPA-02-02 | Synchronize Applications Using Argo CD | 6,8 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S3 : démo, autonome 1-3, break-fix app-degraded, défi 10 min | F1 (rédigé) |
| CAPA-02-03 | Use Argo CD Application | 6,8 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S2 : démo, autonome 1-3, break-fix repo-credentials et destination-forbidden, défi 10 min | F1 (rédigé) |
| CAPA-02-04 | Configure Argo CD with Helm and Kustomize | 6,8 % | — | — | F2 |
| CAPA-02-05 | Identify Common Reconciliation Patterns | 6,8 % | — | — | F2 |

### CAPA-03 — Argo Rollouts (18 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CAPA-03-01 | Understand Argo Rollouts Fundamentals | 6,0 % | — | — | F6 |
| CAPA-03-02 | Use Common Progressive Rollout Strategies | 6,0 % | — | — | F6 |
| CAPA-03-03 | Describe Analysis Template and AnalysisRun | 6,0 % | — | — | F6 |

### CAPA-04 — Argo Events (12 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CAPA-04-01 | Understand Argo Events Fundamentals | 6,0 % | — | — | F7 |
| CAPA-04-02 | Understand Argo Event Components and Architecture | 6,0 % | — | — | F7 |

### Compétences partagées avec CGOA

CAPA et CGOA se passent dans le même bloc (`docs/prerequis.md`, parcours Golden Kubestronaut, jalon `gitops_conf`).
Les chapitres ci-dessous citent les deux programmes dans leur front matter pour éviter un doublon.

| Chapitre | IDs CAPA | IDs CGOA réutilisables |
|---|---|---|
| F1 Argo CD fondamentaux | CAPA-02-01, 02-02, 02-03 | CGOA-01-02, 01-03, 01-04, 01-05, 01-06, 01-09, 02-03, 02-04 |
| F2 Argo CD Helm/Kustomize/réconciliation | CAPA-02-04, 02-05 | CGOA-04-04, 05-01, 05-02 |
| F6 Argo Rollouts | CAPA-03-01 à 03-03 | CGOA-04-01, 04-02 |
| F7 Argo Events | CAPA-04-01, 04-02 | CGOA-04-03 |

Le mapping CGOA complet est dans `certifs/CGOA/objectifs.md` (2026-10-02) ; il confirme les IDs ci-dessus et y ajoute CGOA-05-03 pour F1.

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de rédaction recommandé (DECISIONS.md, 2026-10-02).
Tous les chapitres ciblent le profil `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`).
Tant que `lab up kubernetes-ha` n'existe pas, les fiches **débutant** ont pour chemin principal un cluster `kind`
sur une VM du profil `linux-base` (8 vCPU / 16 Go / 180 Go) et gardent `kubernetes-ha` en variante ; les fiches
confirmé attendent le profil complet. Git du lab : dépôt bare SSH sur `core-jump01` derrière `git.lab.home.arpa`
(DECISIONS.md, 2026-10-02). Gateway API : Cilium par défaut (DECISIONS.md, 2026-10-02).
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.

### F1 — `fiches/gitops/01-argo-cd-fondamentaux.md` — rédigé (brouillon, 2026-10-02)

- **Titre** : Argo CD — installer, déclarer une Application, synchroniser
- **Niveau** : débutant (`gitops_deb`)
- **Couvre** : CAPA-02-01, CAPA-02-02, CAPA-02-03
- **Prérequis** : `kubernetes_deb` (kubectl, Deployments, namespaces), `iac_deb` (Git, dépôt bare SSH du lab sur `core-jump01`)
- **Lab** : `kind` sur `linux-base` (chemin principal tant que le profil n'est pas levé), variante `kubernetes-ha`.
  Clés `versions.yaml` : `argo_cd`, `kind`, `cilium`, `cert_manager`.
- **Plan validé** : `docs/plans/gitops-01-argo-cd-fondamentaux.md` (2026-10-02).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer Argo CD (manifests officiels de la version `argo_cd`), exposer l'UI via Gateway API, se connecter avec `argocd` CLI,
     créer un projet et une Application pointant vers un dépôt du lab — CAPA-02-01, CAPA-02-03.
  2. Comparer sync manuelle / automatique, `prune`, `selfHeal` : modifier une ressource à la main, observer `OutOfSync`,
     corriger le drift dans les deux sens — CAPA-02-02.
  3. Lire l'arbre de ressources, les états `health` et `sync`, revenir à un commit précédent (`argocd app history` / `rollback`),
     diagnostiquer une Application `Degraded` — CAPA-02-02, CAPA-02-03.
- **Break-fix** : `break/gitops/01-argocd-repo-credentials.sh` (secret de dépôt cassé → `ComparisonError`).
- **Défi chronométré** : déployer une app depuis un dépôt vierge en moins de 10 min.

### F2 — `fiches/gitops/04-argo-cd-helm-kustomize-reconciliation.md`

- **Titre** : Argo CD — sources Helm et Kustomize, patterns de réconciliation
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CAPA-02-04, CAPA-02-05
- **Prérequis** : F1, `kubernetes_conf` (Helm 4, Kustomize, RBAC)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `argo_cd`, `helm`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Déployer la même application en source Helm (valeurs inline, `valueFiles`, dépôt OCI sur Harbor) puis en Kustomize
     (overlays `dev`/`prod`, `images`, `namePrefix`) ; expliquer ce qu'Argo CD rend et comment (`argocd app manifests`) — CAPA-02-04.
  2. Mettre en œuvre app-of-apps puis un `ApplicationSet` (générateurs `list`, `git directories`, `cluster`), avec sync waves,
     hooks `PreSync`/`PostSync`, `ignoreDifferences` et `syncOptions` (`CreateNamespace`, `ServerSideApply`, `Replace`) — CAPA-02-05.
  3. Diagnostiquer les patterns de réconciliation : drift permanent (HPA vs replicas), boucle de sync due à un webhook mutant,
     `ComparisonError` sur un CRD manquant, timeouts de refresh ; mesurer l'effet de `timeout.reconciliation` — CAPA-02-05.
- **Break-fix** : `break/gitops/04-argocd-sync-loop.sh` (champ muté par un contrôleur, Application jamais `Synced`).
- **Défi chronométré** : passer une app Kustomize de `dev` à `prod` par PR, sync vérifiée, en moins de 15 min.

### F3 — `fiches/gitops/02-argo-workflows-fondamentaux.md` — rédigé (brouillon, 2026-10-02)

- **Titre** : Argo Workflows — installer, écrire et lancer un premier workflow
- **Niveau** : débutant (`gitops_deb`)
- **Couvre** : CAPA-01-01, CAPA-01-04
- **Prérequis** : `kubernetes_deb` (Pods, Jobs, ServiceAccount, RBAC de base)
- **Lab** : `kind` sur `linux-base` (chemin principal), variante `kubernetes-ha`.
  Clés `versions.yaml` : `argo_workflows`, `kind`, `cilium`, `cert_manager`.
- **Plan validé** : `docs/plans/gitops-02-argo-workflows-fondamentaux.md` (2026-10-02).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer le contrôleur et le serveur Argo Workflows, configurer `argo` CLI, lancer `hello-world`, lire les logs,
     comprendre les composants (controller, server, executor emissary, archive) — CAPA-01-01.
  2. Écrire un `Workflow` avec `entrypoint`, `templates` `container`, `script`, `resource`, `suspend`, et `steps`
     séquentiels / parallèles ; passer des `parameters` d'entrée et de sortie — CAPA-01-04.
  3. Ajouter `retryStrategy`, `activeDeadlineSeconds`, `ttlStrategy`, `podGC`, limites de ressources, ServiceAccount dédié ;
     observer l'effet de chaque champ avec `argo get` et `kubectl get pods` — CAPA-01-04.
- **Break-fix** : `break/gitops/02-argo-workflows-rbac.sh` (ServiceAccount sans droit `workflowtaskresults`, nœuds en `Error`),
  `02-argo-workflows-controller-down.sh`, `02-argo-workflows-image-pull.sh`, `02-argo-workflows-quota.sh` (optionnel).
- **Défi chronométré** : écrire et faire passer un workflow à trois étapes avec paramètres en moins de 10 min.

### F4 — `fiches/gitops/03-argo-workflows-artefacts-templates-dag.md`

- **Titre** : Argo Workflows — artefacts, WorkflowTemplate et DAG
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CAPA-01-02, CAPA-01-03, CAPA-01-05
- **Prérequis** : F3 ; `ceph_deb` recommandé (bucket S3 via Ceph RGW), sinon MinIO
- **Lab** : `kubernetes-ha` + `ceph-3n` (combinaison autorisée, `labs/profiles/README.md`) ou MinIO sur le cluster.
  Clés `versions.yaml` : `argo_workflows` (à créer), `rook` ou `minio` (à créer).
- **Temps** : 7 h
- **3 exercices clés** :
  1. Configurer un dépôt d'artefacts S3 (`artifactRepositoryRef`, secret d'accès), produire un artefact dans une étape,
     le consommer dans la suivante, archiver un `output` ; comparer artefacts, paramètres et volumes partagés — CAPA-01-02.
  2. Factoriser en `WorkflowTemplate` et `ClusterWorkflowTemplate`, les appeler via `templateRef` et `workflowTemplateRef`,
     planifier un `CronWorkflow` avec `concurrencyPolicy` — CAPA-01-03.
  3. Réécrire un enchaînement `steps` en `dag` : `dependencies`, expression `depends` (`A.Succeeded && !B.Failed`),
     `continueOn`, `failFast`, cible `--entrypoint` partielle ; visualiser le graphe dans l'UI — CAPA-01-05.
- **Break-fix** : `break/gitops/03-argo-workflows-artifact-repo.sh` (clé S3 invalide, étape bloquée en `Pending` puis `Error`).
- **Défi chronométré** : transformer un workflow linéaire de 4 étapes en DAG à 2 branches parallèles avec artefact partagé,
  en moins de 15 min.

### F5 — `fiches/gitops/06-argo-workflows-traitement-de-donnees.md`

- **Titre** : Argo Workflows — traitement de données en parallèle
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CAPA-01-06
- **Prérequis** : F4
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `argo_workflows` (à créer), `prometheus` (métriques du contrôleur).
- **Temps** : 4 h
- **3 exercices clés** :
  1. Fan-out / fan-in avec `withItems`, `withParam` (liste JSON produite par une étape), `withSequence`, agrégation des sorties
     (`{{steps.x.outputs.parameters}}`) — CAPA-01-06.
  2. Contrôler la charge : `parallelism` par workflow et par template, `synchronization` (mutex, sémaphore ConfigMap),
     `memoize` sur une étape coûteuse, `volumeClaimTemplates` pour un espace de travail partagé — CAPA-01-06.
  3. Lancer un lot de 50 fichiers (découpage → traitement → fusion), mesurer la durée selon `parallelism`,
     lire les métriques du contrôleur dans Prometheus, archiver les workflows terminés — CAPA-01-06.
- **Break-fix** : `break/gitops/06-argo-workflows-parallelism.sh` (sémaphore à 0, lot figé en `Pending`).
- **Défi chronométré** : traiter 20 éléments en parallèle avec agrégation finale en moins de 12 min.

### F6 — `fiches/gitops/05-argo-rollouts.md`

- **Titre** : Argo Rollouts — canary, blue-green et analyse automatisée
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CAPA-03-01, CAPA-03-02, CAPA-03-03
- **Prérequis** : F1 ; `observabilite_deb` (Prometheus installé, PromQL de base) ; `kubernetes_conf` (Gateway API)
- **Lab** : `kubernetes-ha` (Gateway API Cilium par défaut, Envoy Gateway en variante justifiée, Prometheus). Clés `versions.yaml` :
  `argo_rollouts` (à créer), `argo_cd`, `prometheus`, `cilium`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Convertir un `Deployment` en `Rollout`, installer le plugin `kubectl argo rollouts`, suivre `get rollout --watch`,
     `promote`, `abort`, `undo`, comprendre ReplicaSets stable/canary — CAPA-03-01.
  2. Stratégie canary avec `steps` (`setWeight`, `pause`), routage de trafic par Gateway API (plugin), puis blue-green
     (`activeService`, `previewService`, `autoPromotionEnabled`, `scaleDownDelaySeconds`) — CAPA-03-02.
  3. Écrire un `AnalysisTemplate` Prometheus (taux d'erreur), l'attacher en `analysis` de step et en `backgroundAnalysis`,
     provoquer un échec d'`AnalysisRun` et observer le rollback automatique ; comparer avec un `Experiment` — CAPA-03-03.
- **Break-fix** : `break/gitops/05-argo-rollouts-analysis-fail.sh` (requête PromQL qui échoue toujours, Rollout `Degraded`).
- **Défi chronométré** : publier une nouvelle image en canary 20 % → 50 % → 100 % avec analyse en moins de 15 min.

### F7 — `fiches/gitops/07-argo-events.md`

- **Titre** : Argo Events — EventBus, EventSource, Sensor
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CAPA-04-01, CAPA-04-02
- **Prérequis** : F3 (les triggers lancent des Workflows), `kubernetes_conf` (RBAC, Services)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `argo_events` (à créer), `argo_workflows` (à créer).
- **Temps** : 4 h
- **3 exercices clés** :
  1. Installer Argo Events, déployer un `EventBus` JetStream, un `EventSource` `webhook` et `calendar`, un `Sensor`
     avec trigger `k8s` ; déclencher par `curl` et lire les événements CloudEvents — CAPA-04-01.
  2. Trigger `argoWorkflow` avec paramétrage depuis le payload (`parameters`, `dataKey`), filtres `data`/`time`/`expr`,
     `dependencies` multiples et logique de déclenchement — CAPA-04-02.
  3. Schématiser l'architecture (EventSource → EventBus → Sensor → trigger) en Mermaid, mesurer la résilience :
     tuer le pod EventBus, observer la reprise ; comparer avec un `EventSource` `minio`/`resource` — CAPA-04-02.
- **Break-fix** : `break/gitops/07-argo-events-eventbus-down.sh` (EventBus absent, Sensor en `Pending`, aucun trigger).
- **Défi chronométré** : du webhook au Workflow déclenché avec un paramètre extrait du payload en moins de 10 min.

### S1 — `scenarios/NN-chaine-argo-bout-en-bout/README.md`

- **Titre** : NN — Du commit au canary : chaîne Argo complète sur le lab (numéro `NN` attribué à la création)
- **Niveau** : expert (`gitops_exp`) ; prérequis F1 à F7 complets, pas de saut direct
- **Couvre** : les 16 compétences CAPA en situation, plus CGOA-04-01 à 04-04
- **Lab** : `kubernetes-ha` + `ceph-3n` (RGW pour les artefacts), Harbor, GitLab du lab, Prometheus. Clés `versions.yaml` :
  `argo_cd`, `argo_workflows`, `argo_rollouts`, `argo_events`, `harbor`, `gitlab`, `prometheus`.
- **Temps** : 8 h en deux séances
- **Livrable** : runbook « publier une version » + postmortem d'un canary avorté
- **3 exercices clés** :
  1. Un push GitLab → webhook Argo Events → Workflow de build (kaniko) qui pousse l'image sur Harbor et commit le tag
     dans le dépôt de déploiement.
  2. Argo CD détecte le commit, synchronise un `Rollout` canary ; `AnalysisTemplate` Prometheus décide de la promotion.
  3. Break-fix transverse : image non signée refusée par Harbor, drift manuel sur le Rollout, EventBus arrêté ;
     diagnostiquer de bout en bout en moins de 30 min.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| F1 Argo CD fondamentaux (rédigé, brouillon) | débutant | linux-base (kind) ou kubernetes-ha | 5 h |
| F2 Argo CD Helm/Kustomize/réconciliation | confirmé | kubernetes-ha | 6 h |
| F3 Argo Workflows fondamentaux (rédigé, brouillon) | débutant | linux-base (kind) ou kubernetes-ha | 5 h |
| F4 Argo Workflows artefacts/templates/DAG | confirmé | kubernetes-ha + ceph-3n | 7 h |
| F5 Argo Workflows traitement de données | confirmé | kubernetes-ha | 4 h |
| F6 Argo Rollouts | confirmé | kubernetes-ha | 6 h |
| F7 Argo Events | confirmé | kubernetes-ha | 4 h |
| S1 Chaîne Argo bout en bout | expert | kubernetes-ha + ceph-3n | 8 h |
| Révision (flashcards, quiz, examen blanc `exams/`) | — | — | 6 h |
| **Total** | | | **51 h** |

À 5 h par semaine, compter 10 à 11 semaines, cohérent avec le cycle de 4 à 6 semaines par bloc de `docs/roadmap.md` §7
si le bloc CGOA + CAPA est traité ensemble sur deux cycles.

## 6. Ce que le lab ne couvre pas

- Rien n'est `[lecture + simulation]` : les quatre projets Argo tournent sur `kubernetes-ha` sans matériel particulier.
- Les exemples d'examen cités dans la documentation Argo pour des fournisseurs de trafic SaaS (ALB, Istio managé,
  SMI) sont remplacés par Gateway API ; les noms des champs des autres fournisseurs sont à connaître pour le QCM
  (section « à connaître pour l'examen » de F6, lecture seule).
- L'examen est un QCM sans documentation (`examen.md`) : les flashcards de chaque fiche et le quiz `revision/quiz/`
  sont la préparation directe, les manipulations servent la rétention.
