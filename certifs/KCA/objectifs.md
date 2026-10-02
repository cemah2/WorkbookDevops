---
code: KCA
titre: "KCA — mapping compétences → chapitres"
programme: "certifs/KCA/programme.md (converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14)"
chapitres_existants: 0
generated: 2026-10-02
status: "0 chapitre rédigé sur 8 ; à mettre à jour à chaque PR de chapitre"
---

# KCA — objectifs et couverture

Mapping entre les 31 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : aucun chapitre n'aborde Kyverno. Les deux fiches rédigées (`fiches/gitops/01` et `02`)
ne couvrent aucune compétence KCA ; elles fournissent seulement le chemin d'installation d'un cluster `kind`
réutilisé par les fiches débutant ci-dessous. Ce fichier sert de plan de création ; chaque PR de chapitre
remplit les colonnes « chapitre » et « exercices » et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| KCA-01 Fundamentals of Kyverno | 18 % | 4 | 4,5 % | 1 fiche (+ 1 partagée) |
| KCA-02 Installation, Configuration, and Upgrades | 18 % | 6 | 3,0 % | 1 fiche (+ 1 partagée) |
| KCA-03 Kyverno CLI | 12 % | 4 | 3,0 % | 1 fiche |
| KCA-04 Applying Policies | 10 % | 3 | 3,3 % | 1 fiche (partagée avec KCA-01) |
| KCA-05 Writing Policies | 32 % | 11 | 2,9 % | 3 fiches |
| KCA-06 Policy Management | 10 % | 3 | 3,3 % | 1 fiche |
| Transverse | — | 31 | — | 1 scénario |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle. Lecture utile : KCA-01 pèse 4,5 % par compétence avec quatre
compétences seulement, KCA-05 pèse 32 % mais dilué sur onze ; les deux méritent le même temps.

