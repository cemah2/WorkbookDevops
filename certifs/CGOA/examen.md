---
code: CGOA
titre: "CGOA — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org, cncf.io et opengitops.dev sont bloqués depuis la
  session qui a produit ce fichier (proxy de sortie). Les valeurs marquées « indirecte » viennent des extraits de ces pages
  officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles sont à confirmer en ouvrant l'URL citée à la
  prochaine veille (prompts/07-veille.md). github.com était joignable : les valeurs marquées « directe » viennent d'un clone
  des dépôts cncf/curriculum et open-gitops/documents le 2026-10-02. Rien n'a été repris de sources tierces.
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# CGOA — Certified GitOps Associate : l'examen

Légende de la colonne « vérification » :

- **directe** : source officielle ouverte le jour indiqué (ici : dépôts GitHub de la CNCF et d'OpenGitOps) ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF et Continuous Delivery Foundation (CDF), administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/certified-gitops-associate-cgoa/> | indirecte, 2026-10-02 |
| Lancement | 2024-02-21 | <https://training.linuxfoundation.org/blog/cgoa-certification/> | indirecte, 2026-10-02 |
| Durée | 90 min (règle générale des QCM Linux Foundation, seule exception connue : CNPA) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Format | QCM en ligne, surveillé à distance | <https://training.linuxfoundation.org/certification/certified-gitops-associate-cgoa/> | indirecte, 2026-10-02 |
| Nombre de questions | **non trouvé** sur les extraits officiels consultés (les sources tierces annoncent 60 ; à confirmer sur la FAQ CGOA) | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-cgoa> | non trouvé, 2026-10-02 |
| Score de réussite | 75 % | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Domaines et poids | Terminology 20 %, Principles 30 %, Related Practices 16 %, Patterns 20 %, Tooling 14 % | <https://github.com/cncf/curriculum> (`CGOA_Curriculum.pdf`) | directe, 2026-10-02 (clone) ; mêmes valeurs dans l'extrait de la page LF |
| Version du programme | non versionné ; PDF ajouté le 2024-02-22, dernier commit le 2024-11-19 ; **écart** : `cgoa/README.md` du même dépôt (2025-11-28) annonce quatre domaines à 25 %, voir §2 | <https://github.com/cncf/curriculum/commits/master/CGOA_Curriculum.pdf> | directe, 2026-10-02 (clone) |
| Référentiel conceptuel | principes et glossaire OpenGitOps, version `v1.0.0` (le billet officiel « How to Ace the CGOA » dit que l'examen suit les standards OpenGitOps) | <https://github.com/open-gitops/documents> · <https://training.linuxfoundation.org/blog/ace-the-cgoa/> | directe (tag `v1.0.0` lu par `git ls-remote`) ; billet indirecte, 2026-10-02 |
| Version des logiciels | **non trouvé** : examen indépendant des outils, aucune version d'Argo CD ou de Flux n'est annoncée | <https://training.linuxfoundation.org/certification/certified-gitops-associate-cgoa/> | non trouvé, 2026-10-02 |
| Documentation autorisée | **aucune** : pas d'outil, de ressource ni de site externe pendant un QCM Linux Foundation | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 (extrait obtenu lors de la session CAPA, même page) |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser, webcam, une seule fenêtre ouverte, pièce vide et bureau dégagé | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 |
| Règles et interdits | notes, autres applications, navigation web, communication avec un tiers et appareils externes interdits | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-rules-and-policies> | indirecte, 2026-10-02 (extrait obtenu lors de la session CAPA, même page) |
| Prérequis | **non trouvé** : aucun prérequis n'apparaît dans les extraits consultés (aucune certification associée Linux Foundation n'en impose, à confirmer) | <https://training.linuxfoundation.org/certification/certified-gitops-associate-cgoa/> | non trouvé, 2026-10-02 |
| Validité | 2 ans (24 mois pour tout examen passé depuis le 2024-04-01) | <https://training.linuxfoundation.org/certification-policy-change-2024/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir le même examen avant l'expiration | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/certificates-and-certification> | indirecte, 2026-10-02 (extrait obtenu lors de la session CAPA, même page) |
| Prix indicatif | 250 USD (examen seul) ; 495 USD avec l'abonnement THRIVE-ONE (250 + 360) ; promotions fréquentes | <https://training.linuxfoundation.org/certification/cgoa-exam-thrive-one-subscription-bundle/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | 12 mois pour passer l'examen après l'achat ; deux tentatives (une reprise gratuite) | <https://training.linuxfoundation.org/certification/certified-gitops-associate-cgoa/> | indirecte, 2026-10-02 |
| Simulateur inclus | **non** : le simulateur killer.sh est réservé aux examens pratiques ; aucun examen blanc officiel pour les QCM | <https://training.linuxfoundation.org/blog/linux-foundation-kubernetes-certifications-now-include-exam-simulator/> | indirecte, 2026-10-02 (extrait obtenu lors de la session CAPA) |
| Langues disponibles | **non trouvé** | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-cgoa> | non trouvé, 2026-10-02 |
| Cours officiel associé | LFS269 « GitOps: Continuous Delivery on Kubernetes with Flux » (facultatif, payant) ; bundle examen + cours : prix **non trouvé** | <https://training.linuxfoundation.org/training/gitops-continuous-delivery-on-kubernetes-with-flux-lfs269/> | indirecte, 2026-10-02 |
| Auteurs du programme | 18 contributeurs nommés dans `cgoa/README.md` (dont des mainteneurs Argo et Flux et des ambassadeurs CDF) | <https://github.com/cncf/curriculum/blob/master/cgoa/README.md> | directe, 2026-10-02 (clone) |
| Golden Kubestronaut | oui, CGOA fait partie des certifications requises | <https://www.cncf.io/training/kubestronaut/> | indirecte, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- **Découpage du programme.** `CGOA_Curriculum.pdf` (cinq domaines, retranscrit dans `programme.md`) et `cgoa/README.md`
  (quatre domaines à 25 % : GitOps Fundamentals ; Principles & Practices ; Tooling & Implementation ; Security & Observability)
  coexistent dans `cncf/curriculum`. Ouvrir la section « Domains & Competencies » de la page officielle ; si elle a changé,
  régénérer `programme.md` par `certifs/_sources_pdf/generer_programmes.py` (tâche de veille uniquement, CLAUDE.md) et
  reprendre `objectifs.md` §1. Les IDs `CGOA-DD-CC` existants restent stables (DECISIONS.md : une compétence retirée reste barrée un cycle).
- Nombre de questions, langues et prérequis : ouvrir la FAQ CGOA et la page « Important Instructions » des QCM
  (<https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-mc>).
- `programme.md` indique `source_file: CGOA.pdf` alors que le dépôt `cncf/curriculum` nomme le fichier `CGOA_Curriculum.pdf` ;
  même écart que pour CAPA, à aligner dans le générateur.
- Existence et prix d'un bundle examen + LFS269, et d'un cours d'introduction gratuit (un cours « Introduction to GitOps »
  LFS169 est cité par des sources tierces, non vérifié sur une page officielle).
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : depuis le 2024-04-01 toutes les certifications
  Linux Foundation passées sont valides 24 mois (déjà signalé par `certifs/CAPA/examen.md`, hors périmètre de cette PR).

