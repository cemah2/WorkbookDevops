---
chapitre: "fiches/gitops/13-flux-et-flagger.md"
domaine: "gitops"
niveau: "confirmé"
statut: "proposé le 2026-10-02 — en attente de validation (prompts/02), rien n'est rédigé"
duree_estimee: "6 h"
profil_lab: "kubernetes-ha ; chemin de secours kind + Cilium sur linux-base (question Q1)"
versions: "flux, flagger (à créer), gateway_api (à créer), cilium, prometheus, helm, kubernetes, kind, cert_manager"
certifications:
  - "CNPE-02-01"
  - "CNPE-02-03"
  - "CGOA-04-01, CGOA-04-02, CGOA-05-03, CGOA-05-04 (à confirmer par la cartographie CGOA)"
  - "CNPA-01-07, CNPA-03-04, CNPA-03-05 (à confirmer par la cartographie CNPA)"
---

# Plan — 08 Flux et Flagger : GitOps multi-sources et livraison progressive

Chapitre `P3` de `certifs/CNPE/objectifs.md` §4, nœud `gitops/13-flux-et-flagger` de `docs/prerequis.md` §6.5
(numéro 13 à la suite des séries CAPA 01–07 et CGOA 08–12, DECISIONS.md 2026-10-02 « fiches numérotées par série »).
Pourquoi lui en premier : CNPE-02 pèse 25 % de l'examen (le domaine le plus lourd avec CNPE-03), Flux et Flagger
sont deux des quinze projets cités par le programme, et aucun chapitre du workbook ne les touche. Le chapitre
donne aussi le second moteur GitOps que CGOA-05-03 demande de comparer à Argo CD (fiche 01).

Arbitrages hérités (DECISIONS.md, 2026-10-02) : Gateway API Cilium par défaut, `port-forward` sur `kind` ;
Helm 4 ; dépôt bare SSH sur `core-jump01` (`git.lab.home.arpa`) ; installation versionnée depuis `versions.yaml`,
jamais `latest`.

## Objectifs mesurables

À la fin de la fiche tu sais :

- bootstraper Flux (`flux bootstrap git`) sur le dépôt du lab avec les contrôleurs d'image, depuis un cluster vierge,
  et voir `flux check` et `flux get all -A` tout `Ready` en moins de 15 min ;
- nommer sans notes les six contrôleurs de Flux et dire en une phrase quel CRD chacun réconcilie ;
- déclarer une chaîne `GitRepository` → `Kustomization` (infra) → `Kustomization` (apps) avec `dependsOn`, `wait`,
  `healthChecks` et `prune`, puis un `OCIRepository` + `HelmRelease` avec `valuesFrom`, et la voir `Ready` en moins
  de 15 min ;
- mettre en place l'automatisation d'image (`ImageRepository`, `ImagePolicy` semver, marqueur `$imagepolicy`,
  `ImageUpdateAutomation`) et voir Flux committer un nouveau tag dans le dépôt en moins de 10 min ;
- lire et agir sur l'état de Flux : `flux get`, `flux events`, `flux reconcile`, `flux suspend` / `resume`,
  `flux diff kustomization`, `flux trace`, et retrouver pourquoi une `Kustomization` n'applique rien en moins de 5 min ;
- expliquer en trois phrases ce qui distingue Flux d'Argo CD (modèle de ressources, drift, UI, multi-tenancy) ;
- installer Flagger par Flux, convertir un `Deployment` en `Canary` routé par Gateway API Cilium, écrire deux
  `MetricTemplate` Prometheus et voir une version saine promue 10 % → 50 % → 100 % en moins de 15 min ;
- provoquer un rollback automatique sur une version qui renvoie des erreurs, puis réaliser une promotion
  blue/green (`iterations`) et expliquer quand choisir canary, blue/green ou A/B.

## Niveau et prérequis

