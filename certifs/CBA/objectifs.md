---
code: CBA
titre: "CBA — mapping compétences → chapitres"
programme: "certifs/CBA/programme.md (converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14)"
chapitres_existants: 0
generated: 2026-10-02
status: "0 chapitre rédigé sur 6 ; à mettre à jour à chaque PR de chapitre"
---

# CBA — objectifs et couverture

Mapping entre les 19 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : aucun chapitre du domaine `plateforme` n'existe (`fiches/plateforme/` ne contient que son README),
aucune fiche d'un autre domaine ne touche Backstage. Les six chapitres ci-dessous sont donc tous des trous.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices »
et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| CBA-01 Backstage Development Workflow | 24 % | 5 | 4,8 % | 2 fiches (F1, F5) |
| CBA-02 Backstage Catalog | 22 % | 6 | 3,7 % | 2 fiches (F2, F4) |
| CBA-03 Backstage Infrastructure | 22 % | 4 | 5,5 % | 2 fiches (F1, F5) |
| CBA-04 Customizing Backstage | 32 % | 4 | 8,0 % | 1 fiche (F3) |
| Transverse | — | 19 | — | 1 scénario (S1) |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle. Les quatre compétences de CBA-04 pèsent chacune 8 % : c'est le domaine
à travailler en priorité, mais il suppose F1 et F2.

Ordre de rédaction recommandé (il suit la numérotation, chaque fiche s'appuie sur la précédente) :
premier lancement → catalogue → plugins et personnalisation → ingestion automatisée → configuration et production →
scénario de bout en bout.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : la clé `backstage` existe (1.55.3, vérifiée le 2026-10-02). Il manque le runtime que Backstage impose :
  ajouter `nodejs` (datasource `node-version`, canal LTS actif dans la plage `engines` de la version `backstage`) dans la PR de F1.
  Pas de clé `yarn` : le champ `packageManager` de l'app fait foi, lu par `corepack` (plan de F1, arbitrage du 2026-10-02).
  Pour F5 seulement : un moteur de conteneurs pour la VM de développement, `docker_engine` ou `podman` (le choix n'est pas
  tranché dans `DECISIONS.md` ; proposer une entrée datée dans la PR de F5), et `postgresql` (image officielle, conteneur local)
  en plus de `cloudnative_pg` déjà présent (déploiement Kubernetes). Passe par la veille (`prompts/07-veille.md`)
  ou par la PR du chapitre concerné.
- `labs/profiles/linux-base.yaml` : les VM font 2 vCPU / 4 Go. `yarn install` + `yarn tsc` + `yarn build` d'une app
  Backstage dépassent 4 Go. Les fiches F1 à F4 déclarent une **VM dédiée 4 vCPU / 8 Go / 60 Go** sur ce profil
  (même convention que `fiches/gitops/01-argo-cd-fondamentaux.md`), ou `linux-base-lx01` redimensionnée le temps du chapitre.
  Si le profil est modifié durablement, nouvelle entrée `DECISIONS.md`.
- `labs/profiles/kubernetes-ha.yaml` : la liste `components` ne cite ni `backstage`, ni `cloudnative_pg`, ni `harbor`,
  ni `keycloak`. Ajouter `backstage` et `cloudnative_pg` à la PR de F5. Le registre d'images (`registry.lab.home.arpa`,
  alias prévu dans `labs/network.md` §4) n'est porté par aucun profil hors `airgap` (proxy cache) : F5 a besoin d'un
  registre joignable depuis `kubernetes-ha`. Proposition : Harbor par chart Helm sur `kubernetes-ha` (clé `harbor` existante),
  à acter dans `DECISIONS.md` avec la PR de F5 ; en attendant, `kind load docker-image` sur la variante `kind`.
- IdP : Keycloak est prévu sur `core-pki01` (`idp.lab.home.arpa`, `labs/profiles/core.yaml`) mais aucun chapitre
  `services` ne l'installe encore. F4 (provider Keycloak) et F5 (authentification OIDC) en dépendent : soit la fiche
  `services` Keycloak existe avant, soit F4/F5 embarquent une installation minimale de Keycloak en conteneur sur la VM
  de développement, marquée comme provisoire.
