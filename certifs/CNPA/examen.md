---
code: CNPA
titre: "CNPA — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org et cncf.io sont bloqués depuis la session
  qui a produit ce fichier (proxy de sortie), comme pour CAPA. Les valeurs marquées « indirecte » viennent des extraits
  de ces pages officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles sont à confirmer en ouvrant l'URL
  citée à la prochaine veille (prompts/07-veille.md). Rien n'a été repris de sites tiers (dumps, blogs de candidats).
  Le dépôt github.com/cncf/curriculum a été cloné et lu directement.
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# CNPA — Certified Cloud Native Platform Engineering Associate : l'examen

Légende de la colonne « vérification » :

- **directe** : source officielle ouverte ou clonée le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/> | indirecte, 2026-10-02 |
| Annonce | 2024-11-15 (communiqué CNCF « expands certification to platform engineering ») | <https://www.cncf.io/announcements/2024/11/15/cloud-native-computing-foundation-expands-certification-to-platform-engineering-and-more/> | indirecte, 2026-10-02 |
| Lancement | programme publié le 2025-04-01 (commit `b13a899` de `CNPA_Curriculum.pdf`) ; examen présenté comme disponible dans le billet CNCF du 2025-06-15 | <https://www.cncf.io/blog/2025/06/15/introducing-the-certified-cloud-native-platform-engineering-associate-cnpa-community-driven-certification-for-platform-engineers/> | directe (dépôt) et indirecte (billet), 2026-10-02 |
| Niveau visé | « associate », début de carrière ; aucun prérequis | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/> | indirecte, 2026-10-02 |
| Durée | **120 min** (seul QCM Linux Foundation à 120 min, les autres sont à 90 min) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Format | QCM en ligne, surveillé à distance (flux audio, vidéo et partage d'écran) | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-mc> | indirecte, 2026-10-02 |
| Nombre de questions | **85** d'après les instructions officielles des QCM (les autres QCM en ont 60) ; des sites tiers annoncent 60, à trancher sur l'URL | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-mc> | indirecte, 2026-10-02 |
| Score de réussite | 75 % | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Résultats | par courriel sous 24 h | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-mc> | indirecte, 2026-10-02 |
| Domaines et poids | Core Fundamentals 36 %, Observability/Security/Conformance 20 %, CD & Platform Engineering 16 %, APIs & Provisioning 12 %, IDPs & DevEx 8 %, Measuring 8 % | <https://github.com/cncf/curriculum> (`CNPA_Curriculum.pdf`, `cnpa/README.md`) | directe, 2026-10-02 |
| Version du programme | non versionné ; PDF committé le 2025-04-01, inchangé depuis (même empreinte que `certifs/_sources_pdf/CNPA.pdf`) ; `cnpa/README.md` ajouté le 2025-11-28 ; dépôt lu au commit `88e6106` du 2026-10-01 | <https://github.com/cncf/curriculum/commits/master/CNPA_Curriculum.pdf> | directe, 2026-10-02 |
| Version des logiciels | **non trouvé** : examen « vendor-neutral », aucune version de Kubernetes ni d'outil annoncée | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/> | non trouvé, 2026-10-02 |
| Documentation autorisée | **aucune** : pas d'outil, de ressource ni de site externe pendant un QCM Linux Foundation | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser (basé sur Chrome), webcam, une seule fenêtre ouverte, pièce vide et bureau dégagé | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 |
| Règles et interdits | notes, autres applications, navigation web, communication avec un tiers et appareils externes interdits | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-rules-and-policies> | indirecte, 2026-10-02 |
| Prérequis | aucun | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/> | indirecte, 2026-10-02 |
| Validité | 2 ans | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir le même examen avant l'expiration | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/certificates-and-certification> | indirecte, 2026-10-02 |
| Prix indicatif | 250 USD (examen seul) ; 495 USD avec l'abonnement THRIVE-ONE (examen 135 USD + abonnement 360 USD) ; promotions fréquentes ; garantie de remboursement annoncée | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | 12 mois pour passer l'examen après l'achat ; une reprise gratuite incluse (deux tentatives) | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/> | indirecte, 2026-10-02 |
| Simulateur inclus | **non** : le simulateur killer.sh est réservé aux examens pratiques ; aucun examen blanc officiel pour les QCM | <https://training.linuxfoundation.org/blog/linux-foundation-kubernetes-certifications-now-include-exam-simulator/> | indirecte, 2026-10-02 |
| Langues disponibles | **non trouvé** pour CNPA (le handbook cite anglais, allemand, chinois simplifié, japonais selon l'examen) | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/language> | non trouvé, 2026-10-02 |
| Cours officiel associé | **non trouvé** : aucun cours LFS/LFD lié sur les extraits consultés | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineering-associate-cnpa/> | non trouvé, 2026-10-02 |
| Golden Kubestronaut | oui, requis depuis le 2025-10-15 (les Golden Kubestronaut antérieurs gardent leur statut) | <https://www.cncf.io/blog/2025/07/16/kubestronauts-celebrating-2000-achievements-and-an-exciting-new-chapter/> | indirecte, 2026-10-02 |
| Bundle Golden Kubestronaut | une offre groupée Linux Foundation existe ; prix **non trouvé** | <https://training.linuxfoundation.org/certification/golden-kubestronaut-bundle/> | non trouvé, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- Nombre de questions : 85 (instructions officielles des QCM, extrait indirect) contre 60 (sites tiers). Ouvrir
  `important-instructions-mc` et la FAQ CNPA (`frequently-asked-questions-cnpa`, URL non confirmée) ; régler le minuteur du
  quiz blanc sur la valeur confirmée.
- Langues et cours officiel : ouvrir la page produit et le handbook.
- Prix du bundle Golden Kubestronaut et promotions en cours avant d'acheter.
- `programme.md` indique `source_file: CNPA.pdf` alors que le dépôt `cncf/curriculum` nomme le fichier `CNPA_Curriculum.pdf` ;
  `source_url` cite un « dernier commit consulté : 2026-03-14 » alors que le PDF n'a pas changé depuis le 2025-04-01 ;
  aligner le générateur `certifs/_sources_pdf/generer_programmes.py` (même remarque que pour CAPA).
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : CNPA est valide 2 ans. À corriger dans la roadmap
  (hors périmètre de cette PR).

## 3. Conséquences pour la préparation

- **Pas de documentation pendant l'épreuve** : le vocabulaire (CNCF Platforms White Paper, DORA, golden path, IDP, CRD, opérateur,
  mTLS, PSA, SBOM) et les noms d'outils doivent être mémorisés. Chaque fiche produit 10 à 20 flashcards
  (`revision/flashcards/plateforme-*.csv`, `securite-*.csv`, `observabilite-*.csv`) ; le quiz `revision/quiz/` et l'examen blanc
  `exams/` (prompt `06-examen-blanc.md`) reproduisent le format : 120 min, 85 questions, soit 85 s par question.
- **Six domaines, 56 % des points sur deux** : fondamentaux (36 %) et observabilité/sécurité/conformité (20 %).
  Ordre de travail dans `objectifs.md` §1.
- **Transverse plutôt que profond** : CNPA interroge le métier, pas les options d'un outil. Les fiches partagées avec ICA, KCSA,
  KCA, PCA/OTCA et CBA suffisent si leurs flashcards sont revues ; les sections `[lecture]` listent les outils cités sans pratique.
- **Jalon** : CNPA se passe dans le bloc `plateforme_conf` du parcours Golden Kubestronaut, avec CBA (`docs/prerequis.md` §3).
  Fixer la date d'examen à la fin du bloc, comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 2 ans. Pour le Golden Kubestronaut, planifier CNPA dans la rafale des associées après le bloc
  CKA/CKAD/CKS, avant CNPE qui réutilise les mêmes fiches (`docs/roadmap.md` §7).

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit).
- [ ] Quiz blanc à 120 min réalisé deux fois à ≥ 80 % (marge sur le seuil de 75 %).
- [ ] Flashcards des onze fiches revues à J-7, J-3, J-1 (`journal/`).
- [ ] Bureau dégagé, une seule fenêtre, aucun second écran.
