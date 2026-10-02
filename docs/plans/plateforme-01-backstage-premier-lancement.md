---
chapitre: "fiches/plateforme/01-backstage-premier-lancement.md"
domaine: "plateforme"
niveau: "débutant"
statut: "validé le 2026-10-02 (recommandations des six questions retenues) — rédaction à démarrer après fusion de la PR #32"
duree_estimee: "5 h"
profil_lab: "linux-base (VM de développement 4 vCPU / 8 Go / 60 Go)"
versions: "backstage, nodejs (à créer), ubuntu_lts"
certifications:
  - "CBA-01-01"
  - "CBA-01-02"
  - "CBA-01-03"
  - "CBA-01-04"
  - "CBA-03-01"
  - "CBA-03-04"
---

# Plan — 01 Backstage : créer une app, la lancer, comprendre ce qui tourne

Chapitre `F1` de `certifs/CBA/objectifs.md` §4, nœud `plateforme/01-backstage-premier-lancement` de `docs/prerequis.md` §6.2
(numéro attribué par la cartographie CBA, PR #32, DECISIONS.md 2026-10-02 « fiches numérotées par série »).
Pourquoi lui : c'est la première fiche du domaine `plateforme`, la seule qui ne dépend d'aucun autre chapitre Backstage,
et les cinq autres chapitres CBA en partent. Elle couvre 6 des 19 compétences, dont deux du domaine Infrastructure (22 %).

Arbitrages hérités : aucune version en dur, tout vient de `versions.yaml` (clé `backstage`, clé `nodejs` à créer) ;
VM de développement dédiée sur `linux-base` (objectifs.md §2) ; pas de Kubernetes ni de conteneur dans cette fiche.

## Objectifs mesurables

À la fin de la fiche tu sais :

- installer Node.js (version `nodejs`) et Yarn par `corepack` sur une VM Ubuntu vierge, créer une app avec
  `@backstage/create-app`, l'aligner sur la version `backstage` et obtenir une UI qui répond sur le port 3000
  en moins de 15 min (hors temps de téléchargement mesuré à part) ;
- nommer sans notes ce que contient le monorepo généré (`packages/app`, `packages/backend`, `plugins/`, `app-config*.yaml`,
  `backstage.json`, `package.json` racine, `yarn.lock`, `.yarnrc.yml`) et dire à quoi sert chaque fichier en une phrase ;
- faire tourner la boucle de développement : modifier un composant, voir le rechargement, lancer `yarn tsc`, `yarn lint`,
  `yarn test` et interpréter une erreur de typage en moins de 5 min ;
- expliquer ce que fait `yarn install` (workspaces, lockfile, `--immutable`), `yarn backstage-cli versions:bump`
  et `corepack`, et vérifier qu'une installation est reproductible ;
- décrire l'architecture client-serveur (SPA React sur 3000, backend Node sur 7007, plugins frontend et backend,
  services de base, base par plugin) en un schéma Mermaid et en 3 phrases, et prouver chaque élément par une commande
  (`curl` sur `/api/catalog/entities`, logs des processus `[0]` et `[1]`) ;
- lire et modifier la configuration (`app-config.yaml`, `app-config.local.yaml`, `backend.baseUrl`, `app.baseUrl`,
  `backend.database`), afficher la configuration effective avec `config:print` et la valider avec `config:check` ;
- diagnostiquer une app qui ne démarre pas ou une UI muette (version de Node hors plage, port occupé, `baseUrl`
  incohérente) en moins de 10 min.

## Niveau et prérequis

- Débutant, nœud `plateforme_deb`. Arêtes `linux_deb` → fiche et `iac_deb` → fiche (prerequis.md §6.2) : shell, paquets,
  ports, `systemd`, Git (clone, commit). Aucun chapitre rédigé pour ces nœuds au 2026-10-02 : le front matter cite les nœuds.
