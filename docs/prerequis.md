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

Nœuds `<domaine>/<slug>` ajoutés par les cartographies (6.1 CAPA, 6.2 CNPE). Statut `planifié` tant que le chapitre n'existe pas,
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

### 6.2 CNPE (certifs/CNPE/objectifs.md, 2026-10-02)

Quatorze fiches confirmé réparties sur cinq domaines et deux scénarios expert. CNPE est l'examen pratique de la filière
plateforme : il ne planifie aucune fiche débutant et s'appuie sur les nœuds `*_deb` des autres certifications
(PCA/OTCA, KCA, ICA, CBA, CKA/CKS) et sur les chapitres CAPA de §6.1 (F2, F6, F7, S1).
Les chemins `NN` sont numérotés à la PR du chapitre (numéro suivant de la série du domaine), sauf `gitops/08` et `09`
qui prolongent la série fixée par CAPA. Arêtes inter-domaines nouvelles, justifiées dans `certifs/CNPE/objectifs.md` §4 :
`iac_conf` → Crossplane (provider OpenTofu vers Proxmox), `services_deb` → identité et RBAC (Keycloak OIDC),
`ceph_deb` ⇢ multi-tenancy et observabilité (StorageClass, stockage persistant).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef plan fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  kubernetes_conf[kubernetes_conf]:::ref
  reseau_conf[reseau_conf]:::ref
  iac_conf[iac_conf]:::ref
  gitops_deb[gitops_deb]:::ref
  gitops_conf[gitops_conf]:::ref
  observabilite_deb[observabilite_deb]:::ref
  observabilite_conf[observabilite_conf]:::ref
  securite_deb[securite_deb]:::ref
  securite_conf[securite_conf]:::ref
  services_deb[services_deb]:::ref
  ceph_deb[ceph_deb]:::ref
  plateforme_deb[plateforme_deb]:::ref
  plateforme_conf[plateforme_conf]:::ref
  plateforme_exp[plateforme_exp]:::ref

  argocd_fond["gitops/01-argo-cd-fondamentaux (déb., rédigé)"]:::ref
  wf_fond["gitops/02-argo-workflows-fondamentaux (déb., rédigé)"]:::ref

  p1["kubernetes/NN-multi-tenancy-quotas-isolation (conf.)"]:::plan
  p2["plateforme/NN-opencost-dimensionnement-autoscaling (conf.)"]:::plan
  p3["gitops/08-flux-et-flagger (conf.)"]:::plan
  p4["gitops/09-tekton-pipelines-securisees (conf.)"]:::plan
  p5["plateforme/NN-crd-conception-validation-cel (conf.)"]:::plan
  p6["plateforme/NN-operateurs-kubernetes (conf.)"]:::plan
  p7["plateforme/NN-crossplane-self-service (conf.)"]:::plan
  p8["plateforme/NN-backstage-scaffolder-self-service (conf.)"]:::plan
  p9["observabilite/NN-pile-observabilite-plateforme (conf.)"]:::plan
  p10["observabilite/NN-slo-dora-indicateurs-plateforme (conf.)"]:::plan
  p11["securite/NN-identite-rbac-plateforme-oidc (conf.)"]:::plan
  p12["securite/NN-mtls-service-a-service (conf.)"]:::plan
  p13["securite/NN-admission-kyverno-gatekeeper-vap (conf.)"]:::plan
  p14["securite/NN-sbom-signature-conformite (conf.)"]:::plan
  s1["scenarios/NN-plateforme-interne-bout-en-bout (exp.)"]:::planexp
  s2["scenarios/NN-astreinte-plateforme-incidents (exp.)"]:::planexp

  %% rattachement aux nœuds de référence
  kubernetes_conf --> p1
  reseau_conf --> p1
  ceph_deb -.-> p1
  observabilite_deb --> p2
  argocd_fond --> p3
  kubernetes_conf --> p3
  observabilite_deb --> p3
  wf_fond --> p4
  kubernetes_conf --> p4
  kubernetes_conf --> p5
  gitops_deb --> p5
  kubernetes_conf --> p6
  iac_conf --> p7
  services_deb -.-> p8
  observabilite_deb --> p9
  kubernetes_conf --> p9
  ceph_deb -.-> p9
  securite_deb --> p11
  kubernetes_conf --> p11
  services_deb --> p11
  plateforme_deb --> p12
  reseau_conf --> p12
  securite_deb --> p13

  %% progression intra-série (jamais déb. -> exp.)
  p1 --> p2
  p3 --> p7
  p3 --> p10
  p4 --> p10
  p4 --> p14
  p5 --> p6
  p5 --> p7
  p5 --> p13
  p6 --> p7
  p7 --> p8
  p9 --> p10
  p9 --> p12
  p1 --> p11
  p11 --> p14
  p13 --> p14

  %% sortie vers les nœuds de référence et scénarios
  p1 --> kubernetes_conf
  p3 --> gitops_conf
  p4 --> gitops_conf
  p9 --> observabilite_conf
  p10 --> observabilite_conf
  p11 --> securite_conf
  p12 --> securite_conf
  p13 --> securite_conf
  p14 --> securite_conf
  p2 --> plateforme_conf
  p8 --> plateforme_conf
  gitops_conf --> s1
  observabilite_conf --> s1
  securite_conf --> s1
  plateforme_conf --> s1
  s1 --> s2
  s1 --> plateforme_exp
  s2 --> plateforme_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `kubernetes/NN-multi-tenancy-quotas-isolation` | confirmé | planifié | CNPE-01-01, 01-03 | `kubernetes_conf`, `reseau_conf` ; `ceph_deb` recommandé |