- Git du lab : dépôt bare SSH sur `core-jump01` (DECISIONS.md, 2026-10-02). Backstage lit ses `catalog-info.yaml`
  par URL HTTP(S), pas par SSH : F2 utilise des fichiers locaux (`type: file`) et des URL GitHub publiques ; F4 (découverte
  automatique) utilise l'intégration GitHub avec un jeton personnel sur un dépôt public de l'apprenant, et garde
  GitLab en variante pour le jour où le placement de GitLab 19.x sera décidé.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6 (cette PR). Première cartographie du
  domaine `plateforme` : la série `fiches/plateforme/NN-` démarre à `01` avec Backstage ; les chapitres Istio (ICA),
  opérateurs et Kafka prendront les numéros suivants (DECISIONS.md, 2026-10-02, « fiches numérotées par série »).
- Pas de nouvelle décision à prendre sur l'exposition : Gateway API Cilium + certificat cert-manager de la CA interne
  (DECISIONS.md, 2026-10-02) s'applique à l'UI Backstage sur `kubernetes-ha` ; `port-forward` sur `kind`.

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. La colonne « chapitre cible » renvoie à la section 4.

### CBA-01 — Backstage Development Workflow (24 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CBA-01-01 | Build and run Backstage projects locally | 4,8 % | — | — | F1 |
| CBA-01-02 | Understand local development workflows | 4,8 % | — | — | F1 (approfondi en F3) |
| CBA-01-03 | Compile a Backstage project with TypeScript | 4,8 % | — | — | F1 (`yarn tsc` au quotidien), F5 (build de production) |
| CBA-01-04 | Download and install dependencies for a Backstage project with NPM/Yarn | 4,8 % | — | — | F1 |
| CBA-01-05 | Use Docker to build a container image of a Backstage project | 4,8 % | — | — | F5 |

### CBA-02 — Backstage Catalog (22 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CBA-02-01 | Understand how/why to use Backstage Catalog | 3,7 % | — | — | F2 |
| CBA-02-02 | Populate Backstage Catalog | 3,7 % | — | — | F2 |
| CBA-02-03 | Using annotations | 3,7 % | — | — | F2 |
| CBA-02-04 | Working with manually registered entity locations | 3,7 % | — | — | F2 |
| CBA-02-05 | Troubleshooting entity ingestion | 3,7 % | — | — | F2 (locations manuelles), F4 (providers) |
| CBA-02-06 | Working with automated ingestion | 3,7 % | — | — | F4 |

### CBA-03 — Backstage Infrastructure (22 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CBA-03-01 | Understand the Backstage framework | 5,5 % | — | — | F1 |
| CBA-03-02 | Configure Backstage | 5,5 % | — | — | F5 (introduit en F1) |
| CBA-03-03 | Deploy Backstage to production | 5,5 % | — | — | F5 |
| CBA-03-04 | Understand Backstage client-server architecture | 5,5 % | — | — | F1 |

### CBA-04 — Customizing Backstage (32 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CBA-04-01 | Understand frontend versus backend plugins | 8,0 % | — | — | F3 |
| CBA-04-02 | Customizing Backstage plugins | 8,0 % | — | — | F3 |
| CBA-04-03 | Make changes to React code in Backstage App | 8,0 % | — | — | F3 |
| CBA-04-04 | Using Material UI components | 8,0 % | — | — | F3 |

### Compétences partagées avec CNPA et CNPE

CBA et CNPA se passent dans le même bloc (`docs/prerequis.md`, parcours Golden Kubestronaut, jalon `plateforme_conf`) ;
CNPE ferme le parcours (`plateforme_exp`). Les chapitres ci-dessous citent les trois programmes dans leur front matter
pour éviter un doublon ; les mappings CNPA et CNPE eux-mêmes seront faits par leurs propres sessions
`prompts/01-cartographie-certification.md`.

| Chapitre | IDs CBA | IDs CNPA / CNPE réutilisables |
|---|---|---|
| F2 Catalogue | CBA-02-01 à 02-05 | CNPA-05-02 (API-Driven Service Catalogs) |
| F4 Ingestion automatisée | CBA-02-05, 02-06 | CNPA-05-02 |
| F5 Configuration et production | CBA-01-03, 01-05, 03-02, 03-03 | CNPA-05-03 (Developer Portals for Platform Adoption) |
| S1 Portail développeur du lab | les 19 compétences CBA | CNPA-05-01, 05-02, 05-03 ; CNPE-03-02, CNPE-03-04 (Software Templates, hors programme CBA) |