- Aucune compétence Kubernetes, conteneur, React ni TypeScript exigée. Une page de lecture « lire du TypeScript et du JSX
  sans paniquer » ouvre la section 2 (comptée dans les 20 % de lecture) ; la vraie pratique React est en fiche 03.
- Infrastructure : une VM Ubuntu 24.04 LTS (`ubuntu_lts`) sur `linux-base`, accès Internet par le NAT du lab
  (registre npm : 1 à 2 Go téléchargés à la création de l'app).

## Compétences couvertes

| Section | CBA | CNPA (à confirmer par la cartographie CNPA) |
|---|---|---|
| 1 Installer l'outillage et créer l'app | CBA-01-01, CBA-01-04 | — |
| 2 La boucle de développement | CBA-01-02, CBA-01-03, CBA-01-04 | — |
| 3 Ce qui tourne : client, serveur, configuration | CBA-03-01, CBA-03-04 (introduit CBA-03-02, approfondi en fiche 05) | CNPA-05-03 (notion de portail développeur, lecture) |

Hors périmètre, renvoyé aux fiches suivantes : catalogue et `catalog-info.yaml` (02), création de plugin et React (03),
providers (04), image Docker, PostgreSQL, production (05). Trois à cinq flashcards les nomment car le QCM les cite.

## Sections et exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Lire `backstage` et `nodejs` dans `versions.yaml` (`yq`), installer Node.js à la version `nodejs`, `corepack enable`, vérifier `node -v`, `corepack -v`, `git -v` ; comparer avec le Node des dépôts Ubuntu (trop ancien) | versions affichées conformes à `versions.yaml` |
| 1.2 | 1 | guidé | `npx @backstage/create-app@<version>` (nom `lab-portal`), lire ce qui est généré fichier par fichier, `backstage.json`, `packageManager` dans `package.json` ; aligner sur la version `backstage` avec `yarn backstage-cli versions:bump --release <backstage>` puis `yarn install` ; `yarn start`, UI sur 3000, connexion en invité | `backstage.json` = version `backstage`, page d'accueil servie |
| 1.3 | 1 | autonome | Recréer l'app sur un second utilisateur Unix sans aide, en pinnant la version dès la création ; mesurer la taille de `node_modules`, le temps de `yarn install` à froid puis à chaud (cache Yarn) ; livrer un `README` de la VM qui liste les versions installées | app démarrée, mesures notées dans `journal/` |
| 1.4 | 1 | break-fix | `break/plateforme/01-backstage-node-version.sh` | `yarn install` et `yarn start` repassent, cause expliquée |
| 1.5 | 1 | chronométré | De la VM vierge (Node absent) à une UI Backstage qui répond, version alignée sur `versions.yaml` | 15 min hors téléchargements |
| 2.1 | 2 | guidé | Modifier le titre de la page d'accueil et une entrée de la barre latérale dans `packages/app/src`, observer le rechargement à chaud ; introduire une erreur de type volontaire, lire la sortie de `yarn tsc` puis `yarn tsc:full` ; `yarn lint`, `yarn fix`, `yarn test` ; `yarn clean` | erreur de type reproduite puis corrigée, tests verts |
| 2.2 | 2 | guidé | Gestion des dépendances : workspaces `packages/*` et `plugins/*`, `yarn workspaces list`, ajouter une dépendance à un seul workspace (`yarn workspace app add …`), `yarn why`, `yarn.lock` et `yarn install --immutable`, `.yarnrc.yml`, cache Yarn ; `yarn backstage-cli versions:bump` et `versions:check` ; `backstage-cli info` | lockfile stable après `--immutable`, mise à jour expliquée |
| 2.3 | 2 | autonome | Depuis un clone frais du dépôt Git de l'app (commité en 1.3) : installer en mode immuable, faire passer `tsc`, `lint`, `test`, écrire un script `make check` ou `justfile` qui enchaîne les trois ; ajouter une dépendance au backend seulement et vérifier que le frontend ne la voit pas | script vert en une commande, `git status` propre |
| 2.4 | 2 | break-fix | `break/plateforme/01-backstage-lockfile-corepack.sh` | `yarn install --immutable` repasse, cause expliquée |
| 2.5 | 2 | chronométré | Trouver et corriger trois erreurs (type, lint, test) injectées dans un dépôt fourni | 10 min |
| 3.1 | 3 | guidé | Lire les deux processus de `yarn start` (`[0]` frontend, `[1]` backend), ports 3000 et 7007, `curl http://localhost:7007/api/catalog/entities`, `/api/app/…`, onglet réseau du navigateur ; `packages/backend/src/index.ts` (`createBackend`, `backend.add`), liste des plugins backend chargés dans les logs ; services de base (logger, database, httpRouter, scheduler) ; schéma Mermaid complété par l'apprenant | chaque flèche du schéma prouvée par une commande |
| 3.2 | 3 | guidé | Configuration : `app-config.yaml` vs `app-config.local.yaml` (ignoré par Git), `app.baseUrl`, `backend.baseUrl`, `backend.listen`, `backend.cors`, `backend.database` (SQLite mémoire : les entités enregistrées disparaissent au redémarrage ; passage à SQLite sur fichier), `yarn backstage-cli config:print` et `config:check`, substitution `${VAR}` | configuration effective lue, persistance SQLite constatée |
| 3.3 | 3 | autonome | Exposer l'app aux autres VM du lab : `backend.listen.host`, `app.baseUrl` et `backend.baseUrl` sur le nom DNS de la VM (`lab.home.arpa`), CORS cohérent, ouvrir les ports dans `ufw` ; depuis une seconde VM, `curl` l'API et ouvrir l'UI ; retirer un plugin backend de `index.ts` et constater le 404 sur sa route | UI et API joignables depuis une autre VM, 404 expliqué |
| 3.4 | 3 | break-fix | `break/plateforme/01-backstage-baseurl.sh` et `break/plateforme/01-backstage-port-occupe.sh` | API de nouveau appelée par l'UI, cause expliquée |
| 3.5 | 3 | chronométré | Diagnostiquer et corriger une app fournie qui ne répond pas (une panne tirée au sort parmi les scripts de la fiche) | 10 min |

Les flashcards (15 à 20) couvrent en plus les notions citées par l'examen mais hors manipulation débutant :
`yarn build:backend`, `build-image`, `Dockerfile` du backend, PostgreSQL, ancien système de backend (`createRouter`,
`PluginEnvironment`) face au nouveau, nouveau système de frontend (non activé par défaut), `backstage-cli migrate`.

## Scénarios de panne (`break/plateforme/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-backstage-node-version.sh` | Node par défaut basculé sur une version hors plage `engines` (par le gestionnaire de versions, ou `PATH` détourné vers un binaire Node 20) | `yarn install` refuse (`The engine "node" is incompatible`), ou `yarn start` échoue au chargement d'un module natif |
| `01-backstage-lockfile-corepack.sh` | `packageManager` de `package.json` pointé sur une version de Yarn inexistante et une ligne de `yarn.lock` altérée | `corepack` échoue à préparer Yarn ; une fois réparé, `yarn install --immutable` refuse le lockfile |
| `01-backstage-baseurl.sh` | `app-config.local.yaml` avec `backend.baseUrl` sur un mauvais port et `backend.cors.origin` incohérent | UI chargée, page du catalogue vide, erreurs réseau/CORS dans la console, `curl` direct sur 7007 fonctionne |
| `01-backstage-port-occupe.sh` | processus factice (`python3 -m http.server` ou `nc -l`) sur 7007, ou `backend.listen.port` changé sans changer `backend.baseUrl` | `yarn start` : `EADDRINUSE` sur `[1]`, frontend vivant, API muette |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck, même convention que `break/gitops/01-argocd-*.sh`.
Création du dossier `break/plateforme/` et de son `README.md` dans la PR du chapitre.

## Profil de lab et budget

- Chemin principal : `linux-base`, **VM de développement 4 vCPU / 8 Go RAM / 60 Go** (sur les 8 vCPU / 16 Go / 180 Go du profil ;
  la documentation Backstage exige 6 Go de RAM et 20 Go de disque minimum ; `yarn install` + `tsc` + `start` tiennent dans 8 Go).
  Ubuntu 24.04 LTS (`ubuntu_lts`). Le profil ne décrit que des VM 2 vCPU / 4 Go : la fiche déclare la VM dédiée dans
  `budget_lab` comme `fiches/gitops/01` ; le profil n'est pas modifié (arbitrage 6).
- Seconde VM `linux-base` quelconque pour l'exercice 3.3 (client `curl` / navigateur).
- Aucun conteneur, aucun Kubernetes, aucune base externe : SQLite embarqué. Pas d'appel à `core-jump01` ni à Keycloak.
- Réseau : NAT vers le registre npm (`registry.npmjs.org`, `repo.yarnpkg.com`, `nodejs.org`). Variante air-gap
  (miroir npm Nexus sur `core-mirror01`) en lecture seule, renvoi au profil `airgap`.

## Préalables à régler dans la PR du chapitre

- Fusion de la PR #32 (cartographie CBA) : `certifs/CBA/objectifs.md` et `docs/prerequis.md` §6.2 n'existent que sur sa branche.
- `versions.yaml` : ajouter `nodejs` (datasource `node-version`, canal `lts`). Au 2026-10-02 : Node **24** est l'Active LTS
  (fin de vie 2028-04-30), Node 22 est en maintenance (fin 2027-04-30), Node 20 est en fin de vie depuis le 2026-04-30 ;
  le gabarit `create-app` de Backstage 1.55.3 déclare `engines.node: "22 || 24"` (lu sur le dépôt officiel, tag `v1.55.3`).
  Valeur retenue : `24` (arbitrage 2).
- `certifs/CBA/objectifs.md` §3 (six IDs) et §4 (F1 → rédigé), `docs/prerequis.md` §6.2 (nœud `rédigé`), `docs/plans/README.md`.
- Dossier de ressources de la fiche : `fiches/plateforme/01-backstage-premier-lancement/config/` (exemples d'`app-config.local.yaml`,
  schéma Mermaid source). Pas de dossier `manifests/` : la CI y lancerait `kubeconform` sur des fichiers qui ne sont pas des manifests.

## Points de vigilance `versions.yaml`

- **Cadence mensuelle de Backstage** : `npx @backstage/create-app@latest` (create-app 0.9.2 au 2026-10-02) génère une app sur la
  dernière release, pas sur 1.55.3. Deux options : pinner la version de `create-app` qui correspond à 1.55.3 (à retrouver dans
  le changelog du paquet), ou créer puis `versions:bump --release 1.55.3`. La seconde est retenue (arbitrage 3).
- **Yarn** : la page « Getting started » de la documentation parle encore de Yarn 4.4.1 alors que le gabarit `create-app` 1.55.3
  pinne `packageManager: yarn@4.13.0` et que la dernière Yarn est 4.18.1 (2026-09-24). La version utile est celle du
  `packageManager` de l'app, lue par `corepack` : pas de clé `yarn` dans `versions.yaml` (arbitrage 4), mais une flashcard et une ligne
  d'explication dans la fiche.
- **Node 22 ou 24** : si la clé `nodejs` vaut 24 et que la session de rédaction tourne en 22 (c'est le cas de la session qui a
  produit ce plan : Node 22.22.0, `corepack` 0.34.0, registre npm joignable), les sorties affichées porteront `v22.x` ;
  la fiche le signale plutôt que de maquiller les sorties.
- **Système de backend** : 1.55.3 génère le nouveau système (`createBackend`, `backend.add`) ; le programme d'examen date
  d'octobre 2024 (1.32 environ) et peut citer l'ancien. Section « à connaître pour l'examen » en lecture seule.
- **Nouveau système de frontend** : non activé par défaut en 1.55.3 ; cité en flashcard, pas enseigné.
- **Ubuntu 24.04** : le paquet `nodejs` des dépôts (18.x) est hors plage ; la fiche doit interdire `apt install nodejs`
  sans dépôt tiers et imposer `nvm` (arbitrage 1).
- Matrice create-app / Backstage : à relire dans les notes de version 1.55.x avant rédaction ; `config:check` et
  `versions:check` existent-ils sous ce nom exact dans le CLI 1.55.3 : `[à vérifier]` pendant la rédaction (la page de référence
  du CLI n'a pas pu être lue cette session).

## `[lecture + simulation]`

- Rien pour cause de matériel : tout tourne sur une VM Ubuntu.
- Lecture seule avec renvoi : installation sous Windows/WSL (hors lab), miroir npm air-gap (profil `airgap`), nouveau système
  de frontend, authentification de service à service (`backend.auth`), PostgreSQL et image de conteneur (fiche 05).

## Durée

5 h d'apprentissage, lecture ≤ 20 % (environ 1 h), le reste en manipulation :
section 1 ≈ 1 h 30 (dont téléchargements), section 2 ≈ 1 h 45, section 3 ≈ 1 h 45, dont 35 min de défis chronométrés.

## Livrables attendus de la session de rédaction

- `fiches/plateforme/01-backstage-premier-lancement.md` (gabarit `templates/fiche.md`) et
  `fiches/plateforme/01-backstage-premier-lancement/config/`
- `solutions/fiches/plateforme/01-backstage-premier-lancement.md` (3 indices puis correction commentée par exercice)
- `break/plateforme/README.md` et `break/plateforme/01-backstage-*.sh` (4 scripts)
- `revision/flashcards/plateforme-01-backstage-premier-lancement.csv` (15 à 20 cartes)
- mises à jour : `versions.yaml` (`nodejs`), `certifs/CBA/objectifs.md`, `docs/prerequis.md` §6.2, `docs/plans/README.md`,
  ce plan avec `statut: validé`
- Exécution réelle attendue : la session dispose de Node 22, de `corepack` et du registre npm ; `create-app`, `yarn install`,
  `tsc`, `lint`, `test`, démarrage du backend et `curl` de l'API peuvent être exécutés pour de vrai. Sans navigateur,
  les vérifications de l'UI se font par `curl` sur le port 3000 et sont marquées `[non testé : pas de navigateur]`.

## Arbitrages validés le 2026-10-02

1. Node.js installé par `nvm` par utilisateur (recommandation de la documentation Backstage) ; le dépôt apt NodeSource est
   cité en variante pour un provisionnement Ansible de la VM (`labs/ansible/`).
2. Clé `nodejs` de `versions.yaml` : **24** (Active LTS jusqu'en 2028-04-30, dans la plage `engines` de Backstage 1.55.3).
3. Création par `npx @backstage/create-app@latest` puis alignement par `yarn backstage-cli versions:bump --release <backstage>` ;
   la fiche vérifie `backstage.json` après coup.
4. Pas de clé `yarn` dans `versions.yaml` : le champ `packageManager` de l'app fait foi, lu par `corepack`.
   `certifs/CBA/objectifs.md` §2 est corrigé en conséquence dans la PR #32.
5. Aucun moteur de conteneurs dans cette fiche ; le choix Docker / Podman et son entrée `DECISIONS.md` sont reportés à la
   fiche 05. `certifs/CBA/objectifs.md` §2 est corrigé en conséquence dans la PR #32.
6. La VM de développement 4 vCPU / 8 Go / 60 Go est déclarée dans le front matter de la fiche, comme `fiches/gitops/01` ;
   le profil `linux-base` n'est pas modifié.
