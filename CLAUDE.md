# Workbook DevOps cloud privé — instructions permanentes

## Contexte

Workbook d'autoformation, très complet et orienté pratique, pour un admin système/réseau
junior visant un poste DevOps cloud privé et les certifications listées dans `certifs/`
(objectif long terme : Golden Kubestronaut + RHCSA/RHCE + Terraform/Vault Associate + COA).
Lab : un serveur Proxmox VE (16 vCPU Xeon E-2378G, 128 Go RAM, 2 To NVMe + 2 To SSD + 2 To HDD),
LAN 192.168.0.0/24 (passerelle 192.168.0.254). Plan d'adressage interne dans `labs/network.md`.
Licences : open source d'abord (OpenTofu, OpenBao, Rocky/Alma ou RHEL developer) ;
Terraform et Vault uniquement dans les chapitres de préparation à leurs certifications.

## Sources de vérité (lire avant d'écrire)

- `versions.yaml` : seule source des versions. Ne jamais écrire une version en dur dans un chapitre.
- `labs/network.md`, `labs/profiles/` : adressage, VLAN, budgets CPU/RAM/disque par profil de lab.
- `certifs/<CODE>/programme.md` : programme officiel avec identifiants stables `CODE-DD-CC`.
- `certifs/<CODE>/objectifs.md` : mapping compétence → chapitres/exercices (à maintenir à chaque PR).
- `DECISIONS.md` : arbitrages pris. Ne pas les rouvrir ; proposer un ajout daté si besoin.
- `templates/fiche.md`, `templates/scenario.md` : gabarits obligatoires.
- `docs/roadmap.md` : feuille de route et axes pédagogiques.

## Langue et style

Texte en français, commandes / code / noms de fichiers / identifiants en anglais. Tutoiement.
Phrases courtes. Pas de remplissage, pas de « dans ce chapitre nous allons ».
Chaque concept est suivi d'une manipulation dans les 10 lignes.

## Pédagogie (non négociable)

Cycle par section : concept court → démo guidée → exercice autonome → break-fix →
défi chronométré → checklist de maîtrise mesurable (« je sais faire X en moins de N min »).
La lecture représente au plus 20 % du volume d'un chapitre.
Trois niveaux : débutant, confirmé, expert. Jamais de saut direct débutant → expert.
Solutions dans `solutions/` avec 3 indices progressifs avant la correction commentée.
Chaque exercice cite les compétences de certification couvertes (IDs de `programme.md`).
Chaque chapitre produit 10 à 20 flashcards dans `revision/` (CSV `question;réponse;tags`).
Ce qui n'est pas praticable sur le lab (NUMA, RDMA, MIG…) est marqué `[lecture + simulation]`.

## Qualité

Toute commande a été exécutée, ou est marquée `[non testé]` avec la raison. Pas de sortie inventée.
Scripts : shellcheck. Manifests Kubernetes : kubeconform. Markdown : markdownlint.
En cas de doute, vérifier la documentation officielle de la version de `versions.yaml`
et signaler l'incertitude plutôt que la masquer.
Schémas en Mermaid dans le Markdown ; icônes CNCF depuis `assets/icons/` ; sources Excalidraw committées.

## Définition de « terminé » (à cocher honnêtement dans chaque PR)

- [ ] gabarit respecté, niveaux annoncés
- [ ] IDs de certification cités et `objectifs.md` mis à jour
- [ ] solutions exécutées (ou `[non testé]` justifié)
- [ ] break-fix présent et scripté
- [ ] flashcards générées
- [ ] profil de lab et budget indiqués
- [ ] lint OK
- [ ] relecture critique faite dans une session séparée et corrections intégrées

## Façon de travailler

Toujours proposer un plan et attendre validation avant de rédiger un chapitre.
Un chapitre = une branche = une PR. Commits petits et descriptifs.
Ne jamais modifier `certifs/*/programme.md` hors de la tâche de veille.
Quand un problème est générique, corriger le gabarit ou ce fichier, pas seulement le chapitre.
