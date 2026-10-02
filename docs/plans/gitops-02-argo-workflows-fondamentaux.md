---
chapitre: "fiches/gitops/02-argo-workflows-fondamentaux.md"
domaine: "gitops"
niveau: "débutant"
statut: "réalisé le 2026-10-02 — chapitre en brouillon, relecture critique à faire (prompts/04)"
duree_estimee: "5 h"
profil_lab: "linux-base (kind sur une VM) ; variante kubernetes-ha"
versions: "argo_workflows (à créer), kind, kubernetes"
certifications:
  - "CAPA-01-01"
  - "CAPA-01-04"
  - "CGOA-03-04 (à confirmer par la cartographie CGOA)"
---

# Plan — 02 Argo Workflows : installer, écrire et lancer un premier workflow

Chapitre `F3` de `certifs/CAPA/objectifs.md` §4, nœud `gitops/02-argo-workflows-fondamentaux` de `docs/prerequis.md` §6.1
(numéro attribué par la cartographie CAPA, DECISIONS.md 2026-10-02 « fiches numérotées par série »).
Pourquoi lui et pas la suite d'Argo CD : Argo Workflows pèse 36 % de l'examen, c'est la seule fiche débutant restante,
et les fiches 03, 06 et 07 en dépendent. La fiche 04 (Argo CD Helm/Kustomize) est confirmée et attend `kubernetes-ha`.

Arbitrages hérités (DECISIONS.md, 2026-10-02) : chemin principal `kind` sur `linux-base` pour une fiche débutant,
`kubernetes-ha` en variante ; installation par manifests officiels versionnés, jamais `latest` ni `stable` ;
Gateway API Cilium pour la variante, `port-forward` sur `kind`.

## Objectifs mesurables

À la fin de la fiche tu sais :

- installer le contrôleur et le serveur Argo Workflows depuis les manifests de la version `argo_workflows`,
  installer le CLI `argo` à la même version et lancer `hello-world` avec succès en moins de 15 min ;
- nommer sans notes les composants (workflow-controller, argo-server, executor emissary, conteneurs `init`/`wait`/`main`)
  et dire ce que fait chacun en une phrase ;
- écrire un `Workflow` à trois étapes avec `entrypoint`, templates `container` et `script`, `steps` séquentiels et
  parallèles, paramètres d'entrée et de sortie, et le voir `Succeeded` en moins de 10 min ;
- lire l'état d'un workflow avec `argo get`, `argo logs`, `argo watch` et `kubectl get pods`, et retrouver quelle étape
  a échoué et pourquoi en moins de 5 min ;
- maîtriser le cycle de vie : `argo submit`, `suspend`, `resume`, `stop`, `terminate`, `retry`, `resubmit`, `delete`,
  et expliquer ce qui distingue `stop` de `terminate` et `retry` de `resubmit` ;
- borner un workflow avec `activeDeadlineSeconds`, `retryStrategy`, `ttlStrategy`, `podGC` et des `resources`,
  et vérifier l'effet de chaque champ par une commande ;
- diagnostiquer un workflow bloqué en `Pending` ou en `Error` (RBAC du ServiceAccount, contrôleur absent, image
  introuvable) en moins de 10 min.

## Niveau et prérequis

- Débutant, nœud `gitops_deb`. Indépendant de la fiche 01 : Argo Workflows ne nécessite pas Argo CD.
- Prérequis obligatoire : `kubernetes_deb` (Pods, Jobs, ServiceAccount, Role/RoleBinding, `kubectl logs`, namespaces).
  Aucun chapitre rédigé pour ce nœud au 2026-10-02 : le front matter cite le nœud, comme la fiche 01.
