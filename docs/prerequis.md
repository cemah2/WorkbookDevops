# Graphe de prérequis entre chapitres

Les nœuds de référence sont des **domaines × niveaux** (§2). Les chapitres planifiés par une cartographie de
certification apparaissent en §6 sous la forme `<domaine>/<slug>` et sont rattachés aux nœuds de référence.
Chaque chapitre rédigé s'y rattache par son front matter (`domaine`, `niveau`, `prerequis`) et ajoute
ses propres arêtes. Règle de `CLAUDE.md` : jamais de saut direct débutant → expert.

## 1. Domaines

| Domaine | Clé | Noyau / extension | Certifications principales |
|---|---|---|---|
| Linux | `linux` | noyau | LFCS, RHCSA, RHCE |
| Réseau | `reseau` | noyau | CCA, CKA, COA |
| Proxmox / KVM | `proxmox` | noyau | — (socle du lab) |
| Ceph | `ceph` | noyau | COA (stockage), CKA (CSI) |
| Kubernetes | `kubernetes` | noyau | KCNA, CKA, CKAD, CKS, CCA, ICA, KCA |
| Infrastructure as code | `iac` | noyau | TFA, RHCE (Ansible) |
| GitOps | `gitops` | noyau | CGOA, CAPA |
| Observabilité | `observabilite` | noyau | PCA, OTCA |
| Sécurité | `securite` | noyau | KCSA, CKS, VA, KCA |
| Sauvegarde et données | `sauvegarde` | noyau | CKA (Velero, CSI), COA |
| OpenStack | `openstack` | extension | COA |
| Services de base (DNS, PKI, IdP, NTP, NetBox) | `services` | extension | RHCE, LFCS |
| Plateforme (mesh, Backstage, opérateurs, Kafka, IA sur CPU) | `plateforme` | extension | ICA, CBA, CNPA, CNPE |

## 2. Graphe domaines × niveaux

Convention des nœuds : `<domaine>_<niveau>` avec `deb` (débutant), `conf` (confirmé), `exp` (expert).
Arête pleine = prérequis obligatoire ; arête pointillée = recommandé.

```mermaid
flowchart TB
  classDef deb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20
  classDef conf fill:#fff8e1,stroke:#f9a825,color:#6d4c00
  classDef exp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f

  subgraph L1[Débutant]
    direction LR
    linux_deb[Linux]:::deb
    reseau_deb[Réseau]:::deb
    proxmox_deb[Proxmox / KVM]:::deb
    iac_deb[IaC]:::deb
    kubernetes_deb[Kubernetes]:::deb
    ceph_deb[Ceph]:::deb
    gitops_deb[GitOps]:::deb
    observabilite_deb[Observabilité]:::deb
    securite_deb[Sécurité]:::deb
    sauvegarde_deb[Sauvegarde]:::deb
    services_deb[Services de base]:::deb
    openstack_deb[OpenStack]:::deb
    plateforme_deb[Plateforme]:::deb
  end

  subgraph L2[Confirmé]
    direction LR
    linux_conf[Linux]:::conf
    reseau_conf[Réseau]:::conf
    proxmox_conf[Proxmox / KVM]:::conf
    iac_conf[IaC]:::conf
    kubernetes_conf[Kubernetes]:::conf
    ceph_conf[Ceph]:::conf
    gitops_conf[GitOps]:::conf
    observabilite_conf[Observabilité]:::conf
    securite_conf[Sécurité]:::conf
    sauvegarde_conf[Sauvegarde]:::conf
    services_conf[Services de base]:::conf
    openstack_conf[OpenStack]:::conf
    plateforme_conf[Plateforme]:::conf
  end

  subgraph L3[Expert]
    direction LR
    linux_exp[Linux]:::exp
    reseau_exp[Réseau]:::exp
    proxmox_exp[Proxmox / KVM]:::exp
    iac_exp[IaC]:::exp
    kubernetes_exp[Kubernetes]:::exp
    ceph_exp[Ceph]:::exp
    gitops_exp[GitOps]:::exp
    observabilite_exp[Observabilité]:::exp
    securite_exp[Sécurité]:::exp
    sauvegarde_exp[Sauvegarde]:::exp
    services_exp[Services de base]:::exp
    openstack_exp[OpenStack]:::exp
    plateforme_exp[Plateforme]:::exp
  end

  %% Progression intra-domaine (jamais de saut débutant -> expert)
  linux_deb --> linux_conf --> linux_exp
  reseau_deb --> reseau_conf --> reseau_exp
  proxmox_deb --> proxmox_conf --> proxmox_exp
  iac_deb --> iac_conf --> iac_exp
  kubernetes_deb --> kubernetes_conf --> kubernetes_exp
  ceph_deb --> ceph_conf --> ceph_exp
  gitops_deb --> gitops_conf --> gitops_exp
  observabilite_deb --> observabilite_conf --> observabilite_exp
  securite_deb --> securite_conf --> securite_exp
  sauvegarde_deb --> sauvegarde_conf --> sauvegarde_exp
  services_deb --> services_conf --> services_exp
  openstack_deb --> openstack_conf --> openstack_exp
  plateforme_deb --> plateforme_conf --> plateforme_exp

  %% Prérequis inter-domaines, niveau débutant
  linux_deb --> reseau_deb
  linux_deb --> proxmox_deb
  linux_deb --> iac_deb
  reseau_deb --> proxmox_deb
  proxmox_deb --> kubernetes_deb
  linux_conf --> kubernetes_deb
  reseau_deb --> kubernetes_deb
  linux_conf --> ceph_deb
  proxmox_deb --> ceph_deb
  kubernetes_deb --> gitops_deb
  iac_deb --> gitops_deb
  kubernetes_deb --> observabilite_deb
  linux_deb --> securite_deb
  linux_deb --> sauvegarde_deb
  linux_conf --> services_deb
  reseau_conf --> services_deb
  linux_conf --> openstack_deb
  reseau_conf --> openstack_deb
  proxmox_conf --> openstack_deb
  ceph_deb -.-> openstack_deb
  kubernetes_conf --> plateforme_deb
  gitops_deb --> plateforme_deb

  %% Prérequis inter-domaines, niveaux confirmé et expert
  reseau_conf --> kubernetes_conf
  ceph_conf -.-> kubernetes_conf
  kubernetes_conf --> securite_conf
  services_deb --> securite_conf
  kubernetes_conf --> sauvegarde_conf
  ceph_conf --> sauvegarde_conf
  observabilite_conf --> plateforme_conf
  securite_conf --> plateforme_conf
  iac_conf --> openstack_conf
  reseau_exp -.-> openstack_exp
  securite_exp -.-> plateforme_exp
  proxmox_exp -.-> reseau_exp
```

