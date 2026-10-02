---
code: CNPE
titre: "CNPE — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org, cncf.io et killer.sh sont bloqués depuis la
  session qui a produit ce fichier (proxy de sortie). Les valeurs marquées « indirecte » viennent des extraits de ces
  pages officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles sont à confirmer en ouvrant l'URL citée
  à la prochaine veille (prompts/07-veille.md). Rien n'a été repris de sources tierces ; quand une source tierce
  contredit ou complète un extrait officiel, c'est signalé en §2 comme point à vérifier, jamais repris comme valeur.
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# CNPE — Certified Cloud Native Platform Engineer : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineer-cnpe/> | indirecte, 2026-10-02 |
| Annonce et lancement | annoncé le 2025-11-11 (KubeCon + CloudNativeCon North America), ouverture des inscriptions annoncée pour le 2025-11-26 | <https://www.cncf.io/announcements/2025/11/11/cncf-launches-cnpe-certification-to-define-enterprise-scale-platform-engineering-globally/> | indirecte, 2026-10-02 |
| Durée | 120 min (2 h) | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-cnpe> | indirecte, 2026-10-02 |
| Format | pratique : tâches à résoudre dans un bureau distant Linux (terminal et interfaces web), en ligne, surveillé à distance (audio, vidéo, partage d'écran) | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-cnpe> | indirecte, 2026-10-02 |
| Nombre de questions | 15 à 20 tâches pratiques | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-cnpe> | indirecte, 2026-10-02 |
| Score de réussite | 64 % | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-cnpe> | indirecte, 2026-10-02 |
| Niveau annoncé | intermédiaire | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineer-cnpe/> | indirecte, 2026-10-02 |
| Domaines et poids | Platform Architecture and Infrastructure 15 %, GitOps and Continuous Delivery 25 %, Platform APIs and Self-Service Capabilities 25 %, Observability and Operations 20 %, Security and Policy Enforcement 15 % | <https://github.com/cncf/curriculum> (`CNPE_Curriculum.pdf`) | directe, 2026-10-02 |
| Version du programme | non versionné ; PDF ajouté le 2025-11-28, remplacé le 2025-12-03 (dernier commit) | <https://github.com/cncf/curriculum/commits/master/CNPE_Curriculum.pdf> | directe, 2026-10-02 |
| Outils cités par le programme | Argo, Crossplane, Flagger, Flux, Gatekeeper, Grafana, Istio, Jaeger, Kyverno, Linkerd, OPA, OpenCost, OpenTelemetry, Prometheus, Tekton (exemples, pas une liste exhaustive) | <https://github.com/cncf/curriculum> (`CNPE_Curriculum.pdf`, page 3) | directe, 2026-10-02 |
| Version des logiciels | **non trouvé** : aucune version de Kubernetes ni des outils n'est annoncée sur les extraits officiels consultés | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-cnpe> | non trouvé, 2026-10-02 |
| Documentation autorisée | documentation Kubernetes (<https://kubernetes.io/docs>, toutes langues, recherche interne autorisée sans ouvrir de résultat externe), blog Kubernetes (<https://kubernetes.io/blog/>), et la documentation propre à chaque tâche fournie dans la boîte « Quick Reference » de l'interface (liens vers les outils nécessaires à la tâche) ; consultée depuis le navigateur du bureau distant uniquement | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser ; bureau distant XFCE sur Ubuntu avec émulateur de terminal (plusieurs fenêtres autorisées), Firefox (plusieurs onglets) et clavier virtuel ; deux onglets au départ : « ReadMe » (consignes) et « Remote Desktop » ; copier/coller terminal `Ctrl+Shift+C` / `Ctrl+Shift+V` | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-cnpe> et <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-user-interface/examui-performance-based-exams> | indirecte, 2026-10-02 |
| Règles et interdits | test système PSI à passer avant l'épreuve ; pièce vide, bureau dégagé, une seule fenêtre PSI, webcam ; notes, autres applications, navigation hors ressources autorisées, communication avec un tiers et appareils externes interdits | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> et <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-rules-and-policies> | indirecte, 2026-10-02 |
| Prérequis | aucun | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineer-cnpe/> | indirecte, 2026-10-02 |
| Validité | 2 ans | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineer-cnpe/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir l'examen avant l'expiration (règle générale Linux Foundation) | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/certificates-and-certification> | indirecte, 2026-10-02 |
| Prix indicatif | 445 USD (examen seul) ; 625 USD avec l'abonnement THRIVE-ONE (« full access ») ; promotions fréquentes (Cyber Week, Mega May) | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineer-cnpe/> et <https://training.linuxfoundation.org/certification/cnpe-exam-thrive-one-subscription-bundle/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | 12 mois pour passer l'examen après l'achat ; une reprise gratuite incluse | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineer-cnpe/> | indirecte, 2026-10-02 |
| Simulateur inclus | **oui** : simulateur killer.sh inclus dans l'inscription ; deux sessions identiques de 36 h chacune, activables indépendamment pendant 12 mois ; 20 scénarios avec solutions, sur des outils du paysage CNCF liés au platform engineering | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-cnpe> et <https://killer.sh/cnpe> | indirecte, 2026-10-02 |
| Langues disponibles | **non trouvé** | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-cnpe> | non trouvé, 2026-10-02 |
| Cours officiel associé | **non trouvé** : aucun cours Linux Foundation dédié identifié sur les extraits consultés (les bundles proposés sont « examen + THRIVE-ONE ») | <https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineer-cnpe/> | non trouvé, 2026-10-02 |
| Golden Kubestronaut | oui : CNPE est requis pour le Golden Kubestronaut depuis le 2026-03-01 (CNPA depuis le 2025-10-15) | <https://training.linuxfoundation.org/resources/kubestronaut-program/> | indirecte, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- Ouvrir la FAQ CNPE et les « Important Instructions » : nombre exact de tâches, score de réussite, langues,
  et surtout la liste des documentations présentes dans la boîte « Quick Reference » (une source tierce consultée
  affirme que l'examen n'est lié à aucune version de Kubernetes ; non repris faute d'extrait officiel).
- Vérifier sur la page du simulateur killer.sh le nombre de scénarios et la durée des sessions (36 h) : l'extrait
  cite la règle commune aux simulateurs CKA/CKAD/CKS/LFCS, pas une page CNPE ouverte.
- `programme.md` indique `source_file: CNPE.pdf` alors que le dépôt `cncf/curriculum` nomme le fichier
  `CNPE_Curriculum.pdf` ; aligner le générateur `certifs/_sources_pdf/generer_programmes.py` (même écart que CAPA).
- `programme.md` indique `source_url` « dernier commit consulté : 2026-03-14 » : le PDF n'a pas changé depuis le
  2025-12-03 ; mettre à jour la date à la veille.
- Prix : vérifier les promotions en cours avant d'acheter (bundle Golden Kubestronaut, THRIVE-ONE, Cyber Week).
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : CNPE et les associées sont valides 24 mois
  (déjà signalé dans `certifs/CAPA/examen.md`, hors périmètre de cette PR).

## 3. Conséquences pour la préparation

- **Examen pratique avec documentation limitée** : seule la documentation Kubernetes est garantie ; celle des autres
  outils n'est accessible que par les liens fournis dans la tâche. Il faut donc connaître les noms des CRD, des
  commandes CLI (`flux`, `argocd`, `tkn`, `kubectl argo rollouts`, `crossplane`, `kyverno`, `istioctl`) et savoir
  naviguer vite dans une documentation inconnue. Chaque fiche de `objectifs.md` §4 se termine par un défi
  « outil inconnu » de 15 min.
- **15 à 20 tâches en 120 min** : 6 à 8 min par tâche. Les défis chronométrés des fiches sont calibrés entre 12 et
  20 min en apprentissage ; le scénario S1 (exercice 3) et l'examen blanc `exams/cnpe/` (prompt `06-examen-blanc.md`)
  rejouent le format réel : 12 tâches, 120 min, `setup.sh` + `grade.sh`.
- **Score de 64 %** : accepter de sauter une tâche coûteuse ; s'entraîner à lire l'énoncé, estimer, trier.
- **Simulateur inclus** : deux sessions killer.sh de 36 h, à placer à J-14 (diagnostic, liste des manques) et J-3
  (confirmation), chacune suivie d'une entrée dans `journal/`.
- **Jalon** : CNPE ferme le parcours Golden Kubestronaut (`docs/prerequis.md` §3, nœud `plateforme_exp`) ; il se
  prépare après CNPA, ICA, KCA, PCA/OTCA et le bloc CGOA/CAPA dont il réutilise les chapitres (`objectifs.md` §5).
  Fixer la date d'examen à la fin du bloc, comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois, à aligner sur les autres certifications pour que tout soit valide en
  même temps au moment de la demande Golden Kubestronaut.

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit).
- [ ] Deuxième session killer.sh terminée à ≥ 80 % en moins de 120 min (marge sur le seuil de 64 %).
- [ ] Examen blanc `exams/cnpe/` réussi deux fois en conditions réelles (terminal seul, documentation Kubernetes seule).
- [ ] Flashcards des 14 fiches revues à J-7, J-3, J-1 (`journal/`) ; aliases et autocomplétion `kubectl` connus par cœur
  (ils doivent être recréés dans l'environnement d'examen).
- [ ] Raccourcis Firefox et terminal du bureau distant répétés (copier/coller `Ctrl+Shift+C/V`, onglets).
- [ ] Bureau dégagé, une seule fenêtre, aucun second écran.