Le Scaffolder (Software Templates) et TechDocs ne figurent pas dans le programme CBA. Ils n'entrent dans aucune fiche
CBA ; le scénario S1 les utilise parce que CNPA-05 et CNPE-03 les attendent.

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de lecture recommandé (DECISIONS.md, 2026-10-02).
Les fiches F1 à F4 tournent sur **une VM de développement** du profil `linux-base` (4 vCPU / 8 Go / 60 Go, §2) :
Backstage est une application Node.js, pas un composant Kubernetes, et l'examen porte d'abord sur le poste de
développement. Seules F5 et S1 ont besoin de `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`) ;
tant que `lab up kubernetes-ha` n'existe pas, leur chemin principal est un cluster `kind` sur la VM de développement.
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.

Point de vigilance pour toutes les fiches : le PDF du programme date d'octobre 2024 (Backstage 1.32 environ) et l'examen
n'annonce aucune version (`examen.md`). La version `backstage` de `versions.yaml` utilise le **nouveau système de backend**
(`createBackend()`, `backend.add(...)`) et MUI v5 ; l'ancien système (`createRouter`, `PluginEnvironment`, `@material-ui/core`)
peut encore apparaître dans les questions. Chaque fiche concernée garde une section « à connaître pour l'examen »
(lecture seule) qui met les deux formes face à face.

### F1 — `fiches/plateforme/01-backstage-premier-lancement.md`

- **Titre** : Backstage — créer une app, la lancer, comprendre ce qui tourne
- **Niveau** : débutant (`plateforme_deb`)
- **Couvre** : CBA-01-01, CBA-01-02, CBA-01-03, CBA-01-04, CBA-03-01, CBA-03-04
- **Prérequis** : `linux_deb` (shell, paquets, systemd, ports), `iac_deb` (Git : clone, commit, push).
  Aucune compétence Kubernetes : voir la justification de l'arête dans `docs/prerequis.md` §6.3.
- **Lab** : VM de développement sur `linux-base` (Ubuntu LTS). Clés `versions.yaml` : `backstage`, `nodejs` (à créer), `ubuntu_lts`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Installer Node.js LTS et Yarn via `corepack`, créer l'app avec `npx @backstage/create-app@latest`, lire l'arborescence
     du monorepo (`packages/app`, `packages/backend`, `plugins/`, `app-config.yaml`, `app-config.local.yaml`),
     lancer `yarn start`, ouvrir l'UI sur le port 3000 et l'API sur le port 7007 — CBA-01-01, CBA-01-04.
  2. Boucle de développement : modifier un fichier et observer le rechargement, `yarn tsc` (vérification de types),
     `yarn lint`, `yarn test`, `yarn backstage-cli versions:bump`, lire `yarn.lock` et les workspaces ; comparer
     `yarn install --immutable` et une installation normale — CBA-01-02, CBA-01-03, CBA-01-04.
  3. Architecture : schéma Mermaid frontend (SPA React) → backend (Node, système de backend, plugins backend) → base
     SQLite de développement ; interroger `curl http://localhost:7007/api/catalog/entities`, lire les logs du backend,
     identifier quel processus sert quoi et où passe un appel d'API depuis le navigateur — CBA-03-01, CBA-03-04.
- **Break-fix** : `break/plateforme/01-backstage-node-version.sh` (version de Node hors plage supportée et `yarn.lock`
  altéré : `yarn install` et `yarn start` échouent avec des messages à décoder).
- **Défi chronométré** : d'une VM vierge à une UI Backstage qui répond en moins de 15 min.

### F2 — `fiches/plateforme/02-backstage-catalogue.md`

- **Titre** : Backstage Catalog — entités, annotations, locations enregistrées à la main
- **Niveau** : débutant (`plateforme_deb`)
- **Couvre** : CBA-02-01, CBA-02-02, CBA-02-03, CBA-02-04, CBA-02-05
- **Prérequis** : F1
- **Lab** : VM de développement sur `linux-base`. Clés `versions.yaml` : `backstage`, `nodejs` (à créer).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Écrire les `catalog-info.yaml` d'un petit système (`Component`, `API`, `System`, `Resource`, `Group`, `User`,
     `Domain`) avec `spec.owner`, `dependsOn`, `providesApis`/`consumesApis`, `subcomponentOf` ; les déclarer dans
     `catalog.locations` (`type: file`, `type: url`) et observer le graphe de relations dans l'UI — CBA-02-01, CBA-02-02.
  2. Annotations : `backstage.io/managed-by-location`, `backstage.io/source-location`, `backstage.io/techdocs-ref`,
     `backstage.io/kubernetes-id`, `github.com/project-slug`, annotation maison lue par un composant ; expliquer qui
     pose chaque annotation (fichier, processeur, provider) — CBA-02-03.
  3. Enregistrer une `Location` par l'UI (« Register existing component ») et par l'API (`POST /api/catalog/locations`),
     la rafraîchir, la supprimer, retrouver les entités orphelines ; diagnostiquer une ingestion qui échoue :
     erreurs affichées sur l'entité, `catalog.rules` (`allow` par `kind`), YAML invalide, `metadata.name` non conforme,
     référence d'`owner` introuvable, `catalog.processingInterval` — CBA-02-04, CBA-02-05.