- Recommandé : fiche 01 pour le réflexe `yq` sur `versions.yaml` et la VM `kind` déjà prête.
- Infrastructure : la même VM Ubuntu `linux-base` avec Docker et `kind` que la fiche 01 ; cluster `kind` dédié
  `argo-lab` (ou réutilisation d'`argocd-lab`, sans conflit : namespace `argo`).

## Compétences couvertes

| Section | CAPA | CGOA (à confirmer) |
|---|---|---|
| 1 Installer et comprendre | CAPA-01-01 | — |
| 2 Écrire un Workflow : templates, steps, paramètres | CAPA-01-04 | CGOA-03-04 (place d'un moteur de workflows dans la CI/CD) |
| 3 Piloter l'exécution : cycle de vie, limites, nettoyage | CAPA-01-01, CAPA-01-04 | — |

Hors périmètre, renvoyé aux fiches suivantes : artefacts (03), `WorkflowTemplate` / `CronWorkflow` (03), `dag` (03),
`withItems` / `withParam` / `parallelism` (06), Argo Events (07). Trois à cinq flashcards les nomment car le QCM les cite.

## Sections et exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Lire `argo_workflows` dans `versions.yaml`, installer par `install.yaml` versionné dans le namespace `argo`, CLI `argo` à la même version, `argo version`, `argo submit` du `hello-world` officiel, `argo list` / `get` / `logs` | workflow `Succeeded`, `argo version` affiche serveur et client identiques |
| 1.2 | 1 | guidé | Lire les composants : pods `workflow-controller` et `argo-server`, `workflow-controller-configmap`, conteneurs `init` / `wait` / `main` d'un pod de workflow, executor emissary ; UI par `port-forward` (variante `Gateway` + `HTTPRoute` sur `kubernetes-ha`) | schéma Mermaid complété par l'apprenant |
| 1.3 | 1 | autonome | Passer `argo-server` du mode `--auth-mode=server` au mode `client`, créer un ServiceAccount + token et se connecter à l'UI et au CLI avec ; expliquer pourquoi le mode `server` est réservé au lab | `argo list` fonctionne avec `ARGO_TOKEN` |
| 1.4 | 1 | break-fix | `break/gitops/02-argo-workflows-controller-down.sh` | workflow repart et finit `Succeeded` |
| 1.5 | 1 | chronométré | Depuis un cluster vierge : Argo Workflows installé, CLI connecté, `hello-world` terminé | 15 min |
| 2.1 | 2 | guidé | Anatomie du `Workflow` : `entrypoint`, `templates`, `container`, `script` (bash puis python), `inputs.parameters`, `arguments` et `argo submit -p` ; `steps` séquentiels puis parallèles (`- -` vs `-`) ; `outputs.parameters` via `valueFrom.path` et `{{steps.x.outputs.parameters.y}}` ; template `suspend` avec `argo resume` | workflow à 3 étapes dont 2 parallèles, valeur de sortie reprise en entrée |
| 2.2 | 2 | autonome | Écrire un workflow « préparer → tester en parallèle (lint, unit) → publier un résumé » avec un paramètre `version` passé en ligne de commande et repris dans le résumé ; variante avec le template `resource` qui crée un ConfigMap et lit un champ en sortie | `Succeeded`, ConfigMap présent, résumé contient `version` |
| 2.3 | 2 | break-fix | `break/gitops/02-argo-workflows-rbac.sh` | étapes ne tombent plus en `Error`, sorties transmises |
| 2.4 | 2 | chronométré | Workflow à trois étapes avec un paramètre d'entrée et une sortie réutilisée, écrit de zéro | 10 min |
| 3.1 | 3 | guidé | Cycle de vie : `submit --watch`, `suspend` / `resume`, `stop` vs `terminate` (handler `onExit` exécuté ou non), `retry` vs `resubmit`, `delete` ; `argo get` des nœuds, `kubectl describe` du pod en échec | différences constatées, pas récitées |
| 3.2 | 3 | guidé | Bornes et nettoyage : `activeDeadlineSeconds` (workflow et template), `retryStrategy` (`limit`, `retryPolicy`, `backoff`), `ttlStrategy`, `podGC`, `resources` du conteneur, `serviceAccountName` dédié, `onExit` qui notifie | chaque champ vérifié par une commande |
| 3.3 | 3 | autonome | Rendre robuste un workflow fourni qui échoue une fois sur deux (script aléatoire) : retry avec backoff, délai max, nettoyage des pods réussis, workflow supprimé après 10 min ; mesurer avec `argo get` et `kubectl get pods -w` | 10 lancements, 10 `Succeeded`, aucun pod résiduel |
| 3.4 | 3 | break-fix | `break/gitops/02-argo-workflows-image-pull.sh` | étape repart, cause expliquée |
| 3.5 | 3 | chronométré | Diagnostiquer et corriger un workflow fourni bloqué (une panne tirée au sort parmi les scripts) | 10 min |

Les flashcards (15 à 20) couvrent en plus les notions citées par l'examen mais hors manipulation débutant :
`WorkflowTemplate`, `CronWorkflow`, `dag`, artefacts, archive des workflows (base de données), executor emissary comme seul
executor depuis la 3.4.

## Scénarios de panne (`break/gitops/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `02-argo-workflows-controller-down.sh` | `workflow-controller` à 0 réplica | `argo submit` accepté, workflow reste `Pending` sans pod, UI vivante |
| `02-argo-workflows-rbac.sh` | Role du ServiceAccount privé du verbe `create`/`patch` sur `workflowtaskresults` | pods `main` finissent mais nœuds en `Error`, message sur `workflowtaskresults.argoproj.io` |
| `02-argo-workflows-image-pull.sh` | tag d'image inexistant patché dans un `WorkflowTemplate` du lab ou miroir d'image bloqué | nœud `Pending` → `Error`, `ImagePullBackOff` sur le pod, `argo get` ne dit pas pourquoi |
| `02-argo-workflows-quota.sh` (optionnel) | `ResourceQuota` à 0 pod sur le namespace | workflow `Pending`, événement `forbidden: exceeded quota` sur le pod |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck, même convention que les scripts `01-argocd-*.sh`.

## Profil de lab et budget

- Chemin principal : `linux-base`, la VM de la fiche 01 (4 vCPU / 8 Go / 60 Go sur les 8 vCPU / 16 Go / 180 Go du profil),
  Docker + `kind`. Argo Workflows seul : environ 0,5 vCPU / 512 Mo (contrôleur + serveur), plus un pod par étape.
- Variante : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go), exposition de l'UI par `Gateway` + `HTTPRoute` Cilium et certificat
  cert-manager, hôte `argo.apps.lab.home.arpa`. Pas de stockage S3 dans cette fiche (artefacts : fiche 03).
- Aucune dépendance à `core-jump01` : les manifests du chapitre sont lus depuis le dépôt du workbook cloné sur la VM.

## Préalables à régler dans la PR du chapitre

- `versions.yaml` : ajouter la clé `argo_workflows` (dépôt `argoproj/argo-workflows`, datasource `github-releases`).
  Version lue le 2026-10-02 par les tags git du dépôt officiel : **4.1.4** ; l'API GitHub n'est pas accessible depuis la
  session, donc `verification: indirect` tant que la page des releases n'a pas été lue directement.
- `labs/profiles/kubernetes-ha.yaml` : ajouter `argo_workflows` à `components`.
- `certifs/CAPA/objectifs.md` §3 (CAPA-01-01, CAPA-01-04) et §4 (F3 → rédigé), `docs/prerequis.md` §6.1 (nœud `rédigé`) :
  ces deux fichiers n'existent que sur la branche de la fiche 01, pas encore sur `main`.

## Points de vigilance `versions.yaml`

- Argo Workflows **4.x** : les supports d'examen et la majorité des exemples en ligne datent de la 3.x. À vérifier dans les
  notes de version avant rédaction : champs retirés ou renommés dans la spec, modes d'authentification par défaut
  d'`argo-server`, format de `install.yaml` (cluster) vs `namespace-install.yaml`, image par défaut de l'executor.
  La fiche signale les écarts sans enseigner la 3.x.
- CLI `argo` à la version exacte du serveur, jamais `latest` ; binaire `argo-linux-amd64.gz` de la release.
- Kubernetes 1.37.1 : matrice de compatibilité d'Argo Workflows 4.1 à vérifier ; même écart `kind` / clé `kubernetes` que
  la fiche 01 (image de nœud livrée avec `kind` 0.33.0).
- Le `quick-start-*.yaml` officiel embarque MinIO et un mode `server` sans auth : on ne l'utilise pas, on part
  d'`install.yaml` pour que ce que l'apprenant voit ressemble à une installation réelle.

## `[lecture + simulation]`

- Rien pour cause de matériel.
- Lecture seule avec renvoi : archive des workflows en base PostgreSQL/MySQL (sujet d'examen, pas de base sur `kind`),
  SSO d'`argo-server`, exécution multi-cluster. Couverts par des flashcards.

## Durée

5 h d'apprentissage, lecture ≤ 20 % (environ 1 h), le reste en manipulation :
section 1 ≈ 1 h 30, section 2 ≈ 2 h, section 3 ≈ 1 h 30, dont 35 min de défis chronométrés.

## Livrables attendus de la session de rédaction

- `fiches/gitops/02-argo-workflows-fondamentaux.md` (gabarit `templates/fiche.md`) et `fiches/gitops/02-argo-workflows-fondamentaux/manifests/`
  (workflows de démo, ServiceAccount + Role, variante Gateway)
- `solutions/fiches/gitops/02-argo-workflows-fondamentaux.md` (3 indices puis correction commentée par exercice)
- `break/gitops/02-argo-workflows-*.sh` (3 scripts, 1 optionnel)
- `revision/flashcards/gitops-02-argo-workflows-fondamentaux.csv` (15 à 20 cartes)
- mises à jour : `versions.yaml`, `labs/profiles/kubernetes-ha.yaml`, `certifs/CAPA/objectifs.md`, `docs/prerequis.md` §6.1,
  ce plan copié dans `docs/plans/` avec `statut: validé`

## Arbitrages validés le 2026-10-02

1. La fiche 02 est Argo Workflows fondamentaux (ordre de la cartographie CAPA), pas la suite d'Argo CD (fiche 04).
2. La rédaction attend la fusion de la cartographie CAPA (PR #26) puis de la fiche 01 (PR #28), qui portent
   `certifs/CAPA/objectifs.md` et `docs/prerequis.md` §6 ; la PR du chapitre 02 part de `main` ensuite.
3. La clé `argo_workflows` entre dans `versions.yaml` par la PR du chapitre, comme `objectifs.md` §2 le prévoit.
4. Démo d'`argo-server` en `--auth-mode=client` (token de ServiceAccount) ; le mode `server` est présenté en lecture.
5. Le cluster `kind` `argocd-lab` de la fiche 01 est réutilisé s'il existe, sinon créé ; la fiche gère les deux cas.
