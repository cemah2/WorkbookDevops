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

### 6.2 CGOA (certifs/CGOA/objectifs.md, 2026-10-02)

Cinq fiches `gitops` numérotées `08` à `12`, à la suite des sept fiches CAPA (la `08` est rédigée, brouillon) ; la révision
(quiz, examen blanc) et le scénario expert sont partagés avec CAPA. Arêtes inter-domaines nouvelles, justifiées dans
`certifs/CGOA/objectifs.md` §4 :
`iac_deb` → G4 (OpenTofu et Ansible pilotés par Git), `securite_deb` ⇢ G4 (Kyverno, cosign, sops),
`observabilite_deb` → G5 (métriques et alertes des moteurs GitOps), `ceph_deb` ⇢ G2 (`Bucket` Flux sur RGW).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef deb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20
  classDef plandeb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20,stroke-dasharray: 4 2
  classDef plan fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  kubernetes_deb[kubernetes_deb]:::ref
  kubernetes_conf[kubernetes_conf]:::ref
  iac_deb[iac_deb]:::ref
  gitops_deb[gitops_deb]:::ref
  gitops_conf[gitops_conf]:::ref
  gitops_exp[gitops_exp]:::ref
  observabilite_deb[observabilite_deb]:::ref
  securite_deb[securite_deb]:::ref
  ceph_deb[ceph_deb]:::ref

  argocd_fond["gitops/01-argo-cd-fondamentaux (déb., rédigé, CAPA)"]:::deb
  wf_fond["gitops/02-argo-workflows-fondamentaux (déb., rédigé, CAPA)"]:::deb
  argocd_helm["gitops/04-argo-cd-helm-kustomize-reconciliation (conf., CAPA)"]:::plan
  g1["gitops/08-opengitops-principes-et-vocabulaire (déb., rédigé)"]:::deb
  g2["gitops/09-flux-fondamentaux (déb.)"]:::plandeb
  g3["gitops/10-architectures-gitops-depots-reconciliateurs (conf.)"]:::plan
  g4["gitops/11-pratiques-associees-iac-cac-devsecops (conf.)"]:::plan
  g5["gitops/12-notifications-observabilite-ci (conf.)"]:::plan
  s_argo["scenarios/NN-chaine-argo-bout-en-bout (exp., CAPA)"]:::planexp

  %% rattachement aux nœuds de référence
  kubernetes_deb --> gitops_deb
  iac_deb --> gitops_deb
  gitops_deb --> argocd_fond
  gitops_deb --> wf_fond
  gitops_deb --> g1
  kubernetes_conf --> g3
  kubernetes_conf --> g4
  kubernetes_conf --> g5
  iac_deb --> g4
  securite_deb -.-> g4
  observabilite_deb --> g5
  ceph_deb -.-> g2

  %% progression intra-domaine (jamais déb. -> exp.)
  argocd_fond --> g1
  argocd_fond --> g2
  g1 -.-> g2
  argocd_fond --> argocd_helm
  g2 --> g3
  argocd_helm --> g3
  g2 --> g4
  wf_fond --> g4
  g2 --> g5
  wf_fond --> g5
  g3 --> gitops_conf
  g4 --> gitops_conf
  g5 --> gitops_conf
  gitops_conf --> s_argo --> gitops_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `gitops/08-opengitops-principes-et-vocabulaire` | débutant | rédigé (brouillon) | CGOA-01-01, 01-06, 01-07, 01-08, 02-01, 02-02 (+ consolidation CGOA-01-02 à 01-05, 01-09, 02-03, 02-04) | `gitops/01-argo-cd-fondamentaux`, `gitops_deb` ; `iac_deb` recommandé |
| `gitops/09-flux-fondamentaux` | débutant | planifié | CGOA-05-03, 05-02, 05-01, 01-05, 01-07, 02-03, 02-04 | `gitops/01-argo-cd-fondamentaux`, `kubernetes_deb` ; `gitops/08-…` et `ceph_deb` recommandés |
| `gitops/10-architectures-gitops-depots-reconciliateurs` | confirmé | planifié | CGOA-04-04, 04-03, 04-01, 01-07, 05-02, CAPA-02-05 | `gitops/09-flux-fondamentaux`, `gitops/04-argo-cd-helm-kustomize-reconciliation`, `kubernetes_conf` |
| `gitops/11-pratiques-associees-iac-cac-devsecops` | confirmé | planifié | CGOA-03-01, 03-02, 03-03 | `gitops/09-flux-fondamentaux`, `gitops/02-argo-workflows-fondamentaux`, `iac_deb`, `kubernetes_conf` ; `securite_deb` recommandé |
| `gitops/12-notifications-observabilite-ci` | confirmé | planifié | CGOA-05-04, 01-08, 03-04, CAPA-02-02 | `gitops/09-flux-fondamentaux`, `gitops/02-argo-workflows-fondamentaux`, `observabilite_deb`, `kubernetes_conf` |

