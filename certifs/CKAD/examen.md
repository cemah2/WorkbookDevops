---
code: CKAD
titre: "CKAD — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org, cncf.io, kubernetes.io et killer.sh sont bloqués
  depuis la session qui a produit ce fichier (proxy de sortie), comme pour certifs/CAPA/examen.md. Les valeurs marquées
  « indirecte » viennent des extraits de ces pages officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles
  sont à confirmer en ouvrant l'URL citée à la prochaine veille (prompts/07-veille.md). Seul github.com/cncf/curriculum
  a été lu directement. Rien n'a été repris de sources tierces.
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# CKAD — Certified Kubernetes Application Developer : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/> | indirecte, 2026-10-02 |
| Durée | 2 h (120 min) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Format | pratique : tâches à résoudre en ligne de commande sur de vrais clusters Kubernetes, en ligne, surveillé à distance | <https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/> | indirecte, 2026-10-02 |
| Nombre de questions | 15 à 20 tâches pratiques (la FAQ donne une fourchette, pas un nombre fixe) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Score de réussite | 66 % | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Correction | automatique, résultat sous 24 h en général | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Domaines et poids | Design and Build 20 %, Deployment 20 %, Observability and Maintenance 15 %, Environment/Configuration/Security 25 %, Services and Networking 20 % | <https://github.com/cncf/curriculum> (`CKAD_Curriculum_v1.37.pdf`) | directe, 2026-10-02 |
| Version du programme | v1.37, commit `f423fa4` du 2026-10-01 ; texte identique au v1.35 (commit du 2026-02-25) conservé dans `programme.md` | <https://github.com/cncf/curriculum/commits/master/CKAD_Curriculum_v1.37.pdf> | directe, 2026-10-02 |
| Version de Kubernetes à l'examen | v1.37 annoncé sur la page d'examen ; l'environnement est aligné sur la dernière mineure 4 à 8 semaines après sa sortie | <https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/> et <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Documentation autorisée | un seul onglet de navigateur supplémentaire vers `https://kubernetes.io/docs/` (toutes langues), `https://kubernetes.io/blog/`, `https://helm.sh/docs/` et `https://github.com/kubernetes/`, sous-domaines compris ; rien d'autre (notes, autres sites, outils) | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser ; bureau Linux distant (ExamUI) avec émulateur de terminal, Firefox pour la documentation autorisée et clavier virtuel ; webcam, pièce privée, candidat dans le champ de la caméra | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-user-interface/examui-performance-based-exams> et <https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad> | indirecte, 2026-10-02 |
| Clusters et contextes | **non trouvé** sur les extraits officiels (nombre de clusters, nom du nœud de départ, contexte à activer par tâche) ; lire « Important Instructions: CKA and CKAD » à la veille | <https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad> | non trouvé, 2026-10-02 |
| Règles et interdits | session enregistrée et relue ; toute activité suspecte annule le score et peut interdire de repasser l'examen ; pièce d'identité officielle physique au nom exact du compte | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 |
| Prérequis | aucun | <https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/> | indirecte, 2026-10-02 |
| Validité | 2 ans (24 mois pour tout examen passé depuis le 2024-04-01 00:00 UTC) | <https://training.linuxfoundation.org/certification-policy-change-2024/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir l'examen avant l'expiration | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/certificates-and-certification> | non trouvé (page non ouverte, règle générale reprise de `certifs/CAPA/examen.md`), 2026-10-02 |
| Prix indicatif | 445 USD (examen seul) ; 625 USD avec l'abonnement THRIVE-ONE ; 645 USD avec le cours LFD259 « Kubernetes for Developers » ; bundle CKA + CKAD + CKS et promotions fréquentes | <https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/> et <https://training.linuxfoundation.org/training/cka-ckad-cks-exam-bundle/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | 12 mois pour passer l'examen après l'achat ; une reprise gratuite, à utiliser dans ces mêmes 12 mois | <https://training.linuxfoundation.org/?p=1493> (Exam Retake Policy) | indirecte, 2026-10-02 |
| Simulateur inclus | **oui** : killer.sh, deux sessions, 36 h d'accès chacune à partir de l'activation, même interface que l'examen | <https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/> et <https://training.linuxfoundation.org/blog/linux-foundation-kubernetes-certifications-now-include-exam-simulator/> | indirecte, 2026-10-02 |
| Langues disponibles | anglais, japonais, chinois simplifié (épreuve et surveillant) | <https://training.linuxfoundation.org/blog/certified-kubernetes-application-developer-exam-available-in-chinese/> et <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/language> | indirecte, 2026-10-02 |
| Cours officiel associé | LFD259 « Kubernetes for Developers » (facultatif) | <https://training.linuxfoundation.org/certification/kubernetes-for-developers-lfd259-ckad-exam-bundle/> | indirecte, 2026-10-02 |
| Kubestronaut / Golden Kubestronaut | oui, CKAD fait partie des cinq certifications Kubestronaut (repris de `certifs/README.md`, page officielle non ouverte cette session) | <https://www.cncf.io/training/kubestronaut/> | non vérifié, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- Version de Kubernetes réellement servie à l'examen à la date du jalon (page d'examen) et écart avec `versions.yaml` (clé
  `kubernetes`, `exam_note` encore à « CKAD en 1.35 »). Mettre `programme.md` en v1.37 via `certifs/_sources_pdf/generer_programmes.py`
  (le dépôt `cncf/curriculum` nomme le fichier `CKAD_Curriculum_v1.37.pdf`, le générateur attend `CKAD_v1.37.pdf`).