## 3. Parcours nommés

Chaque parcours est une suite ordonnée de nœuds du graphe, fermée par des jalons d'examen (voir `docs/roadmap.md` §7).
Le détail chapitre par chapitre sera ajouté quand les chapitres existeront.

```mermaid
flowchart LR
  subgraph P1[Parcours Kubestronaut]
    direction LR
    k1[linux_deb] --> k2[reseau_deb] --> k3[kubernetes_deb] --> k4[kubernetes_conf] --> k5[securite_conf] --> k6[kubernetes_exp]
    k3 -. KCNA .-> k4
    k4 -. CKA · CKAD .-> k5
    k5 -. KCSA · CKS .-> k6
  end
```

```mermaid
flowchart LR
  subgraph P2[Parcours Golden Kubestronaut]
    direction LR
    g0[Kubestronaut] --> g1[linux_conf] --> g2[gitops_conf] --> g3[observabilite_conf] --> g4[reseau_conf] --> g5[plateforme_conf] --> g6[plateforme_exp]
    g1 -. LFCS .-> g2
    g2 -. CGOA · CAPA .-> g3
    g3 -. PCA · OTCA .-> g4
    g4 -. CCA · ICA · KCA .-> g5
    g5 -. CBA · CNPA .-> g6
    g6 -. CNPE .-> g6
  end
```

```mermaid
flowchart LR
  subgraph P3[Parcours Cloud privé OpenStack]
    direction LR
    o1[linux_conf] --> o2[reseau_conf] --> o3[proxmox_conf] --> o4[ceph_conf] --> o5[iac_conf] --> o6[openstack_deb] --> o7[openstack_conf] --> o8[openstack_exp]
    o1 -. RHCSA · RHCE .-> o2
    o5 -. TFA .-> o6
    o7 -. COA .-> o8
  end
```

```mermaid
flowchart LR
  subgraph P4[Parcours Plateforme SecNumCloud]
    direction LR
    s1[securite_deb] --> s2[services_conf] --> s3[securite_conf] --> s4[sauvegarde_conf] --> s5[observabilite_conf] --> s6[securite_exp] --> s7[plateforme_exp]
    s2 -. VA .-> s3
    s3 -. KCSA · CKS .-> s4
    s6 -. "exigence → contrôle → preuve (OpenSCAP, ANSSI, NIS2, HDS)" .-> s7
  end
```

## 4. Tableau de correspondance parcours → certifications