- Confirmé, nœud `gitops_conf`.
- Obligatoires : `fiches/gitops/09-flux-fondamentaux.md` (CGOA G2, débutant, planifiée : `flux install`, `GitRepository`,
  `Kustomization`, `OCIRepository`, `Bucket`, `flux get` / `reconcile` / `suspend`) — tant qu'elle n'est pas rédigée, la
  section 1 ouvre par un rappel de 20 lignes et la démo 1.2 reste ; `fiches/gitops/01-argo-cd-fondamentaux.md` (réflexes
  GitOps, dépôt du lab, comparaison) ;
  `kubernetes_conf` (Helm 4, Kustomize, Gateway API, RBAC, `kubectl apply --server-side`) ;
  `observabilite_deb` (Prometheus installé ou installable, PromQL `rate` et `histogram_quantile`).
  Aucun chapitre rédigé pour ces deux nœuds au 2026-10-02 : le front matter cite les nœuds, comme les fiches 01 et 02.
- Recommandé : `fiches/gitops/02-argo-workflows-fondamentaux.md` (habitude du CLI et des CRD Argo), fiche CAPA F6
  Argo Rollouts (`gitops/05`) si elle existe, pour la comparaison Flagger / Rollouts ; sinon la comparaison est en lecture.

## Compétences couvertes

| Section | CNPE | CGOA (à confirmer) | CNPA (à confirmer) |
|---|---|---|---|
| 1 Bootstrap et modèle de Flux | CNPE-02-01 | CGOA-05-04 (CGOA-05-03 est porté par `gitops/09`) | CNPA-01-07 |
| 2 Chaîne infra → apps, Helm/OCI, automatisation d'image | CNPE-02-01 | CGOA-04-01, CGOA-05-03 | CNPA-03-04, CNPA-03-05 |
| 3 Flagger : canary, analyse, blue/green | CNPE-02-03 | CGOA-04-02 | CNPA-01-07 |

Hors périmètre, renvoyé ailleurs : fondamentaux Flux et magasins d'état `Bucket`/OCI (CGOA G2, `gitops/09`), architectures
de dépôts et notifications (CGOA `gitops/10` et `12`), Argo Rollouts (CAPA F6, `gitops/05`), Argo CD Helm/Kustomize/ApplicationSet
(CAPA F2, `gitops/04`), GitOps de l'infrastructure Crossplane (CNPE P7 : ici « infrastructure » = la couche d'add-ons du
cluster), Tekton et la chaîne CI amont (CNPE P4, `gitops/09`), notifications Flux vers un chat (lecture, flashcard).

