# Solutions — 01 Backstage : créer une app, la lancer, comprendre ce qui tourne

Trois indices progressifs par exercice, puis la correction commentée. Lis un indice, retourne manipuler, reviens si besoin.
Les commandes ont été exécutées dans la session de rédaction sur une app générée par `create-app` 0.9.2 (Backstage 1.55.0,
Node 22.22.0, Yarn 4.13.0) sauf mention `[non testé]` avec la raison.

## Section 1 — Exercice autonome

### Indices

1. `nvm` s'installe par utilisateur : le second utilisateur n'a ni `nvm`, ni Node, ni le cache Yarn du premier. C'est le but.
   Pour chronométrer, `time` devant chaque commande ; `yarn cache clean --all` vide le cache global avant l'installation « à froid ».
2. `corepack disable` retire les shims `yarn` et `pnpm` du répertoire `bin` de Node ; il ne touche pas aux fichiers de l'app.
   Regarde ce que `.yarnrc.yml` appelle `yarnPath`, puis ce que le `Dockerfile` copie en premier (`COPY .yarn ./.yarn`).
3. `git check-ignore -v <chemin>` dit quelle règle de `.gitignore` exclut un fichier ; lis le bloc `# Yarn files`, les lignes
   qui commencent par `!` sont des exceptions.

### Correction commentée

**Point 1.** Sur la VM, en tant que `dev2` :

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && source ~/.nvm/nvm.sh
nvm install "$(yq -r '.components.nodejs.version' ~/WorkbookDevops/versions.yaml)" && corepack enable
time (echo lab-portal | npx @backstage/create-app@latest --skip-install)
cd lab-portal
yarn backstage-cli versions:bump --release "$(yq -r '.components.backstage.version' ~/WorkbookDevops/versions.yaml)" --skip-install
yarn cache clean --all
time yarn install            # à froid
time yarn install            # à chaud
du -sh node_modules ~/.yarn/berry/cache
```

Mesures de la session de rédaction (cache vide, 4 vCPU, registre npm via proxy) : `create-app --skip-install` en **10 s**,
`yarn install` à froid en **2 min 52 s** (résolution 55 s, fetch 56 s pour 1,1 Go, link 1 min 18 s), à chaud en **6 s** ;
`node_modules` 1,9 Go, cache 1,2 Go. `nvm install` et `versions:bump` sont `[non testé : nodejs.org et versions.backstage.io
bloqués depuis la session]`. Ce que ces chiffres t'apprennent : la résolution et le fetch dépendent du réseau, le link du disque
et du CPU ; sur le lab, c'est le NVMe qui fait la différence. Le cache est **global** (`~/.yarn/berry/cache`), partagé entre
tes apps mais pas entre utilisateurs.

**Point 2.** Exécuté :

```bash
corepack disable
yarn --version
# bash: yarn: command not found
node .yarn/releases/yarn-4.13.0.cjs --version
# 4.13.0
```

`yarn` n'existe que comme shim de corepack : désactivé, la commande disparaît. Le binaire embarqué est un fichier JavaScript
autonome que Node exécute directement, c'est lui que `yarnPath` désigne, et c'est lui que le `Dockerfile` utilise dans l'image
(`COPY .yarn ./.yarn` puis `yarn workspaces focus`) : une image ne dépend donc ni de corepack ni d'un téléchargement. Dans la session,
corepack lui-même ne pouvait pas télécharger Yarn (`repo.yarnpkg.com` bloqué, « Error when performing the request to
`https://repo.yarnpkg.com/4.13.0/packages/yarnpkg-cli/bin/yarn.js` ») : le binaire embarqué a servi pour tout le chapitre.

**Point 3.** `create-app` a déjà fait `git init` (branche `master`) : `git status` liste tout en non suivi. Après le commit :

```bash
git check-ignore -v node_modules .yarn/cache .yarn/releases/yarn-4.13.0.cjs app-config.local.yaml .nvmrc
```

