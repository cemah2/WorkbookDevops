---
code: CKA
titre: "CKA — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org, cncf.io et killer.sh sont bloqués depuis la session
  qui a produit ce fichier (proxy de sortie, 403 sur CONNECT). Les valeurs marquées « indirecte » viennent des extraits de ces
  pages officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles sont à confirmer en ouvrant l'URL citée à la
  prochaine veille (prompts/07-veille.md). Rien n'a été repris de sources tierces (blogs, dépôts de préparation).
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# CKA — Certified Kubernetes Administrator : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué, ou document officiel committé dans le dépôt ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/> | indirecte, 2026-10-02 |
| Durée | 2 h (120 min) | <https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/> | indirecte, 2026-10-02 |
| Format | pratique : tâches à résoudre en ligne de commande sur des clusters Linux réels, surveillé à distance (audio, vidéo, partage d'écran) | <https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad> | indirecte, 2026-10-02 |
| Nombre de questions | 15 à 20 tâches notées (fourchette officielle ; le nombre exact varie d'une session à l'autre) | <https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad> | indirecte, 2026-10-02 |
| Score de réussite | 66 % | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Domaines et poids | Storage 10 %, Workloads and Scheduling 15 %, Servicing and Networking 20 %, Troubleshooting 30 %, Cluster Architecture, Installation and Configuration 25 % | <https://github.com/cncf/curriculum> (`CKA_v1.35.pdf`, copie dans `certifs/_sources_pdf/`) | directe (PDF committé), 2026-10-02 |
| Version du programme | Kubernetes 1.35 (`CKA_v1.35.pdf`) ; dernière révision de fond du programme entrée en vigueur le 2025-02-18 (Gateway API, Helm, Kustomize, CRD, opérateurs ajoutés ; « provision underlying infrastructure » retiré) | <https://training.linuxfoundation.org/certified-kubernetes-administrator-cka-program-changes/> | indirecte, 2026-10-02 |
| Version de l'environnement d'examen | Kubernetes v1.35 (l'extrait de la même page indique CKAD en v1.37 : à confirmer, incohérent avec `certifs/CKAD/programme.md`) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Documentation autorisée | un seul onglet de navigateur dans l'environnement d'examen vers : <https://kubernetes.io/docs> (recherche interne du site autorisée, pas de résultat externe), <https://kubernetes.io/blog>, <https://helm.sh/docs>, et pour la CKA seulement <https://gateway-api.sigs.k8s.io> ; traductions de kubernetes.io incluses ; liens de la boîte « Quick Reference » de chaque tâche | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser, bureau Linux distant avec terminal ; ne jamais redémarrer le nœud `base` ; raccourcis Linux (`Ctrl+Shift+C` / `Ctrl+Shift+V`, `Ctrl+Alt+W` à la place de `Ctrl+W`) ; écran 15" et 1080p recommandés | <https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad> | indirecte, 2026-10-02 |
| Règles et interdits | pièce privée, bureau dégagé, murs nus, pas d'espace public ; aucune autre application ni fenêtre ; notes, communication avec un tiers et appareils externes interdits ; pièce d'identité officielle non expirée au nom exact du compte | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 |
| Prérequis | aucun (la CKA est elle-même prérequis de la CKS) | <https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/> | indirecte, 2026-10-02 |
| Validité | 2 ans (24 mois) | <https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir la CKA avant expiration ; depuis 2026, programme CARE de la CNCF : réussir la CKS prolonge aussi la CKA (modalités à lire sur l'annonce) | <https://www.cncf.io/blog/2026/06/17/expanding-care-passing-cks-can-now-extend-your-cka-certification/> | indirecte, 2026-10-02 |
| Prix indicatif | 445 USD (examen seul) ; 625 USD avec l'abonnement THRIVE-ONE ; 645 USD avec le cours LFS258 ; bundles CKA+CKAD+CKS, KCNA+CKA et Kubestronaut ; promotions fréquentes | <https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | une reprise offerte en cas d'échec « when eligible » ; durée d'éligibilité après achat : **non trouvé** dans les extraits (règle générale LF à confirmer sur la page CKA) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte / non trouvé, 2026-10-02 |
| Simulateur inclus | **oui** : simulateur killer.sh, deux sessions de 36 h chacune à partir de l'activation ; environnement identique à l'examen, questions identiques entre les deux sessions | <https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/> | indirecte, 2026-10-02 |
| Langues disponibles | anglais, chinois simplifié, japonais (une déclinaison CKA-JP existe au catalogue) | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Cours officiel associé | LFS258 « Kubernetes Fundamentals » (facultatif) | <https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/> | indirecte, 2026-10-02 |
| Kubestronaut / Golden Kubestronaut | oui : la CKA fait partie des cinq certifications Kubestronaut (KCNA, KCSA, CKA, CKAD, CKS) et des 15 + LFCS du Golden ; toutes doivent être valides en même temps | <https://www.cncf.io/training/kubestronaut/> | indirecte, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- Version de l'environnement d'examen : l'extrait de la FAQ cite CKA v1.35 et CKAD v1.37 ; relire la page et aligner
  `certifs/CKAD/programme.md` ou `versions.yaml` (`exam_note`) si l'écart est réel.
- Durée d'éligibilité après achat (12 mois selon la règle générale Linux Foundation) : à lire sur la page CKA, non reprise ici faute d'extrait.
- Nombre exact de tâches et barème par tâche : non publiés ; garder « 15 à 20 ».
- Programme CARE : vérifier dans quelles conditions une CKS réussie prolonge la CKA (durée, date d'effet) avant de planifier le renouvellement.
- Prix : vérifier les promotions et bundles avant d'acheter (Kubestronaut bundle si les cinq examens sont prévus dans l'année).
- `docs/roadmap.md` §7 écrit « la plupart des associées 3 ans » : toutes les certifications Linux Foundation passées depuis le 2024-04-01
  sont valides 24 mois (déjà signalé dans `certifs/CAPA/examen.md`, hors périmètre de cette PR).

## 3. Conséquences pour la préparation

- **Examen pratique, documentation officielle ouverte** : ce qui compte est la vitesse. Chaque fiche K1 à K12 finit par un défi
  chronométré avec `kubernetes.io/docs` ouvert dans un seul onglet et rien d'autre ; les examens blancs `exams/cka-blanc-NN/` reproduisent
  les 120 min, le seuil de 66 % et l'absence de toute autre ressource. Apprendre à naviguer dans la documentation (recherche interne, pages
  « Tasks ») est un exercice en soi.
- **55 % des points sur le dépannage et l'architecture de cluster** : K5, K6, K11, K12 sont les fiches les plus longues et les plus
  rejouées (`break.sh random`). Ordre de travail dans `objectifs.md` §1.
- **Environnement** : clusters réels sur Ubuntu, `kubeadm`, `containerd`, `etcdctl`, `crictl`, `journalctl`, `systemctl`. Le lab
  `kubernetes-ha` reproduit cette pile (DECISIONS.md : Ubuntu 24.04 LTS, kubeadm par défaut). S'entraîner avec les raccourcis Linux
  du terminal et sans `tmux` ni `k9s` (interdits d'examen listés dans `docs/roadmap.md` §4).
- **Version** : lab en 1.37 (`versions.yaml`), examen en 1.35. Les fiches signalent les écarts dans « Points de vigilance (versions) » ;
  pas de second lab.
- **Simulateur** : les deux sessions killer.sh sont à placer à J-14 (diagnostic) et J-3 (confirmation), pas avant d'avoir fini K12.
- **Jalon** : la CKA ouvre le bloc CKA → CKAD → CKS du parcours Kubestronaut (`docs/prerequis.md` §3, nœud `kubernetes_conf`).
  Fixer la date d'examen à la fin du bloc K1 à K12 comme mécanisme d'engagement (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois, et le Golden Kubestronaut exige que tout soit valide en même temps : planifier CKAD puis CKS
  dans la foulée (K1 à K4 et K7 à K10 servent directement la CKAD).

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit), écran ≥ 15" en 1080p.
- [ ] Deux examens blancs `exams/cka-blanc-*` réalisés en 120 min à ≥ 80 % (marge sur le seuil de 66 %).
- [ ] Session killer.sh n° 2 faite à J-3, erreurs rejouées sur le lab.
- [ ] `break.sh random` sur K11 et K12 : trois pannes réparées en moins de 15 min, deux fois de suite.
- [ ] Flashcards des douze fiches revues à J-7, J-3, J-1 (`journal/`).
- [ ] Bureau dégagé, une seule fenêtre, aucun second écran, raccourcis `Ctrl+Shift+C` / `Ctrl+Shift+V` réflexes.
