---
code: CNPE
titre: "CNPE — mapping compétences → chapitres"
programme: "certifs/CNPE/programme.md (converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14)"
chapitres_existants: 2
generated: 2026-10-02
status: "0 chapitre dédié rédigé ; 2 fiches gitops (brouillons) couvrent partiellement CNPE-02 ; à mettre à jour à chaque PR de chapitre"
---

# CNPE — objectifs et couverture

Mapping entre les 18 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : aucun chapitre n'a été écrit pour CNPE. Deux fiches `gitops` rédigées pour CAPA
(`fiches/gitops/01-argo-cd-fondamentaux.md`, `fiches/gitops/02-argo-workflows-fondamentaux.md`, brouillons)
couvrent partiellement le domaine CNPE-02, et cinq chapitres planifiés par `certifs/CAPA/objectifs.md`
en couvriront une part de plus, de même que la fiche CGOA `gitops/09-flux-fondamentaux` (planifiée). Tout le reste est un trou.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices »
et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Couverture actuelle | Chapitres à créer |
|---|---|---|---|---|---|
| CNPE-01 Platform Architecture and Infrastructure | 15 % | 3 | 5,0 % | aucune | 2 fiches |
| CNPE-02 GitOps and Continuous Delivery | 25 % | 3 | 8,3 % | partielle (2 fiches CAPA rédigées, 3 planifiées) | 2 fiches |
| CNPE-03 Platform APIs and Self-Service Capabilities | 25 % | 4 | 6,25 % | aucune | 4 fiches |
| CNPE-04 Observability and Operations | 20 % | 3 | 6,7 % | aucune | 2 fiches + 1 scénario |
| CNPE-05 Security and Policy Enforcement | 15 % | 5 | 3,0 % | aucune | 4 fiches (+ 1 section de P4) |
| Transverse | — | 18 | — | — | 1 scénario |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle.

Lecture du programme : CNPE est l'examen **pratique** de la filière plateforme (CNPA est le QCM).
Les compétences sont formulées en « implementing / configuring / using », pas en « understand » :
chaque chapitre doit déboucher sur une manipulation chronométrée avec la seule documentation officielle.
La CNCF cite quinze projets (`programme.md`, section « Outils cités ») ; le candidat doit savoir en prendre
un inconnu en main depuis sa documentation pendant l'épreuve. Les chapitres ci-dessous traitent chaque
projet cité au moins une fois en manipulation, sauf Linkerd (comparé en lecture dans P12) et Jaeger
(remplacé par le backend de traces du lab si `versions.yaml` en retient un autre, voir §2).

Ordre de rédaction recommandé (du plus lourd au plus léger, en respectant les prérequis) :
Flux + Flagger (P3) → Tekton (P4) → CRD (P5) → opérateurs (P6) → Crossplane (P7) → pile d'observabilité (P9) →
multi-tenancy (P1) → OpenCost (P2) → identité et RBAC (P11) → admission (P13) → mTLS (P12) →
SBOM et conformité (P14) → SLO et DORA (P10) → Backstage (P8) → scénario plateforme (S1) → scénario astreinte (S2).

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : les clés `argo_cd`, `argo_workflows`, `flux`, `kyverno`, `istio`, `prometheus`, `grafana`, `loki`,
  `opentelemetry_collector`, `harbor`, `backstage`, `keycloak`, `cilium`, `cert_manager`, `kubebuilder` (absente),
  `helm` existent ou non comme indiqué. Clés à créer, toutes citées par le programme ou nécessaires aux exercices :
  `crossplane`, `tekton` (Pipelines + CLI `tkn`), `flagger`, `opencost`, `jaeger`, `gatekeeper` (OPA Gatekeeper),
  `opa` (CLI), `linkerd` (lecture seule, optionnelle), `trivy`, `cosign`, `syft`, `kube_prometheus_stack` (chart,
  Prometheus Operator), `keda`, `vertical_pod_autoscaler`, `kubebuilder`, `policy_reporter`, `kube_bench`,
  `sloth` ou `pyrra` (générateur de SLO), `capsule` (optionnel, multi-tenancy). Passe par la veille
  (`prompts/07-veille.md`) ou par la PR du chapitre concerné. Ne jamais écrire une version dans un chapitre.
- `labs/profiles/kubernetes-ha.yaml` : la liste `components` cite `argo_cd`, `argo_workflows`, `flux`, `prometheus`,
  `grafana`, `loki`, `velero` ; ajouter `kyverno`, `istio`, `cert_manager`, `harbor`, `keycloak`, `backstage` et les clés
  créées ci-dessus au fil des chapitres. Le budget RAM (48 Go) tient pour un chapitre à la fois ; le scénario S1
  qui empile tout exige `kubernetes-ha` + `ceph-3n` (stockage persistant Prometheus/Loki/Harbor via Rook) et une
  vérification du budget dans la PR du scénario.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.5 (cette PR). Les fiches **débutant**
  dont dépendent ces chapitres (Prometheus, OpenTelemetry, Kyverno, Istio, Backstage, RBAC Kubernetes) ne sont
  pas planifiées ici : elles relèvent des cartographies PCA, OTCA, KCA, ICA, CBA, CKA/CKS. Tant qu'elles n'existent
  pas, chaque fiche CNPE ouvre par un rappel de 20 lignes maximum et renvoie au nœud `<domaine>_deb`.
- Numérotation : les fiches `gitops` prennent les numéros `13` et `14` (la série `01`–`07` est fixée par CAPA,
  `08`–`12` par CGOA, DECISIONS.md 2026-10-02). Dans `plateforme`, `01`–`05` sont fixés par CBA (Backstage) et
  `06`–`13` par ICA (Istio). Dans `plateforme`, `observabilite`, `securite` et `kubernetes`, les fiches débutant
  appartiennent à d'autres certifications : les chemins ci-dessous portent `NN`, attribué à la PR du chapitre en
  prenant le numéro suivant de la série du domaine, sans changer le slug.