| Parcours | Domaines traversés | Certifications (ordre de passage) | Durée de validité à surveiller |
|---|---|---|---|
| Kubestronaut | linux, reseau, kubernetes, securite | KCNA → CKA → CKAD → KCSA → CKS | CKA/CKAD/CKS : 2 ans |
| Golden Kubestronaut | + linux, gitops, observabilite, reseau, plateforme | LFCS → PCA → OTCA → CGOA → CAPA → CCA → ICA → KCA → CBA → CNPA → CNPE | tout valide en même temps |
| Cloud privé OpenStack | linux, reseau, proxmox, ceph, iac, openstack | RHCSA → RHCE → TFA → COA | RHCSA/RHCE : 3 ans |
| Plateforme SecNumCloud | securite, services, sauvegarde, observabilite, plateforme | VA → KCSA → CKS (+ conformité outillée, sans certification) | — |

## 5. Règles d'édition du graphe

- Un chapitre ajoute ses nœuds sous la forme `<domaine>/<slug>` et ne relie que des nœuds existants.
- Une cartographie de certification (`prompts/01-cartographie-certification.md`) ajoute ses chapitres **planifiés**
  en §6 avec le statut `planifié` ; la PR du chapitre passe le nœud en `rédigé` et déplace ses arêtes si besoin.
- Une arête inter-domaines nouvelle se justifie en une ligne dans la PR du chapitre.
- Le graphe est régénéré, pas retouché à la main, dès qu'un script `scripts/prerequis.py` existera (à créer).

## 6. Chapitres planifiés par certification

Nœuds `<domaine>/<slug>` ajoutés par les cartographies. Statut `planifié` tant que le chapitre n'existe pas,
`rédigé` ensuite (le nœud prend la couleur de son niveau).
Arête pleine = prérequis obligatoire ; arête pointillée = recommandé.

### 6.1 CAPA (certifs/CAPA/objectifs.md, 2026-10-02)

Sept fiches `gitops` et un scénario. Arêtes inter-domaines nouvelles, justifiées dans `certifs/CAPA/objectifs.md` §4 :
`observabilite_deb` → Argo Rollouts (AnalysisTemplate Prometheus), `ceph_deb` ⇢ Argo Workflows artefacts (bucket S3 via RGW).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef deb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20
  classDef plan fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  kubernetes_deb[kubernetes_deb]:::ref
  kubernetes_conf[kubernetes_conf]:::ref
  iac_deb[iac_deb]:::ref
  gitops_deb[gitops_deb]:::ref
  gitops_conf[gitops_conf]:::ref
  gitops_exp[gitops_exp]:::ref
  observabilite_deb[observabilite_deb]:::ref
  ceph_deb[ceph_deb]:::ref

  argocd_fond["gitops/01-argo-cd-fondamentaux (déb., rédigé)"]:::deb
  argocd_helm["gitops/04-argo-cd-helm-kustomize-reconciliation (conf.)"]:::plan
  wf_fond["gitops/02-argo-workflows-fondamentaux (déb., rédigé)"]:::deb
  wf_art["gitops/03-argo-workflows-artefacts-templates-dag (conf.)"]:::plan
  wf_data["gitops/06-argo-workflows-traitement-de-donnees (conf.)"]:::plan
  rollouts["gitops/05-argo-rollouts (conf.)"]:::plan
  events["gitops/07-argo-events (conf.)"]:::plan
  s_argo["scenarios/NN-chaine-argo-bout-en-bout (exp.)"]:::planexp

  %% rattachement aux nœuds de référence
  kubernetes_deb --> gitops_deb
  iac_deb --> gitops_deb
  gitops_deb --> argocd_fond
  gitops_deb --> wf_fond
  kubernetes_conf --> argocd_helm
  kubernetes_conf --> rollouts
  kubernetes_conf --> events
  observabilite_deb --> rollouts
  ceph_deb -.-> wf_art

  %% progression intra-domaine (jamais déb. -> exp.)
  argocd_fond --> argocd_helm
  argocd_fond --> rollouts
  wf_fond --> wf_art --> wf_data
  wf_fond --> events
  argocd_helm --> gitops_conf
  wf_data --> gitops_conf
  rollouts --> gitops_conf
  events --> gitops_conf
  gitops_conf --> s_argo --> gitops_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `gitops/01-argo-cd-fondamentaux` | débutant | rédigé (brouillon) | CAPA-02-01 à 02-03, CGOA-01-02 à 01-06, 01-09, 02-03, 02-04 | `kubernetes_deb`, `iac_deb` |