## Sections et exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Lire `flux` dans `versions.yaml`, installer le CLI à la même version, `flux check --pre`, `flux bootstrap git --url=ssh://git@git.lab.home.arpa/... --branch=main --path=clusters/lab --private-key-file=... --components-extra=image-reflector-controller,image-automation-controller` ; lire ce que Flux a commité (`flux-system/gotk-components.yaml`, `gotk-sync.yaml`) | `flux check` OK, `flux get all -A` tout `Ready`, commit visible dans le dépôt |
| 1.2 | 1 | guidé | Les contrôleurs : `source`, `kustomize`, `helm`, `notification`, `image-reflector`, `image-automation` ; schéma Mermaid source → artefact → réconciliation ; lecture d'une `GitRepository` et d'une `Kustomization` (`interval`, `ref`, `path`, `prune`) ; `flux events`, `flux logs` | schéma complété, chaque contrôleur relié à son CRD |
| 1.3 | 1 | autonome | Mettre un `Deployment` sous Flux depuis un second dépôt (`GitRepository` + `Kustomization`), le modifier à la main, observer la correction au prochain `interval`, forcer avec `flux reconcile`, suspendre, réparer, reprendre ; comparer avec `argocd app sync` et `selfHeal` de la fiche 01 en 5 lignes | drift corrigé, tableau Flux / Argo CD rempli |
| 1.4 | 1 | break-fix | `break/gitops/13-flux-source-auth.sh` | `GitRepository` repasse `Ready`, cause expliquée |
| 1.5 | 1 | chronométré | Cluster vierge → Flux bootstrapé avec contrôleurs d'image, première app synchronisée | 15 min |
| 2.1 | 2 | guidé | Chaîne en deux `Kustomization` : `infra` (cert-manager par `HelmRepository` + `HelmRelease`, `ClusterIssuer` CA interne, Gateway API CRDs, `Gateway` partagée) puis `apps` avec `dependsOn`, `wait`, `healthChecks`, `timeout` ; `flux diff kustomization` avant push | `apps` ne démarre qu'après `infra` `Ready`, `flux tree` cohérent |
| 2.2 | 2 | guidé | `OCIRepository` (chart podinfo depuis `oci://ghcr.io/stefanprodan/charts`) + `HelmRelease` : `chartRef`, `valuesFrom` (ConfigMap par environnement), `install.remediation`, `upgrade.remediation.retries`, `test.enable` ; valeurs `dev` / `prod` par overlay Kustomize | deux `HelmRelease` `Ready` avec des valeurs différentes, `helm list -A` (Helm 4) les voit |
| 2.3 | 2 | guidé | Automatisation d'image : `ImageRepository` sur `ghcr.io/stefanprodan/podinfo`, `ImagePolicy` semver `6.x`, marqueur `# {"$imagepolicy": "flux-system:podinfo"}` dans le manifest, `ImageUpdateAutomation` (`git.checkout`, `git.push.branch`, `commit.messageTemplate`), clé de déploiement en écriture | Flux committe un tag, `flux get image all` cohérent |
| 2.4 | 2 | autonome | Reproduire la structure `clusters/<cluster>` → `infra` → `apps` → `overlays/{dev,prod}` du dépôt officiel d'exemple sur le dépôt du lab, y ajouter une `Kustomization` qui livre des `ClusterPolicy` Kyverno **ou** des `CiliumNetworkPolicy` (infrastructure de gouvernance, pas une app), avec `postBuild.substituteFrom` pour les variables d'environnement | `flux tree kustomization apps` montre la hiérarchie, une variable substituée est visible dans le cluster |
| 2.5 | 2 | break-fix | `break/gitops/13-flux-kustomization-stuck.sh` | `Kustomization` repasse `Ready`, aucune ressource orpheline |
| 2.6 | 2 | chronométré | Déployer une app depuis un dépôt vierge via `HelmRelease` + overlay `dev`, puis faire committer un nouveau tag par Flux | 15 min |
| 3.1 | 3 | guidé | Installer Flagger par Flux (`OCIRepository` `oci://ghcr.io/fluxcd/charts/flagger` + `HelmRelease`, `meshProvider: gatewayapi:v1`, `metricsServer` vers le Prometheus du lab) et le load tester (`OCIRepository` `flagger-manifests` + `Kustomization` `./tester`) ; lire les CRD `Canary`, `MetricTemplate`, `AlertProvider` | `flagger` et `flagger-loadtester` `Ready`, `kubectl explain canary.spec` fonctionne |
| 3.2 | 3 | guidé | Convertir podinfo en `Canary` : `targetRef`, `service.port/hosts/gatewayRefs`, `analysis` (`interval`, `threshold`, `maxWeight`, `stepWeight`), deux `MetricTemplate` Prometheus (succès et latence p99 sur les métriques de podinfo), `webhooks` `load-test` ; lire la `HTTPRoute` générée et les Services `-primary` / `-canary` ; promotion d'une version saine suivie avec `kubectl describe canary` et `kubectl get canary -w` | pondérations 10 → 50 → 100 observées dans la `HTTPRoute`, `Promoting` puis `Succeeded` |
| 3.3 | 3 | autonome | Pousser une version qui renvoie 50 % d'erreurs (podinfo `--random-error`) : observer `Failed`, le rollback et `canary.status.failedChecks` ; puis passer la stratégie en blue/green (`iterations`, sans `stepWeight`), avec `mirror: true` si Cilium accepte le filtre `RequestMirror` sinon sans (Q4) ; terminer par un A/B sur en-tête (`match`) | rollback automatique constaté, blue/green promu, A/B routé par en-tête |
| 3.4 | 3 | break-fix | `break/gitops/13-flagger-metric-no-data.sh` | analyse repart, cause expliquée |
| 3.5 | 3 | chronométré | Depuis un `Deployment` existant : `Canary` + `MetricTemplate` + webhook, nouvelle image poussée, promotion complète | 15 min |
| 3.6 | 3 | chronométré « outil inconnu » | Installer Argo Rollouts (ou Flagger si la fiche 05 existe déjà) depuis sa seule documentation et faire une promotion manuelle d'un `Rollout` canary à 2 étapes | 15 min |

