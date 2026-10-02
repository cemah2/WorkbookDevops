# 00 — Amorçage du dépôt (une seule fois, première session)

Je te fournis un kit de démarrage (dossier `kit/` : CLAUDE.md, DECISIONS.md, docs/roadmap.md,
certifs/ avec 21 programmes de certification en Markdown, prompts/). Objectif de cette session :
créer le dépôt Git du workbook, y déposer ce kit, construire le squelette et pousser sur GitHub.

1. Crée un dépôt Git local nommé `workbook-devops-cloud-prive` et copies-y l'intégralité de `kit/`
   à la racine (CLAUDE.md et DECISIONS.md à la racine, le reste dans ses dossiers).
2. Lis CLAUDE.md, DECISIONS.md et docs/roadmap.md avant toute autre action.
3. Crée l'arborescence décrite dans docs/roadmap.md §6 (dossiers vides avec un README.md d'une ligne).
4. Crée `templates/fiche.md` et `templates/scenario.md` qui imposent le cycle pédagogique de CLAUDE.md
   (front matter : titre, niveau, prérequis, durée estimée, profil de lab, IDs de certification couverts ;
   puis les sections du cycle ; puis checklist de maîtrise et lien vers solutions/, break/, revision/).
5. Crée `versions.yaml` : pour chaque composant (Proxmox VE, Ubuntu LTS, Rocky/RHEL, Kubernetes, kubeadm,
   containerd, Cilium, Ceph, OpenStack, Kolla-Ansible, OpenTofu, Terraform, OpenBao, Vault, Ansible,
   Argo CD, Flux, Prometheus, Grafana, Loki, Harbor, GitLab, Talos, k3s, RKE2, Velero, Keycloak…),
   la version courante VÉRIFIÉE sur la source officielle, l'URL de vérification et la date.
   Signale toute version que tu n'as pas pu vérifier.
6. Crée `labs/network.md` : plan d'adressage et de VLAN cohérent pour un LAN 192.168.0.0/24
   (gw 192.168.0.254) avec des réseaux internes dédiés management / stockage / overlay /
   provider-externe / air-gap ; nommage des VM ; conventions DNS internes.
7. Crée `labs/profiles/` avec au moins 4 profils chiffrés (CPU, RAM, disque, VLAN) tenant dans
   16 vCPU / 128 Go : `linux-base`, `kubernetes-ha`, `openstack-kolla`, `ceph-3n`, `airgap`.
8. Crée `mkdocs.yml` (Material), une CI GitHub Actions (markdownlint, shellcheck, kubeconform,
   build MkDocs), une configuration Renovate ciblant versions.yaml, un `.gitignore`, une `LICENSE`
   (CC-BY-SA 4.0 texte, Apache-2.0 code, attribution CNCF pour certifs/).
9. Crée `docs/prerequis.md` : graphe de prérequis entre chapitres (Mermaid), vide de contenu mais
   avec les domaines et les trois niveaux, et les parcours nommés de la roadmap.
10. Ne rédige AUCUN contenu pédagogique dans cette session.
11. Commits petits et descriptifs. Crée le dépôt GitHub (privé) avec `gh`, pousse `main`,
    puis ouvre une issue par certification (« Cartographier <CODE> ») et une issue par point
    « à vérifier » listé dans certifs/README.md.
12. Termine par la liste des hypothèses prises et des points qui demandent ma décision.
