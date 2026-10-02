---
code: KCNA
titre: "KCNA — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org et cncf.io sont bloqués depuis la session
  qui a produit ce fichier (proxy de sortie, testé par curl et WebFetch le 2026-10-02). Les valeurs marquées
  « indirecte » viennent des extraits de ces pages officielles renvoyés par un moteur de recherche le 2026-10-02 ;
  elles sont à confirmer en ouvrant l'URL citée à la prochaine veille (prompts/07-veille.md). Rien n'a été repris
  de sources tierces : les guides non officiels décrivent encore l'ancien programme à cinq domaines, à ignorer.
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# KCNA — Kubernetes and Cloud Native Associate : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/> | indirecte, 2026-10-02 |
| Public visé | certification « pré-professionnelle », point d'entrée avant CKA, CKAD, KCSA et CKS | <https://www.cncf.io/training/certification/kcna/> | indirecte, 2026-10-02 |
| Lancement | 2021-11-18 (annonce CNCF, avec le cours LFS250) | <https://www.cncf.io/announcements/2021/11/18/kubernetes-and-cloud-native-essentials-training-and-kcna-certification-now-available/> | indirecte, 2026-10-02 |
| Durée | 90 min (règle générale des QCM Linux Foundation, seule exception connue : CNPA) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Format | QCM en ligne, surveillé à distance ; questions à choix unique et à choix multiples | <https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/> | indirecte, 2026-10-02 |
| Nombre de questions | 60 (règle générale des QCM Linux Foundation ; seule exception connue : CNPA, 85 questions) | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-mc> | indirecte, 2026-10-02 |
| Score de réussite | 75 % | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Domaines et poids | Kubernetes Fundamentals 44 %, Container Orchestration 28 %, Cloud Native Application Delivery 16 %, Cloud Native Architecture 12 % | <https://github.com/cncf/curriculum> (`KCNA_Curriculum.pdf`, copie dans `certifs/_sources_pdf/KCNA.pdf`) | directe, 2026-10-02 |
| Version du programme | non versionné ; PDF mis à jour par le commit `06702fe` du 2025-11-24 (ancienne version archivée dans `old-versions/`) ; examen mis à jour « au plus tôt le 2025-11-24 », observabilité rattachée à Cloud Native Architecture, compétences ajoutées, retirées ou reformulées par domaine | <https://github.com/cncf/curriculum/commits/master/KCNA_Curriculum.pdf> · <https://training.linuxfoundation.org/kcna-program-changes/> | directe (commits) · indirecte (page des changements), 2026-10-02 |
| Version des logiciels | **non trouvé** : aucune version de Kubernetes n'est annoncée pour KCNA (contrairement à CKA/CKAD/CKS) ; les chapitres suivent la clé `kubernetes` de `versions.yaml` | <https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/> | non trouvé, 2026-10-02 |
| Documentation autorisée | **aucune** : pas d'outil, de ressource ni de site externe pendant un QCM Linux Foundation | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser (basé sur Chrome, dernière version de Chrome recommandée pour la planification), webcam mobile pour balayer la pièce, pas de double écran, candidat dans le champ en permanence | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 |
| Règles et interdits | ne pas quitter le bureau sans accord du surveillant, pas de nourriture (liquides clairs tolérés), pas d'écouteurs ni d'appareils, rien d'écrit hors de la console d'examen, pas de communication avec un tiers | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-rules-and-policies> | indirecte, 2026-10-02 |
| Prérequis | aucun | <https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/> | indirecte, 2026-10-02 |
| Validité | 24 mois pour tout examen passé depuis le 2024-04-01 (36 mois auparavant) | <https://www.cncf.io/blog/2024/03/01/aligning-certifications-to-kubernetes-support-windows/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir l'examen avant l'expiration ; **ou** programme CARE (Certification Advancement & Recertification Experience) : obtenir ou renouveler CKA ou CKAD à partir du 2026-01-01 remet automatiquement KCNA à jour, même expirée, avec alignement des dates d'expiration ; mise en œuvre complète annoncée pour juin 2026 | <https://www.cncf.io/blog/2026/03/23/cncf-introduces-a-new-recertification-program-as-kubestronaut-community-surpasses-3500/> · <https://training.linuxfoundation.org/care-program/> | indirecte, 2026-10-02 |
| Prix indicatif | 250 USD (examen seul) ; 299 USD avec le cours LFS250 ; 495 USD avec l'abonnement THRIVE-ONE ; bundles KCNA + CKA, KCNA + KCSA, Kubestronaut (KCNA + KCSA + CKA + CKAD + CKS) et Golden Kubestronaut existent, prix **non trouvé** dans les extraits ; promotions fréquentes | <https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/> · <https://training.linuxfoundation.org/certification/kubestronaut-bundle/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | 12 mois pour passer l'examen après l'achat ; une reprise gratuite incluse | <https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/> | indirecte, 2026-10-02 |
| Simulateur inclus | **non** : le simulateur killer.sh est réservé aux examens pratiques (CKA, CKAD, CKS, CNPE, LFCS, CKNE) ; le bundle KCNA + CKA n'inclut le simulateur que pour CKA ; aucun examen blanc officiel pour les QCM | <https://training.linuxfoundation.org/blog/linux-foundation-kubernetes-certifications-now-include-exam-simulator/> · <https://training.linuxfoundation.org/training/kcna-cka-exam-bundle/> | indirecte, 2026-10-02 |
| Langues disponibles | anglais ; japonais (examen KCNA-JP distinct) ; chinois simplifié **non trouvé** pour KCNA (cité pour CKA/CKAD/ICA seulement) | <https://training.linuxfoundation.org/certification/kubernetes-and-cloud-native-associate-kcna-jp/> · <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/language> | indirecte (partiel), 2026-10-02 |
| Cours officiel associé | LFS250 « Kubernetes and Cloud Native Essentials » (facultatif, 8 à 10 h, labs et accès 12 mois) | <https://training.linuxfoundation.org/training/kubernetes-and-cloud-native-essentials-lfs250/> | indirecte, 2026-10-02 |
| Kubestronaut | oui : KCNA est l'une des cinq certifications requises (avec KCSA, CKA, CKAD, CKS), toutes valides en même temps ; requise aussi pour le Golden Kubestronaut (14 certifications CNCF + LFCS, CNPA incluse depuis le 2025-10-15) | <https://www.cncf.io/training/kubestronaut/> · <https://www.cncf.io/training/kubestronaut/kubestronaut-faq/> | indirecte, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- Ouvrir <https://training.linuxfoundation.org/kcna-program-changes/> : la page liste les compétences ajoutées, retirées
  ou reformulées sous chaque domaine ; reporter ces sous-points dans `objectifs.md` §3 (colonne « thèmes attendus »),
  qui n'est pour l'instant qu'une lecture des titres.
