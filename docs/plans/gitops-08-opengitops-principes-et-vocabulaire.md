---
chapitre: "fiches/gitops/08-opengitops-principes-et-vocabulaire.md"
domaine: "gitops"
niveau: "débutant"
statut: "validé le 2026-10-02 — rédaction à lancer (prompts/03) après fusion de la PR #34"
duree_estimee: "4 h"
profil_lab: "linux-base (kind sur une VM, cluster et Argo CD de la fiche 01) ; variante kubernetes-ha"
versions: "argo_cd, kind, kubernetes, opengitops_documents (à créer)"
certifications:
  - "CGOA-01-01"
  - "CGOA-01-06"
  - "CGOA-01-07"
  - "CGOA-01-08"
  - "CGOA-02-01"
  - "CGOA-02-02"
  - "CGOA-01-02 à 01-05, 01-09, 02-03, 02-04 (consolidation, vus en fiche 01)"
---

# Plan — 08 OpenGitOps : les quatre principes et le vocabulaire, prouvés sur le lab

Chapitre `G1` de `certifs/CGOA/objectifs.md` §4, nœud `gitops/08-opengitops-principes-et-vocabulaire` de `docs/prerequis.md` §6.2.
Pourquoi lui d'abord : terminologie et principes pèsent 50 % de l'examen CGOA et six compétences n'ont aucune couverture
(CGOA-01-01, 01-06, 01-07, 01-08, 02-01, 02-02). C'est aussi la seule fiche CGOA sans nouveau logiciel : elle réutilise
le cluster `kind` et l'Argo CD de la fiche 01 et ne demande aucune clé `versions.yaml` logicielle supplémentaire.

