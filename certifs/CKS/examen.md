---
code: CKS
titre: "CKS — fiche d'examen"
generated: 2026-10-02
verification_note: >
  Les domaines training.linuxfoundation.org, docs.linuxfoundation.org, cncf.io et killer.sh sont bloqués depuis la
  session qui a produit ce fichier (proxy de sortie), comme pour la fiche CAPA. Les valeurs marquées « indirecte »
  viennent des extraits de ces pages officielles renvoyés par un moteur de recherche le 2026-10-02 ; elles sont à
  confirmer en ouvrant l'URL citée à la prochaine veille (prompts/07-veille.md). Seul github.com/cncf/curriculum a été
  ouvert directement. Rien n'a été repris de sources tierces.
status: "à confirmer sur les URL officielles (accès direct impossible le 2026-10-02)"
---

# CKS — Certified Kubernetes Security Specialist : l'examen

Légende de la colonne « vérification » :

- **directe** : URL officielle ouverte le jour indiqué ;
- **indirecte** : extrait de l'URL officielle obtenu via un moteur de recherche le jour indiqué, page bloquée depuis la session ;
- **non trouvé** : aucune valeur sur les sources officielles consultées ; ne pas inventer, chercher à la veille.

## 1. Fiche synthétique

| Information | Valeur | URL officielle | Vérification |
|---|---|---|---|
| Éditeur | CNCF, administré par Linux Foundation Training & Certification | <https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/> | indirecte, 2026-10-02 |
| Lancement | 2020 (billet d'annonce officiel) ; jour exact **non trouvé** dans les extraits | <https://training.linuxfoundation.org/blog/kubernetes-security-specialist-certification-now-available/> | non trouvé, 2026-10-02 |
| Durée | 2 h | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Format | pratique : tâches à résoudre en ligne de commande sur des clusters Kubernetes réels, en ligne, surveillé à distance | <https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/> | indirecte, 2026-10-02 |
| Nombre de tâches | 15 à 20 | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Score de réussite | 67 % | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Domaines et poids | Cluster Setup 15 %, Cluster Hardening 15 %, System Hardening 10 %, Minimize Microservice Vulnerabilities 20 %, Supply Chain Security 20 %, Monitoring/Logging/Runtime Security 20 % | <https://github.com/cncf/curriculum> (`CKS_Curriculum v1.34.pdf`) | directe, 2026-10-02 |
| Version du programme | v1.34 ; fichier `CKS_Curriculum v1.34.pdf`, commit `94f35b0` du 2025-10-30 ; aucun commit CKS depuis | <https://github.com/cncf/curriculum/commits/master/CKS_Curriculum%20v1.34.pdf> | directe, 2026-10-02 |
| Version de Kubernetes à l'examen | « v1.35 » selon l'extrait de la page officielle ; l'environnement est aligné sur la dernière version mineure « dans les 4 à 8 semaines » suivant sa sortie. ⚠️ Contradiction avec le programme (1.34) et avec `versions.yaml` (lab en 1.37) : à trancher à la veille | <https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/> | indirecte, 2026-10-02 |
| Dernière refonte du programme | 2024-10-15 : domaines inchangés, compétences ajoutées/retirées/reformulées, poids modifiés ; le prérequis CKA n'a plus besoin d'être **actif**, seulement obtenu | <https://training.linuxfoundation.org/cks-program-changes/> | indirecte, 2026-10-02 |
| Documentation autorisée | depuis le navigateur du bureau distant uniquement : <https://kubernetes.io/docs/>, <https://kubernetes.io/blog/>, <https://falco.org/docs/>, documentation de `bom` (`kubernetes-sigs/bom`), <https://etcd.io/docs/>, documentation NGINX Ingress Controller, documentation Cilium, documentation Istio, et la documentation propre à la tâche fournie dans la « Quick Reference ». La recherche interne de ces sites est permise, aucun résultat externe ne doit être ouvert. Trivy et AppArmor : absents de l'extrait consulté, à confirmer sur la page | <https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed> | indirecte, 2026-10-02 |
| Environnement d'examen | plateforme PSI Bridge, PSI Secure Browser, bureau distant Linux avec un terminal et un navigateur ; nœud de départ `base` (ne jamais le redémarrer, aucun outil installé dessus) ; chaque tâche désigne un hôte à joindre par `ssh <nodename>` ; retour sur `base` après chaque tâche ; pas de `ssh` imbriqué ; `sudo -i` autorisé ; sur les hôtes : `kubectl` avec alias `k` et complétion, `yq`, `curl`, `wget`, `man` ; `Ctrl+Alt+W` à la place de `Ctrl+W` ; copier/coller terminal `Ctrl+Shift+C` / `Ctrl+Shift+V` | <https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-cks> | indirecte, 2026-10-02 |
| Règles et interdits | pièce vide, bureau dégagé, une seule fenêtre (l'ExamUI), webcam et micro actifs, pas de notes ni de second écran, pas de communication avec un tiers | <https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/candidate-requirements> | indirecte, 2026-10-02 |
| Prérequis | avoir réussi CKA (à n'importe quelle date depuis le 2024-10-15 ; auparavant CKA devait être active) | <https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/> | indirecte, 2026-10-02 |
| Validité | 2 ans (CKS a toujours été valide 24 mois ; la politique 2024 qui a ramené les autres certifications de 36 à 24 mois ne la concerne pas) | <https://training.linuxfoundation.org/certification-policy-change-2024/> | indirecte, 2026-10-02 |
| Renouvellement | repasser et réussir le même examen avant l'expiration ; programme CARE : obtenir ou renouveler CKS à partir du 2026-06-18 prolonge automatiquement CKA jusqu'à la date d'expiration de CKS | <https://training.linuxfoundation.org/blog/expanding-care-passing-cks-can-now-extend-your-cka-certification/> | indirecte, 2026-10-02 |
| Prix indicatif | 445 USD (examen seul) ; bundles relevés le même jour : KCSA + CKS 645 USD, CKA + CKAD + CKS 1 245 USD, Kubestronaut (KCNA + KCSA + CKA + CKAD + CKS) 1 235 USD, Golden Kubestronaut 4 229 USD ; certains montants sont des prix promotionnels, à revérifier avant achat | <https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/> ; <https://training.linuxfoundation.org/certification/kubestronaut-bundle/> | indirecte, 2026-10-02 |
| Éligibilité et reprise | 12 mois pour passer l'examen après l'achat ; deux tentatives (une reprise gratuite) | <https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/> | indirecte, 2026-10-02 |
| Simulateur inclus | **oui** : deux sessions du simulateur killer.sh, chacune ouverte 36 h (temps calendaire, pas d'usage) une fois activée, 17 scénarios avec solutions par session, accessibles depuis la checklist de préparation du compte Linux Foundation | <https://training.linuxfoundation.org/blog/linux-foundation-kubernetes-certifications-now-include-exam-simulator/> | indirecte, 2026-10-02 |
| Langues disponibles | anglais, chinois simplifié, japonais ; la langue des tâches suit celle du navigateur et peut être changée pendant l'examen | <https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks> | indirecte, 2026-10-02 |
| Cours officiel associé | **non trouvé** dans les extraits (le cours LFS260 « Kubernetes Security Essentials » est cité de mémoire, à confirmer) | <https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/> | non trouvé, 2026-10-02 |
| Kubestronaut / Golden Kubestronaut | oui : CKS fait partie des cinq certifications Kubestronaut (CKA, CKAD, CKS, KCNA, KCSA, toutes actives en même temps) et du Golden Kubestronaut (toutes les certifications CNCF + LFCS, titre acquis à vie) | <https://training.linuxfoundation.org/resources/kubestronaut-program/> | indirecte, 2026-10-02 |

## 2. Points à confirmer à la prochaine veille

- **Version de Kubernetes** : ouvrir la page CKS et la FAQ, noter la version en vigueur, renseigner `exam_version_cks`
  dans l'entrée `kubernetes` de `versions.yaml` (`objectifs.md` §2). Vérifier aussi si le dépôt `cncf/curriculum`
  a publié un PDF CKS plus récent que v1.34 (les commits du 2026-10-01 ont passé CKAD en v1.37 et ajouté une nouvelle
  certification CKNE : `certifs/CKA` et `certifs/CKAD` sont probablement en retard, et CKNE n'a pas de dossier).
- **Documentation autorisée** : confirmer la liste complète (Trivy, AppArmor, `github.com/kubernetes` ?) sur la page
  « Resources Allowed » ; elle conditionne ce que les fiches doivent faire mémoriser.
- `programme.md` indique `source_file: CKS_v1.34.pdf` alors que le dépôt nomme le fichier `CKS_Curriculum v1.34.pdf`
  (même écart que pour CAPA) ; aligner `certifs/_sources_pdf/generer_programmes.py`.
- Prix : vérifier les promotions en cours avant d'acheter (bundles Kubestronaut, THRIVE-ONE, promotions mensuelles).
- Date de lancement et cours associé : ouvrir le billet d'annonce et la page de l'examen.

## 3. Conséquences pour la préparation

- **Examen pratique avec documentation** : inutile de mémoriser les champs de spec au mot près, indispensable de savoir
  **où** ils sont dans `kubernetes.io/docs` et dans la documentation Falco/etcd/Cilium/Istio sans moteur de recherche
  externe. Chaque fiche se termine par un défi au format examen (énoncé en anglais, hôte désigné, minuteur) et une liste
  des pages de documentation à retrouver en moins de 30 s.
- **Un seul terminal, pas de poste personnel** : travailler dès la première fiche avec `k`, `--dry-run=client -o yaml`,
  `kubectl explain`, `vim` sans configuration, et sans `tmux` ni `k9s` (`docs/roadmap.md` §4, « interdits d'examen »).
  Les scripts `break/securite/` et `exams/CKS/` s'exécutent sur un hôte désigné par `ssh`, comme à l'examen.
- **Tâches système sur les nœuds** : six fiches sur quatorze éditent des static pods ou des fichiers sous
  `/etc/kubernetes`, `/var/lib/kubelet`, `/etc/apparmor.d` : le profil `kubernetes-ha` (nœuds kubeadm réels) est requis
  pour s'entraîner dans les conditions de l'examen (`objectifs.md` §5).
- **Seuil 67 % sur 15 à 20 tâches** : on peut sauter deux ou trois tâches ; la stratégie « faire d'abord les tâches
  rapides, noter les autres » se travaille sur l'examen blanc `exams/CKS/` et les deux sessions killer.sh.
- **Version** : le lab suit `versions.yaml` (1.37) ; l'examen blanc tourne sur la version d'examen. Les écarts de champs
  entre les deux sont signalés dans les fiches.
- **Jalon** : CKS clôt le bloc Kubestronaut (`docs/prerequis.md`, parcours Kubestronaut, nœud `securite_conf`, après KCSA).
  CKA est le prérequis officiel ; passer CKS tôt après CKA fait courir les deux validités ensemble, et le programme CARE
  réaligne l'expiration de CKA sur celle de CKS. Fixer la date d'examen à la fin du bloc (`docs/roadmap.md` §7).
- **Compte à rebours de validité** : 24 mois, comme CKA et CKAD. Pour le Golden Kubestronaut, les cinq certifications
  Kubestronaut doivent être actives en même temps que les associées : planifier la rafale des associées dans les
  18 mois qui suivent CKS.

## 4. Checklist J-7

- [ ] Compte Linux Foundation créé, CKA figurant au compte, examen planifié sur PSI, pièce d'identité conforme au nom du compte.
- [ ] Test système PSI passé (PSI Secure Browser, webcam, micro, débit) ; un seul écran, pièce vide.
- [ ] Deux sessions killer.sh faites, la seconde à ≥ 80 % en moins de 2 h (marge sur le seuil de 67 %).
- [ ] Examen blanc `exams/CKS/mock-01/` réalisé deux fois en conditions réelles, `grade.sh` ≥ 80 %.
- [ ] Les quatorze défis chronométrés des fiches refaits dans le temps imparti (`revision/checklists/`).
- [ ] Pages de documentation clés retrouvées sans recherche externe en moins de 30 s chacune : NetworkPolicy, Pod Security
  Admission, EncryptionConfiguration, audit Policy, RuntimeClass, AppArmor, seccomp, ImagePolicyWebhook, Falco rules, etcdctl.
- [ ] Flashcards des quatorze fiches revues à J-7, J-3, J-1 (`journal/`).
