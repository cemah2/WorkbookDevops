---
code: COA
titre: "COA — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines openstack.org, wiki.openstack.org, openinfra.org, superuser.openinfra.org et docs.openstack.org sont
  bloqués depuis la session qui a produit ce fichier (proxy de sortie), ainsi que les archives web. Les valeurs marquées
  « indirecte » viennent des extraits de ces pages officielles renvoyés par un moteur de recherche le 2026-10-02 ;
  elles sont à confirmer en ouvrant l'URL citée à la prochaine veille (prompts/07-veille.md). Rien n'a été repris de
  sources tierces (organismes de formation, livres, banques de questions).
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# COA — Certified OpenStack Administrator : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | OpenInfra Foundation (ex-OpenStack Foundation) ; « the only professional certification offered by the Open Infrastructure Foundation » | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Prestataire de l'examen | Mirantis administre l'examen depuis la refonte d'octobre 2019 (annonce du 2019-10-17 ; l'examen refondu était alors basé sur Rocky) | <https://www.mirantis.com/company/press-center/company-news/mirantis-partners-with-openstack-foundation-to-support-upgraded-coa-exam/> | indirecte, 2026-10-02 (communiqué du prestataire, pas de la Fondation) |
| Durée | 3 h (180 min). Les handbooks de 2017 et 2018 indiquaient 2,5 h : valeur périmée | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Format | pratique, en ligne, surveillé à distance ; tâches à réaliser sur un environnement OpenStack réel, « a combination of the command line & Horizon UI » ; pas de QCM | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Nombre de tâches | **non trouvé** sur les extraits officiels consultés | <https://www.openstack.org/coa/> | non trouvé, 2026-10-02 |
| Score de réussite | **non trouvé** sur les extraits officiels consultés | <https://www.openstack.org/coa/> | non trouvé, 2026-10-02 |
| Domaines et poids | Identity 15 %, Compute 35 %, Networking 30 %, Block Storage 10 %, Object Storage 5 %, Image 5 % (retranscrits dans `programme.md`) | <https://www.openstack.org/coa/requirements> | directe, 2026-09-28 (session précédente) ; indirecte, 2026-10-02 |
| Version d'OpenStack | 2026.1 Gazpacho d'après la page des exigences relevée le 2026-09-28 (`programme.md`) ; **non confirmée** par les extraits du 2026-10-02 ni par le handbook | <https://www.openstack.org/coa/requirements> | à confirmer, 2026-10-02 |
| Documentation autorisée | documentation officielle OpenStack uniquement (`docs.openstack.org`), consultée depuis la console d'examen ; sites web, courriel et notes interdits ; « Resources are allowed during the Exam as long as they are used by Candidate to work independently on exam objectives and are accessed from within the OpenStack server terminal » | <https://www.openstack.org/assets/coa/COA-Candidate-Handbook-Master-V2.1-November-2018.pdf> | indirecte, 2026-10-02 (handbook 2018, à rapprocher du handbook courant) |
| Environnement d'examen | navigateur Chrome ou Chromium, webcam orientable, micro, connexion fiable ; surveillance par flux audio, vidéo et partage d'écran ; console d'examen dans le navigateur : panneau « Content » (minuteur, objectifs) et panneau « Dashboard/Terminal » (Horizon + terminal) ; pas de `scp` vers la console ; `screen`/`tmux`/`byobu` installables dans le terminal | <https://www.openstack.org/assets/coa/COA-Candidate-Handbook-Master-V2.1-November-2018.pdf> ; <https://superuser.openinfra.org/articles/how-to-pass-the-certified-openstack-administrator-exam/> | indirecte, 2026-10-02 |
| Règles et interdits | le surveillant peut demander un panoramique de la pièce ; pas de notes, d'autres applications ni de communication avec un tiers | <https://www.openstack.org/assets/coa/COA-Candidate-Handbook-Master-V2.1-November-2018.pdf> | indirecte, 2026-10-02 |
| Prérequis | aucun prérequis formel ; « written for OpenStack professionals with at least six months of experience managing an OpenStack cloud environment » | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Validité | 36 mois à partir de la date de réussite | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Renouvellement | **non trouvé** : aucune voie de renouvellement décrite dans les extraits ; en l'absence d'autre information, repasser l'examen | <https://www.openstack.org/coa/> | non trouvé, 2026-10-02 |
| Prix indicatif | 400 USD | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Reprise | **aucune** : « There are no retakes for this exam. » Les handbooks 2017 et 2018 incluaient une reprise gratuite : politique changée, à relire dans le handbook courant | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Délai de résultat | 7 à 10 jours ouvrés | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Langues disponibles | anglais | <https://www.openstack.org/assets/coa/COA-Candidate-Handbook-Master-V2.1-November-2018.pdf> | indirecte, 2026-10-02 (handbook 2018) |
| Simulateur inclus | **non trouvé** : aucun examen blanc ni simulateur officiel dans les extraits ; les partenaires de formation du marketplace proposent leurs propres mocks (non officiels, non repris ici) | <https://www.openstack.org/marketplace/training/> | non trouvé, 2026-10-02 |
| Inscription | sur la page COA ou via un partenaire de formation du marketplace ; contact `cert@openstack.org` | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Handbook du candidat | lien « Download the handbook » sur la page COA ; seules les versions V1.4 (2016), V1.7 (2017) et V2.1 (novembre 2018) sont indexées en PDF, toutes antérieures à la refonte de 2019 | <https://www.openstack.org/coa/> | indirecte, 2026-10-02 |
| Golden Kubestronaut | non (certification OpenInfra, hors périmètre CNCF ; repris de `certifs/README.md`) | — | directe, 2026-10-02 (dépôt) |