Les nœuds CAPA cités (`01`, `02`, `04`, scénario) sont définis en §6.1 ; leurs IDs CGOA y sont confirmés par `certifs/CGOA/objectifs.md` §3.

### 6.3 CBA (certifs/CBA/objectifs.md, 2026-10-02)

Cinq fiches `plateforme` et un scénario. Première cartographie du domaine : la série `fiches/plateforme/NN-` démarre
à `01`. Arêtes inter-domaines nouvelles, justifiées ici : `linux_deb` → premier lancement et `iac_deb` → premier lancement
(Backstage est une application Node.js lancée sur une VM, versionnée dans Git ; les deux fiches débutant n'ont pas besoin
de Kubernetes). L'arête de référence `kubernetes_conf` → `plateforme_deb` de §2 reste valable pour le reste du domaine
(mesh, opérateurs) et n'est pas retirée. `kubernetes_conf` → configuration et production (déploiement sur `kubernetes-ha`) ;
`services_deb` ⇢ ingestion automatisée et ⇢ configuration et production (Keycloak du socle `core`, recommandé).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef plandeb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20,stroke-dasharray: 4 2
  classDef plan fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  linux_deb[linux_deb]:::ref
  iac_deb[iac_deb]:::ref
  kubernetes_conf[kubernetes_conf]:::ref
  services_deb[services_deb]:::ref
  gitops_deb[gitops_deb]:::ref
  observabilite_conf[observabilite_conf]:::ref
  securite_conf[securite_conf]:::ref
  plateforme_deb[plateforme_deb]:::ref
  plateforme_conf[plateforme_conf]:::ref
  plateforme_exp[plateforme_exp]:::ref

  bs_lancement["plateforme/01-backstage-premier-lancement (déb.)"]:::plandeb
  bs_catalogue["plateforme/02-backstage-catalogue (déb.)"]:::plandeb
  bs_plugins["plateforme/03-backstage-plugins-et-personnalisation (conf.)"]:::plan
  bs_ingestion["plateforme/04-backstage-ingestion-automatisee (conf.)"]:::plan
  bs_prod["plateforme/05-backstage-configuration-et-production (conf.)"]:::plan
  s_portail["scenarios/NN-portail-developpeur-backstage (exp.)"]:::planexp

  %% rattachement aux nœuds de référence
  linux_deb --> bs_lancement
  iac_deb --> bs_lancement
  plateforme_deb --> bs_lancement
  kubernetes_conf --> bs_prod
  services_deb -.-> bs_ingestion
  services_deb -.-> bs_prod
  gitops_deb --> s_portail
  observabilite_conf --> s_portail
  securite_conf --> s_portail

  %% progression intra-domaine (jamais déb. -> exp.)
  bs_lancement --> bs_catalogue
  bs_catalogue --> bs_plugins
  bs_plugins --> bs_ingestion
  bs_plugins --> bs_prod
  bs_ingestion --> plateforme_conf
  bs_prod --> plateforme_conf
  plateforme_conf --> s_portail --> plateforme_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `plateforme/01-backstage-premier-lancement` | débutant | planifié | CBA-01-01 à 01-04, 03-01, 03-04 | `linux_deb`, `iac_deb` |
| `plateforme/02-backstage-catalogue` | débutant | planifié | CBA-02-01 à 02-05, CNPA-05-02 | `plateforme/01-backstage-premier-lancement` |
| `plateforme/03-backstage-plugins-et-personnalisation` | confirmé | planifié | CBA-04-01 à 04-04 (+ 01-02, 01-03) | `plateforme/01-…`, `plateforme/02-…` |
| `plateforme/04-backstage-ingestion-automatisee` | confirmé | planifié | CBA-02-05, 02-06, CNPA-05-02 | `plateforme/02-…`, `plateforme/03-…`, `services_deb` (recommandé) |
| `plateforme/05-backstage-configuration-et-production` | confirmé | planifié | CBA-01-03, 01-05, 03-02, 03-03, CNPA-05-03 | `plateforme/01-…`, `plateforme/03-…`, `kubernetes_conf`, `services_deb` (recommandé) |
| `scenarios/NN-portail-developpeur-backstage` | expert | planifié | CBA (19 compétences), CNPA-05-01 à 05-03, CNPE-03-02, 03-04 | les cinq fiches ci-dessus, `gitops/01-argo-cd-fondamentaux`, `observabilite_conf`, `securite_conf` |

