# Feuille de route et axes pédagogiques

Issu de la revue du projet du 2026-10-02. Sert de référence à `CLAUDE.md` et de backlog initial.

## 1. Pédagogie : rétention avant exhaustivité
- Cycle fixe par section : concept court → démo guidée → exercice autonome → break-fix → défi chronométré → auto-évaluation. Lecture ≤ 20 %.
- Solutions à indices progressifs (où regarder → quelle commande → quoi lire → correction commentée).
- Le troubleshooting est un fil rouge : dossier `break/` par techno, pannes scriptées injectées à l'aveugle (`break.sh random`).
- Rappel espacé : flashcards générées depuis le dépôt (Anki/Obsidian), séances J+1, J+7, J+30 planifiées dans les parcours.
- Checklists de maîtrise mesurables et chronométrées ; un chapitre n'est fini que coché en conditions réelles.
- Examens blancs en conditions d'examen (terminal seul, doc officielle, minuteur, `setup.sh` + `grade.sh`).
- Produire pour apprendre : chaque scénario se termine par un runbook, un ADR ou un postmortem.
- Trois niveaux explicites : débutant / confirmé / expert.

## 2. Le lab est le premier workbook
- Profils de lab déclaratifs (`lab up kubernetes-ha`, `lab up openstack-kolla`, `lab down`) avec budget CPU/RAM/disque ; OpenTofu (`bpg/proxmox`) + Packer + cloud-init + Ansible.
- Plan d'adressage et VLAN fixés une fois (management, stockage, overlay, provider/externe, air-gap) ; routeur/pare-feu virtuel (VyOS ou OPNsense) comme exercice réseau ; Proxmox SDN pour une fabric EVPN/VXLAN virtuelle avec FRR.
- Disques par rôle : NVMe → VM perf ; SSD → OSD Ceph ; HDD → Proxmox Backup Server. Le lab se restaure en 20 min.
- BMC virtuels (sushy-tools / VirtualBMC) pour PXE, MAAS, Ironic, Metal3 sur VM.
- VLAN air-gapped avec VM miroir (apt-mirror, Harbor proxy cache, Nexus, CA interne).
- Multi-site simulé avec `tc netem` (latence, pertes) pour stretch clusters, quorum, split-brain.
- GPU : décision matérielle à prendre (carte low-profile) ; module en deux temps.
- Expert matériel étiqueté `[lecture + simulation]` quand le lab ne permet pas une vraie pratique.

## 3. Périmètre et progression
- Graphe de prérequis explicite entre chapitres ; parcours nommés : Kubestronaut, Golden Kubestronaut, Cloud privé OpenStack, Plateforme SecNumCloud.
- Noyau (Linux, réseau, Proxmox/KVM, Ceph, Kubernetes, IaC, GitOps, observabilité, sécurité, sauvegarde) vs extensions (OpenStack à l'échelle, service mesh, Backstage, Go/opérateurs, Kafka). VMware : fiche de migration uniquement.
- Mapping certification ↔ chapitre dans les deux sens (`certifs/<CODE>/objectifs.md`).
- CNPA et CNPE intégrés (Golden Kubestronaut). CKS : vérifier la version avant le jalon.
- RHEL réel via l'abonnement développeur ; OpenTofu/OpenBao en scénarios, Terraform/Vault en préparation d'examen.

## 4. Contenus à ajouter
- Services de base : DNS interne (PowerDNS/Bind), PKI (step-ca ou Vault PKI), NTP, FreeIPA → Keycloak, NetBox.
- Conformité outillée : OpenSCAP / ComplianceAsCode contre CIS et le guide ANSSI ; exercice « exigence SecNumCloud → contrôle → preuve » ; NIS2, HDS.
- Hygiène d'alerting et astreinte simulée ; postmortems.
- Données avec état : CloudNativePG + Barman/pgBackRest, Velero + snapshots CSI, restaurations mesurées (RPO/RTO).
- Sécurité runtime eBPF : Tetragon à côté de Falco. Talos comme distribution immuable.
- Culture ops : gestion des changements, ADR, capacity planning, FinOps on-prem.
- Poste de travail : tmux, k9s, kubectx, fzf, dotfiles, avec les interdits d'examen.

## 5. Qualité et maintenance
- `versions.yaml` unique + templating + Renovate.
- Solutions exécutées en CI (kind/conteneurs) chaque nuit ; badge « testé le … » pour ce qui exige Proxmox.
- Conventions : FR texte / EN code, admonitions standardisées, glossaire FR/EN, nommage VM et réseaux.
- Schémas en sources éditables (Mermaid, Excalidraw) ; icônes CNCF.
- Licence : CC-BY-SA pour le texte, Apache-2 pour le code ; attribution CNCF (CC-BY).
- Veille : une issue par programme d'examen, flux RSS des release notes.

## 6. Organisation du dépôt
```
fiches/        une techno isolée, progressive (linux/, reseau/, ceph/, kubernetes/…)
scenarios/     multi-technos, numérotés, de plus en plus proches du réel
certifs/       un dossier par certification : programme.md (IDs), objectifs.md, examen.md
exams/         examens blancs (setup.sh, grade.sh, barème, correction)
labs/          OpenTofu, Packer, Ansible, profils, plan d'adressage
solutions/     même arborescence que fiches/ et scenarios/, indices progressifs puis correction
break/         scénarios de panne scriptés
revision/      flashcards, quiz, checklists de maîtrise
templates/     gabarits de fiche et de scénario
docs/          rendu MkDocs Material ; roadmap, prérequis, glossaire
prompts/       prompts de travail avec Claude
assets/        icônes, sources Excalidraw
versions.yaml  DECISIONS.md  CLAUDE.md
```

## 7. Planification
- Dates d'examen fixées à l'avance comme mécanisme d'engagement.
- Validité : CKA/CKAD/CKS 2 ans, la plupart des associées 3 ans ; le Golden Kubestronaut exige que tout soit valide en même temps → bloc LFCS → KCNA → CKA → CKAD → CKS d'abord, associées en rafale ensuite, bundles et promotions Linux Foundation.
- Cycles de 4 à 6 semaines par bloc, fermés par un examen ou un examen blanc, avec une semaine de révision entrelacée.
- Journal d'apprentissage dans le dépôt (`journal/`), matière première des révisions et futur portfolio.