Les flashcards (15 à 20) couvrent en plus les notions citées par les examens mais hors manipulation : `Bucket` et
`HelmChart` comme sources, `Receiver` (webhook entrant) et `Alert`/`Provider` du notification-controller, multi-tenancy
Flux (`--tenant`, `kustomization.spec.serviceAccountName`), `Flagger` providers autres que Gateway API (istio, linkerd,
nginx, kubernetes), `AlertProvider`, les quatre stratégies (canary, blue/green, A/B, mirroring).

## Scénarios de panne (`break/gitops/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `13-flux-source-auth.sh` | clé privée du Secret `flux-system` remplacée (même technique que `01-argocd-repo-credentials.sh`) | `GitRepository/flux-system` `Ready: False` (auth), les `Kustomization` restent sur le dernier artefact, aucune nouvelle révision |
| `13-flux-kustomization-stuck.sh` | `Kustomization/apps` patchée avec un `dependsOn` vers une `Kustomization` inexistante, ou `healthChecks` sur un Deployment qui n'existera jamais | `apps` en `DependencyNotReady` ou `HealthCheckFailed`, `flux get kustomizations` l'affiche mais `kubectl get events` est muet |
| `13-flagger-metric-no-data.sh` | `MetricTemplate` dont la requête PromQL vise un label renommé, ou `metricsServer` pointé vers un port fermé | chaque itération d'analyse échoue `no values found`, `Canary` finit `Failed` et revient en arrière alors que l'application est saine |
| `13-flagger-gateway-missing.sh` (optionnel) | `Gateway` référencée supprimée ou `gatewayRefs` renommée | `HTTPRoute` générée sans parent accepté, `Canary` `Initializing` ou `Progressing` sans trafic, load test en erreur 404 |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck, même convention que `01-argocd-*.sh`, `02-argo-workflows-*.sh`
et `08-opengitops-*.sh`.

## Profil de lab et budget

- Chemin principal : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go), Cilium avec `kubeProxyReplacement=true` et
  `gatewayAPI.enabled=true`, pool LoadBalancer `10.10.40.200`–`.219`, hôte `podinfo.apps.lab.home.arpa` et certificat
  cert-manager de la CA interne. Consommation du chapitre : Flux 6 contrôleurs ≈ 0,5 vCPU / 1 Go ; Flagger + load tester
  ≈ 0,2 vCPU / 256 Mo ; Prometheus ≈ 0,5 vCPU / 1 Go ; podinfo ×2 environnements ×(primary + canary) négligeable.
- Chemin de secours si le profil n'est pas levé (Q1) : `kind` sur `linux-base-lx01` (4 vCPU / 8 Go / 60 Go) **avec Cilium
  en remplacement de kube-proxy** (config `kind` `kubeProxyMode: none`, `disableDefaultCNI: true`) et Gateway API ; pas de
  LoadBalancer sur `kind` → le load tester et `curl` depuis un pod visent le Service de la Gateway (ClusterIP), l'UI par
  `port-forward`. C'est plus lourd que le `kind` des fiches 01 et 02 ; la fiche l'écrit comme variante, pas comme chemin principal.