### 6.4 ICA (certifs/ICA/objectifs.md, 2026-10-02)

Huit fiches `plateforme` (numéros 06 à 13, à la suite des cinq fiches Backstage de la cartographie CBA, §6.3), un scénario
et un examen blanc (`exams/ica-01/`, hors graphe). Aucun chapitre rédigé au 2026-10-02.
Arêtes inter-domaines nouvelles, justifiées dans `certifs/ICA/objectifs.md` §4 :
`securite_deb` ⇢ sécurité mTLS/JWT (TLS, certificats, JWT), `services_deb` ⇢ TLS en bordure (CA interne, cert-manager),
`observabilite_deb` ⇢ troubleshooting (Prometheus, lecture de métriques Istio), `gitops_deb` ⇢ personnalisation et
mises à jour (valeurs Helm dans Git), `gitops/05-argo-rollouts` ⇢ scénario (moteur de canary, si la fiche CAPA existe).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef plandeb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20,stroke-dasharray: 4 2
  classDef plan fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  kubernetes_conf[kubernetes_conf]:::ref
  gitops_deb[gitops_deb]:::ref
  plateforme_deb[plateforme_deb]:::ref
  plateforme_conf[plateforme_conf]:::ref
  plateforme_exp[plateforme_exp]:::ref
  securite_deb[securite_deb]:::ref
  services_deb[services_deb]:::ref
  observabilite_deb[observabilite_deb]:::ref
  rollouts["gitops/05-argo-rollouts (conf., planifié CAPA)"]:::plan

  i06["plateforme/06-istio-installation-sidecar-ambient (déb.)"]:::plandeb
  i07["plateforme/07-istio-ingress-et-routage (déb.)"]:::plandeb
  i08["plateforme/08-istio-traffic-shifting-resilience-fault-injection (conf.)"]:::plan
  i09["plateforme/09-istio-services-externes-et-egress (conf.)"]:::plan
  i10["plateforme/10-istio-securite-mtls-jwt-autorisation (conf.)"]:::plan
  i11["plateforme/11-istio-tls-en-bordure (conf.)"]:::plan
  i12["plateforme/12-istio-personnalisation-et-mises-a-jour (conf.)"]:::plan
  i13["plateforme/13-istio-troubleshooting (conf.)"]:::plan
  s_mesh["scenarios/NN-service-mesh-bout-en-bout (exp.)"]:::planexp

  %% rattachement aux nœuds de référence
  kubernetes_conf --> plateforme_deb
  gitops_deb --> plateforme_deb
  plateforme_deb --> i06
  securite_deb -.-> i10
  services_deb -.-> i11
  observabilite_deb -.-> i13
  gitops_deb -.-> i12
  rollouts -.-> s_mesh

  %% progression intra-domaine (jamais déb. -> exp.)
  i06 --> i07
  i07 --> i08
  i07 --> i09
  i07 --> i10
  i10 --> i11
  i06 --> i12
  i07 --> i12
  i08 --> i13
  i09 --> i13
  i10 --> i13
  i11 --> i13
  i12 --> i13
  i13 --> plateforme_conf
  plateforme_conf --> s_mesh --> plateforme_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `plateforme/06-istio-installation-sidecar-ambient` | débutant | planifié | ICA-01-01, 01-02, 01-03 ; KCSA-05-04 | `plateforme_deb` (donc `kubernetes_conf`) |