Le piège d'une fiche « concepts » est de devenir une fiche de lecture. Règle tenue ici : chaque principe et chaque terme est
**prouvé par une manipulation** (un push qui ne garantit rien, un `push --force` refusé, un délai de détection mesuré),
la lecture reste sous 20 % (≈ 45 min sur 4 h). Les définitions sont celles d'OpenGitOps `v1.0.0`, citées en anglais
(l'examen est en anglais et reprend ces formulations) puis expliquées en français.

Arbitrages hérités (DECISIONS.md, 2026-10-02) : `kind` sur `linux-base` en chemin principal pour une fiche débutant,
`kubernetes-ha` en variante ; numérotation `08` à la suite des fiches CAPA ; Git du lab = dépôt bare SSH ; Helm 4 et
Gateway API sans objet ici.

## Objectifs mesurables

À la fin de la fiche tu sais :

- réciter les quatre principes OpenGitOps en anglais et dire, pour chacun, ce qu'il interdit concrètement, sans notes,
  en moins de 3 min ;
- auditer une chaîne de déploiement décrite en dix lignes : lister les principes violés, le terme exact de chaque violation
  et la correction, en moins de 10 min ;
- nommer les trois parties d'un « GitOps managed software system » (runtimes, agents, policies) et les désigner sur le lab
  par leurs objets réels en moins de 5 min ;
- configurer un dépôt bare pour qu'il refuse la réécriture et la suppression d'historique, le prouver par un `push --force`
  refusé, en moins de 10 min ;
- revenir en arrière « à la GitOps » par `git revert` et expliquer en deux phrases pourquoi `argocd app rollback` n'est pas
  la même chose, en moins de 5 min ;
- mesurer le délai de détection d'une dérive, le réduire par `timeout.reconciliation` et prouver la réparation avec les
  horodatages de `argocd app get`, en moins de 10 min ;
- lire le retour d'information d'un agent (conditions, événements, métrique `argocd_app_info`) et retrouver d'où vient un
  `OutOfSync` en moins de 5 min ;
- définir les neuf termes de CGOA-01 avec tes mots puis les faire correspondre, un à un, au glossaire OpenGitOps.

## Niveau et prérequis

- Débutant, nœud `gitops_deb`.
- Prérequis obligatoire : fiche 01 (`fiches/gitops/01-argo-cd-fondamentaux.md`) : Argo CD installé sur `kind`, CLI connecté,
  Application `guestbook` et dépôt du lab `lab-demo` fonctionnels. La fiche 08 repart de cet état et le vérifie en 5 lignes.
- Recommandé : `iac_deb` (Git : `revert`, `reflog`, `push --force`, hooks côté serveur). Aucun chapitre rédigé pour ce nœud
  au 2026-10-02 : le front matter cite le nœud, comme les fiches 01 et 02.
- Non requis : fiche 02 (Argo Workflows). Le « push côté CI » de la section 1 est simulé par un `CronJob` Kubernetes qui
  fait `kubectl apply`, pour ne pas ajouter Argo Workflows aux prérequis.

## Compétences couvertes

| Section | CGOA (nouvelles) | CGOA (consolidées) |
|---|---|---|
| 1 Les quatre principes, push contre pull | CGOA-02-01, 02-02, 01-06 | CGOA-02-03, 02-04, 01-02, 01-03 |
| 2 Le magasin d'état : versionné, immuable, contrôlé | CGOA-01-07, 02-02 | CGOA-01-09 |
| 3 La boucle de contrôle : continu, dérive, retour d'information | CGOA-01-01, 01-08 | CGOA-01-04, 01-05, 02-04 |

Aucun ID CAPA : la fiche ne manipule rien de nouveau dans Argo CD. Hors périmètre, renvoyé aux fiches suivantes :
Flux et les magasins d'état OCI / S3 (09), réconciliateur externe et pull vs événement (10), notifications et métriques
dans Prometheus (12). Trois à cinq flashcards les nomment car le QCM les cite.

## Sections et exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Vérifier l'état hérité de la fiche 01 (`argocd app list`, dépôt du lab joignable). Lire `PRINCIPLES.md` v1.0.0 (4 principes, 12 lignes) et poser la grille d'audit « principe → ce qu'il exige → preuve observable → ce qu'il interdit ». | grille vide prête, principes récités |
| 1.2 | 1 | guidé | Déployer la même app deux fois : `demo-push` par un `CronJob` « CI » qui fait `kubectl apply` du dossier `push/` toutes les 2 min (ServiceAccount + Role dédiés) ; `demo-pull` par une `Application` Argo CD `automated` + `selfHeal` sur le dossier `pull/`. Pour chaque principe, une manipulation qui le teste des deux côtés : édition manuelle (déclaratif ? réconcilié ?), commit non poussé puis poussé (tiré ou poussé ?), suppression d'un fichier (prune ?), arrêt de l'agent (que reste-t-il ?). Remplir la grille. | grille remplie avec une commande par case |
| 1.3 | 1 | autonome | Désigner sur le lab les trois parties du « GitOps managed software system » du glossaire (runtimes, agents, policies) : objets Kubernetes et Git concrets pour chacune ; puis dire quelle partie manque à `demo-push`. Expliquer en une phrase par principe ce que le push ne garantit pas, même avec `selfHeal` ajouté par-dessus. | 3 parties nommées avec objets réels ; 4 phrases |
| 1.4 | 1 | break-fix | `break/gitops/08-gitops-push-direct.sh` | l'Application reste `Synced` 10 min d'affilée |
| 1.5 | 1 | chronométré | Texte de dix lignes décrivant une chaîne de déploiement (fourni dans `solutions/`, trois variantes) : lister les violations, les termes exacts et la correction ; vérifier avec la grille de 1.1 | 10 min, ≥ 3 violations sur 4 trouvées |
| 2.1 | 2 | guidé | Lire la définition « State Store » du glossaire (immuable, versionné, contrôle d'accès, audit). Sur le dépôt bare du lab : `git config receive.denyNonFastForwards true` et `receive.denyDeletes true`, tenter `push --force` et suppression de branche, lire le refus ; `git log --format` et `reflog` côté serveur comme piste d'audit ; clé SSH d'Argo CD en lecture seule (`command=` restreint dans `authorized_keys` ou utilisateur dédié) comme contrôle d'accès. | push refusé avec le message exact, log serveur lu |
| 2.2 | 2 | guidé | Rollback « à la GitOps » : commit cassé poussé, `git revert`, push, sync ; puis `argocd app history` et `argocd app rollback` sur l'autre Application ; comparer ce que montre `git log` dans les deux cas et ce que vaut `status.sync.revision`. | règle écrite : « un rollback GitOps est un nouveau commit » |
| 2.3 | 2 | autonome | Mettre le dépôt du lab en conformité avec les quatre critères du glossaire et le prouver : un tableau critère → mécanisme → commande de preuve. Option : signer les commits (`gpg.format ssh`, `allowedSignersFile`) et refuser les commits non signés par un hook `pre-receive`. | tableau 4 lignes, chaque preuve rejouable |
| 2.4 | 2 | break-fix | `break/gitops/08-gitops-state-store-rewritten.sh` | commit restauré, hooks remis, `argocd app rollback` fonctionne à nouveau |
| 2.5 | 2 | chronométré | Dépôt bare vierge fourni : le rendre immuable (deux options `receive.*`), y pousser l'app, provoquer un rollback par `revert` synchronisé | 10 min ; `git -C <bare> config --get receive.denyNonFastForwards` vaut `true`, Application `Synced` sur le commit de revert |
| 3.1 | 3 | guidé | Lire « Continuous », « Drift », « Reconciliation », « Feedback » du glossaire. Mesurer : drift manuel sur `demo-pull`, horodatages `status.reconciledAt` / `status.operationState.finishedAt`, avec `timeout.reconciliation` à 180 s (défaut) puis 30 s (`argocd-cm`, redémarrage du contrôleur) ; même mesure sans `selfHeal` (détecté, pas réparé). Schéma Mermaid de la boucle : état désiré → agent → état réel → retour → agent. | tableau des délais mesurés, schéma complété |
| 3.2 | 3 | guidé | Le retour d'information sans Prometheus : `argocd app get` (conditions, `health`, `sync`), `kubectl -n argocd get events`, `curl` de `argocd-metrics:8082/metrics` par `port-forward` filtré sur `argocd_app_info` et `argocd_app_sync_total` ; lire ce qu'un humain, un tableau de bord et un autre agent peuvent faire de ce retour (rollback automatique, alerte, nouvelle tentative). | trois sources de retour lues, chacune reliée à un terme du glossaire |
| 3.3 | 3 | autonome | Écrire les neuf termes de CGOA-01 avec tes mots (une phrase chacun), puis les confronter au glossaire v1.0.0 : noter chaque écart de sens (par ex. « continu » ≠ « instantané », « desired state » exclut les données persistantes). Les écarts deviennent des flashcards. | 9 définitions, écarts listés |
| 3.4 | 3 | break-fix | `break/gitops/08-gitops-reconciliation-stalled.sh` | un nouveau commit est déployé sans action manuelle dans les 3 min |
| 3.5 | 3 | chronométré | Panne tirée au sort parmi les trois scripts : diagnostic et correction, puis nommer en une phrase le principe ou le terme OpenGitOps que la panne violait | 10 min ; `argocd app list` ne renvoie que `Synced Healthy` |

Les flashcards (15 à 20) couvrent : les quatre principes en anglais, les neuf termes, « continuous » ≠ instantané,
les quatre critères du state store, rollback = nouvel état désiré, feedback au sens de la théorie du contrôle,
push vs pull (pourquoi le pull est un prérequis de la réconciliation continue), `timeout.reconciliation` et sa valeur par défaut,
les trois parties d'un système géré par GitOps, et trois termes hors périmètre (OCI comme state store, réconciliateur externe,
livraison progressive).

## Scénarios de panne (`break/gitops/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `08-gitops-push-direct.sh` | `CronJob` dans un namespace `ci-legacy`, ServiceAccount avec `patch` sur les Deployments de `demo-pull`, qui réapplique toutes les minutes un manifest obsolète (`replicas: 3`, ancienne image) | l'Application alterne `Synced` / `OutOfSync` toutes les minutes avec `selfHeal`, ou reste `OutOfSync` sans ; `argocd app diff` montre toujours le même écart ; `selfHeal` ne suffit pas, il faut trouver qui pousse |
| `08-gitops-state-store-rewritten.sh` | sur le bare : sauvegarde du dernier commit dans `refs/break/08-saved`, `receive.deny*` passés à `false`, `push --force` qui retire ce commit, options laissées à `false` | une fonctionnalité a disparu du cluster sans aucun commit dans `git log` ; `argocd app history` cite un SHA que `git show` ne trouve plus ; `argocd app rollback` vers cette révision échoue |
| `08-gitops-reconciliation-stalled.sh` | `timeout.reconciliation: 24h` dans `argocd-cm`, redémarrage du contrôleur | un commit poussé n'est jamais déployé ; `argocd app get --hard-refresh` le voit et le déploie une fois, puis plus rien ; les webhooks (fiche 10) sont la fausse piste |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck, variables `ARGOCD_NS`, `APP`, `BARE_REPO`, même convention que
`01-argocd-*.sh`. Le second script touche au dépôt Git : il refuse de s'exécuter si `BARE_REPO` n'est pas sous le chemin du
lab (garde-fou contre un dépôt réel).

## Profil de lab et budget

- Chemin principal : `linux-base`, la VM de la fiche 01 (4 vCPU / 8 Go / 60 Go sur les 8 vCPU / 16 Go / 180 Go du profil),
  cluster `kind` `argocd-lab` et Argo CD `argo_cd` déjà installés. Ajouts de la fiche : un `CronJob`, deux Applications,
  un dépôt bare supplémentaire : négligeable (< 0,2 vCPU / 100 Mo).
- Dépôt bare : sur la VM elle-même (`/srv/git/gitops-principes.git`, SSH local), parce que la fiche édite la configuration
  et les hooks **côté serveur**, ce qui demande un shell sur la machine qui héberge le bare. Variante : `core-jump01`
  derrière `git.lab.home.arpa` (DECISIONS.md), mêmes commandes via SSH.
- Variante `kubernetes-ha` (16 vCPU / 48 Go / 300 Go) : aucune différence de contenu ; l'UI passe par la `Gateway` de la fiche 01.
- Aucun service du socle `core` requis en chemin principal.

## Préalables à régler dans la PR du chapitre

- `versions.yaml` : ajouter `opengitops_documents` (dépôt `open-gitops/documents`, datasource `github-releases`,
  version `1.0.0`, tag lu par `git ls-remote` le 2026-10-02, `verification: direct`). Ce n'est pas un logiciel mais la fiche
  cite ses définitions et CLAUDE.md interdit une version en dur dans un chapitre.
- `certifs/CGOA/objectifs.md` §3 (six compétences nouvelles) et §4 (G1 → rédigé), `docs/prerequis.md` §6.2 (nœud `rédigé`) :
  ces deux fichiers arrivent par la PR de cartographie [cemah2/WorkbookDevops#34](https://github.com/cemah2/WorkbookDevops/pull/34),
  à fusionner avant la PR du chapitre.
- `fiches/gitops/01-argo-cd-fondamentaux.md` : ajouter `CGOA-05-03` au front matter à l'occasion de sa relecture (hors périmètre ici).

## Points de vigilance `versions.yaml`

- `argo_cd` 3.5.3 : `timeout.reconciliation` (et `timeout.reconciliation.jitter`) se règlent dans `argocd-cm` et exigent un
  redémarrage de `argocd-application-controller` ; le défaut est 180 s. Les champs d'horodatage `status.reconciledAt` et
  `status.operationState.*` sont ceux de la 3.x ; vérifier dans le CRD de la version avant d'écrire la démo 3.1.
- `argocd app rollback` est refusé tant que `automated` est actif (constaté dans la fiche 01) : la démo 2.2 coupe l'automatique
  sur `guestbook` avant, et montre que le `revert` n'a pas cette contrainte.
- Métriques : service `argocd-metrics` port 8082 (contrôleur) ; les noms `argocd_app_info` (labels `sync_status`, `health_status`)
  et `argocd_app_sync_total` sont à confirmer sur `docs/operator-manual/metrics.md` à la version 3.5.3 avant rédaction.
- `kind` 0.33.0 et clé `kubernetes` 1.37 : même écart accepté que les fiches 01 et 02 ; rien ici ne touche une API instable.
- Git côté serveur : Ubuntu 24.04 LTS livre Git 2.43 ; `receive.denyNonFastForwards`, `receive.denyDeletes`, `gpg.format ssh`
  et `gpg.ssh.allowedSignersFile` y existent (signature SSH depuis 2.34). Sur Rocky 10 ou RHEL, vérifier la version avant
  de promettre la signature SSH.
- `opengitops_documents` 1.0.0 : la branche `main` du dépôt annonce « work in progress » ; la fiche cite uniquement le tag,
  jamais `main`. Si une 1.1 ou 2.0 sort, la veille compare les définitions avant de changer la clé (les flashcards en dépendent).
- Statut d'exécution : si la session de rédaction n'a pas de démon Docker (cas des fiches 01 et 02), les commandes cluster
  seront `[non testé]` ; les manipulations Git côté serveur, les hooks et les scripts en `--reveal` sont exécutables sans cluster
  et doivent l'être pour de vrai.

## `[lecture + simulation]`

- Rien pour cause de matériel.
- Lecture seule avec renvoi : fonctions des forges hébergées (protection de branche, revues obligatoires, statuts de commit,
  signature imposée sur GitHub / GitLab) : pas de forge sur le lab avant le scénario CAPA S1, et le QCM cite ces noms ;
  magasins d'état autres que Git (OCI, S3 : manipulés en fiche 09) ; réconciliateur externe et déclenchement par événement
  (fiche 10) ; rollback automatique sur retour d'information (Argo Rollouts, fiche 05 CAPA). Couverts par des flashcards.

## Durée

4 h d'apprentissage, lecture ≤ 20 % (≈ 45 min, dont la lecture des deux documents OpenGitOps), le reste en manipulation :
section 1 ≈ 1 h 30, section 2 ≈ 1 h 15, section 3 ≈ 1 h 15, dont 30 min de défis chronométrés.

## Livrables attendus de la session de rédaction

- `fiches/gitops/08-opengitops-principes-et-vocabulaire.md` (gabarit `templates/fiche.md`) et
  `fiches/gitops/08-opengitops-principes-et-vocabulaire/manifests/` (CronJob « CI » + RBAC, deux Applications, dossiers `push/` et `pull/`)
- `solutions/fiches/gitops/08-opengitops-principes-et-vocabulaire.md` (3 indices puis correction commentée par exercice ;
  grille d'audit corrigée ; trois textes de chaîne de déploiement pour le défi 1.5 avec leur corrigé)
- `break/gitops/08-gitops-*.sh` (3 scripts)
- `revision/flashcards/gitops-08-opengitops-principes-et-vocabulaire.csv` (15 à 20 cartes, tags `cgoa-01-xx`, `cgoa-02-xx`)
- mises à jour : `versions.yaml` (`opengitops_documents`), `certifs/CGOA/objectifs.md`, `docs/prerequis.md` §6.2,
  `docs/plans/README.md`, ce plan passé en `statut: validé` puis `réalisé`

## Arbitrages validés le 2026-10-02

1. Le chapitre est G1, `fiches/gitops/08-opengitops-principes-et-vocabulaire.md`, premier de l'ordre de rédaction
   de `certifs/CGOA/objectifs.md` §1.
2. Dépôt bare sur la VM `kind` en chemin principal (hooks édités en shell local) ; `core-jump01` en variante, mêmes
   commandes via SSH.
3. Le « push » de la section 1 est un `CronJob` Kubernetes avec `kubectl apply` ; la fiche 02 n'est pas un prérequis.
4. Clé `opengitops_documents` ajoutée à `versions.yaml` par la PR du chapitre (tag `v1.0.0`, Renovate suit les tags).
5. Signature SSH des commits : option de l'exercice 2.3, pas obligatoire, pas de fiche `securite` dédiée.
6. Définitions citées en anglais mot pour mot, puis expliquées en français.
7. La rédaction attend la fusion de la PR de cartographie CGOA (#34), qui porte `certifs/CGOA/objectifs.md`,
   `docs/prerequis.md` §6.2 et ce plan ; la PR du chapitre part de `main` ensuite.
