---
code: CNPA
titre: "CNPA — mapping compétences → chapitres"
programme: "certifs/CNPA/programme.md (converti le 2026-10-02 ; PDF CNPA_Curriculum.pdf committé le 2025-04-01 dans cncf/curriculum, dépôt consulté le 2026-10-02)"
chapitres_existants: 2
generated: 2026-10-02
status: "0 chapitre propre à CNPA ; 2 fiches gitops couvrent partiellement 8 compétences sur 27 ; 11 fiches et 1 scénario à créer"
---

# CNPA — objectifs et couverture

Mapping entre les 27 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : aucun chapitre du domaine `plateforme` n'existe. Les deux fiches rédigées
(`fiches/gitops/01-argo-cd-fondamentaux.md`, `fiches/gitops/02-argo-workflows-fondamentaux.md`, statut brouillon)
couvrent partiellement les compétences GitOps et CI. Ce fichier sert de plan de création ; chaque PR de chapitre
remplit les colonnes « chapitre » et « exercices » et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| CNPA-01 Platform Engineering Core Fundamentals | 36 % | 7 | 5,1 % | 2 fiches (F1, F4) + réutilisation gitops/01, gitops/02 |
| CNPA-02 Platform Observability, Security, and Conformance | 20 % | 5 | 4,0 % | 4 fiches (F5, F6, F7, F8) |
| CNPA-03 Continuous Delivery & Platform Engineering | 16 % | 5 | 3,2 % | 1 fiche (F11) + F4 + réutilisation gitops/01 et CAPA F2 |
| CNPA-04 Platform APIs and Provisioning Infrastructure | 12 % | 4 | 3,0 % | 2 fiches (F2, F3) |
| CNPA-05 IDPs and Developer Experience | 8 % | 4 | 2,0 % | 2 fiches (F9, F10) |
| CNPA-06 Measuring your Platform | 8 % | 2 | 4,0 % | F11 |
| Transverse | — | 27 | — | 1 scénario (S1) |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle. Conséquence : une compétence du domaine 01 vaut 2,5 fois une compétence
du domaine 05 ; les fondamentaux (F1) et la chaîne CI/CD (F4) passent avant le portail et l'IA.

Ordre de rédaction recommandé (du plus lourd au plus léger, en respectant les prérequis) :
F1 fondamentaux plateforme → F6 sécurité Kubernetes → F8 observabilité → F2 CRD/opérateurs → F4 CI sécurisée →
F7 Kyverno → F3 Crossplane → F5 mTLS → F11 incidents/DORA → F9 Backstage → F10 IA → S1 scénario.

Particularité de CNPA : c'est un QCM transverse, « vendor-neutral », sur un métier plus que sur un outil.
Cinq des onze fiches sont partagées avec d'autres certifications du Golden Kubestronaut (KCSA, KCA, PCA/OTCA, ICA, CBA)
et seront citées par leurs cartographies respectives ; seules six fiches (F1, F2, F3, F4, F10, F11) et le scénario sont
propres à CNPA.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : les clés `backstage`, `kyverno`, `istio`, `cert_manager`, `prometheus`, `grafana`, `loki`,
  `opentelemetry_collector`, `harbor`, `cloudnative_pg`, `open_webui`, `litellm`, `kserve`, `argo_cd`, `argo_workflows`
  existent. Clés à créer, par la veille (`prompts/07-veille.md`) ou par la PR du chapitre concerné :
  `crossplane` (+ `crossplane_provider_kubernetes`, `crossplane_provider_helm`, `crossplane_provider_terraform`) pour F3 ;
  `kopf` (ou `shell_operator`) pour F2 ; `kaniko` (ou `buildkit`), `trivy`, `cosign`, `syft` pour F4 ;
  `tempo` (ou `jaeger`) et `alloy` pour F8 ; `ollama` et `k8sgpt` pour F10 ; `opencost` (optionnel) pour F11.
- `labs/profiles/kubernetes-ha.yaml` : la liste `components` ne cite ni `cert_manager` (déjà utilisé par gitops/01 et 02),
  ni `harbor`, `kyverno`, `istio`, `backstage`, `crossplane`, `opentelemetry_collector`. Les ajouter au fil des PR ;
  vérifier le budget RAM (48 Go) quand Backstage, Istio, Harbor et Ollama coexistent (voir §5).
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.2 (cette PR).
- Décision à proposer dans `DECISIONS.md` (hors périmètre de cette PR) : une forge Git avec API et webhooks sur le lab.
  Le dépôt bare SSH de `core-jump01` (DECISIONS.md, 2026-10-02) suffit à F1, F2, F3 ; F4 (déclenchement par webhook),
  F9 (scaffolder Backstage) et S1 ont besoin d'une forge (GitLab 19.x, clé `gitlab` existante, ou Gitea plus léger).
  Même besoin que le scénario CAPA S1 : une seule décision pour les deux.