| `plateforme/07-istio-ingress-et-routage` | débutant | planifié | ICA-02-01, 02-02, 02-03 ; CKA-03-04, CCA-03-01 à 03-03 | `plateforme/06-…` |
| `plateforme/08-istio-traffic-shifting-resilience-fault-injection` | confirmé | planifié | ICA-02-04, 02-06, 02-07 | `plateforme/07-…` |
| `plateforme/09-istio-services-externes-et-egress` | confirmé | planifié | ICA-02-05, 02-01 (egress) | `plateforme/07-…` |
| `plateforme/10-istio-securite-mtls-jwt-autorisation` | confirmé | planifié | ICA-03-01, 03-02 ; CKS-04-04, KCSA-05-04 | `plateforme/07-…` ; `securite_deb` recommandé |
| `plateforme/11-istio-tls-en-bordure` | confirmé | planifié | ICA-03-03 ; CKA-03-04 | `plateforme/10-…` ; `services_deb` recommandé |
| `plateforme/12-istio-personnalisation-et-mises-a-jour` | confirmé | planifié | ICA-01-03, 01-04 | `plateforme/06-…`, `plateforme/07-…` ; `gitops_deb` recommandé |
| `plateforme/13-istio-troubleshooting` | confirmé | planifié | ICA-04-01 à 04-03 | `plateforme/08-…` à `12-…` ; `observabilite_deb` recommandé |
| `scenarios/NN-service-mesh-bout-en-bout` | expert | planifié | ICA (17 compétences), CKS-04-04, CKA-03-04 ; CAPA-03-02 si Argo Rollouts | les huit fiches ci-dessus ; `gitops/05-argo-rollouts` recommandé |

### 6.5 CCA (certifs/CCA/objectifs.md, 2026-10-02)

Sept fiches `reseau` (numéros `10` à `16`, les `01` à `09` restant aux fiches `reseau_deb`) et un scénario ; la fiche 10 est rédigée (brouillon).
Aucune fiche Cilium au niveau débutant : `reseau_deb` est un prérequis de `kubernetes_deb`, dont Cilium a besoin.
Arêtes inter-domaines nouvelles, justifiées dans `certifs/CCA/objectifs.md` §2 et §4 : `kubernetes_deb` → Cilium installation
(cluster existant, kubectl, Services) ; `linux_conf` ⇢ IPAM/datapath/eBPF (namespaces réseau, `nft`, `tcpdump`) ;
`securite_deb` ⇢ Network Policy (moindre privilège) ; `observabilite_deb` ⇢ Hubble (Prometheus, Grafana) ;
`services_deb` ⇢ Gateway API (PKI interne, DNS `*.apps.lab.home.arpa`) ; `proxmox_conf` ⇢ BGP (OPNsense `core-rtr01`, plugin FRR).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef conf fill:#fff8e1,stroke:#f9a825,color:#6d4c00
  classDef plan fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  reseau_deb[reseau_deb]:::ref
  reseau_conf[reseau_conf]:::ref
  reseau_exp[reseau_exp]:::ref
  kubernetes_deb[kubernetes_deb]:::ref
  linux_conf[linux_conf]:::ref
  securite_deb[securite_deb]:::ref
  observabilite_deb[observabilite_deb]:::ref
  services_deb[services_deb]:::ref
  proxmox_conf[proxmox_conf]:::ref

  cil_install["reseau/10-cilium-installation-architecture (conf., rédigé)"]:::conf
  cil_datapath["reseau/11-cilium-ipam-datapath-ebpf (conf.)"]:::plan
  cil_policy["reseau/12-cilium-network-policy (conf.)"]:::plan
  cil_hubble["reseau/13-cilium-hubble-observabilite (conf.)"]:::plan
  cil_gateway["reseau/14-cilium-gateway-api-service-mesh (conf.)"]:::plan
  cil_bgp["reseau/15-cilium-bgp-egress-gateway (exp.)"]:::planexp
  cil_mesh["reseau/16-cilium-cluster-mesh (exp.)"]:::planexp
  s_cilium["scenarios/NN-plateforme-reseau-cilium (exp.)"]:::planexp

  %% rattachement aux nœuds de référence
  reseau_deb --> cil_install
  kubernetes_deb --> cil_install
  linux_conf -.-> cil_datapath
  securite_deb -.-> cil_policy
  observabilite_deb -.-> cil_hubble
  services_deb -.-> cil_gateway
  proxmox_conf -.-> cil_bgp

  %% progression intra-domaine (jamais déb. -> exp.)
  cil_install --> cil_datapath
  cil_install --> cil_policy
  cil_policy --> cil_hubble
  cil_hubble --> cil_gateway
  cil_datapath --> cil_gateway
  cil_datapath --> reseau_conf
  cil_policy --> reseau_conf
  cil_hubble --> reseau_conf
  cil_gateway --> reseau_conf
  reseau_conf --> cil_bgp
  reseau_conf --> cil_mesh
  cil_bgp -.-> cil_mesh
  cil_bgp --> s_cilium
  cil_mesh --> s_cilium
  s_cilium --> reseau_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `reseau/10-cilium-installation-architecture` | confirmé | rédigé (brouillon) | CCA-01-01, 01-02, 01-04, 05-01, 05-02 | `reseau_deb`, `kubernetes_deb` |
