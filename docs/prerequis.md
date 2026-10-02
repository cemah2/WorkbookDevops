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

### 6.2 CKAD (certifs/CKAD/objectifs.md, 2026-10-02)

Treize fiches `kubernetes` (sept débutant, six confirmé) et un scénario. `fiches/kubernetes/` était vide : ces nœuds forment
le contenu de `kubernetes_deb` et de `kubernetes_conf`, partagé avec CKA et KCNA (la cartographie CKA réutilise les nœuds
communs et prend les numéros suivants). Arêtes inter-domaines nouvelles, justifiées dans `certifs/CKAD/objectifs.md` §4 :
`securite_deb` ⇢ K8 (capabilities, seccomp côté hôte), `ceph_deb` ⇢ K5 (variante CSI Rook),
K11 → `gitops/04-argo-cd-helm-kustomize-reconciliation` (Argo CD rend des sources Helm/Kustomize, il faut les connaître avant).

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
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

  k1["kubernetes/01-kubectl-pods-namespaces (déb.)"]:::plan
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
| `kubernetes/01-kubectl-pods-namespaces` | débutant | planifié | CKAD-01-02 (Pods), 03-03, 03-04 ; KCNA-01-01 | `linux_conf`, `reseau_deb` |
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