- Dépôt Git : `git.lab.home.arpa` sur `core-jump01`, deux dépôts bare (`fleet` pour le bootstrap, `podinfo-deploy` pour
  l'exercice 1.3) et une clé de déploiement **en écriture** pour l'automatisation d'image.
- Registre : aucun. L'automatisation d'image scrute l'image publique `ghcr.io/stefanprodan/podinfo` ; Harbor n'est placé
  dans aucun profil (Q3).
- Prometheus : instance dédiée au chapitre, déployée **par Flux** dans la `Kustomization` `infra` (Q2).

## Préalables à régler dans la PR du chapitre

- `versions.yaml` : créer `flagger` (dépôt `fluxcd/flagger`, `github-releases`, extractVersion `^v`) ; version lue le
  2026-10-02 par les tags git du dépôt officiel : **1.45.0** (chart Helm à la même version, image `ghcr.io/fluxcd/flagger`).
  Créer `gateway_api` (dépôt `kubernetes-sigs/gateway-api`) : dernier tag **1.6.2**, mais la documentation de Cilium 1.20.2
  (`Documentation/conf.py`) cible **v1.6.1** → `channel: stable`, `version: "1.6.1"`, note « version documentée par
  `cilium` ; monter avec Cilium ». Mettre `verification: direct` (tags git du dépôt officiel) ou `indirect` selon la
  convention retenue pour `argo_workflows`.
- `labs/profiles/kubernetes-ha.yaml` : ajouter `flagger`, `gateway_api`, `cert_manager` à `components` (`flux` y est déjà).
- `certifs/CNPE/objectifs.md` §3 (CNPE-02-01, 02-03) et §4 (P3 → rédigé), `docs/prerequis.md` §6.5 (nœud `rédigé`) :
  portés par la PR #42, à fusionner avant la PR du chapitre.
- Pas d'entrée `DECISIONS.md` nécessaire : Gateway API Cilium et Git du lab sont déjà tranchés. Si Q2 retient
  `kube_prometheus_stack`, la clé entre par cette PR.

## Points de vigilance `versions.yaml`

- **Flux 2.9.6** : CRD `source.toolkit.fluxcd.io/v1`, `kustomize.toolkit.fluxcd.io/v1`, `helm.toolkit.fluxcd.io/v2`,
  `image.toolkit.fluxcd.io/v1` ; beaucoup d'exemples en ligne sont en `v1beta1`/`v1beta2` : la fiche n'écrit que les
  versions servies par 2.9 et le signale. Vérifier dans les notes 2.8 → 2.9 : vérification Cosign des artefacts OCI
  (bundle sigstore depuis 2.8, utilisée par l'installation de Flagger), `OCIRepository` `v1`, `HelmRelease.chartRef`.
  `flux bootstrap git` sur un dépôt bare SSH générique : vérifier que `--private-key-file` et `--silent` suffisent sans
  hôte connu (`known_hosts` généré par le CLI) ; le dépôt doit exister et la clé avoir le droit de pousser.
- **Flagger 1.45.0** : `meshProvider: gatewayapi:v1` exige les CRD Gateway API `v1` (`HTTPRoute` `v1`) ; aucun métrique
  intégré avec ce provider → `MetricTemplate` obligatoires ; `mirror: true` exige le filtre `RequestMirror` côté
  implémentation (Q4). Lire les notes 1.40 → 1.45 pour les champs `analysis` ajoutés ou renommés.
- **Cilium 1.20.2** : Gateway API documentée en v1.6.1 ; prérequis `kubeProxyReplacement=true`, `l7Proxy=true`, `TPROXY`
  par iptables (modules netfilter présents sur Ubuntu 24.04 ; absents sur certaines images minimales → connexions qui
  expirent, à mettre en vigilance) ; sur `kind`, les sept CRD standard (`GatewayClass`, `Gateway`, `HTTPRoute`,
  `GRPCRoute`, `BackendTLSPolicy`, `ReferenceGrant`, `TLSRoute`) sont **obligatoires** avant l'activation.
- **Helm 4.3.0** : le helm-controller de Flux embarque sa propre bibliothèque Helm ; `helm list` local en Helm 4 lit les
  releases créées par Flux (format de stockage `Secret` inchangé) : à vérifier avant d'écrire « Helm 4 les voit ».
- **Kubernetes 1.37.1** : matrice de support de Flux 2.9 (habituellement N-3 mineures) et de Flagger à vérifier ;
  même écart `kind` / clé `kubernetes` que les fiches 01 et 02.
- **podinfo** : image `ghcr.io/stefanprodan/podinfo`, dernier tag `6.15.0` le 2026-10-02 (tags git du dépôt) ; la fiche
  part d'un tag inférieur (`6.14.x`) pour que l'automatisation ait quelque chose à mettre à jour, et cite le tag avec sa
  date, comme la fiche 02 pour `busybox`/`alpine`.
- **Prometheus 3.15.0** : syntaxe PromQL inchangée pour `rate` et `histogram_quantile` ; si Q2 retient la métrique Envoy de
  Cilium, les noms de métriques (`envoy_cluster_upstream_rq_*`) dépendent de `envoy.prometheus.enabled` et du port 9964 :
  à vérifier sur le lab, sinon `[non testé]`.

## `[lecture + simulation]`

- Rien pour cause de matériel.
- Lecture seule avec renvoi : multi-tenancy Flux (`--tenant`, impersonation par `serviceAccountName`) et `Receiver`
  webhook (exigent un second tenant et un serveur Git avec webhooks : GitLab non placé) ; `Alert`/`Provider` vers un chat
  (pas de serveur de messagerie sur le lab : un `Provider` `generic` vers un pod `echo` peut servir de démo, décision à la
  rédaction) ; providers Flagger Istio/Linkerd/nginx (couverts par ICA et la fiche CNPE P12) ; `mirror: true` si Q4 est
  négatif.

## Durée

6 h d'apprentissage, lecture ≤ 20 % (environ 1 h 10), le reste en manipulation :
section 1 ≈ 1 h 30, section 2 ≈ 2 h 15, section 3 ≈ 2 h 15, dont 60 min de défis chronométrés (quatre défis).

## Livrables attendus de la session de rédaction

- `fiches/gitops/13-flux-et-flagger.md` (gabarit `templates/fiche.md`) et `fiches/gitops/13-flux-et-flagger/manifests/`
  (arborescence `clusters/lab`, `infra`, `apps`, overlays, `Canary`, `MetricTemplate`, variante `kind`)
- `solutions/fiches/gitops/13-flux-et-flagger.md` (3 indices puis correction commentée par exercice)
- `break/gitops/13-flux-*.sh` et `13-flagger-*.sh` (3 scripts, 1 optionnel)
- `revision/flashcards/gitops-13-flux-et-flagger.csv` (15 à 20 cartes)
- mises à jour : `versions.yaml` (`flagger`, `gateway_api`), `labs/profiles/kubernetes-ha.yaml`, `certifs/CNPE/objectifs.md`,
  `docs/prerequis.md` §6.5, `docs/plans/README.md`, ce plan avec `statut: validé`

## Questions ouvertes (réponses attendues avant rédaction)

- **Q1 — Lab.** Le profil `kubernetes-ha` est-il levé (ou le sera-t-il avant la rédaction) ? Sinon, la fiche confirmé
  s'écrit-elle avec le chemin de secours `kind` + Cilium sur `linux-base` comme chemin principal, à l'inverse des fiches
  débutant ? Réponse recommandée : `kubernetes-ha` principal, `kind` en variante documentée mais marquée `[non testé]`
  si la session de rédaction n'a pas de cluster.
- **Q2 — Prometheus.** Instance légère déployée par Flux (manifests pinnés sur la clé `prometheus`, 1 h de moins) ou
  `kube-prometheus-stack` par `HelmRelease` (nouvelle clé `kube_prometheus_stack`, réutilisée par P9, plus lourd) ?
  Recommandé : instance légère ici, l'opérateur arrive avec P9.
- **Q3 — Registre.** Automatisation d'image sur l'image publique podinfo (aucun registre à placer) ou sur une image
  construite et poussée par l'apprenant (exige Harbor ou un registre `distribution` sur le cluster, et un chapitre de build
  qui n'existe pas encore : P4 Tekton) ? Recommandé : image publique, Harbor en variante quand il sera placé.
- **Q4 — Blue/green.** Si le filtre `RequestMirror` n'est pas pris en charge par la Gateway API de Cilium 1.20 (non
  documenté dans `Documentation/network/servicemesh/gateway-api/`), le blue/green se fait sans miroir (`iterations` +
  webhooks) et le miroir passe en lecture. Acceptable, ou faut-il basculer la section 3 sur Envoy Gateway (variante
  autorisée par DECISIONS.md) pour garder le miroir en pratique ?
- **Q5 — Métriques d'analyse.** `MetricTemplate` sur les métriques de l'application (podinfo, robuste, mais « triche »
  par rapport à un vrai service non instrumenté) ou sur les métriques Envoy de la Gateway Cilium (réaliste, à valider sur
  le lab) ? Recommandé : application en démo guidée, Envoy en exercice autonome `[non testé]` si pas de lab.
- **Q6 — Défi « outil inconnu ».** Argo Rollouts en 3.6 (fiche 05 pas encore écrite : risque de doublon avec CAPA F6)
  ou un autre projet cité par CNPE et absent du workbook (Linkerd, OpenCost) ? Recommandé : Argo Rollouts, l'exercice
  reste un défi documentation sans solution détaillée, la fiche 05 fera le cours.