`node_modules/` est reconstruit par `yarn install` ; `.yarn/*` est exclu **sauf** `patches`, `plugins`, `releases`, `sdks`,
`versions` : ce qu'il faut pour que Yarn tourne à l'identique sur un clone (le binaire) sans embarquer le cache (1,2 Go).
`app-config.local.yaml` est ignoré parce qu'il porte les secrets et les réglages de poste ; `.nvmrc` aussi, par choix du gabarit,
ce qui se discute : sur le lab, un `.nvmrc` commité aligné sur `versions.yaml` est un bon réflexe.

## Section 2 — Exercice autonome

### Indices

1. `yarn install --immutable` doit sortir en code 0 sans toucher `yarn.lock` ; `make` s'arrête à la première commande en erreur
   si chaque commande est sur sa propre ligne. `CI=true` évite que Jest attende un terminal.
2. `jq .dependencies packages/app/package.json` et `jq .dependencies packages/backend/package.json` : la dépendance n'apparaît que
   dans le second. `yarn why <paquet>` montre qui la demande.
3. `App.test.tsx` rend l'app avec une configuration injectée (`APP_CONFIG` dans `process.env`, `app.title: 'Test'`) : il ne lit
   pas ton `app-config.yaml`.

### Correction commentée

**Point 1.** `Makefile` minimal :

```makefile
.RECIPEPREFIX := >
.PHONY: check install
install:
> yarn install --immutable
check: install
> yarn tsc
> yarn lint:all
> CI=true yarn test
```

`.RECIPEPREFIX` remplace la tabulation obligatoire des recettes par `>` (GNU make ≥ 3.82) : plus lisible dans un workbook,
et `markdownlint` refuse les tabulations.

Exécuté sur l'app de la session : `install --immutable` en 6 s (« Done with warnings »), `tsc` 9 s, `lint:all` 4 s, `test` 18 s.
Les « warnings » sont des pairs mal satisfaits (`@testing-library/dom` 9.3.4 demandé en `^10`), hérités du gabarit : ils ne cassent rien
mais lis-les une fois avec `yarn explain peer-requirements <hash>`.

**Point 2.** `[non testé : lockfile volontairement laissé intact dans la session de rédaction]` :

```bash
yarn workspace backend add node-fetch@3
jq '.dependencies["node-fetch"]' packages/backend/package.json packages/app/package.json   # "^3.x" puis null
yarn why node-fetch
yarn workspace backend remove node-fetch
git status --short            # vide
yarn install --immutable
```

Le lockfile a bougé à l'ajout et à la suppression, puis est revenu à l'identique : `--immutable` passe. Si tu avais lancé
`yarn add` à la racine, la dépendance serait entrée dans le `package.json` racine, visible de tous les workspaces et invisible
des outils qui lisent le `package.json` du backend (le `Dockerfile` et `yarn workspaces focus`).

**Point 3.** Le texte d'accueil est dans la constante `content` de `homeModule.tsx` ; le titre dans `app.title`. Le serveur de
développement recharge à la sauvegarde `[non testé : pas de navigateur dans la session]`. `yarn test` passe toujours :
`App.test.tsx` vérifie seulement que l'app se rend sans planter, avec sa propre configuration. Tester ton titre demanderait un test
qui cherche le texte, par exemple `await screen.findByText('Portail du lab')` : sujet de la fiche 03.

## Section 3 — Exercice autonome

### Indices