- **Break-fix** : `break/plateforme/02-backstage-location-refusee.sh` (règle `catalog.rules` qui exclut le `kind` déclaré et
  `metadata.name` invalide : la Location est acceptée, les entités n'apparaissent jamais).
- **Défi chronométré** : modéliser un système de trois composants, une API et un propriétaire, visibles et reliés
  dans l'UI, en moins de 10 min.

### F3 — `fiches/plateforme/03-backstage-plugins-et-personnalisation.md`

- **Titre** : Backstage — plugins frontend et backend, React et Material UI
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CBA-04-01, CBA-04-02, CBA-04-03, CBA-04-04 (+ CBA-01-02, CBA-01-03 en pratique quotidienne)
- **Prérequis** : F1, F2 ; aucune expérience React exigée mais une heure de lecture TypeScript/JSX est prévue dans
  le chapitre (comptée dans les 20 % de lecture)
- **Lab** : VM de développement sur `linux-base`. Clés `versions.yaml` : `backstage`, `nodejs` (à créer).
- **Temps** : 8 h (le domaine pèse 32 %)
- **3 exercices clés** :
  1. Créer un plugin frontend et un plugin backend avec `yarn new`, lire ce qui est généré (`plugin.ts`, `routes.ts`,
     `index.ts`, `router.ts`), les enregistrer (`packages/app/src/App.tsx`, `packages/backend/src/index.ts` avec
     `backend.add(...)`), ajouter une entrée de barre latérale ; exposer une route HTTP dans le backend via
     `coreServices.httpRouter` et `coreServices.logger`, l'appeler depuis le frontend avec `discoveryApiRef` et
     `fetchApiRef` — CBA-04-01, CBA-04-03.
  2. Personnaliser l'existant sans forker : configurer un plugin par `app-config.yaml`, réorganiser `EntityPage.tsx`
     (`EntityLayout`, `EntitySwitch`, cartes conditionnelles), page d'accueil, thème (`createUnifiedTheme`), logo et
     barre latérale ; installer un plugin communautaire et un module backend (`backend.add(import(...))`) — CBA-04-02.
  3. Composants Material UI : construire une page avec `InfoCard`, `Table`, `Progress`, `ResponseErrorPanel` de
     `@backstage/core-components` et `Grid`, `Typography`, `Chip`, `Button` de `@mui/material` ; `useApi`,
     `useEntity`, `useAsync` ; écrire un test avec `@backstage/test-utils` ; section « à connaître pour l'examen » :
     `@material-ui/core` (MUI v4) face à `@mui/material` (MUI v5), ancien système de backend face au nouveau —
     CBA-04-03, CBA-04-04.
- **Break-fix** : `break/plateforme/03-backstage-plugin-non-enregistre.sh` (plugin backend créé mais absent de `index.ts`,
  route frontend déclarée vers un plugin dont l'`id` ne correspond pas : page blanche et 404 sur `/api/<plugin>`).
- **Défi chronométré** : plugin frontend + backend qui affiche une donnée servie par le backend en moins de 20 min.

### F4 — `fiches/plateforme/04-backstage-ingestion-automatisee.md`

- **Titre** : Backstage Catalog — ingestion automatisée (providers, découverte, provider maison)
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CBA-02-05, CBA-02-06
- **Prérequis** : F2, F3 (un provider maison est un module backend) ; `services_deb` recommandé (Keycloak sur
  `core-pki01`, §2)
- **Lab** : VM de développement sur `linux-base` + accès à `idp.lab.home.arpa` (Keycloak) et à GitHub (NAT du lab).
  Clés `versions.yaml` : `backstage`, `nodejs` (à créer), `keycloak`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Ingestion des utilisateurs et groupes depuis Keycloak (`@backstage/plugin-catalog-backend-module-keycloak`) :
     `catalog.providers.keycloakOrg`, `schedule` (`frequency`, `timeout`), vérifier les entités `User`/`Group`
     et les relations `memberOf` ; comparer avec le module GitHub org — CBA-02-06.
  2. Découverte de `catalog-info.yaml` dans des dépôts : `integrations.github` avec jeton, `catalog.providers.github`
     (`filters.branch`, `filters.repository`, `catalogPath`), rythme de rafraîchissement ; variante GitLab
     (`catalog.providers.gitlab`) lue sans la pratiquer tant que le lab n'a pas de GitLab — CBA-02-06.
  3. Écrire un `EntityProvider` maison (lit un fichier JSON d'inventaire du lab, émet des `Resource`) et un
     `CatalogProcessor` (ajoute une relation ou une annotation), les brancher dans un module backend ; dépanner :
     provider qui n'émet rien, `locationKey` en conflit, entités supprimées puis recréées, logs du
     `catalog` à niveau `debug` — CBA-02-05, CBA-02-06.
- **Break-fix** : `break/plateforme/04-backstage-provider-muet.sh` (jeton d'intégration révoqué et `schedule` absent :
  le provider démarre sans erreur visible et n'ingère rien).
- **Défi chronométré** : des groupes Keycloak visibles comme `Group` dans le catalogue, avec un propriétaire résolu
  sur un `Component`, en moins de 15 min.

### F5 — `fiches/plateforme/05-backstage-configuration-et-production.md`

- **Titre** : Backstage — configuration, image de conteneur et déploiement en production
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : CBA-01-03, CBA-01-05, CBA-03-02, CBA-03-03
- **Prérequis** : F1, F3 ; `kubernetes_conf` (Deployment, Secret, Gateway API, PVC) ; `services_deb` recommandé (Keycloak)
- **Lab** : VM de développement sur `linux-base` (build) + `kubernetes-ha` (déploiement ; chemin principal `kind`
  tant que le profil n'est pas levé). Clés `versions.yaml` : `backstage`, `nodejs` (à créer), `docker_engine` ou
  `podman` (à créer), `postgresql` (à créer), `cloudnative_pg`, `kubernetes`, `cilium`, `cert_manager`, `harbor`, `keycloak`.
- **Temps** : 7 h
- **3 exercices clés** :
  1. Configuration en couches : `app-config.yaml`, `app-config.production.yaml`, `app-config.local.yaml`, option
     `--config`, substitution `${POSTGRES_PASSWORD}` et `$include`, `backend.baseUrl` / `app.baseUrl` / `backend.cors`,
     `backend.database` (SQLite → PostgreSQL), `backend.listen`, `auth.providers` OIDC vers Keycloak avec
     `signIn.resolvers`, `backend.auth.keys` ; lire la configuration effective avec `yarn backstage-cli config:print`
     et la valider avec `config:check` — CBA-03-02.
  2. Construire l'artefact : `yarn tsc`, `yarn build:backend`, lire `packages/backend/Dockerfile` (image Node,
     `skeleton.tar.gz`, `bundle.tar.gz`, `yarn workspaces focus --production`), construire l'image avec le moteur de
     conteneurs de la VM, la lancer avec un PostgreSQL en conteneur, la pousser sur `registry.lab.home.arpa` ; comparer
     image multi-étapes « host build » et image « build in Docker » — CBA-01-03, CBA-01-05.
  3. Déployer sur Kubernetes : namespace, `Secret` (base, clés d'auth), `ConfigMap` (app-config de production),
     `Deployment` + `Service`, PostgreSQL via CloudNativePG, `Gateway` + `HTTPRoute` Cilium avec certificat de la CA
     interne, sonde sur `/healthcheck`, ressources CPU/RAM, mise à jour d'image sans interruption ; variante Helm
     (chart communautaire) ; lecture seule : haute disponibilité (plusieurs réplicas, sessions) et
     sauvegarde de la base — CBA-03-03.
- **Break-fix** : `break/plateforme/05-backstage-baseurl-cors.sh` (`backend.baseUrl` et `backend.cors.origin` incohérents
  avec l'URL publiée par la Gateway : UI chargée, toutes les requêtes API refusées).
- **Défi chronométré** : nouvelle image construite, poussée et déployée, UI joignable en HTTPS, en moins de 20 min.

### S1 — `scenarios/NN-portail-developpeur-backstage/README.md`

- **Titre** : NN — Le portail développeur du lab : Backstage en production, catalogue vivant, SSO et golden path
  (numéro `NN` attribué à la création)
- **Niveau** : expert (`plateforme_exp`) ; prérequis F1 à F5 complets, pas de saut direct
- **Couvre** : les 19 compétences CBA en situation, plus CNPA-05-01 à 05-03 et CNPE-03-02, CNPE-03-04
  (Software Templates et TechDocs, hors programme CBA)
- **Prérequis** : F1 à F5, `fiches/gitops/01-argo-cd-fondamentaux.md` (déploiement du portail par Argo CD),
  `observabilite_conf` (métriques du backend dans Prometheus), `securite_conf` (OIDC, permissions)
- **Lab** : `kubernetes-ha` + socle `core` (Keycloak, DNS, PKI) ; registre Harbor (§2). Clés `versions.yaml` :
  `backstage`, `nodejs`, `cloudnative_pg`, `harbor`, `keycloak`, `argo_cd`, `prometheus`, `cert_manager`, `cilium`.
- **Temps** : 8 h en deux séances
- **Livrable** : ADR « pourquoi un portail, périmètre et règles de propriété du catalogue » + runbook « mettre à jour
  Backstage »
- **3 exercices clés** :
  1. Portail en production livré par GitOps : image construite sur la VM, poussée sur Harbor, manifests dans le
     dépôt du lab synchronisés par Argo CD, PostgreSQL CloudNativePG, SSO Keycloak, permissions par groupe.
  2. Catalogue vivant : providers Keycloak et GitHub, provider maison alimenté par l'inventaire du lab
     (`labs/profiles/*.yaml` → `Resource`), plugin Kubernetes relié aux workloads par `backstage.io/kubernetes-id`,
     un plugin maison qui affiche l'état du lab.
  3. Golden path et break-fix transverse : un Software Template qui crée un dépôt avec `catalog-info.yaml` et TechDocs
     (hors CBA, pour CNPA/CNPE) ; pannes injectées : jeton d'intégration expiré, base PostgreSQL pleine, clé
     `backend.auth.keys` changée entre deux réplicas ; diagnostiquer de bout en bout en moins de 30 min.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| F1 Backstage premier lancement | débutant | linux-base (VM de développement) | 5 h |
| F2 Catalogue, annotations, locations | débutant | linux-base (VM de développement) | 6 h |
| F3 Plugins et personnalisation | confirmé | linux-base (VM de développement) | 8 h |
| F4 Ingestion automatisée | confirmé | linux-base + Keycloak du socle | 5 h |
| F5 Configuration et production | confirmé | linux-base + kubernetes-ha (ou kind) | 7 h |
| S1 Portail développeur du lab | expert | kubernetes-ha + core | 8 h |
| Révision (flashcards, quiz, examen blanc `exams/`) | — | — | 5 h |
| **Total** | | | **44 h** |

À 5 h par semaine, compter 9 semaines, cohérent avec un bloc de 4 à 6 semaines par certification de `docs/roadmap.md` §7
si CBA et CNPA partagent le bloc `plateforme_conf` sur deux cycles.

## 6. Ce que le lab ne couvre pas

- Rien n'est `[lecture + simulation]` : Backstage tourne sur une VM Ubuntu, puis sur `kubernetes-ha` (ou `kind`),
  sans matériel particulier.
- Les intégrations SaaS citées par la documentation (GitHub App, Okta, Azure AD, AWS, GCP) sont remplacées par
  Keycloak et un jeton GitHub personnel ; leurs noms de configuration (`integrations.*`, `auth.providers.*`,
  `catalog.providers.*`) sont à connaître pour le QCM (sections « à connaître pour l'examen », lecture seule).
- GitLab n'est pas sur le lab tant que son placement n'est pas décidé (DECISIONS.md, 2026-10-02) : le provider GitLab
  et la découverte GitLab sont lus, pas pratiqués.
- L'examen est un QCM sans documentation (`examen.md`) : les flashcards de chaque fiche et le quiz `revision/quiz/`
  sont la préparation directe, les manipulations servent la rétention. Les noms exacts des clés `app-config.yaml`,
  des commandes `backstage-cli` et des `kind` d'entité doivent être mémorisés.