- Pas de nouvelle décision pour le reste : Gateway API Cilium (DECISIONS.md, 2026-10-02) sert aux expositions TLS de F5 ;
  Helm 4 s'applique à toutes les installations ; le module IA reste en « partie CPU » (DECISIONS.md, 2026-10-02) pour F10.

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe ; `(partiel)` quand une fiche d'un autre domaine
touche la compétence sans la viser. La colonne « chapitre cible » renvoie à la section 4 ; « CAPA F2 » et « CAPA F7 »
renvoient aux chapitres planifiés par `certifs/CAPA/objectifs.md` §4, réutilisés sans doublon.

### CNPA-01 — Platform Engineering Core Fundamentals (36 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPA-01-01 | Declarative Resource Management | 5,1 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (partiel, brouillon) | S2 : Application et AppProject déclaratifs ; S3 : drift, `argocd app diff`, `selfHeal` | F1 (ex. 2) ; socle `kubectl apply` / server-side apply attendu de `kubernetes_deb` (cartographie KCNA/CKA) |
| CNPA-01-02 | DevOps Practices in Platform Engineering | 5,1 % | — | — | F1 |
| CNPA-01-03 | Application Environments and Infrastructure Concepts | 5,1 % | — | — | F1 ; promotion d'environnements dans CAPA F2 |
| CNPA-01-04 | Platform Architecture and Capabilities | 5,1 % | — | — | F1 |
| CNPA-01-05 | Platform Engineering Goals, Objectives, and Approaches | 5,1 % | — | — | F1 |
| CNPA-01-06 | Continuous Integration Fundamentals | 5,1 % | `fiches/gitops/02-argo-workflows-fondamentaux.md` (partiel, brouillon) | S2 : templates, steps, paramètres ; S3 : cycle de vie, limites | F4 |
| CNPA-01-07 | Continuous Delivery and GitOps | 5,1 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S1 : démo, autonome, break-fix repo-server-down ; S3 : sync manuelle/auto, drift, rollback, défi 10 min | couvert ; F4 (ex. 3) relie CI et CD ; CAPA F2 approfondit |

### CNPA-02 — Platform Observability, Security, and Conformance (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPA-02-01 | Observability Fundamentals: Traces, Metrics, Logs, and Events | 4,0 % | — | — | F8 |
| CNPA-02-02 | Secure Service Communication | 4,0 % | — | — | F5 |
| CNPA-02-03 | Policy Engines for Platform Governance | 4,0 % | — | — | F7 |
| CNPA-02-04 | Kubernetes Security Essentials | 4,0 % | `fiches/gitops/02-argo-workflows-fondamentaux.md` (partiel, brouillon) | S2 : break-fix RBAC (`break/gitops/02-argo-workflows-rbac.sh`) | F6 |
| CNPA-02-05 | Security in CI/CD Pipelines | 4,0 % | — | — | F4 |

### CNPA-03 — Continuous Delivery & Platform Engineering (16 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPA-03-01 | Continuous Integration Pipelines Overview | 3,2 % | `fiches/gitops/02-argo-workflows-fondamentaux.md` (partiel, brouillon) | S2 : pipeline `steps` séquentiel / parallèle (`wf-02-pipeline-steps.yaml`), défi 10 min | F4 |
| CNPA-03-02 | Incident Response in Platform Engineering | 3,2 % | — | — | F11 |
| CNPA-03-03 | CI/CD Relationship Fundamentals | 3,2 % | — | — | F4 |
| CNPA-03-04 | GitOps Basics and Workflows | 3,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (brouillon) | S1 à S3 : installation, Application, sync, drift, rollback, 4 break-fix, 3 défis | couvert ; la cartographie CGOA ajoutera la théorie (principes OpenGitOps) |
| CNPA-03-05 | GitOps for Application Environments | 3,2 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (partiel, brouillon) | S2 : AppProject, destinations, break-fix destination-forbidden | F1 (ex. 2) ; CAPA F2 (overlays dev/prod, ApplicationSet) |

### CNPA-04 — Platform APIs and Provisioning Infrastructure (12 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPA-04-01 | Kubernetes Reconciliation Loop | 3,0 % | `fiches/gitops/01-argo-cd-fondamentaux.md` (partiel, brouillon) | S3 : `selfHeal`, drift corrigé par le contrôleur | F2 |
| CNPA-04-02 | APIs for Self-Service Platforms (CRDs) | 3,0 % | — | — | F2 ; F3 (XRD et claims) |
| CNPA-04-03 | Infrastructure Provisioning with Kubernetes | 3,0 % | — | — | F3 |
| CNPA-04-04 | Kubernetes Operator Pattern for Integration | 3,0 % | — | — | F2 |

### CNPA-05 — IDPs and Developer Experience (8 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPA-05-01 | Simplified Access to Platform Capabilities | 2,0 % | — | — | F9 ; F1 (golden path, partiel) |
| CNPA-05-02 | API-Driven Service Catalogs | 2,0 % | — | — | F9 ; F3 (claims comme API de service, partiel) |
| CNPA-05-03 | Developer Portals for Platform Adoption | 2,0 % | — | — | F9 |
| CNPA-05-04 | AI/ML in Platform Automation | 2,0 % | — | — | F10 |

