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

### 6.2 CKA (certifs/CKA/objectifs.md, 2026-10-02)

Douze fiches `kubernetes`, un scénario et un examen blanc. Aucune fiche `kubernetes` n'existe au 2026-10-02 ; les deux fiches `gitops`
rédigées couvrent partiellement cinq compétences CKA (RBAC, NodePort, Gateway API en variante, logs, limites) et sont citées comme
prérequis **recommandés** de K7, K9 et K10. Arêtes inter-domaines nouvelles, justifiées dans `certifs/CKA/objectifs.md` §4 :
`ceph_deb` ⇢ K4 (variante Rook-Ceph sur `ceph-3n`), `iac_deb` ⇢ K5 (`lab up kubernetes-ha` sans Kubernetes, rôle Ansible de préparation
des nœuds). Les arêtes `linux_conf` → K5/K11 et `reseau_conf` → K5/K9 précisent les arêtes de référence déjà présentes en §2.

```mermaid
flowchart TB
  classDef ref fill:#eceff1,stroke:#546e7a,color:#263238
  classDef plandeb fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20,stroke-dasharray: 4 2
  classDef plan fill:#fff8e1,stroke:#f9a825,color:#6d4c00,stroke-dasharray: 4 2
  classDef planexp fill:#fbe9e7,stroke:#d84315,color:#7f2a0f,stroke-dasharray: 4 2

  linux_conf[linux_conf]:::ref
  reseau_deb[reseau_deb]:::ref
  reseau_conf[reseau_conf]:::ref
  proxmox_deb[proxmox_deb]:::ref
  iac_deb[iac_deb]:::ref
  ceph_deb[ceph_deb]:::ref
  kubernetes_deb[kubernetes_deb]:::ref
  kubernetes_conf[kubernetes_conf]:::ref
  kubernetes_exp[kubernetes_exp]:::ref
  gitops01["gitops/01-argo-cd-fondamentaux (rédigé)"]:::ref
  gitops02["gitops/02-argo-workflows-fondamentaux (rédigé)"]:::ref

  k1["kubernetes/01-kubectl-pods-deployments (déb.)"]:::plandeb
  k2["kubernetes/02-configuration-probes-ressources (déb.)"]:::plandeb
  k3["kubernetes/03-services-endpoints-coredns (déb.)"]:::plandeb
  k4["kubernetes/04-stockage-pv-pvc-storageclass (déb.)"]:::plandeb
  k5["kubernetes/05-kubeadm-cluster-ha (conf.)"]:::plan
  k6["kubernetes/06-cycle-de-vie-etcd-upgrade (conf.)"]:::plan
  k7["kubernetes/07-rbac-comptes-de-service (conf.)"]:::plan
  k8["kubernetes/08-ordonnancement-admission-autoscaling (conf.)"]:::plan
  k9["kubernetes/09-network-policies-gateway-api-ingress (conf.)"]:::plan
  k10["kubernetes/10-helm-kustomize-crd-operateurs (conf.)"]:::plan
  k11["kubernetes/11-depannage-noeuds-control-plane (conf.)"]:::plan
  k12["kubernetes/12-depannage-applications-reseau (conf.)"]:::plan
  s_k8s["scenarios/NN-cluster-kubeadm-de-zero-a-l-exploitation (exp.)"]:::planexp
  e_cka["exams/cka-blanc-01 (conf. → exp.)"]:::planexp

  %% rattachement aux nœuds de référence (socle débutant)
  linux_conf --> k1
  reseau_deb --> k1
  proxmox_deb --> k1
  k1 --> k2
  k1 --> k3
  k1 --> k4
  ceph_deb -.-> k4
  k2 --> kubernetes_deb
  k3 --> kubernetes_deb
  k4 --> kubernetes_deb

  %% niveau confirmé (jamais déb. -> exp.)
  kubernetes_deb --> k5
  reseau_conf --> k5
  iac_deb -.-> k5
  k5 --> k6
  k5 --> k7
  gitops02 -.-> k7
  k5 --> k8
  k5 --> k9
  gitops01 -.-> k9
  k5 --> k10
  gitops01 -.-> k10
  gitops02 -.-> k10
  k6 --> k11
  k9 --> k12
  k11 --> k12
  k7 --> kubernetes_conf
  k8 --> kubernetes_conf
  k10 --> kubernetes_conf
  k12 --> kubernetes_conf

  %% expert
  kubernetes_conf --> e_cka
  kubernetes_conf --> s_k8s --> kubernetes_exp
```