Ordre de rédaction recommandé (prérequis d'abord, puis du plus lourd au plus léger) :
fondamentaux → CLI → validation, variables et CEL → mutation, génération et nettoyage → vérification d'images →
installation HA, RBAC et mises à jour → rapports, exceptions et métriques → scénario de bout en bout.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : la clé `kyverno` existe (chart Helm et CLI suivent la même version). Ajouter `cosign`
  (dépôt `sigstore/cosign`, datasource `github-releases`) pour F5 et `policy_reporter` (dépôt `kyverno/policy-reporter`)
  pour F7 ; `syft` est facultatif (SBOM de l'exercice 2 de F5). Passe par la veille (`prompts/07-veille.md`)
  ou par la PR du chapitre concerné.
- `labs/profiles/kubernetes-ha.yaml` : la liste `components` ne cite pas `kyverno` ; l'ajouter, ainsi que `policy_reporter`.
- Harbor : seule la VM miroir du profil `airgap` le porte (proxy cache). F5 et S1 ont besoin d'un registre
  joignable depuis `kubernetes-ha` où pousser des images signées. Proposition à trancher dans la PR de F5 :
  Harbor par chart Helm sur `kubernetes-ha` (clé `harbor` existante, exposition par Gateway API et certificat
  cert-manager), sinon un registre `distribution` léger dans le cluster. À consigner dans `DECISIONS.md`.
- Écart entre programme et version : le curriculum KCA date du 2024-11-28 (`programme.md`, PDF `KCA_Curriculum.pdf`)
  et décrit la syntaxe `ClusterPolicy`/`Policy` (règles `validate`, `mutate`, `generate`, `verifyImages`, `validate.cel`).
  Kyverno `1.19` (`versions.yaml`) ajoute des types CEL dédiés (`ValidatingPolicy`, `MutatingPolicy`,
  `GeneratingPolicy`, `ImageValidatingPolicy`, `DeletingPolicy`). Les fiches enseignent la syntaxe du programme
  en chemin principal et présentent les nouveaux types dans une section « à connaître » en lecture seule,
  jusqu'à ce que la veille constate un changement du curriculum.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.2 (cette PR).
- Pas de nouvelle décision à prendre : Helm 4 (DECISIONS.md, 2026-10-02) s'applique à l'installation de Kyverno ;
  Gateway API Cilium s'applique à l'exposition de Policy Reporter.

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. La colonne « chapitre cible » renvoie à la section 4.

### KCA-01 — Fundamentals of Kyverno (18 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| KCA-01-01 | Kyverno Policies & Rules | 4,5 % | — | — | F1 |
| KCA-01-02 | YAML Manifests | 4,5 % | — | — | F1 |
| KCA-01-03 | Admission Controllers | 4,5 % | — | — | F1 |
| KCA-01-04 | OCI Images | 4,5 % | — | — | F1 (références, tags, digests) puis F5 (signatures) |

### KCA-02 — Installation, Configuration, and Upgrades (18 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| KCA-02-01 | Helm-based Installation and Configuration | 3,0 % | — | — | F1 (installation de base) puis F6 (values avancées) |
| KCA-02-02 | Kyverno Custom Resource Definitions (CRDs) | 3,0 % | — | — | F6 |
| KCA-02-03 | Controller Configuration with Flags | 3,0 % | — | — | F6 |
| KCA-02-04 | Configuring Kyverno RBAC, roles, and permissions | 3,0 % | — | — | F6 (introduit en F4 pour `generate`) |
| KCA-02-05 | High Availability Installations | 3,0 % | — | — | F6 |
| KCA-02-06 | Upgrading Kyverno | 3,0 % | — | — | F6 |

### KCA-03 — Kyverno CLI (12 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| KCA-03-01 | apply | 3,0 % | — | — | F2 |
| KCA-03-02 | test | 3,0 % | — | — | F2 |
| KCA-03-03 | jp | 3,0 % | — | — | F2 |
| KCA-03-04 | Installing Kyverno CLI | 3,0 % | — | — | F2 |

### KCA-04 — Applying Policies (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| KCA-04-01 | Applying Policy in Cluster | 3,3 % | — | — | F1 |
| KCA-04-02 | Resource Selection | 3,3 % | — | — | F1 |
| KCA-04-03 | Common Policy Settings for Kyverno Rules | 3,3 % | — | — | F1 |

### KCA-05 — Writing Policies (32 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| KCA-05-01 | Validation Rules | 2,9 % | — | — | F3 (première règle en F1) |
| KCA-05-02 | Preconditions | 2,9 % | — | — | F3 |
| KCA-05-03 | Background Scans | 2,9 % | — | — | F3 |
| KCA-05-04 | Mutation Rules | 2,9 % | — | — | F4 |
| KCA-05-05 | Generation Rules | 2,9 % | — | — | F4 |
| KCA-05-06 | VerifyImage Rules | 2,9 % | — | — | F5 |
| KCA-05-07 | Variables & API Calls in Policies | 2,9 % | — | — | F3 |
| KCA-05-08 | JSON Patches | 2,9 % | — | — | F4 |
| KCA-05-09 | Autogen Rules | 2,9 % | — | — | F3 |
| KCA-05-10 | Cleanup Policies | 2,9 % | — | — | F4 |
| KCA-05-11 | Common Expression Language (CEL) | 2,9 % | — | — | F3 |

### KCA-06 — Policy Management (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| KCA-06-01 | Policy Reports | 3,3 % | — | — | F7 |
| KCA-06-02 | PolicyExceptions | 3,3 % | — | — | F7 |
| KCA-06-03 | Kyverno Metrics | 3,3 % | — | — | F7 |

### Compétences partagées avec d'autres certifications

Kyverno est l'outil d'admission des parcours Kubestronaut et SecNumCloud (`docs/prerequis.md` §3) : les chapitres
ci-dessous citent aussi les programmes voisins dans leur front matter pour éviter un doublon. Les mappings
de ces certifications seront faits par leur propre session `prompts/01-cartographie-certification.md`.

| Chapitre | IDs KCA | IDs réutilisables (à confirmer par leur cartographie) |
|---|---|---|
| F1 Kyverno fondamentaux | KCA-01-01 à 01-04, 02-01, 04-01 à 04-03 | KCSA-05-07, CKAD-04-02, KCNA (admission, à identifier) |
| F3 Validation, variables et CEL | KCA-05-01 à 05-03, 05-07, 05-09, 05-11 | KCSA-03-02 (Pod Security Admission via la sous-règle `podSecurity`) |
| F5 Vérification d'images | KCA-01-04, 05-06 | KCSA-01-05, KCSA-05-01, KCSA-05-02, CKS-05-03 |
| F7 Rapports, exceptions, métriques | KCA-06-01 à 06-03 | CNPE-05-03 |
| S1 Gouvernance Kyverno du lab | les 31 compétences | CNPA-02-03, CNPE-05-04, CKS-05-03 |

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de rédaction recommandé (DECISIONS.md, 2026-10-02) dans le domaine `securite`,
qui ne contient encore aucune fiche : la série Kyverno prend `01` à `07`, la prochaine fiche sécurité prendra `08`.
Tous les chapitres ciblent le profil `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`).
Tant que `lab up kubernetes-ha` n'existe pas, les fiches **débutant** ont pour chemin principal un cluster `kind`
sur une VM du profil `linux-base` (8 vCPU / 16 Go / 180 Go), en réutilisant la procédure de
`fiches/gitops/01-argo-cd-fondamentaux.md`, et gardent `kubernetes-ha` en variante ; les fiches confirmé attendent
le profil complet (F6 exige trois workers pour la haute disponibilité). Gateway API : Cilium par défaut (DECISIONS.md, 2026-10-02).
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.

Convention commune à toutes les fiches : chaque policy est validée par `kyverno apply` ou `kyverno test` **avant**
d'être appliquée au cluster, et chaque manifest du chapitre passe `kubeconform` (schémas Kyverno via le catalogue
`datreeio/CRDs-catalog` ou `-ignore-missing-schemas`, à fixer dans la PR de F1).