1. Trois URL à rendre cohérentes : `app.baseUrl` (ce que tape l'utilisateur), `backend.baseUrl` (ce que le navigateur appelle),
   `backend.cors.origin` (ce que le backend accepte comme origine). Le serveur de développement du frontend écoute déjà sur toutes
   les interfaces ; le backend non (`backend.listen.host`).
2. Le code HTTP d'une route dont le plugin n'est pas chargé n'est pas 401 : le routeur ne connaît plus `/api/techdocs`.
   Pour `auth`, regarde à quel moment le frontend demande un jeton.
3. `config:print --frontend` prouve la flèche « configuration → navigateur », `grep backend.add` la flèche « index.ts → plugins »,
   `ls .sqlite` la flèche « plugin → base ».

### Correction commentée

**Point 1.** `app-config.local.yaml` sur la VM `dev01` (`config/app-config.lab.yaml` adapté) :

```yaml
app:
  baseUrl: http://dev01.lab.home.arpa:3000
backend:
  baseUrl: http://dev01.lab.home.arpa:7007
  listen:
    port: 7007
    host: 0.0.0.0
  cors:
    origin: http://dev01.lab.home.arpa:3000
```

```bash
sudo ufw allow from 10.10.10.0/24 to any port 3000 proto tcp
sudo ufw allow from 10.10.10.0/24 to any port 7007 proto tcp
yarn start
# depuis linux-base-lx02 :
curl -s http://dev01.lab.home.arpa:7007/.backstage/health/v1/readiness
TOKEN=$(curl -s -H 'X-Requested-With: XMLHttpRequest' http://dev01.lab.home.arpa:7007/api/auth/guest/refresh | jq -r '.backstageIdentity.token')
curl -s -H "Authorization: Bearer $TOKEN" 'http://dev01.lab.home.arpa:7007/api/catalog/entities?filter=kind=component' | jq -r '.[].metadata.name'
```

`[non testé : une seule VM dans la session de rédaction ; la version localhost de ces commandes a été exécutée]`. Si l'UI se charge
mais reste vide, c'est `backend.baseUrl` ou le CORS : `yarn backstage-cli config:print --frontend | grep -A1 backend` montre
exactement l'URL que le navigateur va appeler. Le `--bind` du serveur de développement et `listen.host` sont deux réglages distincts :
l'un pour le serveur de développement du frontend, l'autre pour le backend.

**Point 2.** Sans `plugin-techdocs-backend` : `curl -H "Authorization: Bearer $TOKEN" http://localhost:7007/api/techdocs/metadata/techdocs/default/component/example-website`
renvoie **404** (route inconnue du routeur racine), pas 401. Sans `plugin-auth-backend` : le backend démarre, mais
`/api/auth/guest/refresh` renvoie 404, le frontend ne peut pas obtenir de jeton et toutes les autres routes répondent 401
« Missing credentials » : l'UI boucle sur l'écran de connexion. Remets les deux lignes et vérifie que `yarn tsc` ne se plaint pas
d'un import inutilisé (ce sont des `import()` dynamiques : aucun). `[non testé : suppressions non exécutées dans la session]`.

**Point 3.** Schéma attendu, chaque flèche avec sa commande :

| Flèche | Commande qui la prouve |
|---|---|
| navigateur → frontend :3000 | `curl -s -o /dev/null -w '%{http_code}' http://localhost:3000/` → 200 |
| navigateur → backend :7007 `/api/<plugin>` | `curl -H "Authorization: Bearer $TOKEN" http://localhost:7007/api/catalog/entities` |
| jeton ← plugin auth | `curl -H 'X-Requested-With: XMLHttpRequest' http://localhost:7007/api/auth/guest/refresh` |
| index.ts → plugins chargés | `grep -c backend.add packages/backend/src/index.ts` et la ligne `Plugin initialization started` du journal |
| plugin → sa base | `ls .sqlite/` avec la configuration SQLite sur fichier : `catalog.sqlite`, `auth.sqlite`, … |
| configuration → backend / navigateur | `yarn backstage-cli config:print` et `config:print --frontend` |

Exécuté dans la session : 9 entités au départ, 11 après `POST /api/catalog/locations`, 9 après redémarrage en mémoire,
11 conservées après redémarrage sur fichier ; `.sqlite/` contient un fichier par plugin qui a une base.