### CNPA-06 — Measuring your Platform (8 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CNPA-06-01 | Platform Efficiency and Team Productivity | 4,0 % | — | — | F11 |
| CNPA-06-02 | DORA Metrics for Platform Initiatives | 4,0 % | — | — | F11 |

### Compétences partagées avec d'autres certifications

CNPA se passe dans le bloc `plateforme_conf` du parcours Golden Kubestronaut (`docs/prerequis.md` §3, jalon « CBA · CNPA »),
après les blocs GitOps, observabilité et réseau. Les fiches ci-dessous citent plusieurs programmes dans leur front matter ;
chaque cartographie concernée reprendra la fiche au lieu d'en créer une autre. Les IDs des autres programmes sont
indicatifs tant que leur cartographie n'est pas faite.

| Chapitre | IDs CNPA | IDs réutilisables (à confirmer par la cartographie du programme) |
|---|---|---|
| F4 CI sécurisée | CNPA-01-06, 02-05, 03-01, 03-03 | CGOA-03-04, CNPE-02-02, CNPE-05-05, CKS (supply chain) |
| F5 mTLS et mesh | CNPA-02-02 | ICA (mTLS, PeerAuthentication, AuthorizationPolicy), CCA (mutual auth, NetworkPolicy L7), CNPE-05-01 |
| F6 sécurité Kubernetes | CNPA-02-04 | KCSA, CKS, KCNA-02-02, CNPE-05-02 |
| F7 Kyverno | CNPA-02-03 | KCA-01-01, 01-03, 02-01, 04-01, 05-01, 05-04, 05-05, 05-06, 06-01 ; CNPE-05-04 |
| F8 observabilité | CNPA-02-01 | PCA (PromQL, Alertmanager), OTCA-01-01, 01-03, 03-01, 03-04 ; KCNA-04-01 |
| F9 Backstage | CNPA-05-01, 05-02, 05-03 | CBA-02-01, 02-02, 02-03, 02-04, 03-02, 03-03 |
| F2, F3 CRD, opérateurs, Crossplane | CNPA-04-01 à 04-04 | CNPE-03-01, 03-02, 03-03, 03-04 ; CKA (CRD, opérateurs) |
| F11 incidents et DORA | CNPA-03-02, 06-01, 06-02 | CNPE-04-02, 04-03 |
| gitops/01 (rédigé) | CNPA-01-07, 03-04, 03-05, 04-01 (partiels) | CAPA-02-01 à 02-03, CGOA-01-xx, 02-03, 02-04 |
| gitops/02 (rédigé) | CNPA-01-06, 03-01 (partiels) | CAPA-01-01, 01-04, CGOA-03-04 |

CNPE (examen pratique, même domaine) réutilisera F2 à F11 comme socle et ajoutera des fiches expert ; sa cartographie
est une session à part.

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de lecture recommandé de leur domaine (DECISIONS.md, 2026-10-02) ; le domaine
`plateforme` n'a aucune fiche au 2026-10-02, les numéros 01 à 08 lui sont attribués ici (la cartographie CBA prendra
les suivants). `securite/` et `observabilite/` reçoivent leurs fiches 01 et 02 ; les cartographies KCSA, KCA, PCA, OTCA
numéroteront la suite.
Tous les chapitres ciblent le profil `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`).
Tant que `lab up kubernetes-ha` n'existe pas, les fiches **débutant** ont pour chemin principal un cluster `kind`
sur une VM du profil `linux-base` (8 vCPU / 16 Go / 180 Go) et gardent `kubernetes-ha` en variante, comme gitops/01 et 02 ;
les fiches confirmé attendent le profil complet. Git du lab : dépôt bare SSH sur `core-jump01` (DECISIONS.md, 2026-10-02),
forge avec API à décider (§2). PKI interne : `core-pki01` (step-ca ou OpenBao PKI).
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.
Le niveau d'une fiche `plateforme` est relatif au domaine : « débutant » suppose déjà `kubernetes_conf` et `gitops_deb`
(`docs/prerequis.md` §2).

### F1 — `fiches/plateforme/01-platform-engineering-fondamentaux.md`