| `gitops/04-argo-cd-helm-kustomize-reconciliation` | confirmé | planifié | CAPA-02-04, 02-05 | `gitops/01-argo-cd-fondamentaux`, `kubernetes_conf` |
| `gitops/02-argo-workflows-fondamentaux` | débutant | rédigé (brouillon) | CAPA-01-01, 01-04, CGOA-03-04 | `kubernetes_deb` ; `gitops/01-argo-cd-fondamentaux` recommandé |
| `gitops/03-argo-workflows-artefacts-templates-dag` | confirmé | planifié | CAPA-01-02, 01-03, 01-05 | `gitops/02-argo-workflows-fondamentaux`, `ceph_deb` (recommandé) |
| `gitops/06-argo-workflows-traitement-de-donnees` | confirmé | planifié | CAPA-01-06 | `gitops/03-argo-workflows-artefacts-templates-dag` |
| `gitops/05-argo-rollouts` | confirmé | planifié | CAPA-03-01 à 03-03 | `gitops/01-argo-cd-fondamentaux`, `observabilite_deb`, `kubernetes_conf` |
| `gitops/07-argo-events` | confirmé | planifié | CAPA-04-01, 04-02 | `gitops/02-argo-workflows-fondamentaux`, `kubernetes_conf` |
| `scenarios/NN-chaine-argo-bout-en-bout` | expert | planifié | CAPA (16 compétences), CGOA-04-01 à 04-04 | les sept fiches ci-dessus |

### 6.2 CNPA (certifs/CNPA/objectifs.md, 2026-10-02)

Huit fiches `plateforme`, deux fiches `securite`, une fiche `observabilite` et un scénario. Cinq fiches sont partagées
avec ICA, KCSA, KCA, PCA/OTCA et CBA (`certifs/CNPA/objectifs.md` §3). Arêtes inter-domaines nouvelles, justifiées dans
`certifs/CNPA/objectifs.md` §4 : `kubernetes_deb` → sécurité Kubernetes essentiels (RBAC et PSA supposent l'API Kubernetes,
le graphe de référence ne relie `securite_deb` qu'à `linux_deb`) ; `iac_deb` → Crossplane (comparaison avec OpenTofu, module
`labs/tofu`) ; `services_deb` → mTLS (PKI interne `core-pki01`) ; `observabilite_deb` → incidents et DORA (Alertmanager, PromQL).
Les fiches CAPA `gitops/04`, `gitops/05` et `gitops/07` sont des prérequis recommandés (pointillés).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef plandeb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20,stroke-dasharray: 4 2
  classDef plan fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  kubernetes_deb[kubernetes_deb]:::ref
  kubernetes_conf[kubernetes_conf]:::ref
  gitops_deb[gitops_deb]:::ref
  iac_deb[iac_deb]:::ref
  services_deb[services_deb]:::ref
  securite_deb[securite_deb]:::ref
  securite_conf[securite_conf]:::ref
  observabilite_deb[observabilite_deb]:::ref
  plateforme_deb[plateforme_deb]:::ref
  plateforme_conf[plateforme_conf]:::ref
  plateforme_exp[plateforme_exp]:::ref

  argocd_fond["gitops/01-argo-cd-fondamentaux (déb., rédigé)"]:::ref
  wf_fond["gitops/02-argo-workflows-fondamentaux (déb., rédigé)"]:::ref
  capa_f2["gitops/04 · 05 · 07 (CAPA, conf., planifiés)"]:::ref

  pf01["plateforme/01-platform-engineering-fondamentaux (déb.)"]:::plandeb
  pf02["plateforme/02-crd-operateurs-reconciliation (déb.)"]:::plandeb
  pf03["plateforme/03-crossplane-provisioning-self-service (conf.)"]:::plan
  pf04["plateforme/04-ci-pipelines-securisees (conf.)"]:::plan
  pf05["plateforme/05-communication-securisee-mtls (conf.)"]:::plan
  pf06["plateforme/06-backstage-portail-catalogue-templates (conf.)"]:::plan
  pf07["plateforme/07-ia-dans-l-automatisation-plateforme (déb.)"]:::plandeb
  pf08["plateforme/08-incidents-dora-mesure-de-la-plateforme (conf.)"]:::plan
  sec01["securite/01-kubernetes-securite-essentiels (déb.)"]:::plandeb
  sec02["securite/02-kyverno-politiques-plateforme (conf.)"]:::plan
  obs01["observabilite/01-metriques-logs-traces-evenements (déb.)"]:::plandeb
  s_pf["scenarios/NN-plateforme-self-service-bout-en-bout (exp.)"]:::planexp

  %% rattachement aux nœuds de référence
  kubernetes_conf --> plateforme_deb
  gitops_deb --> plateforme_deb
  argocd_fond --> plateforme_deb
  plateforme_deb --> pf01
  plateforme_deb --> pf02
  plateforme_deb --> pf07
  kubernetes_deb --> obs01
  kubernetes_deb --> sec01
  securite_deb --> sec01
  kubernetes_conf --> sec02
  iac_deb --> pf03
  services_deb --> pf05
  kubernetes_conf --> pf05
  observabilite_deb --> pf08
  wf_fond --> pf04
  argocd_fond --> pf04
  argocd_fond --> pf08
  capa_f2 -.-> pf04
  capa_f2 -.-> pf08
  capa_f2 -.-> s_pf

  %% progression intra-domaine (jamais déb. -> exp.)
  pf01 --> pf02 --> pf03
  pf01 --> pf04
  pf01 --> pf07
  pf04 --> pf06
  pf03 -.-> pf06
  sec01 --> sec02
  sec01 --> pf05
  sec02 -.-> pf04
  obs01 --> pf08
  pf04 --> pf08
  obs01 --> observabilite_deb
  sec01 --> securite_deb
  sec02 --> securite_conf
  pf03 --> plateforme_conf
  pf04 --> plateforme_conf
  pf05 --> plateforme_conf
  pf06 --> plateforme_conf
  pf08 --> plateforme_conf
  plateforme_conf --> s_pf --> plateforme_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `plateforme/01-platform-engineering-fondamentaux` | débutant | planifié | CNPA-01-02 à 01-05 ; partiels 01-01, 03-05, 05-01 | `plateforme_deb` (`kubernetes_conf`, `gitops/01-argo-cd-fondamentaux`) |