### F1 — `fiches/securite/01-kyverno-fondamentaux.md`

- **Titre** : Kyverno — admission controllers, première policy, sélection des ressources
- **Niveau** : débutant (`securite_deb`)
- **Couvre** : KCA-01-01, KCA-01-02, KCA-01-03, KCA-01-04 (références d'images, tags et digests ; la vérification de
  signature est en F5), KCA-02-01 (installation Helm de base ; valeurs avancées en F6), KCA-04-01, KCA-04-02, KCA-04-03
- **Prérequis** : `kubernetes_deb` (kubectl, Pods, Deployments, namespaces, labels, lecture d'un manifest YAML) ;
  `fiches/gitops/01-argo-cd-fondamentaux.md` recommandé pour la mise en place du cluster `kind`
- **Lab** : `kind` sur `linux-base` (chemin principal), variante `kubernetes-ha`.
  Clés `versions.yaml` : `kyverno`, `helm`, `kind`, `kubernetes`, `cilium`, `cert_manager`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Schématiser en Mermaid le chemin d'une requête `kubectl apply` (authentification → autorisation → webhooks
     mutants → validation de schéma → webhooks validants → etcd), installer Kyverno par Helm (chart `kyverno/kyverno`,
     version `kyverno`), identifier les quatre contrôleurs (admission, background, reports, cleanup) et lire les
     `MutatingWebhookConfiguration` / `ValidatingWebhookConfiguration` qu'il gère — KCA-01-03, KCA-02-01, KCA-01-01.
  2. Écrire une première `ClusterPolicy` `validate` (labels obligatoires), l'appliquer en `Audit` puis `Enforce`,
     observer le refus et son message, lire `kubectl get cpol` (`READY`, `ADMISSION`, `BACKGROUND`), comparer avec
     une `Policy` namespacée ; anatomie d'un manifest Kyverno (`spec.rules[]`, `match`, `exclude`, un seul type
     d'action par règle) — KCA-01-01, KCA-01-02, KCA-04-01, KCA-04-03.
  3. Sélection des ressources : `match`/`exclude` avec `any`/`all`, `kinds` (`Pod`, `apps/v1/Deployment`, sous-ressource
     `Pod/exec`), `namespaces`, `names` avec joker, `selector`, `namespaceSelector`, `operations`, `subjects`,
     `roles`/`clusterRoles` ; paramètres communs `validationFailureAction`, `validationFailureActionOverrides`,
     `background`, `failurePolicy`, `webhookTimeoutSeconds`, `admission`, `skipBackgroundRequests` ; OCI : décomposer
     une référence `registry/repo:tag@sha256:…` et interdire `:latest` par `pattern` — KCA-04-02, KCA-04-03, KCA-01-04.