- Décisions à proposer (entrée datée dans `DECISIONS.md`, pas de réouverture d'un arbitrage existant) :
  1. *Mesh de référence* : Istio en mode ambient (programme ICA, projet cité par CNPE) pour le mTLS service à service,
     Cilium gardant Gateway API et le chiffrement WireGuard nœud à nœud ; Linkerd en lecture comparée.
  2. *Moteur CI du lab* : Tekton pour les chapitres CNPE (projet cité), Argo Workflows restant le moteur des
     chapitres CAPA ; GitLab CI n'entre qu'avec le placement de GitLab (décision en attente, DECISIONS.md 2026-10-02).
  3. *Backend de traces* : Jaeger (projet cité, stockage mémoire ou Badger sur le lab) ou Grafana Tempo ; le choix
     fixe la clé `versions.yaml` lue par P9.
- Pas de décision à prendre sur Gateway API (Cilium par défaut, DECISIONS.md 2026-10-02) : Flagger et Argo Rollouts
  l'utilisent pour le routage canary.

## 3. Couverture par compétence

Colonnes « chapitre existant » et « exercices existants » : `—` tant que rien n'existe ; « partiel » quand une fiche
d'une autre certification traite la compétence sans la viser. La colonne « chapitre cible » renvoie à la section 4 ;
« CAPA F2/F6/S1 » renvoie à `certifs/CAPA/objectifs.md` §4.

### CNPE-01 — Platform Architecture and Infrastructure (15 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPE-01-01 | Applying Platform Architecture Best Practices for Networking, Storage, and Compute | 5,0 % | — | — | P1 |
| CNPE-01-02 | Using Cost Management Solutions for Right-Sizing and Scaling | 5,0 % | — | — | P2 |
| CNPE-01-03 | Optimizing Multi-Tenancy Resource Usage | 5,0 % | — | — | P1, P2 |

### CNPE-02 — GitOps and Continuous Delivery (25 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPE-02-01 | Implementing GitOps Workflows for Application and Infrastructure Deployment | 8,3 % | partiel : `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon, applications seulement) | S1 : démo, autonome 1-3, break-fix repo-server-down, défi 20 min ; S2 : AppProject/Application, break-fix repo-credentials ; S3 : drift, rollback, break-fix app-degraded | P3 (Flux, infra via Crossplane) + CAPA F2 (Helm, Kustomize, ApplicationSet) |
| CNPE-02-02 | Building and Configuring CI/CD Pipelines Integrated with Kubernetes | 8,3 % | partiel : `fiches/gitops/02-argo-workflows-fondamentaux.md` (brouillon, moteur de workflow sans chaîne CI) | S1 : installation, hello-world, break-fix controller-down ; S2 : steps, paramètres, break-fix rbac ; S3 : cycle de vie, limites, break-fix image-pull | P4 (Tekton) + CAPA S1 (build kaniko → Harbor → commit) |
| CNPE-02-03 | Deploying Applications Using Progressive Delivery Strategies (e.g., Blue/Green or Canary) | 8,3 % | — | — | P3 (Flagger) + CAPA F6 (Argo Rollouts) |

### CNPE-03 — Platform APIs and Self-Service Capabilities (25 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPE-03-01 | Designing and Creating Custom Resource Definitions (CRDs) for Platform Services | 6,25 % | — | — | P5 |
| CNPE-03-02 | Implementing Workflows for Self-Service Provisioning Using Platform APIs | 6,25 % | partiel : `fiches/gitops/02-argo-workflows-fondamentaux.md` (template `resource`, S2) | S2 : workflow qui crée une ressource Kubernetes | P7 (Crossplane), P8 (Backstage) |
| CNPE-03-03 | Using Kubernetes Operators for Platform Automation and Integration | 6,25 % | — | — | P6 |
| CNPE-03-04 | Using Automation Frameworks for Self-Service Provisioning | 6,25 % | partiel : `fiches/gitops/02-argo-workflows-fondamentaux.md` (Argo Workflows comme moteur d'automatisation) | S2, S3 | P7, P8 + CAPA F7 (Argo Events) |

### CNPE-04 — Observability and Operations (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPE-04-01 | Implementing Monitoring, Alerting, Logging, and Tracing Solutions | 6,7 % | — | — | P9 |
| CNPE-04-02 | Measuring and Improving Platform Efficiency Using Deployment Metrics and Performance Indicators | 6,7 % | — | — | P10 |
| CNPE-04-03 | Diagnosing and Remediating Platform Issue and Incident Scenarios | 6,7 % | partiel : les 8 scripts `break/gitops/01-*.sh` et `02-*.sh` (pannes Argo CD et Argo Workflows) | break-fix des sections S1 à S3 des deux fiches | S2 (astreinte), S1 |

### CNPE-05 — Security and Policy Enforcement (15 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPE-05-01 | Configuring Secure Service-to-Service Communication | 3,0 % | — | — | P12 |
| CNPE-05-02 | Applying RBAC and Security Controls Across Platform Resources | 3,0 % | partiel : `fiches/gitops/01-argo-cd-fondamentaux.md` S2 (AppProject, destinations), `02-argo-workflows-fondamentaux.md` S2 (RBAC exécuteur) | break-fix destination-forbidden, break-fix rbac | P11 |
| CNPE-05-03 | Generating Audit Trails and Enforcing Policy Compliance (SBOM, Compliance Reports, etc.) | 3,0 % | — | — | P14 |
| CNPE-05-04 | Using Policy Engines and Admission Controllers for Governance | 3,0 % | — | — | P13 |
| CNPE-05-05 | Integrating Security Scanning and Compliance Checks into Deployment Pipelines | 3,0 % | — | — | P4 (section 3), P14 |

### Compétences partagées avec les autres certifications

CNPE est le dernier jalon du parcours Golden Kubestronaut (`docs/prerequis.md` §3, nœud `plateforme_exp`).
Chaque chapitre ci-dessous cite dans son front matter les IDs des autres programmes qu'il couvre, pour éviter
un doublon quand ces certifications seront cartographiées. Les IDs « réutilisables » sont indicatifs : la
cartographie de chaque certification les confirme ou les corrige.

| Chapitre | IDs CNPE | IDs réutilisables (à confirmer par la cartographie citée) |
|---|---|---|
| P1 multi-tenancy | 01-01, 01-03 | CKA-02-05, CKS-04-01, CKS-04-03, CNPA-01-03, CNPA-01-04 |
| P2 OpenCost | 01-02, 01-03 | CKA-02-03, CNPA-06-01 |
| P3 Flux + Flagger | 02-01, 02-03 | CGOA-04-02 (Flagger en pratique ; CGOA-05-03 est porté par `gitops/09`), CNPA-01-07, CNPA-03-04, CNPA-03-05 |
| P4 Tekton | 02-02, 05-05 | CGOA-03-04, CNPA-01-06, CNPA-03-01, CNPA-03-03, CNPA-02-05, CKS-05-03, CKS-05-04 |
| P5 CRD | 03-01 | CKA-05-08, CNPA-04-02 |
| P6 opérateurs | 03-03 | CKA-05-08, CNPA-04-01, CNPA-04-04 |
| P7 Crossplane | 03-02, 03-04 | CNPA-04-03, CNPA-01-01 |
| P8 Backstage scaffolder | 03-04, 03-02 | CNPA-05-01, CNPA-05-02, CNPA-05-03 ; CBA : voir `certifs/CBA/objectifs.md` |
| P9 pile d'observabilité | 04-01 | PCA-02-02, PCA-04-01 à 04-03, OTCA-03-01, OTCA-03-02, OTCA-03-04, CNPA-02-01 |
| P10 SLO et DORA | 04-02 | PCA-03-06, PCA-04-02, CNPA-06-01, CNPA-06-02 |
| P11 identité et RBAC | 05-02, 05-03 (audit) | CKS-02-01, CKS-02-02, CKS-02-03, CKS-06-05, CKA-05-01, CNPA-02-04 |
| P12 mTLS | 05-01 | ICA-03-01, ICA-03-02 (déjà couverts par `plateforme/10`), CKS-04-04, CCA (cartographie à faire), CNPA-02-02 |
| P13 admission | 05-04 | KCA-01-03, KCA-04-01, KCA-05-01, KCA-05-04, KCA-05-06, CNPA-02-03 |
| P14 SBOM et conformité | 05-03, 05-05 | CKS-05-02, CKS-05-03, KCA-06-01, CKS-01-02 |
| S1 plateforme bout en bout | les 18 | CNPA-01-04, CNPA-01-05 |
| S2 astreinte | 04-03 | CKA-04-01 à 04-05, CNPA-03-02 |

## 4. Trous et chapitres à créer

Toutes les fiches sont de niveau **confirmé** : CNPE suppose Kubernetes, GitOps, observabilité et sécurité
au niveau débutant acquis (`docs/prerequis.md`, prérequis de `plateforme_deb` et `plateforme_conf`).
Les deux scénarios sont **expert** et exigent les fiches confirmé complètes : pas de saut direct.
Tous les chapitres ciblent le profil `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`),
avec un cluster `kind` sur `linux-base` comme variante quand la fiche l'indique (pas de Gateway API Cilium ni de
LoadBalancer sur `kind` : exposition par `port-forward`). Git du lab : dépôt bare SSH sur `core-jump01`
(DECISIONS.md, 2026-10-02) tant que GitLab n'est pas placé ; P4 et S1 ont besoin de webhooks et motivent ce placement.
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.
Chaque fiche se termine par un défi « outil inconnu » : une tâche sur un projet non traité, résolue avec sa seule
documentation en 15 min, pour entraîner la posture demandée par l'examen.

