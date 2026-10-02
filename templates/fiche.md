---
# Gabarit obligatoire d'une fiche (une techno isolée). Copier, renseigner, ne pas réordonner.
titre: "<Titre court de la fiche>"
domaine: "<linux | reseau | proxmox | ceph | kubernetes | openstack | iac | gitops | observabilite | securite | sauvegarde | services | plateforme>"
niveau: "<débutant | confirmé | expert>"
prerequis:
  - "<chemin/vers/fiche-prerequise.md>"
duree_estimee: "<N h>"
lecture_max: "20 %"
profil_lab: "<linux-base | kubernetes-ha | openstack-kolla | ceph-3n | airgap>"
budget_lab: "<vCPU / Go RAM / Go disque, repris de labs/profiles/<profil>.yaml>"
versions: "<clés de versions.yaml utilisées, ex. kubernetes, cilium>"
certifications:
  - "<CODE-DD-CC>"
praticable_sur_le_lab: "<oui | partiellement : sections marquées [lecture + simulation]>"
solutions: "solutions/fiches/<domaine>/<nom-de-la-fiche>.md"
break_fix: "break/<domaine>/<NN>-<nom-de-la-panne>.sh"
flashcards: "revision/flashcards/<domaine>-<NN>-<nom-de-la-fiche>.csv"
statut: "<brouillon | relu | validé en conditions réelles le AAAA-MM-JJ>"
---

# <Titre de la fiche>

> Niveau **<niveau>** · durée **<N h>** · profil de lab **<profil>** · couvre **<CODE-DD-CC, …>**.

## Objectifs mesurables

À la fin de cette fiche tu sais :

- <verbe d'action + résultat observable + contrainte de temps>
- <…>

## Section 1 — <nom de la section>

Chaque section suit le cycle ci-dessous, dans cet ordre, sans en sauter.

### Concept (court)

<Le concept en quelques phrases. Un schéma Mermaid si ça aide. Une manipulation suit dans les 10 lignes.>

### Démo guidée

<Commandes exécutées une par une, sortie réelle ou `[non testé]` avec la raison.>

### Exercice autonome

<Énoncé seul, sans la solution. Indices et correction dans `solutions/`.>

Compétences couvertes : `<CODE-DD-CC>`, `<CODE-DD-CC>`.

### Break-fix

Script : `break/<domaine>/<NN>-<nom-de-la-panne>.sh` — injecte la panne, `--undo` la retire (`NN` = numéro de la fiche, DECISIONS.md 2026-10-02).

<Symptôme observé par l'apprenant. Pas la cause.>

### Défi chronométré

<Énoncé, temps imparti, critère de réussite vérifiable par une commande.>

## Section 2 — <nom de la section>

<Même cycle : concept → démo guidée → exercice autonome → break-fix → défi chronométré.>

## Checklist de maîtrise

À cocher honnêtement, en conditions réelles (terminal seul, documentation officielle, minuteur).

- [ ] Je sais faire <X> en moins de <N> min
- [ ] Je sais diagnostiquer <panne> en moins de <N> min
- [ ] Je sais expliquer <concept> en 3 phrases sans notes

## Liens

- Solutions (3 indices puis correction commentée) : `solutions/fiches/<domaine>/<nom-de-la-fiche>.md`
- Pannes scriptées : `break/<domaine>/`
- Flashcards (10 à 20, CSV `question;réponse;tags`) : `revision/flashcards/<domaine>-<NN>-<nom-de-la-fiche>.csv`
- Mapping certification : `certifs/<CODE>/objectifs.md`
- Rappel espacé : séances J+1, J+7, J+30 à noter dans `journal/`