| `plateforme/NN-opencost-dimensionnement-autoscaling` | confirmé | planifié | CNPE-01-02, 01-03 | P1, `observabilite_deb` |
| `gitops/08-flux-et-flagger` | confirmé | planifié | CNPE-02-01, 02-03 | `gitops/01-argo-cd-fondamentaux`, `kubernetes_conf`, `observabilite_deb` |
| `gitops/09-tekton-pipelines-securisees` | confirmé | planifié | CNPE-02-02, 05-05 | `gitops/02-argo-workflows-fondamentaux`, `kubernetes_conf` ; P3 ou `gitops/01` |
| `plateforme/NN-crd-conception-validation-cel` | confirmé | planifié | CNPE-03-01 | `kubernetes_conf`, `gitops_deb` |
| `plateforme/NN-operateurs-kubernetes` | confirmé | planifié | CNPE-03-03 | P5, `kubernetes_conf` ; `sauvegarde_deb` recommandé |
| `plateforme/NN-crossplane-self-service` | confirmé | planifié | CNPE-03-02, 03-04 | P5, P6, P3 ou `gitops/01`, `iac_conf` |
| `plateforme/NN-backstage-scaffolder-self-service` | confirmé | planifié | CNPE-03-04, 03-02 | P7 ; `services_deb` recommandé ; partagé avec CBA |
| `observabilite/NN-pile-observabilite-plateforme` | confirmé | planifié | CNPE-04-01 | `observabilite_deb`, `kubernetes_conf` ; `ceph_deb` recommandé |
| `observabilite/NN-slo-dora-indicateurs-plateforme` | confirmé | planifié | CNPE-04-02 | P9, P3, P4 |
| `securite/NN-identite-rbac-plateforme-oidc` | confirmé | planifié | CNPE-05-02, 05-03 | `securite_deb`, `kubernetes_conf`, `services_deb`, P1 |
| `securite/NN-mtls-service-a-service` | confirmé | planifié | CNPE-05-01 | `plateforme_deb` (Istio, fiche ICA à venir), `reseau_conf`, P9 |
| `securite/NN-admission-kyverno-gatekeeper-vap` | confirmé | planifié | CNPE-05-04 | `securite_deb` (Kyverno, fiche KCA à venir), P5 |
| `securite/NN-sbom-signature-conformite` | confirmé | planifié | CNPE-05-03, 05-05 | P4, P13, P11 |
| `scenarios/NN-plateforme-interne-bout-en-bout` | expert | planifié | CNPE (18 compétences) | P1 à P14 ; `gitops_conf`, `observabilite_conf`, `securite_conf`, `plateforme_conf` |
| `scenarios/NN-astreinte-plateforme-incidents` | expert | planifié | CNPE-04-03 | S1 (ou au minimum P3, P4, P6, P9, P11, P13) |
