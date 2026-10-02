---
code: CCA
titre: "CCA — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org, cncf.io et docs.cilium.io sont bloqués depuis la
  session qui a produit ce fichier (proxy de sortie). Les valeurs marquées « indirecte » viennent des extraits de ces pages
  officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles sont à confirmer en ouvrant l'URL citée à la prochaine
  veille (prompts/07-veille.md). Seul github.com (dépôt cncf/curriculum) a été ouvert directement. Rien n'a été repris de
  sources tierces.
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# CCA — Cilium Certified Associate : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/> | indirecte, 2026-10-02 |
| Annonce | 2023-11-06 (« coming soon ») | <https://training.linuxfoundation.org/blog/coming-soon-cilium-certified-associate-cca/> | indirecte, 2026-10-02 |
| Lancement | 2024-03-07 | <https://training.linuxfoundation.org/blog/cilium-certified-associate-cca-launches/> | indirecte, 2026-10-02 |
| Durée | 90 min (règle générale des QCM Linux Foundation, seule exception : CNPA à 120 min) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Format | QCM en ligne, surveillé à distance | <https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/> | indirecte, 2026-10-02 |
| Nombre de questions | 60 (règle générale des QCM Linux Foundation, exception : CNPA à 85) ; la page CCA elle-même ne donne pas de nombre dans les extraits consultés | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Score de réussite | 75 % (règle générale des QCM ; exceptions listées : ICA 68 %, CNPE 64 %, SkillCred 70 %) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | indirecte, 2026-10-02 |
| Domaines et poids | Architecture 20 %, Network Policy 18 %, Service Mesh 16 %, Network Observability 10 %, Installation and Configuration 10 %, Cluster Mesh 10 %, eBPF 10 %, BGP and External Networking 6 % | <https://github.com/cncf/curriculum> (`CCA_Curriculum.pdf`) | directe, 2026-10-02 |
| Version du programme | non versionné ; premier commit du PDF le 2024-02-22, dernier commit le 2024-10-21 (« CCA Exam Curriculum ») | <https://github.com/cncf/curriculum/commits/master/CCA_Curriculum.pdf> | directe, 2026-10-02 |
| Version du logiciel | **non trouvé** : aucune version de Cilium n'est annoncée pour l'examen dans les extraits consultés ; le workbook suit la clé `cilium` de `versions.yaml` | <https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/> | non trouvé, 2026-10-02 |
| Documentation autorisée | **aucune** : pas d'outil, de ressource ni de site externe pendant un QCM Linux Foundation | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 (extrait repris de la fiche CAPA du même jour) |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser (basé sur Chrome), webcam, une seule fenêtre ouverte, pièce vide et bureau dégagé | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 (extrait repris de la fiche CAPA du même jour) |
| Interface de l'épreuve | ExamUI QCM : minuteur affiché ; la pause ne l'arrête pas, une déconnexion non plus ; score envoyé par courriel sous 24 h | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-user-interface/examui-multiple-choice-exams> | indirecte, 2026-10-02 |
| Règles et interdits | notes, autres applications, navigation web, communication avec un tiers et appareils externes interdits | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-rules-and-policies> | indirecte, 2026-10-02 (extrait repris de la fiche CAPA du même jour) |
| Prérequis | aucun ; recommandé : Kubernetes et bases réseau (modèle à 7 couches, rôle de TCP, UDP, DNS et HTTP) | <https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/> | indirecte, 2026-10-02 |
| Validité | 2 ans (24 mois pour tout examen passé depuis le 2024-04-01) | <https://training.linuxfoundation.org/certification-policy-change-2024/> | indirecte, 2026-10-02 (extrait repris de la fiche CAPA du même jour ; la page CCA dit « valid for 2 years ») |
| Renouvellement | repasser et réussir le même examen avant l'expiration ; autres voies dans la FAQ de chaque certification | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/certificates-and-certification> | indirecte, 2026-10-02 (extrait repris de la fiche CAPA du même jour) |
| Prix indicatif | 250 USD (examen seul) ; 495 USD avec l'abonnement THRIVE-ONE ; promotions fréquentes | <https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | 12 mois pour planifier et passer l'examen après l'achat ; deux tentatives (une reprise gratuite) | <https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/> | indirecte, 2026-10-02 |
| Simulateur inclus | **non** : le simulateur killer.sh est réservé aux examens pratiques ; aucun examen blanc officiel pour les QCM | <https://training.linuxfoundation.org/blog/linux-foundation-kubernetes-certifications-now-include-exam-simulator/> | indirecte, 2026-10-02 (extrait repris de la fiche CAPA du même jour) |
| Langues disponibles | **non trouvé** | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | non trouvé, 2026-10-02 |
| FAQ dédiée | **non trouvé** : aucune page « Frequently Asked Questions: CCA » dans les résultats, contrairement à ICA, CNPE ou CKNE ; la FAQ générale des QCM fait foi | <https://docs.linuxfoundation.org/tc-docs/certification/faq-mc> | non trouvé, 2026-10-02 |
| Cours officiel associé | LFS146 « Introduction to Cilium » (gratuit, en ligne, environ 26 h, 8 chapitres de l'installation au Cluster Mesh ; demande un cluster sans CNI) | <https://training.linuxfoundation.org/training/introduction-to-cilium-lfs146/> | indirecte, 2026-10-02 |
| Golden Kubestronaut | oui, CCA fait partie des 15 certifications CNCF requises (+ LFCS), toutes valides en même temps | <https://www.cncf.io/training/kubestronaut/> | indirecte, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- Nombre de questions, langues et éventuelle FAQ dédiée : ouvrir la page CCA, la FAQ des QCM et chercher une page
  « Frequently Asked Questions: CCA » dans `docs.linuxfoundation.org/tc-docs/certification/`.
- Version de Cilium visée par l'examen : rien n'est annoncé ; vérifier si la page CCA ou le curriculum cite une version
  (le PDF du 2024-10-21 n'en cite pas). Le workbook suit `versions.yaml` (`cilium`) et signale les écarts de nom de champ.
- `programme.md` indique `source_file: CCA.pdf` alors que le dépôt `cncf/curriculum` nomme le fichier `CCA_Curriculum.pdf` ;
  aligner le générateur `certifs/_sources_pdf/generer_programmes.py` (même remarque que pour CAPA).
- Prix : vérifier les promotions en cours avant d'acheter (bundles, Cyber Week, THRIVE-ONE).
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : depuis le 2024-04-01 toutes les certifications Linux Foundation
  sont valides 24 mois. Déjà signalé par la fiche CAPA, toujours à corriger (hors périmètre de cette PR).

## 3. Conséquences pour la préparation

- **Pas de documentation pendant l'épreuve** : les noms exacts des CRD (`CiliumNetworkPolicy`, `CiliumClusterwideNetworkPolicy`,
  `CiliumBGPClusterConfig`, `CiliumLoadBalancerIPPool`, `CiliumEgressGatewayPolicy`…), des champs (`toFQDNs`, `toEntities`,
  `endpointSelector`), des modes (`policyEnforcementMode`, `routingMode`, `kubeProxyReplacement`) et des commandes `cilium` / `hubble`
  doivent être mémorisés. Chaque fiche produit 10 à 20 flashcards (`revision/flashcards/reseau-1*.csv`) ; le quiz `revision/quiz/`
  et l'examen blanc `exams/` (prompt `06-examen-blanc.md`) reproduisent le format QCM à 60 questions en 90 min.
- **Les notions dominent les manipulations** : 68 % des points sur Architecture + Network Policy + Service Mesh + eBPF, domaines où
  l'examen attend des comparaisons (eBPF vs iptables, Gateway API vs Ingress, sidecar vs sans sidecar, NetworkPolicy vs
  CiliumNetworkPolicy, tunnel vs routage natif). Les tableaux comparatifs de `objectifs.md` §4 sont à apprendre tels quels.
