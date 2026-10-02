---
code: CAPA
titre: "CAPA — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org et cncf.io sont bloqués depuis la session
  qui a produit ce fichier (proxy de sortie). Les valeurs marquées « indirecte » viennent des extraits de ces pages
  officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles sont à confirmer en ouvrant l'URL citée
  à la prochaine veille (prompts/07-veille.md). Rien n'a été repris de sources tierces.
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# CAPA — Certified Argo Project Associate : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/certified-argo-project-associate-capa/> | indirecte, 2026-10-02 |
| Lancement | 2024-03-05 | <https://training.linuxfoundation.org/blog/certified-argo-project-associate-capa-launches/> | indirecte, 2026-10-02 |
| Durée | 90 min (règle générale des QCM Linux Foundation, seule exception connue : CNPA à 120 min) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Format | QCM en ligne, surveillé à distance | <https://training.linuxfoundation.org/certification/certified-argo-project-associate-capa/> | indirecte, 2026-10-02 |
| Nombre de questions | **non trouvé** sur les extraits officiels consultés (les sources tierces annoncent 60 ; à confirmer sur la FAQ CAPA) | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-capa> | non trouvé, 2026-10-02 |
| Score de réussite | 75 % | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Domaines et poids | Argo Workflows 36 %, Argo CD 34 %, Argo Rollouts 18 %, Argo Events 12 % | <https://github.com/cncf/curriculum> (`CAPA_Curriculum.pdf`) | directe, 2026-10-02 |
| Version du programme | non versionné ; dernier commit du PDF le 2024-10-21 | <https://github.com/cncf/curriculum/commits/master/CAPA_Curriculum.pdf> | directe, 2026-10-02 |
| Version des logiciels | **non trouvé** : aucune version d'Argo CD / Workflows / Rollouts / Events n'est annoncée pour l'examen | <https://training.linuxfoundation.org/certification/certified-argo-project-associate-capa/> | non trouvé, 2026-10-02 |
| Documentation autorisée | **aucune** : pas d'outil, de ressource ni de site externe pendant un QCM Linux Foundation | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser (basé sur Chrome), webcam, une seule fenêtre ouverte, pièce vide et bureau dégagé | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 |
| Règles et interdits | notes, autres applications, navigation web, communication avec un tiers et appareils externes interdits | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-rules-and-policies> | indirecte, 2026-10-02 |
| Prérequis | aucun | <https://training.linuxfoundation.org/certification/certified-argo-project-associate-capa/> | indirecte, 2026-10-02 |
| Validité | 2 ans (24 mois pour tout examen passé depuis le 2024-04-01) | <https://training.linuxfoundation.org/certification-policy-change-2024/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir le même examen avant l'expiration ; autres voies listées dans la FAQ de chaque certification | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/certificates-and-certification> | indirecte, 2026-10-02 |
| Prix indicatif | 250 USD (examen seul) ; 299 USD avec le cours LFS256 ; 495 USD avec l'abonnement THRIVE-ONE ; promotions fréquentes | <https://training.linuxfoundation.org/certification/certified-argo-project-associate-capa/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | 12 mois pour passer l'examen après l'achat ; une reprise gratuite incluse | <https://training.linuxfoundation.org/certification/certified-argo-project-associate-capa/> | indirecte, 2026-10-02 |
| Simulateur inclus | **non** : le simulateur killer.sh est réservé aux examens pratiques (CKA, CKAD, CKS, CKNE, CNPE, LFCS) ; aucun examen blanc officiel pour les QCM | <https://training.linuxfoundation.org/blog/linux-foundation-kubernetes-certifications-now-include-exam-simulator/> | indirecte, 2026-10-02 |
| Langues disponibles | **non trouvé** | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-capa> | non trouvé, 2026-10-02 |
| Cours officiel associé | LFS256 « DevOps and Workflow Management with Argo » (facultatif) | <https://training.linuxfoundation.org/training/devops-and-workflow-management-with-argo-lfs256/> | indirecte, 2026-10-02 |
| Golden Kubestronaut | oui, CAPA fait partie des certifications requises (repris de `certifs/README.md`, page officielle non ouverte cette session) | <https://www.cncf.io/training/kubestronaut/> | non vérifié, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- Nombre de questions et langues : ouvrir la FAQ CAPA et la page « Important Instructions » correspondante.
- `programme.md` indique `source_file: CAPA.pdf` alors que le dépôt `cncf/curriculum` nomme le fichier `CAPA_Curriculum.pdf` ;
  aligner le générateur `certifs/_sources_pdf/generer_programmes.py`.
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : depuis le 2024-04-01 toutes les certifications
  Linux Foundation passées sont valides 24 mois. À corriger dans la roadmap (hors périmètre de cette PR).
- Prix : vérifier les promotions en cours avant d'acheter (bundles, Cyber Monday, THRIVE-ONE).

## 3. Conséquences pour la préparation

- **Pas de documentation pendant l'épreuve** : les noms exacts des CRD, des champs de spec et des commandes CLI
  doivent être mémorisés. Chaque fiche produit 10 à 20 flashcards (`revision/flashcards/gitops-*.csv`) ;
  le quiz `revision/quiz/` et l'examen blanc `exams/` (prompt `06-examen-blanc.md`) reproduisent le format QCM à 90 min.
- **Quatre projets, un seul examen** : 70 % des points sur Workflows + Argo CD. Ordre de travail dans `objectifs.md` §1.
- **Jalon** : CAPA se passe dans le même bloc que CGOA (`docs/prerequis.md`, parcours Golden Kubestronaut,
  nœud `gitops_conf`). Fixer la date d'examen à la fin du bloc, comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois. Pour le Golden Kubestronaut, planifier CAPA dans la rafale des associées
  après le bloc CKA/CKAD/CKS (`docs/roadmap.md` §7).

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit).
- [ ] Quiz blanc à 90 min réalisé deux fois à ≥ 80 % (marge sur le seuil de 75 %).
- [ ] Flashcards des sept fiches revues à J-7, J-3, J-1 (`journal/`).
- [ ] Bureau dégagé, une seule fenêtre, aucun second écran.