- **Titre** : Platform engineering — capacités, environnements et pratiques DevOps sur le lab
- **Niveau** : débutant (`plateforme_deb`)
- **Couvre** : CNPA-01-02, CNPA-01-03, CNPA-01-04, CNPA-01-05 ; partiels : CNPA-01-01, CNPA-03-05, CNPA-05-01
- **Prérequis** : `kubernetes_conf` (namespaces, quotas, Kustomize), `gitops_deb` via `fiches/gitops/01-argo-cd-fondamentaux.md`
- **Lab** : `kind` sur `linux-base` (chemin principal), variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`, `argo_cd`, `helm`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Cartographier la plateforme du lab avec le modèle de capacités du CNCF Platforms White Paper (compute, réseau, données,
     CI/CD, observabilité, sécurité, portail) : inventaire des profils `core` et `kubernetes-ha`, schéma Mermaid, rédaction d'un ADR
     « plateforme minimale viable » avec objectifs mesurables et périmètre refusé — CNPA-01-04, CNPA-01-05.
  2. Environnements d'application : namespaces `dev` / `staging` / `prod` avec `ResourceQuota`, `LimitRange`, labels de propriété,
     base Kustomize + trois overlays appliqués par trois `Application` Argo CD ; promouvoir une version par PR et observer la
     différence entre environnement, infrastructure et configuration — CNPA-01-03, CNPA-01-01, CNPA-03-05.
  3. Pratiques DevOps appliquées à l'équipe plateforme : trunk-based development, revue de PR, dépôt plateforme vs dépôts
     applicatifs, boucle de feedback, plateforme « as a product » (Team Topologies, golden path) ; chronométrer à la main un cycle
     commit → déploiement, qui servira de référence à F11 — CNPA-01-02, CNPA-01-05, CNPA-05-01.
- **Break-fix** : `break/plateforme/01-quota-bloquant.sh` (`ResourceQuota` trop petit sur `dev`, Pods jamais créés, événements `FailedCreate`).
- **Défi chronométré** : créer un environnement `qa` complet (namespace, quota, overlay, Application synchronisée) en moins de 15 min.

### F2 — `fiches/plateforme/02-crd-operateurs-reconciliation.md`

- **Titre** : CRD et opérateurs — la boucle de réconciliation, de `kubectl` au contrôleur maison
- **Niveau** : débutant (`plateforme_deb`)
- **Couvre** : CNPA-04-01, CNPA-04-02, CNPA-04-04
- **Prérequis** : F1 ; `kubernetes_conf` (API server, RBAC, `kubectl explain`)
- **Lab** : `kind` sur `linux-base` (chemin principal), variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`,
  `cloudnative_pg`, `kopf` (à créer ; alternative `shell_operator`).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Observer la boucle de réconciliation des contrôleurs natifs : Deployment → ReplicaSet → Pod avec `kubectl get -w`,
     supprimer un Pod, modifier `replicas` à la main, lire `status.conditions`, `observedGeneration` et les événements ;
     schéma Mermaid observe → compare → agit — CNPA-04-01.
  2. Écrire une CRD `Database` (schéma OpenAPI, `additionalPrinterColumns`, sous-ressource `status`, deux versions et conversion
     `None`), la publier, créer des objets, les valider avec `kubectl explain`, donner à une équipe le droit de créer des `Database`
     et rien d'autre — CNPA-04-02.
  3. Installer un opérateur existant (CloudNativePG), lire sa réconciliation (`Cluster` → Pods, Secrets, Services), puis écrire
     un mini-contrôleur `kopf` (Python, moins de 80 lignes) qui transforme une `Database` en `Cluster` CloudNativePG ;
     finalizers, idempotence, requeue, statut — CNPA-04-04.
- **Break-fix** : `break/plateforme/02-crd-schema-rejet.sh` (CRD modifiée avec un champ obligatoire, nouveaux objets rejetés,
  contrôleur en erreurs répétées).
- **Défi chronométré** : CRD + contrôleur `kopf` qui crée un ConfigMap par objet, testés, en moins de 15 min.

### F3 — `fiches/plateforme/03-crossplane-provisioning-self-service.md`

- **Titre** : Crossplane — provisionner l'infrastructure par l'API Kubernetes
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPA-04-03 ; partiels : CNPA-04-02, CNPA-05-02
- **Prérequis** : F2 ; `iac_deb` (OpenTofu, module `labs/tofu`) ; `ceph_deb` recommandé (bucket S3 via RGW en variante)
- **Lab** : `kubernetes-ha` ; accès à l'API Proxmox pour l'exercice 3. Clés `versions.yaml` : `crossplane` et ses providers (à créer),
  `opentofu`, `terraform_provider_proxmox`, `cloudnative_pg`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Installer Crossplane, `provider-kubernetes` et `provider-helm`, configurer les `ProviderConfig` ; créer une ressource managée
     `Object` et une `Release`, lire `READY` / `SYNCED`, tracer avec `crossplane beta trace`, supprimer et observer la réconciliation — CNPA-04-03.
  2. Écrire une `CompositeResourceDefinition` `XNamespaceEnv` et sa `Composition` (mode `Pipeline`, `function-patch-and-transform`)
     qui produit namespace, quota, NetworkPolicy default-deny et base de données CloudNativePG ; claim namespacé par équipe ;
     RBAC qui n'autorise que le claim ; comparer avec `kro` `[lecture]` — CNPA-04-02, CNPA-04-03, CNPA-05-02.
  3. Infrastructure hors cluster : `provider-terraform` avec le module `bpg/proxmox` de `labs/tofu` pour créer une VM depuis
     un claim ; comparer avec `tofu apply` direct (état, drift, réconciliation continue) ; Cluster API et Metal3 `[lecture]`.
     Marqué `[non testé]` si la session de rédaction n'a pas d'accès Proxmox — CNPA-04-03.