- **Quelques points faciles à prendre** : Cluster Mesh (10 %, 2 compétences) et Installation (10 %, 2 compétences) pèsent 5 % par
  compétence, le double de la moyenne. Ne pas les négliger parce qu'ils arrivent en fin de série (F1 les couvre pour l'installation).
- **Jalon** : CCA se passe dans le bloc `reseau_conf` du parcours Golden Kubestronaut, avec ICA et KCA (`docs/prerequis.md` §3).
  Fixer la date d'examen à la fin du bloc, comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois. Pour le Golden Kubestronaut, planifier CCA dans la rafale des associées après le bloc
  CKA/CKAD/CKS (`docs/roadmap.md` §7).
- **Cours gratuit** : LFS146 couvre les mêmes huit chapitres que le programme ; ses labs supposent un cluster sans CNI, ce que le profil
  `kubernetes-ha` (kubeadm, `--skip-phases=addon/kube-proxy`) fournit. Utile comme second passage avant l'examen blanc.

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit).
- [ ] Quiz blanc à 60 questions / 90 min réalisé deux fois à ≥ 80 % (marge sur le seuil de 75 %).
- [ ] Flashcards des sept fiches revues à J-7, J-3, J-1 (`journal/`).
- [ ] Tableaux comparatifs (eBPF/iptables, Gateway API/Ingress, sidecar/sans sidecar, NetworkPolicy/CNP) récités sans notes.
- [ ] Bureau dégagé, une seule fenêtre, aucun second écran.