- Nombre de clusters, contexte de départ et accès `ssh`/`sudo` aux nœuds : lire « Important Instructions: CKA and CKAD ».
- Nombre exact de tâches (la FAQ donne 15 à 20) et pondération par tâche affichée dans l'interface.
- Documentation autorisée : vérifier que `helm.sh/docs` et `github.com/kubernetes` figurent bien dans la liste CKAD (et pas seulement CKA),
  et si `kubernetes.io/docs` en français est accepté.
- Prix et promotions en cours (bundle CKA + CKAD + CKS, Cyber Monday, THRIVE-ONE) avant d'acheter.
- Nouvelle certification **CKNE** ajoutée au dépôt `cncf/curriculum` le 2026-10-01 : impact sur `certifs/README.md` et le Golden Kubestronaut.
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : depuis le 2024-04-01 toutes les certifications Linux Foundation
  passées sont valides 24 mois (déjà signalé dans `certifs/CAPA/examen.md`, hors périmètre de cette PR).

## 3. Conséquences pour la préparation

- **Tout se joue au terminal, chronomètre en main** : 15 à 20 tâches en 120 min, soit 6 à 8 min par tâche. Chaque fiche
  de `objectifs.md` §4 se termine par un défi chronométré calibré sur cette cadence ; la checklist de maîtrise n'est cochée
  qu'en conditions réelles (un seul onglet `kubernetes.io/docs`, pas d'alias exotique, `vim` seul).
- **La documentation est autorisée, pas le temps de la lire** : savoir *où* est chaque page (`kubectl explain`, index des
  tâches `kubernetes.io/docs/tasks`, `kubectl create --help`) compte plus que mémoriser le YAML. Les flashcards
  (`revision/flashcards/kubernetes-NN-*.csv`) portent sur les noms de champs et les commandes impératives.
- **Seuil à 66 %, pas 100 %** : sauter une tâche longue et y revenir est une stratégie ; `exams/ckad-01/` entraîne à
  trier les tâches par poids affiché.
- **Deux sessions killer.sh de 36 h** : les réserver aux deux dernières semaines, la première comme diagnostic, la seconde
  comme répétition générale ; le simulateur est réputé plus difficile que l'examen, le score n'est pas un prédicteur.
- **Jalon** : CKAD se passe dans le bloc Kubestronaut, juste après CKA (`docs/prerequis.md` §3 et §4, nœud `kubernetes_conf`) ;
  les sept fiches débutant de `objectifs.md` §5 sont communes aux deux examens. Fixer la date d'examen à la fin du troisième
  cycle comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois. Pour le Golden Kubestronaut, enchaîner CKA → CKAD → CKS sur un cycle court
  pour que les trois restent valides pendant la rafale des associées.

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité physique au nom exact du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit) ; pièce privée, bureau dégagé, un seul écran.
- [ ] Examen blanc `exams/ckad-01/` réalisé deux fois à ≥ 80 % en 2 h (marge sur le seuil de 66 %).
- [ ] Première session killer.sh faite à J-14, seconde à J-3, erreurs consignées dans `journal/`.
- [ ] Flashcards des treize fiches revues à J-7, J-3, J-1 ; checklists de maîtrise toutes cochées en conditions réelles.
- [ ] Version de Kubernetes de l'examen vérifiée sur la page officielle et `kind` épinglé dessus pour la dernière semaine.