- **Break-fix** : `break/plateforme/03-crossplane-providerconfig.sh` (secret du `ProviderConfig` invalide, ressources `SYNCED=False`,
  claims jamais `READY`).
- **Défi chronométré** : ajouter un champ `storageGi` à l'XRD et le propager jusqu'au quota en moins de 15 min.

### F4 — `fiches/plateforme/04-ci-pipelines-securisees.md`

- **Titre** : CI sur le lab — pipeline as code, image signée, chaîne jusqu'à Argo CD
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPA-01-06, CNPA-02-05, CNPA-03-01, CNPA-03-03 ; partiel : CNPA-01-07
- **Prérequis** : `fiches/gitops/02-argo-workflows-fondamentaux.md`, `fiches/gitops/01-argo-cd-fondamentaux.md` ; `gitops/07-argo-events`
  (CAPA F7) recommandé pour le déclenchement par webhook ; `kubernetes_conf`
- **Lab** : `kubernetes-ha` + Harbor déployé sur le cluster (à ajouter au profil, §2) ; forge Git à décider (§2), sinon `argo submit`
  manuel. Clés `versions.yaml` : `argo_workflows`, `argo_cd`, `harbor`, `openbao`, `kaniko`/`buildkit`, `trivy`, `cosign`, `syft` (à créer).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Pipeline CI as code : `WorkflowTemplate` clone → tests unitaires → build d'image sans démon (kaniko ou BuildKit rootless) →
     push Harbor avec tag = SHA ; cache, artefacts de test, statut remonté sur le commit ; déclenchement par webhook ou
     manuel — CNPA-01-06, CNPA-03-01.
  2. Sécurité du pipeline : scan Trivy bloquant sur CVE critique, SBOM Syft attachée à l'image, signature cosign (clé dans OpenBao),
     politique Harbor qui refuse les images non signées ou vulnérables, secrets du pipeline via External Secrets, ServiceAccount
     au moindre privilège — CNPA-02-05.
  3. Relation CI → CD : le pipeline commite le nouveau tag dans le dépôt de déploiement, Argo CD synchronise ; tracer une version
     de bout en bout (commit → digest → `Application`) ; comparer push-based et pull-based ; section `[lecture]` vocabulaire
     GitLab CI, GitHub Actions, Tekton, Jenkins pour le QCM — CNPA-03-03, CNPA-01-07.
- **Break-fix** : `break/plateforme/04-ci-image-non-signee.sh` (politique Harbor active, étape de signature retirée, déploiement refusé).
- **Défi chronométré** : ajouter une étape de scan bloquante à un pipeline existant et prouver qu'elle bloque en moins de 15 min.

### F5 — `fiches/plateforme/05-communication-securisee-mtls.md`

- **Titre** : Communication sécurisée entre services — TLS, mutual auth Cilium, mTLS Istio
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPA-02-02
- **Prérequis** : F6 ; `services_deb` (PKI interne `core-pki01`) ; `kubernetes_conf` (Cilium, Gateway API)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `cert_manager`, `cilium`, `istio`, `step_ca`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. TLS nord-sud : `ClusterIssuer` cert-manager sur la CA interne, certificat pour une `HTTPRoute` Gateway API, rotation forcée,
     vérification avec `openssl s_client` et un client qui fait confiance à la CA — CNPA-02-02.
  2. Est-ouest sans mesh : Cilium mutual authentication (identités SPIFFE), `CiliumNetworkPolicy` L7, observation du trafic
     accepté / refusé avec Hubble — CNPA-02-02.
  3. Mesh : Istio ambient (ztunnel), `PeerAuthentication` `STRICT`, `AuthorizationPolicy` par identité, preuve du mTLS entre deux
     services ; comparaison sidecar / ambient / Linkerd `[lecture]` — CNPA-02-02.
- **Break-fix** : `break/plateforme/05-mtls-strict-client-nu.sh` (namespace en `STRICT`, client hors mesh, connexions réinitialisées).
- **Défi chronométré** : passer un namespace en mTLS `STRICT` sans interruption de service en moins de 10 min.

### F6 — `fiches/securite/01-kubernetes-securite-essentiels.md`

- **Titre** : Sécurité Kubernetes — les 4C, RBAC, Pod Security, secrets et NetworkPolicy
- **Niveau** : débutant (`securite_deb`)
- **Couvre** : CNPA-02-04
- **Prérequis** : `linux_deb` ; `kubernetes_deb` (arête nouvelle, justifiée en `docs/prerequis.md` §6.2)
- **Lab** : `kind` sur `linux-base` (chemin principal), variante `kubernetes-ha`. Clés `versions.yaml` : `kubernetes`, `kind`, `cilium`, `openbao`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Les 4C et le contrôle d'accès : `Role` / `ClusterRole` / bindings, `ServiceAccount`, `kubectl auth can-i --as`,
     audit des bindings trop larges, désactivation de l'automontage du token — CNPA-02-04.
  2. Pod Security Admission (`enforce` / `audit` / `warn`, profils `baseline` et `restricted`), `securityContext`
     (`runAsNonRoot`, `readOnlyRootFilesystem`, `capabilities.drop`), Secrets : chiffrement au repos `[lecture]`,
     External Secrets vers OpenBao — CNPA-02-04.
  3. `NetworkPolicy` default-deny par namespace puis autorisations explicites (Cilium), vérification avec Hubble ;
     hygiène d'images (digest, non-root, registre interne) — CNPA-02-04.