| `plateforme/02-crd-operateurs-reconciliation` | débutant | planifié | CNPA-04-01, 04-02, 04-04 ; CNPE-03-01, 03-03 | `plateforme/01`, `kubernetes_conf` |
| `plateforme/03-crossplane-provisioning-self-service` | confirmé | planifié | CNPA-04-03 ; partiels 04-02, 05-02 ; CNPE-03-02, 03-04 | `plateforme/02`, `iac_deb` ; `ceph_deb` recommandé |
| `plateforme/04-ci-pipelines-securisees` | confirmé | planifié | CNPA-01-06, 02-05, 03-01, 03-03 ; partiel 01-07 ; CNPE-02-02, 05-05 | `gitops/02-argo-workflows-fondamentaux`, `gitops/01`, `plateforme/01`, `kubernetes_conf` ; `gitops/07-argo-events` et `securite/02` recommandés |
| `plateforme/05-communication-securisee-mtls` | confirmé | planifié | CNPA-02-02 ; ICA, CCA, CNPE-05-01 | `securite/01`, `services_deb`, `kubernetes_conf` |
| `plateforme/06-backstage-portail-catalogue-templates` | confirmé | planifié | CNPA-05-01 à 05-03 ; CBA-02-xx, 03-02, 03-03 | `plateforme/01`, `plateforme/04`, `gitops/01` ; `plateforme/03` recommandé |
| `plateforme/07-ia-dans-l-automatisation-plateforme` | débutant | planifié | CNPA-05-04 | `plateforme/01` ; `securite/01` ou `securite/02` pour un cluster à diagnostiquer |
| `plateforme/08-incidents-dora-mesure-de-la-plateforme` | confirmé | planifié | CNPA-03-02, 06-01, 06-02 ; CNPE-04-02, 04-03 | `observabilite/01`, `gitops/01`, `plateforme/04` ; `gitops/05-argo-rollouts` recommandé |
| `securite/01-kubernetes-securite-essentiels` | débutant | planifié | CNPA-02-04 ; KCSA, CKS, KCNA-02-02 | `securite_deb` (`linux_deb`), `kubernetes_deb` |
| `securite/02-kyverno-politiques-plateforme` | confirmé | planifié | CNPA-02-03 ; KCA-01-xx, 02-01, 04-01, 05-01, 05-04 à 05-06, 06-01 | `securite/01`, `kubernetes_conf` ; `plateforme/04` recommandé |
| `observabilite/01-metriques-logs-traces-evenements` | débutant | planifié | CNPA-02-01 ; PCA, OTCA-01-xx, 03-01, 03-04, KCNA-04-01 | `kubernetes_deb` |
| `scenarios/NN-plateforme-self-service-bout-en-bout` | expert | planifié | CNPA (27 compétences), CNPE-02-xx, 03-xx partiels | les onze fiches ci-dessus, `gitops/04` et `gitops/05` (CAPA) |
