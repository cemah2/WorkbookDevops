---
code: ICA
titre: "ICA — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org, cncf.io, istio.io et killer.sh sont bloqués
  depuis la session qui a produit ce fichier (proxy de sortie). Les valeurs marquées « indirecte » viennent des
  extraits de ces pages officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles sont à confirmer en
  ouvrant l'URL citée à la prochaine veille (prompts/07-veille.md). Rien n'a été repris de sources tierces
  (blogs, cours, dumps) : quand seules des sources tierces donnaient une valeur, elle est marquée « non trouvé ».
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# ICA — Istio Certified Associate : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/istio-certified-associate-ica/> | indirecte, 2026-10-02 |
| Lancement | achat ouvert le 2023-09-21, passage de l'examen à partir du 2023-11-06 | <https://www.cncf.io/blog/2023/11/06/introducing-the-istio-certified-associate-ica-certification-for-microservices-management/> | indirecte, 2026-10-02 |
| Refonte du programme | nouvelle version de l'examen le 2025-08-12 00:00 UTC (examen hors ligne du 2025-07-28 au 2025-08-11) : domaines 20 / 35 / 25 / 20 %, mode ambient ajouté | <https://training.linuxfoundation.org/istio-certified-associate-ica-program-changes/> | indirecte, 2026-10-02 |
| Durée | 120 min | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-ica> | indirecte, 2026-10-02 |
| Format | pratique : tâches à résoudre en ligne de commande dans un cluster réel, en ligne, surveillé à distance. L'extrait de la page produit dit encore « performance-based and multiple-choice » : formulation à vérifier, la FAQ ne parle que de tâches | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-ica> | indirecte, 2026-10-02 |
| Nombre de questions | 15 à 20 tâches pratiques | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-ica> | indirecte, 2026-10-02 |
| Score de réussite | 68 % | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-ica> | indirecte, 2026-10-02 |
| Domaines et poids | Installation, Upgrades, and Configuration 20 % ; Traffic Management 35 % ; Securing Workloads 25 % ; Troubleshooting 20 % | <https://github.com/cncf/curriculum> (`ICA_Curriculum.pdf`) | directe, 2026-10-02 |
| Version du programme | non versionné ; dernier commit du PDF le 2025-08-12 (précédents : 2024-10-21, 2024-02-22) | <https://github.com/cncf/curriculum/commits/master/ICA_Curriculum.pdf> | directe, 2026-10-02 |
| Version du logiciel | Istio **1.29** selon la FAQ (« The ICA environment is currently running Istio v1.29 ») ; la note de refonte du 2025-08-12 annonçait 1.26, la FAQ est plus récente. Le lab est en 1.31.1 (`versions.yaml`, clé `istio`) | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-ica> | indirecte, 2026-10-02 |
| Documentation autorisée | <https://istio.io/docs/>, <https://istio.io/blog/>, <https://kubernetes.io/docs/> (fonction de recherche de ces sites autorisée, résultats externes interdits) ; liens de la « Quick Reference box » de chaque tâche ; pages `man` et documents sous `/usr/share` de la VM | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 |
| Outils fournis | `kubectl` (alias `k`, complétion Bash), `istioctl` (complétion Bash), `yq`, `curl`, `wget`, pages `man` | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-ica> | indirecte, 2026-10-02 |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser ; ExamUI « performance based » (même interface que CKA/CKAD/CKS/LFCS) : bureau distant Linux avec terminal, Firefox limité aux ressources autorisées, clavier virtuel ; copier-coller avec `Ctrl+Shift+C` / `Ctrl+Shift+V` ; écran 15" et 1080p recommandés | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-user-interface/examui-performance-based-exams> | indirecte, 2026-10-02 |
| Règles et interdits | pièce fermée sans tiers, webcam et micro, pas de second écran ni d'appareil externe, pas de notes, pas de machine professionnelle recommandée | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 |
| Prérequis | **non trouvé** sur les extraits officiels consultés (les examens Linux Foundation n'en imposent généralement pas ; à lire sur la page produit) | <https://training.linuxfoundation.org/certification/istio-certified-associate-ica/> | non trouvé, 2026-10-02 |
| Validité | 2 ans (« certification is valid for 2 years » sur la page produit, cohérent avec la politique du 2024-04-01 : 24 mois pour tout examen passé depuis). Un extrait plus ancien de la FAQ ICA dit encore « renewed every three years » : obsolète, à faire confirmer | <https://training.linuxfoundation.org/certification/istio-certified-associate-ica/> ; <https://training.linuxfoundation.org/certification-policy-change-2024/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir le même examen avant l'expiration | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/certificates-and-certification> | indirecte, 2026-10-02 |
| Prix indicatif | 250 USD (examen seul) ; 299 USD avec le cours LFS245 ; 495 USD avec l'abonnement THRIVE-ONE ; promotions fréquentes | <https://training.linuxfoundation.org/certification/istio-certified-associate-ica/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | une reprise gratuite incluse ; durée d'éligibilité après achat : **non trouvé** dans les extraits ICA (12 mois sur les autres examens Linux Foundation, à confirmer) | <https://training.linuxfoundation.org/certification/istio-certified-associate-ica/> | indirecte (reprise) / non trouvé (éligibilité), 2026-10-02 |
| Simulateur inclus | **non trouvé** : aucune mention d'un simulateur pour ICA sur la page produit ni dans la FAQ ; le simulateur killer.sh inclus par Linux Foundation couvre les examens pratiques Kubernetes, LFCS et CNPE (liste reprise de `certifs/CAPA/examen.md`), ICA n'y figure pas dans les extraits consultés. Le workbook compense avec `exams/ica-01/` (`objectifs.md` §4, E1) | <https://training.linuxfoundation.org/blog/linux-foundation-kubernetes-certifications-now-include-exam-simulator/> | non trouvé, 2026-10-02 |
| Langues disponibles | anglais, chinois simplifié, japonais (bascule par l'icône globe pendant l'épreuve) | <https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-ica> | indirecte, 2026-10-02 |
| Cours officiel associé | LFS245 « Istio Service Mesh Essentials » (facultatif) | <https://training.linuxfoundation.org/training/istio-service-mesh-essentials-lfs245/> | indirecte, 2026-10-02 |
| Golden Kubestronaut | oui : ICA est dans la liste des 15 certifications CNCF requises, plus LFCS | <https://www.cncf.io/training/kubestronaut/> | indirecte, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- Ouvrir la FAQ ICA et la page « Important Instructions: ICA » : version d'Istio en vigueur (1.29 ?), nombre de tâches,
  formulation exacte du format, durée d'éligibilité.
- Ouvrir la page produit : prérequis, mention « multiple-choice » (reliquat de l'ancienne version ou non), prix du jour.
- Vérifier sur killer.sh et sur le blog Linux Foundation si un simulateur ICA a été ajouté depuis.
- `versions.yaml` : ajouter `exam_note` sur la clé `istio` avec la version d'examen confirmée (`objectifs.md` §2).
- `programme.md` indique `source_file: ICA.pdf` alors que le dépôt `cncf/curriculum` nomme le fichier `ICA_Curriculum.pdf` ;
  même écart que pour CAPA, à aligner dans `certifs/_sources_pdf/generer_programmes.py`.
- `programme.md` : `exam_format` dit « 120 min » et `source_url` cite un commit du 2026-03-14 ; le PDF n'a pas changé
  depuis le 2025-08-12, cohérent.
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : déjà signalé par `certifs/CAPA/examen.md`, toujours à corriger.

## 3. Conséquences pour la préparation

- **Examen pratique, documentation ouverte mais chronomètre serré** : 15 à 20 tâches en 120 min, soit 6 à 8 min par
  tâche. Ce qui compte : savoir *où* est la page `istio.io` utile et copier le bon manifeste sans le lire en entier.
  Chaque fiche s'achève sur un défi au format de l'examen et sur des flashcards « nom de CRD → champ → page de doc ».
- **Deux modes à maîtriser** : sidecar et ambient sont tous deux au programme depuis 2025-08-12. Les fiches traitent
  les deux ; ne pas faire l'impasse sur ztunnel et les waypoints.
- **Version** : lab en 1.31.1, examen en 1.29 (à confirmer). Les objets `networking.istio.io/v1` et
  `security.istio.io/v1` sont stables ; surveiller les commandes `istioctl` qui changent de nom (`istioctl x …` → commande
  stable) et les noter dans la ligne « différences avec la version d'examen » de chaque fiche.
- **Seuil à 68 %** : viser 80 % sur `exams/ica-01/` deux fois de suite avant de réserver la date.
- **Jalon** : ICA se passe dans le bloc `reseau_conf` → `plateforme_conf` du parcours Golden Kubestronaut, avec CCA et
  KCA (`docs/prerequis.md` §3). Fixer la date à la fin du bloc, comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois, à planifier dans la rafale des associées après le bloc CKA/CKAD/CKS.

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit), écran 1080p, machine personnelle.
- [ ] `exams/ica-01/` réalisé deux fois à ≥ 80 % en 120 min, avec la seule documentation `istio.io` ouverte.
- [ ] Raccourcis acquis : alias `k`, complétion `istioctl`, `Ctrl+Shift+C/V`, `kubectl config set-context --namespace`.
- [ ] Flashcards des huit fiches revues à J-7, J-3, J-1 (`journal/`).
- [ ] Bureau dégagé, une seule fenêtre, aucun second écran.