### P1 — `fiches/kubernetes/NN-multi-tenancy-quotas-isolation.md`

- **Titre** : Multi-tenancy Kubernetes — namespaces, quotas, isolation réseau et stockage par équipe
- **Niveau** : confirmé (`kubernetes_conf`)
- **Couvre** : CNPE-01-01, CNPE-01-03
- **Prérequis** : `kubernetes_deb` (namespaces, requests/limits, Services), `reseau_conf` (Cilium, NetworkPolicy),
  `ceph_deb` recommandé (StorageClass Rook)
- **Lab** : `kubernetes-ha` (+ `ceph-3n` pour les StorageClass par tenant, sinon Longhorn). Clés `versions.yaml` :
  `kubernetes`, `cilium`, `rook` ou `longhorn`, `capsule` (optionnel, à créer).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Modéliser deux équipes (`team-a`, `team-b`) : namespaces étiquetés, `ResourceQuota` (CPU, RAM, PVC, objets),
     `LimitRange` par défaut, `PriorityClass` plateforme vs tenant, labels Pod Security Admission `restricted` ;
     vérifier chaque garde-fou par un déploiement qui doit échouer — CNPE-01-03.
  2. Isolation réseau par défaut : `CiliumNetworkPolicy` deny-all entrant par namespace, autorisations explicites vers
     DNS, la Gateway et l'observabilité ; isolation stockage : une `StorageClass` par classe de service
     (`nvme-fast`, `ssd-standard`) et `VolumeSnapshotClass`, quota de stockage par tenant — CNPE-01-01.
  3. Placement et capacité : `nodeSelector`/`taints` pour réserver un nœud « plateforme », `topologySpreadConstraints`,
     `PodDisruptionBudget`, mesurer l'usage réel vs demandé par namespace avec `kubectl top` et Prometheus ;
     comparer avec l'opérateur Capsule (Tenant CRD) en variante — CNPE-01-01, CNPE-01-03.
- **Break-fix** : `break/kubernetes/NN-quota-exhausted.sh` (quota saturé par un Job oublié, les Pods d'un tenant restent
  `Pending` sans événement lisible au premier regard).
- **Défi chronométré** : créer un tenant complet (namespace, quota, LimitRange, deny-all, RBAC lecteur) depuis une
  spécification en moins de 12 min.

### P2 — `fiches/plateforme/NN-opencost-dimensionnement-autoscaling.md`

- **Titre** : Coûts et dimensionnement — OpenCost, VPA, HPA et KEDA sur un cluster on-prem
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPE-01-02, CNPE-01-03
- **Prérequis** : P1, `observabilite_deb` (Prometheus installé, PromQL de base)
- **Lab** : `kubernetes-ha` avec Prometheus. Clés `versions.yaml` : `opencost`, `vertical_pod_autoscaler`, `keda`
  (à créer), `prometheus`, `helm`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer OpenCost branché sur Prometheus, définir un modèle de coût on-prem (`CustomPricing` : prix horaire
     vCPU, Go RAM, Go disque dérivés du serveur Proxmox), lire l'allocation par namespace, label `team` et
     Deployment ; exporter un rapport CSV — CNPE-01-02.
  2. Right-sizing : déployer le VPA en mode `Off` (recommandations seules), comparer requests déclarées et
     recommandées sur les composants plateforme, appliquer les corrections par PR GitOps, mesurer l'économie dans
     OpenCost — CNPE-01-02, CNPE-01-03.
  3. Scaling : HPA sur métrique personnalisée (adaptateur Prometheus), puis KEDA `ScaledObject` sur une file ou une
     requête PromQL avec scale-to-zero ; l'autoscaling de nœuds n'est pas praticable sur Proxmox sans Cluster API :
     section `[lecture + simulation]` sur Cluster Autoscaler/Karpenter — CNPE-01-02.
- **Break-fix** : `break/plateforme/NN-opencost-no-data.sh` (OpenCost pointe sur un Prometheus sans `kube-state-metrics`,
  allocations à zéro).
- **Défi chronométré** : identifier les trois workloads les plus surdimensionnés du cluster et proposer les requests
  corrigées, chiffrées, en moins de 15 min.