| `reseau/11-cilium-ipam-datapath-ebpf` | confirmé | planifié | CCA-01-03, 01-05, 07-01 à 07-03 | `reseau/10-cilium-installation-architecture`, `linux_conf` (recommandé) |
| `reseau/12-cilium-network-policy` | confirmé | planifié | CCA-02-01 à 02-05 | `reseau/10-cilium-installation-architecture`, `securite_deb` (recommandé) |
| `reseau/13-cilium-hubble-observabilite` | confirmé | planifié | CCA-04-01 à 04-03 | `reseau/12-cilium-network-policy`, `observabilite_deb` (recommandé) |
| `reseau/14-cilium-gateway-api-service-mesh` | confirmé | planifié | CCA-03-01 à 03-05 | `reseau/12-cilium-network-policy`, `reseau/13-cilium-hubble-observabilite`, `reseau/11-cilium-ipam-datapath-ebpf`, `services_deb` (recommandé) |
| `reseau/15-cilium-bgp-egress-gateway` | expert | planifié | CCA-08-01, 08-02 | `reseau_conf` (les quatre fiches confirmé), `proxmox_conf` (recommandé) |
| `reseau/16-cilium-cluster-mesh` | expert | planifié | CCA-06-01, 06-02 | `reseau_conf`, `reseau/15-cilium-bgp-egress-gateway` (recommandé) |
| `scenarios/NN-plateforme-reseau-cilium` | expert | planifié | CCA (28 compétences), CKA-03-02, 03-04, CKS-01-01, 04-04 (à confirmer) | les sept fiches ci-dessus |

### 6.6 CKAD (certifs/CKAD/objectifs.md, 2026-10-02)

Treize fiches `kubernetes` (sept débutant, six confirmé) et un scénario ; la première est rédigée (brouillon, 2026-10-02). Ces nœuds forment
le contenu de `kubernetes_deb` et de `kubernetes_conf`, partagé avec CKA et KCNA (la cartographie CKA réutilise les nœuds
communs et prend les numéros suivants). Arêtes inter-domaines nouvelles, justifiées dans `certifs/CKAD/objectifs.md` §4 :
`securite_deb` ⇢ K8 (capabilities, seccomp côté hôte), `ceph_deb` ⇢ K5 (variante CSI Rook),
K11 → `gitops/04-argo-cd-helm-kustomize-reconciliation` (Argo CD rend des sources Helm/Kustomize, il faut les connaître avant).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef deb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20
  classDef plan fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20,stroke-dasharray: 4 2
  classDef planconf fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  linux_deb[linux_deb]:::ref
  linux_conf[linux_conf]:::ref
  reseau_deb[reseau_deb]:::ref
  reseau_conf[reseau_conf]:::ref
  kubernetes_deb[kubernetes_deb]:::ref
  kubernetes_conf[kubernetes_conf]:::ref
  kubernetes_exp[kubernetes_exp]:::ref
  securite_deb[securite_deb]:::ref
  ceph_deb[ceph_deb]:::ref
  argocd_helm["gitops/04-argo-cd-helm-kustomize-reconciliation (conf., §6.1)"]:::ref

  k1["kubernetes/01-kubectl-pods-namespaces (déb., rédigé)"]:::deb
  k2["kubernetes/02-images-conteneurs-podman (déb.)"]:::plan
  k3["kubernetes/03-workloads-deployment-daemonset-job-cronjob (déb.)"]:::plan
  k5["kubernetes/05-pods-multi-conteneurs-volumes (déb.)"]:::plan
  k6["kubernetes/06-configmaps-secrets-serviceaccounts-rbac (déb.)"]:::plan
  k7["kubernetes/07-requests-limits-quotas-limitrange (déb.)"]:::plan
  k4["kubernetes/04-rolling-update-blue-green-canary (conf.)"]:::planconf
  k8["kubernetes/08-securite-applicative-securitycontext-admission (conf.)"]:::planconf
  k9["kubernetes/09-probes-monitoring-logs-debugging (conf.)"]:::planconf
  k10["kubernetes/10-crd-operateurs-deprecations-api (conf.)"]:::planconf
  k11["kubernetes/11-helm-kustomize (conf.)"]:::planconf
  k12["kubernetes/12-services-dns-ingress (conf.)"]:::planconf
  k13["kubernetes/13-networkpolicies (conf.)"]:::planconf
  s_shop["scenarios/NN-lab-shop-de-l-image-au-canary (exp.)"]:::planexp

  %% rattachement aux nœuds de référence
  linux_conf --> kubernetes_deb
  reseau_deb --> kubernetes_deb
  kubernetes_deb --> k1
  kubernetes_deb --> k2
  linux_deb --> k2
  k1 -.-> k2
  securite_deb -.-> k8
  ceph_deb -.-> k5
  reseau_conf --> k12
  reseau_conf --> k13

  %% progression intra-domaine (jamais déb. -> exp.)
  k1 --> k3
  k3 --> k5
  k3 --> k6
  k3 --> k7
  k3 --> k12
  k6 --> k12
  k12 --> k4
  k12 --> k13
  k6 --> k8
  k7 --> k8
  k5 --> k9
  k6 --> k9
  k7 --> k9
  k12 --> k9
  k6 --> k10
  k9 --> k10
  k4 --> k11
  k6 --> k11
  k4 --> kubernetes_conf
  k8 --> kubernetes_conf
  k9 --> kubernetes_conf
  k10 --> kubernetes_conf
  k11 --> kubernetes_conf
  k13 --> kubernetes_conf
  k11 --> argocd_helm
  kubernetes_conf --> s_shop --> kubernetes_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `kubernetes/01-kubectl-pods-namespaces` | débutant | rédigé (brouillon) | CKAD-01-02 (Pods), 03-03, 03-04 ; CKA-02-04, 04-04, KCNA-01-01 | `linux_conf`, `reseau_deb` |