## 3. Conséquences pour la préparation

- **Pas de documentation pendant l'épreuve, et des définitions au mot près** : l'examen reprend le vocabulaire OpenGitOps
  (« continuous » ne veut pas dire instantané ; le rollback est un nouvel état désiré ; le state store doit être immuable,
  versionné, avec contrôle d'accès et audit). Lire `PRINCIPLES.md` et `GLOSSARY.md` en anglais, puis les restituer sans notes :
  c'est l'objet de la fiche G1 (`objectifs.md` §4) et de ses flashcards.
- **Indépendant des outils** : connaître les deux moteurs (Argo CD via CAPA, Flux via G2) suffit pour les questions
  « Tooling » (14 %) ; les alternatives (Fleet, kapp-controller, Kluctl, Jenkins X, PipeCD) se lisent, ne s'installent pas.
- **Cinquante pour cent des points sur la terminologie et les principes** : G1 d'abord, puis les patrons (G3) ; les
  pratiques associées (G4, 16 %) se révisent par le quiz plus que par le lab.
- **Jalon** : CGOA se passe dans le même bloc que CAPA (`docs/prerequis.md`, parcours Golden Kubestronaut, nœud `gitops_conf`),
  CGOA en premier. Fixer la date d'examen à la fin du bloc, comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois. Pour le Golden Kubestronaut, planifier CGOA dans la rafale des associées
  après le bloc CKA/CKAD/CKS (`docs/roadmap.md` §7).

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit).
- [ ] Quiz blanc R1 à 90 min réalisé deux fois à ≥ 80 % (marge sur le seuil de 75 %).
- [ ] Les quatre principes et les neuf termes de CGOA-01 récités sans notes, en anglais, en moins de 5 min.
- [ ] Flashcards des cinq fiches CGOA et de F1, F3 revues à J-7, J-3, J-1 (`journal/`).
- [ ] Bureau dégagé, une seule fenêtre, aucun second écran.