| Nœud | Niveau | Statut | Certifications | Prérequis |
|---|---|---|---|---|
| `kubernetes/01-kubectl-pods-deployments` | débutant | planifié | CKA-02-01 (+ 04-04 bases) ; CKAD-01-02, 02-02, 03-03 | `linux_conf`, `reseau_deb`, `proxmox_deb` |
| `kubernetes/02-configuration-probes-ressources` | débutant | planifié | CKA-02-02, 02-04 ; CKAD-03-02, 04-05, 04-06 | `kubernetes/01-kubectl-pods-deployments` |
| `kubernetes/03-services-endpoints-coredns` | débutant | planifié | CKA-03-01, 03-03, 03-06 ; CKAD-05-02 | `kubernetes/01-kubectl-pods-deployments`, `reseau_deb` |
| `kubernetes/04-stockage-pv-pvc-storageclass` | débutant | planifié | CKA-01-01 à 01-03 ; CKAD-01-04 | `kubernetes/01-kubectl-pods-deployments` ; `ceph_deb` recommandé |
| `kubernetes/05-kubeadm-cluster-ha` | confirmé | planifié | CKA-05-02, 05-03, 05-05, 05-07 | K1 à K4 (`kubernetes_deb`), `linux_conf`, `reseau_conf` ; `iac_deb` recommandé |
| `kubernetes/06-cycle-de-vie-etcd-upgrade` | confirmé | planifié | CKA-05-04 (+ 04-02) ; CKS-02-04 | `kubernetes/05-kubeadm-cluster-ha` |
| `kubernetes/07-rbac-comptes-de-service` | confirmé | planifié | CKA-05-01 ; CKAD-04-02, 04-07 ; CKS-02-01 à 02-03 | `kubernetes/05-kubeadm-cluster-ha` ; `gitops/02-argo-workflows-fondamentaux` recommandé |
| `kubernetes/08-ordonnancement-admission-autoscaling` | confirmé | planifié | CKA-02-03, 02-05 ; CKAD-04-03, 04-04 | `kubernetes/02-configuration-probes-ressources`, `kubernetes/05-kubeadm-cluster-ha` |
| `kubernetes/09-network-policies-gateway-api-ingress` | confirmé | planifié | CKA-03-02, 03-04, 03-05 ; CKAD-05-01, 05-03 ; CKS-01-01, 01-03 | `kubernetes/03-services-endpoints-coredns`, `kubernetes/05-kubeadm-cluster-ha`, `reseau_conf` ; `gitops/01-argo-cd-fondamentaux` recommandé |
| `kubernetes/10-helm-kustomize-crd-operateurs` | confirmé | planifié | CKA-05-06, 05-07, 05-08 ; CKAD-02-03, 02-04, 03-01, 04-01 | `kubernetes/04-stockage-pv-pvc-storageclass`, `kubernetes/05-kubeadm-cluster-ha` ; fiches `gitops` recommandées |
| `kubernetes/11-depannage-noeuds-control-plane` | confirmé | planifié | CKA-04-01 à 04-03 | `kubernetes/05-kubeadm-cluster-ha`, `kubernetes/06-cycle-de-vie-etcd-upgrade`, `linux_conf` |
| `kubernetes/12-depannage-applications-reseau` | confirmé | planifié | CKA-04-04, 04-05 ; CKAD-03-04, 03-05 | `kubernetes/03-services-endpoints-coredns`, `kubernetes/09-network-policies-gateway-api-ingress`, `kubernetes/11-depannage-noeuds-control-plane` |
| `scenarios/NN-cluster-kubeadm-de-zero-a-l-exploitation` | expert | planifié | CKA (25 compétences) | les douze fiches ci-dessus (`kubernetes_conf`), `ceph-3n` levé |
| `exams/cka-blanc-01` | confirmé → expert | planifié | échantillon pondéré des 25 compétences CKA | `kubernetes_conf` |