- Nombre de questions et langues : la FAQ propre à KCNA n'est pas apparue dans les extraits (seules les pages génériques
  des QCM ont répondu) ; chercher `frequently-asked-questions-kcna` sur docs.linuxfoundation.org. Le même extrait
  (« 60 questions, CNPA 85 ») vaut pour CAPA, dont `certifs/CAPA/examen.md` note encore « non trouvé » : à mettre à jour.
- Prix des bundles et promotions en cours avant d'acheter (Kubestronaut, Golden Kubestronaut, THRIVE-ONE).
- CARE : vérifier que la mise en œuvre annoncée pour juin 2026 est effective et comment l'alignement des dates apparaît
  sur le compte Linux Foundation ; cela change la stratégie de renouvellement du bloc Kubestronaut (§3).
- `programme.md` indique `source_file: KCNA.pdf` alors que le dépôt `cncf/curriculum` nomme le fichier `KCNA_Curriculum.pdf` ;
  même écart que CAPA, à aligner dans `certifs/_sources_pdf/generer_programmes.py`.
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : toutes les certifications passées depuis le 2024-04-01
  sont valides 24 mois (déjà signalé par `certifs/CAPA/examen.md`, hors périmètre de cette PR).

## 3. Conséquences pour la préparation

- **Pas de documentation pendant l'épreuve** : les noms exacts des objets, des champs et des commandes doivent être mémorisés.
  Chaque fiche produit 10 à 20 flashcards (`revision/flashcards/kubernetes-*.csv`, `securite-01-*.csv`, `observabilite-01-*.csv`) ;
  le quiz `revision/quiz/kcna` et l'examen blanc `exams/kcna/` (prompt `06-examen-blanc.md`) reproduisent le format
  QCM : 60 questions en 90 min, seuil 75 %.
- **Quatre domaines, 72 % sur les deux premiers** : Kubernetes Fundamentals et Container Orchestration d'abord
  (ordre de travail dans `objectifs.md` §1) ; le dépannage pèse 15 % (KCNA-02-03 + KCNA-03-02) et se prépare par les
  break-fix à l'aveugle.
- **Programme récent** : l'examen a changé au plus tôt le 2025-11-24. Les banques de questions et guides tiers décrivent
  encore cinq domaines avec une observabilité séparée ; ne réviser que sur `programme.md` et les flashcards du dépôt.
- **Jalon** : KCNA ferme le nœud `kubernetes_deb` (`docs/prerequis.md` §3, parcours Kubestronaut) et ouvre le bloc
  CKA → CKAD. Fixer la date d'examen à la fin des fiches F1 à F11, comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois. Avec CARE, réussir CKA ou CKAD remet KCNA à jour : passer KCNA tôt coûte
  peu en renouvellement tant que CKA/CKAD suivent dans les 24 mois ; le Kubestronaut exige les cinq certifications
  valides simultanément, donc enchaîner KCNA → CKA → CKAD → KCSA → CKS sans pause longue.

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam mobile, micro, débit), dernière version de Chrome installée.
- [ ] Examen blanc `exams/kcna/` réalisé deux fois à ≥ 80 % en 90 min (marge sur le seuil de 75 %).
- [ ] Flashcards des onze fiches revues à J-7, J-3, J-1 (`journal/`).
- [ ] Noms exacts relus : composants du control plane, états de Pod, types de Service, champs `securityContext`,
  modes d'accès des volumes, niveaux de maturité CNCF.
- [ ] Bureau dégagé, une seule fenêtre, aucun second écran.