| `kubernetes/02-images-conteneurs-podman` | débutant | planifié | CKAD-01-01 ; CKS-05-01, KCNA-01-04 | `linux_deb` ; K1 recommandé |
| `kubernetes/03-workloads-deployment-daemonset-job-cronjob` | débutant | planifié | CKAD-01-02 ; CKA-02-04 | K1 |
| `kubernetes/05-pods-multi-conteneurs-volumes` | débutant | planifié | CKAD-01-03, 01-04 ; CKA-01-02, 01-03 | K3 ; `ceph_deb` recommandé (variante Rook) |
| `kubernetes/06-configmaps-secrets-serviceaccounts-rbac` | débutant | planifié | CKAD-04-02 (partiel), 04-05, 04-06, 04-07 ; CKA-02-02, CKS-02-01, 02-02, 04-02 | K3 |
| `kubernetes/07-requests-limits-quotas-limitrange` | débutant | planifié | CKAD-04-03, 04-04 ; CKA-02-05 | K3 |
| `kubernetes/04-rolling-update-blue-green-canary` | confirmé | planifié | CKAD-02-01, 02-02 ; CKA-02-01 | K3, K12 |
| `kubernetes/08-securite-applicative-securitycontext-admission` | confirmé | planifié | CKAD-04-02 (admission), 04-08 ; CKS-03-04, 04-01 | K6, K7 ; `securite_deb` recommandé |
| `kubernetes/09-probes-monitoring-logs-debugging` | confirmé | planifié | CKAD-03-02 à 03-05 ; CKA-04 | K5, K6, K7, K12 |
| `kubernetes/10-crd-operateurs-deprecations-api` | confirmé | planifié | CKAD-03-01, 04-01 | K6, K9 |
| `kubernetes/11-helm-kustomize` | confirmé | planifié | CKAD-02-03, 02-04 ; CAPA-02-04 (prépare `gitops/04`) | K4, K6 |
| `kubernetes/12-services-dns-ingress` | confirmé | planifié | CKAD-05-02, 05-03 ; CKA-03-03, 03-05, 03-06, CKS-01-03 | K3, K6, `reseau_conf` |
| `kubernetes/13-networkpolicies` | confirmé | planifié | CKAD-05-01 ; CKA-03-02, CKS-01-01 | K12, `reseau_conf` |
| `scenarios/NN-lab-shop-de-l-image-au-canary` | expert | planifié | CKAD (24 compétences) ; CKA-02-01, 03-02, 03-03, CKS-04-01, 05-01 | les treize fiches ci-dessus |