### P3 — `fiches/gitops/13-flux-et-flagger.md`

- **Titre** : Flux et Flagger — GitOps multi-sources et livraison progressive
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CNPE-02-01, CNPE-02-03
- **Prérequis** : `fiches/gitops/09-flux-fondamentaux.md` (CGOA G2, débutant : `flux install`, `GitRepository`,
  `Kustomization`, `OCIRepository`, `Bucket`), `fiches/gitops/01-argo-cd-fondamentaux.md` (comparaison des deux moteurs),
  `kubernetes_conf` (Helm 4, Kustomize, Gateway API), `observabilite_deb` (Prometheus pour les analyses Flagger)
- **Lab** : `kubernetes-ha` (Gateway API Cilium). Clés `versions.yaml` : `flux`, `flagger` (à créer), `helm`,
  `prometheus`, `cilium`, `harbor`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. `flux bootstrap git` sur le dépôt du lab (différence avec `flux install` de la fiche 09), contrôleurs d'image en
     `--components-extra`, `Kustomization` avec `dependsOn`, `HelmRelease` avec `valuesFrom`,
     `ImageRepository`/`ImagePolicy`/`ImageUpdateAutomation` qui committe le nouveau tag ; `flux diff`, `flux trace`
     — CNPE-02-01.
  2. GitOps pour l'infrastructure : la même `Kustomization` déploie des ressources Crossplane (P7) et des policies
     Kyverno, avec `healthChecks` et `wait` ; suspendre/reprendre une réconciliation ; comparer avec un
     `ApplicationSet` Argo CD (CAPA F2) sur les mêmes sources — CNPE-02-01.
  3. Flagger : `Canary` avec `provider: gatewayapi`, `HTTPRoute` pilotée, étapes `stepWeight`/`maxWeight`,
     `metrics` Prometheus (taux d'erreur, latence), `webhooks` de test de charge ; puis stratégie blue/green
     (`mirror`, `iterations`) et rollback automatique sur échec d'analyse — CNPE-02-03.
- **Break-fix** : `break/gitops/13-flux-kustomization-stuck.sh` (secret d'accès au dépôt révoqué, `Kustomization`
  en `ReconciliationFailed`, aucune mise à jour appliquée).
- **Défi chronométré** : déployer une application depuis un dépôt vierge avec Flux et la passer en canary Flagger
  jusqu'à promotion en moins de 15 min.

### P4 — `fiches/gitops/14-tekton-pipelines-securisees.md`

- **Titre** : Tekton — pipelines CI natifs Kubernetes, du build à la livraison GitOps
- **Niveau** : confirmé (`gitops_conf`)
- **Couvre** : CNPE-02-02, CNPE-05-05
- **Prérequis** : `fiches/gitops/02-argo-workflows-fondamentaux.md` (comparaison des moteurs), `kubernetes_conf`
  (ServiceAccounts, Secrets, PVC), P3 ou `fiches/gitops/01-argo-cd-fondamentaux.md` (livraison)
- **Lab** : `kubernetes-ha` + Harbor. Un GitLab (ou un serveur Git avec webhooks) est nécessaire aux Triggers :
  décision de placement à prendre (DECISIONS.md 2026-10-02) ; en attendant, déclenchement manuel par `tkn` et
  `EventListener` testé par `curl`. Clés `versions.yaml` : `tekton` (à créer), `harbor`, `trivy`, `cosign`, `syft`
  (à créer), `kyverno`.
- **Temps** : 7 h
- **3 exercices clés** :
  1. Installer Tekton Pipelines et Triggers, écrire des `Task` (clone, build kaniko ou buildah sans privilège, push
     Harbor), un `Pipeline` avec `workspaces`, `params`, `results` et `runAfter`, lancer un `PipelineRun`, lire les
     logs avec `tkn` ; réutiliser des tâches du Tekton Hub via `ResolverRef` — CNPE-02-02.
  2. Intégrer la livraison : la dernière tâche met à jour le tag d'image dans le dépôt de déploiement (commit signé)
     puis Flux ou Argo CD synchronise ; `EventListener` + `TriggerBinding` + `TriggerTemplate` déclenchés par
     webhook ; `PipelineRun` paramétré par branche — CNPE-02-02.
  3. Portes de sécurité dans le pipeline : scan Trivy bloquant sur CVE critiques, SBOM Syft attaché à l'image,
     signature Cosign (keyless ou clé du lab), vérification de politique Kyverno par `kyverno apply` sur les manifests
     avant commit ; côté cluster, règle `verifyImages` qui refuse les images non signées — CNPE-05-05.
- **Break-fix** : `break/gitops/14-tekton-workspace-pvc.sh` (PVC du workspace en `Pending`, `PipelineRun` bloqué sans
  erreur dans les logs de tâche).
- **Défi chronométré** : construire, scanner, signer et pousser une image puis la voir déployée par GitOps en moins de
  20 min.

### P5 — `fiches/plateforme/NN-crd-conception-validation-cel.md`

- **Titre** : Concevoir une CRD de plateforme — schéma OpenAPI, validation CEL, versions et statut
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPE-03-01
- **Prérequis** : `kubernetes_conf` (API server, `kubectl explain`, RBAC), `gitops_deb`
- **Lab** : `kind` sur `linux-base` suffit (aucun composant externe) ; `kubernetes-ha` en variante. Clés
  `versions.yaml` : `kubernetes`, `kind`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Écrire une CRD `Database` (`platform.lab.home.arpa/v1alpha1`) : schéma structurel OpenAPI v3, champs requis,
     valeurs par défaut, `enum`, `x-kubernetes-validations` en CEL (règles croisées, messages), `status` subresource,
     `additionalPrinterColumns`, `categories`, `shortNames` ; tester chaque règle avec des manifests valides et
     invalides — CNPE-03-01.
  2. Faire évoluer l'API : ajouter `v1beta1` avec un champ renommé, `storage` et `served`, webhook de conversion
     (`[lecture + simulation]` pour le serveur de conversion, pratique pour la conversion `None`), politique de
     dépréciation ; vérifier avec `kubectl get --raw` et `kubectl explain` — CNPE-03-01.
  3. Exposer la CRD comme API de plateforme : RBAC par `apiGroups`, agrégation dans un `ClusterRole` tenant,
     `ValidatingAdmissionPolicy` CEL complémentaire, documentation générée (`kubectl explain --recursive`) ;
     la CRD sert ensuite de contrat à P6 (contrôleur) et P7 (Crossplane) — CNPE-03-01.
- **Break-fix** : `break/plateforme/NN-crd-schema-reject.sh` (schéma non structurel ou règle CEL invalide, la CRD
  passe en `NonStructuralSchema`/`KubernetesAPIApprovalPolicyConformant: Unknown`, les objets sont refusés).
- **Défi chronométré** : écrire une CRD avec trois règles de validation CEL et un statut, prouver chaque règle
  par un refus, en moins de 15 min.

### P6 — `fiches/plateforme/NN-operateurs-kubernetes.md`

- **Titre** : Opérateurs Kubernetes — exploiter, diagnostiquer, écrire un contrôleur minimal
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPE-03-03
- **Prérequis** : P5, `kubernetes_conf` (Deployments, RBAC, finalizers), `sauvegarde_deb` recommandé (CloudNativePG)
- **Lab** : `kubernetes-ha` (+ `ceph-3n` ou Longhorn pour les PVC CloudNativePG). Clés `versions.yaml` :
  `cloudnative_pg`, `cert_manager`, `kube_prometheus_stack` (à créer), `kubebuilder` (à créer), `helm`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Exploiter des opérateurs tiers : installer CloudNativePG et cert-manager, créer un `Cluster` PostgreSQL et un
     `Certificate`, lire `status.conditions`, événements, owner references et finalizers ; suivre une mise à niveau
     de l'opérateur et son effet sur les CR ; comparer Helm, OLM et manifests pour le cycle de vie — CNPE-03-03.
  2. Diagnostiquer la boucle de réconciliation : `kubectl get -o yaml` de la CR vs ressources générées, logs du
     manager (`--zap-log-level`), métriques `controller_runtime_reconcile_*` dans Prometheus, suppression bloquée par
     un finalizer, drift corrigé par l'opérateur — CNPE-03-03.
  3. Écrire un contrôleur minimal pour la CRD `Database` de P5 avec Kubebuilder (Go) : `Reconcile` qui crée un
     `Cluster` CloudNativePG et un `Secret` de connexion, owner reference, mise à jour du `status`, RBAC générés par
     markers, image poussée sur Harbor et déploiement par GitOps ; variante sans Go en `[lecture + simulation]`
     (shell-operator, Metacontroller) — CNPE-03-03.
- **Break-fix** : `break/plateforme/NN-operator-rbac-missing.sh` (ClusterRole de l'opérateur amputé, CR jamais
  `Ready`, erreurs `forbidden` dans les logs du manager).
- **Défi chronométré** : à partir d'un opérateur inconnu installé par un tiers, retrouver sa CRD, créer une instance
  conforme et expliquer pourquoi elle n'est pas `Ready` en moins de 15 min.

### P7 — `fiches/plateforme/NN-crossplane-self-service.md`

- **Titre** : Crossplane — compositions et claims pour le provisionnement en libre-service
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPE-03-02, CNPE-03-04
- **Prérequis** : P5, P3 ou `fiches/gitops/01-argo-cd-fondamentaux.md`, `iac_conf` (OpenTofu, provider `bpg/proxmox`)
- **Lab** : `kubernetes-ha` ; l'accès à l'API Proxmox depuis le cluster passe par le VLAN `mgmt` (`labs/network.md` §7,
  flux à ouvrir dans le routeur). Clés `versions.yaml` : `crossplane` (à créer), `opentofu`,
  `terraform_provider_proxmox`, `argo_cd` ou `flux`, `cloudnative_pg`.
- **Temps** : 7 h
- **3 exercices clés** :
  1. Installer Crossplane, les providers `provider-kubernetes` et `provider-helm`, écrire une `CompositeResourceDefinition`
     `XDatabase` et une `Composition` (fonction `function-patch-and-transform`) qui produit un `Cluster` CloudNativePG,
     un `Secret` et une `NetworkPolicy` ; créer un claim depuis un namespace tenant, lire `crossplane beta trace`
     — CNPE-03-02.
  2. Provisionner hors cluster : `provider-terraform` (OpenTofu) qui crée une VM Proxmox via `bpg/proxmox` depuis une
     composition `XVirtualMachine` ; `ProviderConfig` avec identifiants dans un Secret ; politique de suppression
     (`deletionPolicy: Orphan`) ; `[non testé]` si le provider communautaire Proxmox n'est pas retenu — CNPE-03-02.
  3. Cadre de libre-service : catalogue de compositions versionnées (`Configuration` package sur Harbor), claims
     livrés par GitOps depuis le dépôt de l'équipe, `EnvironmentConfig` par environnement, quotas sur les claims
     par RBAC ; mesurer le délai claim → ressource `Ready` — CNPE-03-04.
- **Break-fix** : `break/plateforme/NN-crossplane-providerconfig.sh` (`ProviderConfig` qui pointe sur un Secret absent,
  claims bloqués `Synced: False`).
- **Défi chronométré** : écrire une XRD et une composition qui créent un namespace, un quota et un `Secret` depuis un
  claim de trois champs, en moins de 20 min.

### P8 — `fiches/plateforme/NN-backstage-scaffolder-self-service.md`

- **Titre** : Backstage — templates de scaffolding qui déclenchent le provisionnement
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPE-03-04, CNPE-03-02
- **Prérequis** : P7, `fiches/plateforme/01-backstage-premier-lancement.md` (série CBA), P3 ou
  `fiches/gitops/01-argo-cd-fondamentaux.md`, `services_deb` (Keycloak OIDC) recommandé
- **Lab** : `kubernetes-ha` + PostgreSQL (CloudNativePG) + serveur Git avec API (GitLab, même décision que P4).
  Clés `versions.yaml` : `backstage`, `keycloak`, `cloudnative_pg`, `argo_cd`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Déployer Backstage (chart) avec PostgreSQL et authentification Keycloak, catalogue alimenté par
     `catalog-info.yaml` dans les dépôts du lab, plugin Kubernetes relié au cluster — CNPE-03-04.
  2. Écrire un template Scaffolder : paramètres, `fetch:template`, `publish:gitlab` (ou `publish:github`),
     création d'un claim Crossplane (P7) et d'une `Application` Argo CD par commit ; suivre l'exécution et les logs
     — CNPE-03-04, CNPE-03-02.
  3. Mesurer le libre-service : TechDocs du template, action personnalisée (appel d'un Workflow Argo ou d'un
     `PipelineRun` Tekton), temps « demande → service prêt » comparé au processus manuel — CNPE-03-04.
- **Break-fix** : `break/plateforme/NN-backstage-scaffolder-token.sh` (jeton d'intégration Git expiré, l'étape
  `publish` échoue, l'entité reste orpheline dans le catalogue).
- **Défi chronométré** : créer un service via le template, voir son dépôt, son claim et son Application apparaître,
  en moins de 12 min.
- **Note** : ce chapitre prolonge la série CBA (`plateforme/01` à `05`, `certifs/CBA/objectifs.md`) ; si une fiche CBA
  couvre déjà le Scaffolder, P8 se réduit au couplage Scaffolder → Crossplane → Argo CD et cite les IDs CNPE.

### P9 — `fiches/observabilite/NN-pile-observabilite-plateforme.md`

- **Titre** : Pile d'observabilité de plateforme — métriques, alertes, logs et traces en code
- **Niveau** : confirmé (`observabilite_conf`)
- **Couvre** : CNPE-04-01
- **Prérequis** : `observabilite_deb` (Prometheus, PromQL, notions OpenTelemetry : fiches PCA/OTCA à venir),
  `kubernetes_conf`, P3 ou `fiches/gitops/01-argo-cd-fondamentaux.md` (déploiement GitOps de la pile)
- **Lab** : `kubernetes-ha` + `ceph-3n` (stockage persistant). Clés `versions.yaml` : `kube_prometheus_stack` (à créer),
  `prometheus`, `grafana`, `loki`, `opentelemetry_collector`, `jaeger` (à créer, ou Tempo selon décision §2).
- **Temps** : 7 h
- **3 exercices clés** :
  1. Déployer kube-prometheus-stack par GitOps : `ServiceMonitor`/`PodMonitor` pour Argo CD, Flux, Kyverno, Crossplane ;
     `PrometheusRule` d'alertes plateforme (contrôleur en erreur, réconciliation en retard, quota saturé) ;
     Alertmanager routé vers un webhook du lab avec inhibition et silences — CNPE-04-01.
  2. Logs : Loki + Alloy (ou Promtail) avec labels par namespace et tenant, rétention, requêtes LogQL sur les logs
     d'audit du kube-apiserver et des contrôleurs ; alerte LogQL sur un motif — CNPE-04-01.
  3. Traces : OpenTelemetry Collector en `DaemonSet` + `Deployment` gateway, application de démo instrumentée,
     export vers Jaeger, corrélation trace ↔ logs ↔ métriques dans Grafana (data links, exemplars), dashboards
     versionnés en `ConfigMap`/`GrafanaDashboard` — CNPE-04-01.
- **Break-fix** : `break/observabilite/NN-servicemonitor-label-mismatch.sh` (sélecteur de labels qui ne matche plus,
  cible disparue, alertes muettes).
- **Défi chronométré** : rendre un nouveau composant observable (métriques scrappées, règle d'alerte, panneau
  Grafana, logs étiquetés) en moins de 15 min.

### P10 — `fiches/observabilite/NN-slo-dora-indicateurs-plateforme.md`

- **Titre** : SLO et indicateurs de livraison — mesurer l'efficacité de la plateforme
- **Niveau** : confirmé (`observabilite_conf`)
- **Couvre** : CNPE-04-02
- **Prérequis** : P9, P3 et P4 (sources des métriques de déploiement)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `prometheus`, `grafana`, `sloth` ou `pyrra` (à créer), `argo_cd`,
  `flux`, `tekton`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Définir trois SLI de plateforme (disponibilité de l'API Argo CD/Flux, latence de réconciliation, succès des
     `PipelineRun`), les SLO associés et les règles d'enregistrement générées par Sloth ou Pyrra ; budgets d'erreur
     et alertes multi-fenêtres — CNPE-04-02.
  2. Métriques DORA depuis les outils du lab : fréquence de déploiement (`argocd_app_sync_total`,
     `gotk_reconcile_*`), délai de mise en production (commit → sync, via les métriques Tekton et les annotations
     Git), taux d'échec de changement (rollbacks Flagger/Rollouts), temps de rétablissement (alertes résolues) ;
     tableau de bord Grafana par équipe — CNPE-04-02.
  3. Boucle d'amélioration : analyser quatre semaines simulées (données injectées), identifier le goulot,
     proposer un changement de plateforme (cache de build, parallélisme, politique de promotion), mesurer l'effet ;
     rédiger la revue mensuelle — CNPE-04-02.
- **Break-fix** : `break/observabilite/NN-recording-rule-broken.sh` (règle d'enregistrement qui référence une métrique
  renommée, SLO affiché à 100 % sans données).
- **Défi chronométré** : produire les quatre métriques DORA d'une application sur 7 jours à partir de Prometheus
  en moins de 15 min.

### P11 — `fiches/securite/NN-identite-rbac-plateforme-oidc.md`

- **Titre** : Identité et RBAC de plateforme — OIDC Keycloak, rôles par tenant, audit
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CNPE-05-02, CNPE-05-03 (journal d'audit)
- **Prérequis** : `securite_deb`, `kubernetes_conf` (RBAC, ServiceAccounts), `services_deb` (Keycloak, PKI interne),
  P1 (tenants)
- **Lab** : `kubernetes-ha` + `core` (Keycloak sur `core-idp01`, CA interne). Clés `versions.yaml` : `keycloak`,
  `kubernetes`, `argo_cd`, `grafana`, `loki`, `step_ca`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Brancher le kube-apiserver sur Keycloak (OIDC, groupes dans les claims), `kubectl` avec `kubelogin`,
     `ClusterRoleBinding` par groupe tenant, rôles agrégés plateforme (lecteur, déployeur, admin tenant) ;
     prouver chaque droit par `kubectl auth can-i` et `--as` — CNPE-05-02.
  2. Étendre aux composants : SSO Argo CD (`policy.csv` par AppProject et groupe), Grafana (rôles par équipe),
     Backstage ; hygiène des ServiceAccounts (`automountServiceAccountToken: false`, tokens liés, durée),
     Pod Security Admission `restricted` sur les tenants — CNPE-05-02.
  3. Journal d'audit : politique d'audit du kube-apiserver (niveaux par ressource, exclusions), export vers Loki,
     requêtes « qui a modifié ce Secret », alerte sur une action sensible, conservation ; audit des opérations
     Argo CD et Keycloak — CNPE-05-03.
- **Break-fix** : `break/securite/NN-oidc-group-claim.sh` (claim de groupes retiré du client Keycloak, tous les
  développeurs perdent leurs droits sauf les ServiceAccounts).
- **Défi chronométré** : donner à un nouveau groupe le droit de déployer dans son namespace via `kubectl` et Argo CD,
  et le prouver, en moins de 12 min.

### P12 — `fiches/securite/NN-mtls-service-a-service.md`

- **Titre** : Communication sécurisée entre services — mTLS Istio, autorisation, chiffrement Cilium
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CNPE-05-01
- **Prérequis** : `fiches/plateforme/10-istio-securite-mtls-jwt-autorisation.md` (série ICA : mTLS, JWT, autorisation
  en pratique), `reseau_conf` (Cilium), P9 (observer le mesh)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `istio`, `cilium`, `cert_manager`, `linkerd` (lecture, optionnel).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Rejouer en conditions d'examen ce que la fiche ICA 10 enseigne : `PeerAuthentication` `STRICT` progressif
     (PERMISSIVE → STRICT) sur deux namespaces, vérification du mTLS avec `istioctl` et les traces,
     `AuthorizationPolicy` par identité SPIFFE et par méthode HTTP, refus lus dans les logs ztunnel/waypoint ;
     la fiche ne réexplique pas, elle chronomètre — CNPE-05-01.
  2. Trafic entrant et sortant : TLS au bord via Gateway API avec certificat cert-manager de la CA interne,
     `ServiceEntry` et politique d'egress, `RequestAuthentication` JWT Keycloak sur une route — CNPE-05-01.
  3. Sans mesh : chiffrement WireGuard Cilium entre nœuds, authentification mutuelle Cilium (SPIRE) en
     `[lecture + simulation]` si le budget ne permet pas SPIRE, NetworkPolicy L7 ; tableau comparatif
     Istio / Linkerd / Cilium pour le défi « outil inconnu » (Linkerd depuis sa documentation) — CNPE-05-01.
- **Break-fix** : `break/securite/NN-mtls-strict-legacy-client.sh` (namespace passé en `STRICT` alors qu'un client hors
  mesh y accède, erreurs `connection reset`).
- **Défi chronométré** : imposer le mTLS strict et une autorisation « seul le frontend parle au backend » sur un
  namespace et le prouver en moins de 12 min.

### P13 — `fiches/securite/NN-admission-kyverno-gatekeeper-vap.md`

- **Titre** : Gouvernance par admission — Kyverno, Gatekeeper/OPA et ValidatingAdmissionPolicy
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CNPE-05-04
- **Prérequis** : `securite_deb` (Kyverno installé et première `ClusterPolicy` : fiche KCA à venir), P5 (CEL),
  P3 ou `fiches/gitops/01-argo-cd-fondamentaux.md` (policies livrées par GitOps)
- **Lab** : `kubernetes-ha` ; `kind` sur `linux-base` suffit pour les sections 1 et 2. Clés `versions.yaml` : `kyverno`,
  `gatekeeper`, `opa` (à créer), `kubernetes`, `policy_reporter` (à créer).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Kyverno en gouvernance de plateforme : jeu de policies « baseline » (labels obligatoires, registre autorisé,
     pas de `latest`, requests/limits, PSS), `validationFailureAction` `Audit` puis `Enforce`, mutation (ajout de
     labels, sidecar annotation), génération (NetworkPolicy par namespace), `PolicyException` ; tests `kyverno test`
     en CI — CNPE-05-04.
  2. Gatekeeper : `ConstraintTemplate` Rego et `Constraint` équivalents à deux policies Kyverno, audit, `Config`
     de synchronisation, `ExpansionTemplate` ; comparer verdicts, latence et ergonomie sur les mêmes manifests
     — CNPE-05-04.
  3. Admission native : `ValidatingAdmissionPolicy` + `Binding` CEL avec `paramRef`, `MutatingAdmissionPolicy`
     (si activée dans la version `kubernetes` de `versions.yaml`, sinon `[lecture + simulation]`), ordre
     d'exécution des webhooks, `failurePolicy`, exclusion des namespaces système ; diagnostiquer une admission qui
     bloque le cluster — CNPE-05-04.
- **Break-fix** : `break/securite/NN-admission-webhook-timeout.sh` (webhook Kyverno injoignable avec `failurePolicy: Fail`,
  plus aucun Pod ne démarre).
- **Défi chronométré** : implémenter la même règle « image depuis Harbor uniquement » en Kyverno, Gatekeeper et
  VAP, et prouver les trois refus, en moins de 15 min.

### P14 — `fiches/securite/NN-sbom-signature-conformite.md`

- **Titre** : Chaîne d'approvisionnement et conformité — SBOM, signatures, rapports de politique, CIS
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CNPE-05-03, CNPE-05-05
- **Prérequis** : P4 (pipeline), P13 (Kyverno `verifyImages`), `securite_conf`
- **Lab** : `kubernetes-ha` + Harbor. Clés `versions.yaml` : `trivy`, `syft`, `cosign`, `kube_bench`, `policy_reporter`
  (à créer), `harbor`, `kyverno`, `compliance_as_code`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. SBOM et attestations : générer un SBOM SPDX/CycloneDX avec Syft, l'attacher à l'image comme attestation Cosign,
     le vérifier côté cluster (`verifyImages` avec `attestations`), scan Trivy du SBOM hors ligne, rapport de
     vulnérabilités par namespace via Trivy Operator — CNPE-05-03, CNPE-05-05.
  2. Rapports de conformité : `PolicyReport`/`ClusterPolicyReport` Kyverno agrégés par Policy Reporter, export
     vers Loki/Grafana, kube-bench contre le benchmark CIS sur un nœud, OpenSCAP (`compliance_as_code`) sur l'OS des
     nœuds ; produire un rapport mensuel « exigence → contrôle → preuve » — CNPE-05-03.
  3. Harbor comme point de contrôle : scan automatique à la poussée, interdiction de tirer une image vulnérable,
     politique de rétention, réplication vers le miroir `airgap` ; relier le rapport Harbor, le `PolicyReport` et le
     journal d'audit (P11) sur un incident simulé — CNPE-05-03, CNPE-05-05.
- **Break-fix** : `break/securite/NN-verifyimages-key-rotated.sh` (clé Cosign tournée côté pipeline, toutes les nouvelles
  images refusées à l'admission).
- **Défi chronométré** : prouver qu'une image donnée est signée, possède un SBOM et ne porte aucune CVE critique,
  avec les commandes et les rapports, en moins de 12 min.

### S1 — `scenarios/NN-plateforme-interne-bout-en-bout/README.md`

- **Titre** : NN — Une plateforme interne complète : du claim d'équipe au service observé et conforme
  (numéro `NN` attribué à la création)
- **Niveau** : expert (`plateforme_exp`) ; prérequis P1 à P14 complets, pas de saut direct
- **Couvre** : les 18 compétences CNPE en situation
- **Lab** : `kubernetes-ha` + `ceph-3n` (budget 28 vCPU alloués / 96 Go, combinaison autorisée dans
  `labs/profiles/README.md` ; vérifier la RAM libre avant de lancer) + Harbor, Keycloak, GitLab (décision de placement).
  Clés `versions.yaml` : toutes celles des fiches P1 à P14.
- **Temps** : 10 h en trois séances
- **Livrable** : ADR « architecture de la plateforme interne » + runbook « onboarder une équipe en 30 min »
- **3 exercices clés** :
  1. Onboarder une équipe par template Backstage : tenant (P1), identité (P11), claim Crossplane de base de données
     (P7), dépôts Git et pipeline Tekton (P4), livraison Flux ou Argo CD avec canary (P3) ; tout en code, rien à la
     main.
  2. Rendre la plateforme gouvernée et observable : policies d'admission (P13), mTLS (P12), SBOM et signatures (P14),
     SLO et tableau DORA de l'équipe (P9, P10), rapport de coût OpenCost (P2).
  3. Épreuve chronométrée en conditions d'examen : 12 tâches tirées des 18 compétences, documentation officielle
     seule, 120 min ; correction par `grade.sh` (base du futur examen blanc `exams/cnpe/`).

### S2 — `scenarios/NN-astreinte-plateforme-incidents/README.md`

- **Titre** : NN — Astreinte plateforme : diagnostiquer et remédier à l'aveugle (numéro `NN` attribué à la création)
- **Niveau** : expert (`plateforme_exp`) ; prérequis S1 ou, au minimum, P3, P4, P6, P9, P11, P13
- **Couvre** : CNPE-04-03 (plus toutes les compétences dont les pannes proviennent)
- **Lab** : même socle que S1. Clés `versions.yaml` : celles de S1.
- **Temps** : 6 h en deux séances
- **Livrable** : trois postmortems au format « chronologie, cause, remédiation, prévention » + runbooks d'astreinte
- **3 exercices clés** :
  1. Pannes injectées à l'aveugle (`break.sh random` sur un catalogue de 12 pannes transverses : webhook d'admission
     bloquant, mTLS strict prématuré, `Kustomization` suspendue, opérateur sans RBAC, quota saturé, Prometheus plein,
     certificat expiré, claim Crossplane orphelin…) ; diagnostiquer avec la seule observabilité en place.
  2. Remédiation conforme GitOps : corriger par commit, pas à la main ; prouver le retour à l'état désiré ; mesurer le
     temps de rétablissement et l'inscrire dans le tableau DORA (P10).
  3. Simulation d'astreinte de 2 h : alertes Alertmanager en chaîne, priorisation, communication d'incident, postmortem
     écrit en 30 min ; déterminer quelle alerte ou quel garde-fou manquait et l'ajouter.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| P1 Multi-tenancy, quotas, isolation | confirmé | kubernetes-ha (+ ceph-3n) | 6 h |
| P2 OpenCost, VPA, HPA, KEDA | confirmé | kubernetes-ha | 5 h |
| P3 Flux et Flagger | confirmé | kubernetes-ha | 6 h |
| P4 Tekton, pipelines sécurisées | confirmé | kubernetes-ha + Harbor (+ GitLab) | 7 h |
| P5 Conception de CRD, CEL | confirmé | linux-base (kind) ou kubernetes-ha | 5 h |
| P6 Opérateurs Kubernetes | confirmé | kubernetes-ha (+ ceph-3n) | 6 h |
| P7 Crossplane self-service | confirmé | kubernetes-ha (+ API Proxmox) | 7 h |
| P8 Backstage scaffolder | confirmé | kubernetes-ha (+ GitLab) | 5 h |
| P9 Pile d'observabilité | confirmé | kubernetes-ha + ceph-3n | 7 h |
| P10 SLO et DORA | confirmé | kubernetes-ha | 5 h |
| P11 Identité, RBAC, audit | confirmé | kubernetes-ha + core (Keycloak) | 6 h |
| P12 mTLS service à service | confirmé | kubernetes-ha | 5 h |
| P13 Admission : Kyverno, Gatekeeper, VAP | confirmé | linux-base (kind) ou kubernetes-ha | 6 h |
| P14 SBOM, signatures, conformité | confirmé | kubernetes-ha + Harbor | 5 h |
| S1 Plateforme interne bout en bout | expert | kubernetes-ha + ceph-3n | 10 h |
| S2 Astreinte plateforme | expert | kubernetes-ha + ceph-3n | 6 h |
| Révision (flashcards, checklists, simulateur killer.sh ×2, examen blanc `exams/cnpe/`) | — | — | 12 h |
| **Total** | | | **115 h** |

Non compté : les fiches débutant des autres certifications (Prometheus, OpenTelemetry, Kyverno, Istio, Backstage,
RBAC) que CNPE suppose acquises, ni les chapitres CAPA F2, F6, F7 et S1 réutilisés.
À 5 h par semaine, compter 23 semaines, soit quatre à cinq cycles de `docs/roadmap.md` §7 : CNPE ferme le parcours
Golden Kubestronaut et se prépare après CNPA, ICA, KCA, PCA/OTCA et le bloc CGOA/CAPA, dont il réutilise les chapitres.
Les deux sessions du simulateur killer.sh incluses dans l'inscription (`examen.md`) se placent à J-14 et J-3.

## 6. Ce que le lab ne couvre pas

- Autoscaling de nœuds (Cluster Autoscaler, Karpenter) : pas de fournisseur cloud ; `[lecture + simulation]` dans P2,
  Cluster API avec un provider Proxmox en variante `[non testé]` si une version stable existe à la rédaction.
- Webhook de conversion de CRD (P5) et authentification mutuelle Cilium par SPIRE (P12) : praticables mais coûteux
  en temps ; `[lecture + simulation]` sauf si la relecture critique juge l'exercice nécessaire à l'examen.
- Linkerd : non installé (un seul mesh sur le lab, décision à proposer en §2) ; traité par comparaison et par le défi
  « outil inconnu » de P12, puisque l'examen peut présenter un projet non pratiqué.
- Fournisseurs cloud des exemples de documentation (AWS, GCP, Azure pour Crossplane, OpenCost, Flagger) : remplacés par
  Proxmox, Prometheus et Gateway API ; les noms des champs des fournisseurs ne sont pas à mémoriser pour un examen
  pratique avec documentation, mais la navigation rapide dans ces documentations s'entraîne (S1, exercice 3).
- L'examen est pratique avec documentation autorisée limitée (`examen.md`) : les flashcards servent à retenir les noms
  de CRD et de commandes pour aller vite, pas à répondre à un QCM ; les défis chronométrés et le scénario S1 en
  conditions d'examen sont la préparation directe.