## 2. Points à confirmer à la prochaine veille

- Ouvrir <https://www.openstack.org/coa/>, <https://www.openstack.org/coa/requirements> et le handbook courant : nombre de
  tâches, score de réussite, politique de reprise (le site dit « aucune », les anciens handbooks disaient « une gratuite »),
  langues, fenêtre de planification après achat, version d'OpenStack du cloud d'examen.
- Confirmer la version 2026.1 Gazpacho annoncée dans `programme.md` ; si elle diffère, mettre à jour `versions.yaml`
  (`openstack`, `kolla_ansible`, `kolla`, `channel: exam`) et le front matter de `programme.md` par la tâche de veille.
- Le moteur de recherche a indexé <https://www.openstack.org/coa/coa-professional/> sans en renvoyer le contenu : vérifier
  s'il s'agit d'une nouvelle déclinaison de l'examen ou d'une page de marketing.
- Un partenaire du marketplace annonce une « live virtual instructor-led session » de 180 min : c'est une formation,
  pas l'examen ; ne pas confondre.
- Prix : vérifier les bundles formation + examen des partenaires avant d'acheter ; le prix nu reste 400 USD.

## 3. Conséquences pour la préparation

- **Examen pratique avec documentation** : la mémorisation porte sur les concepts et les noms de ressources, pas sur chaque
  option. En revanche la navigation dans `docs.openstack.org` doit être rapide : chaque fiche de `objectifs.md` entraîne à
  retrouver la page CLI d'une commande en moins d'une minute, et les défis se font avec cet onglet seul.
- **CLI et Horizon** : chaque section de fiche a une variante Horizon. En examen, le CLI est plus rapide pour les créations
  en masse, Horizon pour vérifier une topologie ou une console ; les deux doivent être réflexes.
- **180 min, nombre de tâches inconnu** : les défis chronométrés visent 4 à 12 min par livraison complète, ce qui laisse
  une marge si l'examen comporte 30 à 40 tâches. Le scénario S1 et `exams/COA/` calibreront cette hypothèse sur le lab.
- **Pas de reprise, 400 USD** : ne réserver qu'après deux examens blancs réussis à ≥ 85 % (`exams/COA/`, `grade.sh`).
- **Jalon** : COA ferme le parcours « Cloud privé OpenStack » (`docs/prerequis.md` §3, `openstack_conf` → `openstack_exp`).
  Fixer la date à la fin du second cycle du bloc, comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 36 mois, indépendant des certifications CNCF ; pas de contrainte de simultanéité.

## 4. Checklist J-7

- [ ] Compte créé sur la plateforme d'examen, créneau réservé, pièce d'identité conforme au nom du compte.
- [ ] Test système fait : Chrome/Chromium, webcam orientable, micro, débit, une seule fenêtre.
- [ ] Deux examens blancs `exams/COA/` à 180 min réussis à ≥ 85 % avec `docs.openstack.org` pour seule aide.
- [ ] Scénario S1 rejoué en conditions d'examen, temps par tâche noté dans `journal/`.
- [ ] Flashcards des dix fiches revues à J-7, J-3, J-1 (`revision/flashcards/openstack-*.csv`).
- [ ] Bureau dégagé, pièce fermée, aucun second écran, `tmux` connu par cœur pour la console d'examen.