- **Break-fix** : `break/securite/01-kyverno-webhook-timeout.sh` (admission controller injoignable avec `failurePolicy: Fail`,
  tout `kubectl apply` refusé, y compris hors périmètre des policies).
- **Défi chronométré** : en moins de 10 min, refuser les Pods sans `resources.requests` dans un seul namespace
  et prouver par une commande que les autres namespaces passent.

### F2 — `fiches/securite/02-kyverno-cli.md`

- **Titre** : Kyverno CLI — `apply`, `test` et `jp` sans cluster
- **Niveau** : débutant (`securite_deb`)
- **Couvre** : KCA-03-01, KCA-03-02, KCA-03-03, KCA-03-04
- **Prérequis** : F1
- **Lab** : `linux-base` (poste ou VM, aucun cluster nécessaire pour l'essentiel) ; variante contre le cluster `kind`
  ou `kubernetes-ha` pour `apply --cluster`. Clé `versions.yaml` : `kyverno` (le binaire CLI est publié avec chaque version).
- **Temps** : 4 h
- **3 exercices clés** :
  1. Installer le CLI par le binaire de la release `kyverno` puis par krew (`kubectl kyverno`), vérifier `kyverno version` ;
     `kyverno apply policy.yaml --resource pod.yaml`, lire le résumé pass/fail/warn/error/skip, options `--audit-warn`,
     `--policy-report`, `--cluster`, `--set` et `--values-file` pour les variables de contexte — KCA-03-04, KCA-03-01.
  2. Écrire `kyverno-test.yaml` (`policies`, `resources`, `results` avec `kind`, `resources`, `rule`, `result`),
     lancer `kyverno test .`, ajouter un cas de mutation avec `patchedResource`, un cas de génération avec
     `generatedResource`, un fichier `variables.yaml`, options `--detailed-results` et `--fail-only` ;
     intégrer le test dans un script exécutable en CI — KCA-03-02.
  3. `kyverno jp query`, `kyverno jp function`, `kyverno jp parse` : expressions JMESPath sur un manifest
     (`request.object.spec.containers[*].image`, `pattern_match`, `time_since`, `x509_decode`, `to_upper`),
     fonctions propres à Kyverno, tester chaque variable avant de l'écrire dans une policy — KCA-03-03.
- **Break-fix** : `break/securite/02-kyverno-test-mismatch.sh` (fichier de test dont les résultats attendus
  contredisent la policy : trouver qui a tort, la policy ou le test).
- **Défi chronométré** : en moins de 10 min, écrire un test couvrant deux ressources `pass` et deux `fail`
  pour une policy donnée et le faire passer.

### F3 — `fiches/securite/03-kyverno-validation-variables-cel.md`

- **Titre** : Kyverno — règles de validation, préconditions, variables, scans en arrière-plan et CEL
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : KCA-05-01, KCA-05-02, KCA-05-03, KCA-05-07, KCA-05-09, KCA-05-11
- **Prérequis** : F1, F2 ; `kubernetes_conf` (RBAC, `kubectl get --raw`, ValidatingAdmissionPolicy native)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `kyverno`, `kubernetes`.
- **Temps** : 7 h
- **3 exercices clés** :
  1. Validation : `pattern` et ses ancres (conditionnelle `()`, égalité `=()`, existence `^()`, négation `X()`,
     globale `<()`), `anyPattern`, `deny` avec `conditions` `any`/`all` et opérateurs, `foreach` sur conteneurs et
     volumes, sous-règle `podSecurity` (profil `restricted`, `exclude` ciblé), `message` templatisé ;
     chaque règle passe par `kyverno apply` avant le cluster — KCA-05-01.
  2. Préconditions (`any`/`all`, opérateurs `Equals`, `In`, `AnyIn`, `GreaterThan`…), variables prédéfinies
     (`request.operation`, `request.object`, `request.oldObject`, `serviceAccountName`, `element`), `context` :
     `configMap`, `apiCall` (`urlPath`, `jmesPath`, méthode `POST` vers un service), `globalContext`
     (`GlobalContextEntry`), `imageRegistry`, `variable` ; autogen : observer les règles `autogen-*` générées pour
     Deployment, StatefulSet et CronJob, annotation `pod-policies.kyverno.io/autogen-controls` — KCA-05-02, KCA-05-07, KCA-05-09.
  3. Scans en arrière-plan : `background: true`, ce qu'une règle en arrière-plan ne peut pas utiliser (`request.*`),
     intervalle (`--backgroundScanInterval`), lecture des `PolicyReport` produits pour les ressources existantes ;
     CEL : réécrire une règle en `validate.cel` (`expressions`, `variables`, `paramKind`, `auditAnnotations`),
     la comparer avec une `ValidatingAdmissionPolicy` native (`--generateValidatingAdmissionPolicy`) et avec le type
     `ValidatingPolicy` de Kyverno `1.19` `[à connaître, hors programme 2024]` — KCA-05-03, KCA-05-11.
- **Break-fix** : `break/securite/03-kyverno-context-apicall.sh` (`apiCall` vers un service absent : selon `failurePolicy`,
  toutes les créations sont refusées ou la règle passe en silence).
- **Défi chronométré** : en moins de 15 min, refuser toute `HTTPRoute` dont l'hôte existe déjà dans le cluster
  (`apiCall` + `deny`), avec un `kyverno test` qui passe.

### F4 — `fiches/securite/04-kyverno-mutation-generation-cleanup.md`

- **Titre** : Kyverno — mutation, génération et nettoyage
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : KCA-05-04, KCA-05-05, KCA-05-08, KCA-05-10 (introduit KCA-02-04 pour les droits du background controller)
- **Prérequis** : F3
- **Lab** : `kubernetes-ha`. Clé `versions.yaml` : `kyverno`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Mutation : `patchStrategicMerge` avec ancres `+()` (ajout si absent) et conditionnelles, `patchesJson6902`
     (`add`, `remove`, `replace`, échappement `~1` dans les chemins), `foreach` avec `order`, mutation de ressources
     existantes (`targets`, `mutateExistingOnPolicyUpdate`), ordre mutation → validation ; vérifier le résultat avec
     `kubectl get -o yaml` et les annotations `policies.kyverno.io/*` — KCA-05-04, KCA-05-08.
  2. Génération : `generate.data` (NetworkPolicy default-deny à la création d'un namespace), `generate.clone` et
     `cloneList` (secret de registre, ConfigMap de CA), `synchronize: true` et son effet à la modification ou suppression
     de la source et de la cible, `generateExisting`, déclencheurs sur événement et sur ressources existantes, droits à
     ajouter au ClusterRole agrégé `kyverno:background-controller`, suivi des `UpdateRequest` — KCA-05-05, KCA-02-04.
  3. Nettoyage : `CleanupPolicy` et `ClusterCleanupPolicy` (`match`, `conditions`, `schedule` cron), label
     `cleanup.kyverno.io/ttl` (durée ou date), Jobs terminés et Pods `Completed`, lecture des logs du cleanup controller — KCA-05-10.
- **Break-fix** : `break/securite/04-kyverno-generate-rbac.sh` (ClusterRole agrégé amputé : `UpdateRequest` en `Failed`,
  ressource jamais générée).
- **Défi chronométré** : en moins de 15 min, chaque nouveau namespace reçoit un NetworkPolicy default-deny et un
  ResourceQuota, et chaque Pod reçoit un `securityContext` par défaut.

### F5 — `fiches/securite/05-kyverno-verify-image.md`

- **Titre** : Kyverno — vérifier signatures et attestations d'images (cosign, Notary, Harbor)
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : KCA-01-04 (complet), KCA-05-06
- **Prérequis** : F3 ; `services_deb` recommandé (PKI interne pour le registre) ; registre d'images du lab (voir §2)
- **Lab** : `kubernetes-ha` + registre (Harbor par chart Helm ou `distribution`). Clés `versions.yaml` :
  `kyverno`, `harbor`, `cosign` (à créer), `syft` (facultatif, à créer).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Signer une image avec cosign (paire de clés locale, puis keyless via Sigstore public ; `[lecture + simulation]`
     si la sortie Internet du cluster est coupée), la pousser sur le registre, écrire `verifyImages` avec `attestors`
     (`keys`, `keyless`, `certificates`), `imageReferences`, `mutateDigest`, `required`, `verifyDigest`,
     `failureAction` ; observer le remplacement du tag par le digest — KCA-05-06, KCA-01-04.
  2. Attestations : produire un SBOM (syft) et un rapport de vulnérabilités, les attacher avec `cosign attest`,
     les exiger via `attestations` + `conditions` (type de prédicat, `time_since` sur la date du scan), `count` et
     entrées multiples d'attestors — KCA-05-06.
  3. Notary (`type: notary`, certificats), registres privés (`imagePullSecrets`, `--registryCredentialHelpers`),
     `imageExtractors` pour une CRD custom, cache de vérification ; comparer avec `ImageValidatingPolicy` de
     Kyverno `1.19` `[à connaître, hors programme 2024]` — KCA-05-06, KCA-01-04.
- **Break-fix** : `break/securite/05-kyverno-verify-key-rotated.sh` (clé publique de la policy différente de celle
  de la signature : tous les déploiements du namespace refusés).
- **Défi chronométré** : en moins de 15 min, le namespace `prod` n'accepte que des images signées par la clé du lab
  et porteuses d'une attestation SBOM.

### F6 — `fiches/securite/06-kyverno-installation-ha-rbac-mise-a-jour.md`

- **Titre** : Kyverno — installation Helm avancée, haute disponibilité, flags, RBAC et mises à jour
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : KCA-02-01, KCA-02-02, KCA-02-03, KCA-02-04, KCA-02-05, KCA-02-06
- **Prérequis** : F1, F4 ; `kubernetes_conf` (Helm 4, PodDisruptionBudget, anti-affinité, agrégation de ClusterRoles)
- **Lab** : `kubernetes-ha` (trois workers nécessaires). Clés `versions.yaml` : `kyverno`, `helm`, `kubernetes`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Installation par values Helm : `replicaCount` 3 pour l'admission controller, `podDisruptionBudget`, anti-affinité,
     ressources, `config.resourceFilters`, `config.webhooks` (`namespaceSelector` excluant `kube-system`),
     `config.excludeGroups`, `features.*` ; lister les CRD installées (`cpol`, `pol`, `polex`, `cleanpol`,
     `clustercleanpol`, `updaterequests`, `globalcontextentries`, `policyreports`, `clusterpolicyreports`,
     `ephemeralreports`) et lire leur schéma avec `kubectl explain` — KCA-02-01, KCA-02-02, KCA-02-05.
  2. Flags des contrôleurs : `--backgroundScan`, `--backgroundScanInterval`, `--admissionReports`,
     `--autoUpdateWebhooks`, `--enablePolicyException`, `--exceptionNamespace`, `--webhookTimeout`,
     `--forceFailurePolicyIgnore`, `--protectManagedResources`, `--clientRateLimitQPS`, `--loggingFormat`,
     `--dumpPayload` ; les passer par `extraArgs` dans les values et observer l'effet de chacun — KCA-02-03.
  3. RBAC : ClusterRoles agrégés `kyverno:admission-controller`, `kyverno:background-controller`,
     `kyverno:reports-controller`, `kyverno:cleanup-controller`, labels `rbac.kyverno.io/aggregate-to-*`, ajout d'un
     droit pour une règle `generate` ; mise à jour : `helm upgrade` entre deux versions mineures après lecture des notes
     de version, CRD mises à jour par Helm ou à la main (`kubectl replace`), webhooks régénérés, retour arrière
     `helm rollback` — KCA-02-04, KCA-02-06.
- **Break-fix** : `break/securite/06-kyverno-resource-filters.sh` (`resourceFilters` modifié : Kyverno ignore les
  namespaces de l'apprenant, plus aucune policy ne s'applique, sans erreur).
- **Défi chronométré** : en moins de 15 min, passer une installation mono-réplica en haute disponibilité (3 réplicas,
  PDB, anti-affinité) et survivre au `drain` d'un worker sans aucun refus d'admission.

### F7 — `fiches/securite/07-kyverno-reports-exceptions-metriques.md`

- **Titre** : Kyverno — PolicyReports, PolicyExceptions et métriques
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : KCA-06-01, KCA-06-02, KCA-06-03
- **Prérequis** : F3 ; `observabilite_deb` (Prometheus et Grafana du profil, PromQL de base)
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `kyverno`, `prometheus`, `grafana`, `policy_reporter` (à créer).
- **Temps** : 4 h
- **3 exercices clés** :
  1. Rapports : `PolicyReport` et `ClusterPolicyReport` (API `wgpolicyk8s.io`), rapports d'admission et d'arrière-plan,
     `EphemeralReport`, résultats pass/fail/warn/error/skip, lecture avec `kubectl get polr -A -o wide` et `jq`,
     installation de Policy Reporter et de son UI derrière Gateway API, export vers Grafana — KCA-06-01.
  2. `PolicyException` : `match`, `policyName`, `ruleNames`, namespace imposé par `--exceptionNamespace`,
     activation par `--enablePolicyException`, exception pour une image ou un Pod système, contrôles `podSecurity`
     dans une exception, cycle de vie (ticket → PR → revue), exceptions CEL de Kyverno `1.19` `[à connaître]` — KCA-06-02.
  3. Métriques : endpoint `/metrics` du service `kyverno-svc-metrics`, `ServiceMonitor`, métriques
     `kyverno_policy_results_total`, `kyverno_policy_rule_info_total`, `kyverno_admission_requests_total`,
     `kyverno_admission_review_duration_seconds`, `kyverno_policy_execution_duration_seconds`,
     `kyverno_policy_changes_total`, `kyverno_client_queries_total` ; filtrage par `metricsConfig` (namespaces
     inclus/exclus, `metricsExposure`), tableau de bord Grafana officiel, alerte sur le taux de refus — KCA-06-03.
- **Break-fix** : `break/securite/07-kyverno-reports-controller-down.sh` (reports controller à zéro réplica :
  rapports figés, scan en arrière-plan sans effet visible).
- **Défi chronométré** : en moins de 10 min, expliquer pourquoi un Pod donné est passé malgré une policy `Enforce`
  (retrouver l'exception) et produire la requête PromQL du taux de `fail` par policy.

### S1 — `scenarios/NN-gouvernance-kyverno-lab/README.md`

- **Titre** : NN — Policy as code : gouverner le cluster du lab avec Kyverno (numéro `NN` attribué à la création)
- **Niveau** : expert (`securite_exp`) ; prérequis F1 à F7 complets, pas de saut direct
- **Couvre** : les 31 compétences KCA en situation, plus CKS-05-03, KCSA-05-07, CNPA-02-03, CNPE-05-04
- **Lab** : `kubernetes-ha` + registre d'images, Git du lab (`core-jump01`), Argo CD de `fiches/gitops/01`,
  Prometheus et Grafana. Clés `versions.yaml` : `kyverno`, `cosign`, `policy_reporter`, `harbor`, `argo_cd`,
  `prometheus`, `grafana`.
- **Temps** : 8 h en deux séances
- **Livrable** : dépôt `policies/` testé par `kyverno test` en CI, runbook « ajouter une exception », rapport de
  conformité PSS `restricted` du cluster
- **3 exercices clés** :
  1. Construire le dépôt de policies (socle PSS `restricted` en `Audit`, passage en `Enforce` namespace par namespace
     via `validationFailureActionOverrides`), tests CLI à chaque commit, déploiement par Argo CD avec sync waves
     (CRD avant policies).
  2. Chaîne d'images : build → signature cosign → attestation SBOM → registre → `verifyImages` en `Enforce` sur `prod` ;
     génération de NetworkPolicy et de quotas par namespace ; nettoyage des Jobs terminés.
  3. Break-fix transverse : mise à jour de Kyverno qui casse une policy (champ retiré), exception périmée, timeout de
     webhook sous charge, reports controller saturé ; diagnostiquer de bout en bout en moins de 30 min avec rapports et métriques.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| F1 Kyverno fondamentaux | débutant | linux-base (kind) ou kubernetes-ha | 5 h |
| F2 Kyverno CLI | débutant | linux-base (sans cluster) | 4 h |
| F3 Validation, variables et CEL | confirmé | kubernetes-ha | 7 h |
| F4 Mutation, génération et nettoyage | confirmé | kubernetes-ha | 6 h |
| F5 Vérification d'images | confirmé | kubernetes-ha + registre | 5 h |
| F6 Installation HA, RBAC, mises à jour | confirmé | kubernetes-ha | 6 h |
| F7 Rapports, exceptions, métriques | confirmé | kubernetes-ha | 4 h |
| S1 Gouvernance Kyverno du lab | expert | kubernetes-ha + registre | 8 h |
| Révision (flashcards, quiz, examen blanc `exams/`) | — | — | 6 h |
| **Total** | | | **51 h** |

À 5 h par semaine, compter 10 à 11 semaines, cohérent avec le cycle de 4 à 6 semaines par bloc de `docs/roadmap.md` §7
si le bloc CCA + ICA + KCA du parcours Golden Kubestronaut (`docs/prerequis.md` §3) est étalé sur deux cycles.

## 6. Ce que le lab ne couvre pas

- Signature keyless (Fulcio et Rekor publics) : nécessite une sortie Internet depuis le poste et le cluster ; le chemin
  principal de F5 utilise une paire de clés locale, keyless passe `[lecture + simulation]` sur la variante `airgap`.
- Multi-cluster : le programme ne le cite pas ; S1 reste sur un cluster, la distribution GitOps des policies
  à plusieurs clusters est hors périmètre.
- Version d'examen : aucune version de Kyverno n'est annoncée pour l'épreuve (`examen.md`). Les fiches suivent
  `versions.yaml` et signalent chaque champ qui n'existait pas dans le curriculum de 2024.
- L'examen est un QCM sans documentation (`examen.md`) : les flashcards de chaque fiche et le quiz `revision/quiz/`
  sont la préparation directe, les manipulations servent la rétention.