- **Break-fix** : `break/securite/01-psa-restricted-bloque.sh` (namespace passé en `restricted`, Deployment refusé, zéro réplica).
- **Défi chronométré** : sécuriser un namespace (RBAC lecture seule, PSA `restricted`, default-deny) en moins de 15 min.

### F7 — `fiches/securite/02-kyverno-politiques-plateforme.md`

- **Titre** : Kyverno — valider, muter, générer : la gouvernance de plateforme par politiques
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CNPA-02-03
- **Prérequis** : F6 ; `kubernetes_conf` (admission, webhooks) ; F4 recommandé pour `verifyImages`
- **Lab** : `kubernetes-ha` (`kind` acceptable). Clés `versions.yaml` : `kyverno`, `helm`, `cosign` (à créer).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer Kyverno en HA (Helm), `ClusterPolicy` `validate` (labels obligatoires, pas de tag `latest`, limites de ressources),
     `validationFailureAction: Audit` puis `Enforce`, lecture des `PolicyReport` — CNPA-02-03.
  2. `mutate` (`securityContext` par défaut, `imagePullSecrets`), `generate` (NetworkPolicy default-deny et quota à la création
     d'un namespace), `verifyImages` (signature cosign de F4) — CNPA-02-03.
  3. Gouvernance : `kyverno apply` et `kyverno test` dans le pipeline (shift-left), `PolicyException`, comparaison
     avec OPA Gatekeeper (Rego) `[lecture]` et `ValidatingAdmissionPolicy` CEL natif (démo courte) — CNPA-02-03.
- **Break-fix** : `break/securite/02-kyverno-webhook-indisponible.sh` (Pods Kyverno arrêtés, `failurePolicy: Fail`, plus aucune création possible).
- **Défi chronométré** : écrire et tester une politique interdisant `hostNetwork` en moins de 10 min.

### F8 — `fiches/observabilite/01-metriques-logs-traces-evenements.md`

- **Titre** : Observabilité — métriques, logs, traces et événements corrélés sur un cluster
- **Niveau** : débutant (`observabilite_deb`)
- **Couvre** : CNPA-02-01
- **Prérequis** : `kubernetes_deb`
- **Lab** : `kind` sur `linux-base` (chemin principal, 8 Go RAM pour la VM), variante `kubernetes-ha`. Clés `versions.yaml` :
  `prometheus`, `grafana`, `loki`, `opentelemetry_collector`, `tempo` (ou `jaeger`) et `alloy` (à créer).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Métriques : kube-prometheus-stack, PromQL de base (`rate`, `histogram_quantile`), `ServiceMonitor` sur une application
     de démonstration, une règle d'alerte, un tableau de bord Grafana — CNPA-02-01.
  2. Logs et événements : Loki + Alloy, LogQL, `kubectl events`, corréler un `OOMKilled` entre événement, logs et métrique mémoire — CNPA-02-01.
  3. Traces : OpenTelemetry Collector (receivers OTLP, processors, exporters), application instrumentée, backend Tempo ou Jaeger,
     suivre une requête sur deux services ; schéma Mermaid des quatre signaux et de leur corrélation — CNPA-02-01.
- **Break-fix** : `break/observabilite/01-servicemonitor-label.sh` (sélecteur de labels faux, cible absente, `up` manquant).
- **Défi chronométré** : trouver la cause d'une latence (trace → service → métrique → log) en moins de 15 min.

### F9 — `fiches/plateforme/06-backstage-portail-catalogue-templates.md`

- **Titre** : Backstage — catalogue, templates et golden path
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPA-05-01, CNPA-05-02, CNPA-05-03
- **Prérequis** : F1, F4 (les templates déclenchent la CI), `fiches/gitops/01-argo-cd-fondamentaux.md` ; F3 recommandé
- **Lab** : `kubernetes-ha` ; forge Git avec API indispensable au scaffolder (§2). Clés `versions.yaml` : `backstage`, `cloudnative_pg`,
  `keycloak`, `gitlab` (ou la forge retenue).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Déployer Backstage (image officielle, PostgreSQL CloudNativePG, OIDC Keycloak), peupler le catalogue (`Component`, `API`,
     `System`, `Resource`, `Group`) depuis le dépôt du lab, plugin Kubernetes pour voir les Pods d'un composant — CNPA-05-02, CNPA-05-03.
  2. Software Template « nouveau service » : crée le dépôt, le `catalog-info.yaml`, l'`Application` Argo CD et le claim Crossplane
     de F3 ; golden path documenté en TechDocs — CNPA-05-01, CNPA-05-02.
  3. Adoption : plugins Argo CD, Kubernetes et TechDocs sur la fiche d'un composant, spécification OpenAPI dans le catalogue,
     scorecard simple ; comparaison `[lecture]` Backstage / Port / Kratix — CNPA-05-03.
- **Break-fix** : `break/plateforme/06-backstage-location-invalide.sh` (`Location` vers un fichier absent, entité orpheline, erreur d'ingestion).
- **Défi chronométré** : enregistrer un composant avec ses liens Argo CD et Kubernetes en moins de 10 min.

### F10 — `fiches/plateforme/07-ia-dans-l-automatisation-plateforme.md`

- **Titre** : IA dans l'automatisation de plateforme — LLM local, diagnostic assisté, modèle servi
- **Niveau** : débutant (`plateforme_deb`)
- **Couvre** : CNPA-05-04
- **Prérequis** : F1 ; F6 ou F7 pour un cluster à diagnostiquer
- **Lab** : `kubernetes-ha`, partie CPU du module IA (DECISIONS.md, 2026-10-02) : 4 Go RAM et 2 vCPU réservés à un modèle de 3 B
  paramètres. Clés `versions.yaml` : `open_webui`, `litellm`, `kserve`, `ollama` et `k8sgpt` (à créer).
- **Temps** : 3 h
- **3 exercices clés** :
  1. Déployer Ollama (CPU) et LiteLLM comme capacité de plateforme : API compatible OpenAI, clés et budget par équipe, Open WebUI — CNPA-05-04.
  2. Diagnostic assisté : `k8sgpt` avec le modèle local sur un cluster cassé par un break-fix de F6 ou F7, comparer avec le
     diagnostic manuel, limites (hallucinations, données sensibles, anonymisation) — CNPA-05-04.
  3. Génération assistée et contrôle : produire une politique Kyverno et un Workflow Argo via LLM, les valider avec `kyverno test`
     et `argo lint` ; servir un petit modèle avec KServe CPU (`InferenceService`) ; AIOps, GPU, MLOps `[lecture]` — CNPA-05-04.
- **Break-fix** : `break/plateforme/07-ollama-oom.sh` (modèle plus gros que la limite mémoire, `OOMKilled` en boucle).
- **Défi chronométré** : diagnostiquer un namespace cassé avec `k8sgpt` puis corriger à la main en moins de 10 min.

### F11 — `fiches/plateforme/08-incidents-dora-mesure-de-la-plateforme.md`

- **Titre** : Réponse à incident et mesure de la plateforme — alertes, postmortem, DORA
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CNPA-03-02, CNPA-06-01, CNPA-06-02
- **Prérequis** : F8 ; `fiches/gitops/01-argo-cd-fondamentaux.md` ; F4 (données de pipeline) ; `gitops/05-argo-rollouts` (CAPA F6) recommandé
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `prometheus`, `grafana`, `argo_cd`, `opencost` (optionnel, à créer).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Réponse à incident : règles Alertmanager sur des symptômes, routage, astreinte simulée, runbook lié à l'alerte, incident
     scripté (break-fix), chronologie, postmortem sans blâme sur gabarit — CNPA-03-02.
  2. DORA : calculer les quatre métriques depuis les données du lab (fréquence de déploiement et lead time via
     `argocd_app_sync_total` et l'historique Git, taux d'échec via rollbacks et `AnalysisRun`, temps de rétablissement via
     Alertmanager), tableau de bord Grafana, interprétation par palier — CNPA-06-02.
  3. Efficacité et productivité : taux d'adoption du golden path, temps d'onboarding d'une équipe, tickets contre self-service,
     coût par namespace (OpenCost `[non testé]` ou `kube-resource-report`), enquête DevEx (cadre SPACE), objectifs et KPI d'une
     initiative plateforme — CNPA-06-01.
- **Break-fix** : `break/plateforme/08-alertmanager-silence-oublie.sh` (silence sans fin sur une alerte critique, incident invisible).
- **Défi chronométré** : de l'alerte au postmortem rédigé en moins de 20 min sur un incident scripté.

### S1 — `scenarios/NN-plateforme-self-service-bout-en-bout/README.md`

- **Titre** : NN — Onboarder une équipe sur la plateforme : du template Backstage au tableau DORA (numéro `NN` attribué à la création)
- **Niveau** : expert (`plateforme_exp`) ; prérequis F1 à F11 complets, plus `gitops/04` et `gitops/05` (CAPA F2, F6) ; pas de saut direct
- **Couvre** : les 27 compétences CNPA en situation, plus CNPE-02-01 à 02-03 et 03-01 à 03-04 (partiels)
- **Lab** : `kubernetes-ha` + `ceph-3n` (RGW pour artefacts et sauvegardes), Harbor, forge Git, Prometheus ; F10 désactivé pour tenir
  le budget RAM. Clés `versions.yaml` : `argo_cd`, `argo_workflows`, `backstage`, `crossplane`, `kyverno`, `istio`, `harbor`,
  `prometheus`, `grafana`.
- **Temps** : 8 h en deux séances
- **Livrable** : ADR « plateforme v1 » + runbook « onboarder une équipe » + tableau DORA sur deux semaines simulées
- **3 exercices clés** :
  1. Onboarding : template Backstage → dépôt, pipeline CI signée, claim Crossplane (namespace, quota, base de données),
     `Application` Argo CD `dev` puis `prod`, politiques Kyverno en `Enforce`, mTLS `STRICT`.
  2. Exploitation : alerte → incident scripté → postmortem ; rejouer deux semaines de commits pour mesurer les quatre métriques DORA.
  3. Break-fix transverse : image non signée, `ProviderConfig` cassé, webhook Kyverno indisponible, silence oublié ;
     diagnostiquer de bout en bout en moins de 30 min.

## 5. Récapitulatif des estimations

| Chapitre | Domaine / niveau | Profil de lab | Partagé avec | Temps |
|---|---|---|---|---|
| F1 Platform engineering fondamentaux | plateforme / débutant | linux-base (kind) ou kubernetes-ha | — | 4 h |
| F2 CRD, opérateurs, réconciliation | plateforme / débutant | linux-base (kind) ou kubernetes-ha | CNPE, CKA | 6 h |
| F3 Crossplane | plateforme / confirmé | kubernetes-ha (+ API Proxmox) | CNPE | 6 h |
| F4 CI sécurisée | plateforme / confirmé | kubernetes-ha + Harbor | CNPE, CKS | 6 h |
| F5 mTLS et mesh | plateforme / confirmé | kubernetes-ha | ICA, CCA | 5 h |
| F6 Sécurité Kubernetes essentiels | securite / débutant | linux-base (kind) ou kubernetes-ha | KCSA, CKS | 5 h |
| F7 Kyverno | securite / confirmé | kubernetes-ha | KCA | 5 h |
| F8 Observabilité | observabilite / débutant | linux-base (kind) ou kubernetes-ha | PCA, OTCA | 5 h |
| F9 Backstage | plateforme / confirmé | kubernetes-ha + forge Git | CBA | 6 h |
| F10 IA dans l'automatisation | plateforme / débutant | kubernetes-ha (CPU) | — | 3 h |
| F11 Incidents et DORA | plateforme / confirmé | kubernetes-ha | CNPE | 5 h |
| S1 Onboarding bout en bout | scénario / expert | kubernetes-ha + ceph-3n | CNPE | 8 h |
| Révision (flashcards, quiz, examen blanc `exams/`) | — | — | — | 6 h |
| **Total** | | | | **70 h** |

Dont 26 h de fiches partagées (F5, F6, F7, F8, F9) qui comptent aussi pour ICA, KCSA, KCA, PCA/OTCA et CBA :
le coût propre à CNPA est de 44 h. À 5 h par semaine, compter 14 semaines si tout est fait d'un bloc,
9 semaines si les fiches partagées ont été faites dans les blocs précédents du parcours Golden Kubestronaut
(`docs/prerequis.md` §3 : observabilité et sécurité avant plateforme), ce qui est l'ordre prévu.
Cohérent avec un cycle de 4 à 6 semaines pour le bloc « CBA · CNPA » de `docs/roadmap.md` §7 si CBA réutilise F9.

Budget RAM à surveiller sur `kubernetes-ha` (48 Go, dont 30 Go de workers) : kube-prometheus-stack + Loki + Tempo
(≈ 6 Go), Istio ambient (≈ 2 Go), Harbor (≈ 4 Go), Backstage + PostgreSQL (≈ 2 Go), Crossplane + providers (≈ 1,5 Go),
Kyverno HA (≈ 1,5 Go), Ollama 3 B (≈ 4 Go). Tout ensemble passe, sans marge pour les applications ; S1 désactive F10.
Ces ordres de grandeur sont à mesurer dans chaque fiche (`budget_lab` du gabarit), pas à recopier.

## 6. Ce que le lab ne couvre pas

- Rien n'est `[lecture + simulation]` pour du matériel : tout tourne sur `kubernetes-ha` CPU.
- Marqués `[lecture]` dans les fiches, parce que le QCM les cite sans qu'un outil de plus apporte de la pratique :
  Tekton, Jenkins, GitHub Actions et GitLab CI (vocabulaire CI, F4) ; OPA Gatekeeper et Rego (F7) ; Linkerd et sidecars Istio (F5) ;
  Port, Kratix (F9) ; Cluster API, Metal3, `kro` (F3) ; AIOps et GPU (F10) ; cadres SPACE et modèles de maturité (F11).
- Fournisseurs de cloud public (comptes AWS/GCP/Azure, Crossplane providers cloud, Karpenter) : non praticables sur le lab ;
  les noms sont à connaître pour le QCM et figurent dans les flashcards de F3.
- L'examen est un QCM sans documentation (`examen.md`) : les flashcards de chaque fiche (`revision/flashcards/`) et le quiz
  `revision/quiz/` sont la préparation directe ; les manipulations servent la rétention et préparent CNPE.
