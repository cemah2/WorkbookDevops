---
code: ICA
titre: "ICA — mapping compétences → chapitres"
programme: "certifs/ICA/programme.md (converti le 2026-10-02, curriculum CNCF consulté le 2026-03-14 ; dernier commit du PDF le 2025-08-12)"
chapitres_existants: 0
generated: 2026-10-02
status: "0 chapitre rédigé sur 9 ; à mettre à jour à chaque PR de chapitre"
---

# ICA — objectifs et couverture

Mapping entre les 17 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : aucun chapitre du domaine `plateforme` n'existe (`fiches/plateforme/` ne contient que son
`README.md`), aucune fiche d'un autre domaine ne touche Istio. Les 17 compétences sont donc des trous.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices »
et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| ICA-01 Installation, Upgrades, and Configuration | 20 % | 4 | 5,0 % | 2 fiches |
| ICA-02 Traffic Management | 35 % | 7 | 5,0 % | 3 fiches |
| ICA-03 Securing Workloads | 25 % | 3 | 8,3 % | 2 fiches |
| ICA-04 Troubleshooting | 20 % | 3 | 6,7 % | 1 fiche (+ un break-fix par fiche) |
| Transverse | — | 17 | — | 1 scénario + 1 examen blanc |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle.

Deux particularités de cet examen pèsent sur le plan (détail dans [`examen.md`](examen.md)) :

- il est **pratique** (15 à 20 tâches en 120 min, terminal + documentation `istio.io` autorisée) : chaque fiche
  se termine par un défi chronométré au format de l'examen, et le dépannage (20 %) est entraîné dans **toutes**
  les fiches par un break-fix, pas seulement dans la fiche 13 ;
- depuis le 2025-08-12 le programme couvre le **mode ambient** au même titre que le mode sidecar : chaque fiche
  de trafic et de sécurité traite les deux modes (sidecar d'abord, puis la variante ambient avec waypoint).

Ordre de rédaction recommandé (du plus lourd au plus léger, en respectant les prérequis) :
installation sidecar/ambient → ingress et routage → traffic shifting, résilience, fault injection →
sécurité mTLS/JWT/autorisation → troubleshooting → services externes et egress → TLS en bordure →
personnalisation et mises à jour → scénario de bout en bout → examen blanc.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : la clé `istio` existe (1.31.1, stable). L'environnement d'examen tourne sur Istio 1.29 selon la
  FAQ officielle (`examen.md`, vérification indirecte) : la veille (`prompts/07-veille.md`) ajoute un `exam_note`
  sur la clé `istio`, comme sur la clé `kubernetes`. Les fiches suivent la version stable et signalent dans
  une ligne « différences avec la version d'examen » ce qui change (les API Istio v1 sont stables, l'écart attendu
  porte sur `istioctl` et sur ambient). Ajouter une clé `kiali` (dépôt `kiali/kiali`, datasource `github-releases`)
  pour la fiche 13 ; Prometheus et Grafana existent déjà.
- `labs/profiles/kubernetes-ha.yaml` : la liste `components` ne cite pas `istio` ; l'ajouter (et `kiali`) à la PR
  de la fiche 06.
- **Compatibilité Istio ↔ Cilium** sur `kubernetes-ha` : Cilium est le CNI avec `kubeProxyReplacement`. La page
  « Platform prerequisites » de la documentation Istio impose des réglages Cilium (`cni.exclusive=false`,
  `socketLB.hostNamespaceOnly=true`, désactivation du masquerading BPF pour ambient). À vérifier dans la
  documentation de la version `istio` au moment du plan de la fiche 06 (`prompts/02-plan-chapitre.md`) et à
  reporter dans `labs/profiles/kubernetes-ha.yaml` ; sinon la fiche le marque `[non testé]` avec la raison.
- `DECISIONS.md` : Gateway API est l'ingress de référence, implémentation Cilium par défaut (2026-10-02).
  Istio installe sa propre `GatewayClass` (`istio`) et le mode ambient repose sur Gateway API pour les waypoints.
  Proposition d'ajout daté à soumettre dans la PR de la fiche 07 : « sur les fiches Istio, la `GatewayClass`
  `istio` porte le trafic du mesh ; la Gateway Cilium reste réservée aux UI du lab ; les API Istio
  (`Gateway`, `VirtualService`) sont enseignées parce que l'examen les cite ». Rien n'est rouvert.
- Chemin principal des fiches **débutant** : un cluster `kind` (CNI par défaut) sur une VM du profil `linux-base`,
  comme pour les fiches `gitops` (DECISIONS.md, 2026-10-02) ; `kubernetes-ha` en variante. Les fiches confirmé
  attendent `kubernetes-ha` (ambient multi-nœuds, egress, Gateway Cilium pour les UI).
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.4 (cette PR).
- `break/plateforme/` : créer son `README.md` à la première panne (celle de la fiche Backstage 01 ou de la fiche 06, selon l'ordre des PR).

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. La colonne « chapitre cible » renvoie à la section 4.

### ICA-01 — Installation, Upgrades, and Configuration (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| ICA-01-01 | Installing Istio with istioctl or Helm | 5,0 % | — | — | F1 |
| ICA-01-02 | Installing Istio in Sidecar or Ambient Mode | 5,0 % | — | — | F1 |
| ICA-01-03 | Customizing your Istio Installation | 5,0 % | — | — | F1 (profils, `IstioOperator` de base), F8 (valeurs Helm, overlays, `MeshConfig`) |
| ICA-01-04 | Upgrading Istio (Canary, In-Place) | 5,0 % | — | — | F8 |

### ICA-02 — Traffic Management (35 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| ICA-02-01 | Configuring Ingress and Egress Traffic | 5,0 % | — | — | F2 (ingress), F6 (egress) |
| ICA-02-02 | Configuring Routing within a Service Mesh | 5,0 % | — | — | F2 |
| ICA-02-03 | Defining Traffic Policies with Destination Rules | 5,0 % | — | — | F2 |
| ICA-02-04 | Configuring Traffic Shifting | 5,0 % | — | — | F3 |
| ICA-02-05 | Connecting In-Mesh Workloads to External Workloads and Services | 5,0 % | — | — | F6 |
| ICA-02-06 | Using Resilience Features (circuit breaking, failover, outlier detection, timeouts, retries) | 5,0 % | — | — | F3 |
| ICA-02-07 | Using Fault Injection | 5,0 % | — | — | F3 |

### ICA-03 — Securing Workloads (25 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| ICA-03-01 | Configuring Authorization | 8,3 % | — | — | F4 |
| ICA-03-02 | Configuring Authentication (mTLS, JWT) | 8,3 % | — | — | F4 |
| ICA-03-03 | Securing Edge Traffic with TLS | 8,3 % | — | — | F7 |

### ICA-04 — Troubleshooting (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| ICA-04-01 | Troubleshooting Configuration | 6,7 % | — | — | F5 (+ break-fix de F2, F3, F4) |
| ICA-04-02 | Troubleshooting the Mesh Control Plane | 6,7 % | — | — | F5 (+ break-fix de F1, F8) |
| ICA-04-03 | Troubleshooting the Mesh Data Plane | 6,7 % | — | — | F5 (+ break-fix de F6, F7) |

### Compétences partagées avec d'autres certifications

ICA se passe dans le bloc `reseau_conf` → `plateforme_conf` du parcours Golden Kubestronaut, avec CCA et KCA
(`docs/prerequis.md` §3). Les chapitres ci-dessous citent les autres programmes dans leur front matter pour éviter
un doublon ; les mappings CKA, CKS, CCA et KCSA seront confirmés par leurs propres sessions
`prompts/01-cartographie-certification.md`.

| Chapitre | IDs ICA | IDs d'autres programmes réutilisables |
|---|---|---|
| F1 Installation sidecar / ambient | ICA-01-01, 01-02, 01-03 | KCSA-05-04 (service mesh, concept) |
| F2 Ingress et routage | ICA-02-01, 02-02, 02-03 | CKA-03-04 (Gateway API), CCA-03-01, CCA-03-02, CCA-03-03 (concept) |
| F4 Sécurité mTLS / JWT / autorisation | ICA-03-01, 03-02 | CKS-04-04 (chiffrement pod à pod avec Istio), KCSA-05-04 |
| F7 TLS en bordure | ICA-03-03 | CKA-03-04 (Gateway API, écoute TLS) |

CNPE cite Istio dans sa liste d'outils sans identifiant de compétence : rien à mapper.

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de lecture recommandé (DECISIONS.md, 2026-10-02) ; la série `plateforme`
démarre à `01` avec Backstage (cartographie CBA), les fiches Istio prennent les numéros 06 à 13 ; les étiquettes F1 à F8
donnent l'ordre de rédaction (§1), qui suit les poids. Tous les chapitres ciblent le profil `kubernetes-ha`
(16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`). Tant que `lab up kubernetes-ha` n'existe pas, les
fiches **débutant** ont pour chemin principal un cluster `kind` sur une VM du profil `linux-base` (8 vCPU / 16 Go /
180 Go) et gardent `kubernetes-ha` en variante ; les fiches confirmé attendent le profil complet.
Application de démonstration : `bookinfo` (dépôt `istio/istio`, `samples/`) parce que c'est celle de la documentation
autorisée à l'examen ; `httpbin` et `sleep`/`curl` pour les tests. Les durées sont des estimations d'apprentissage
(lecture ≤ 20 %, le reste en manipulation), pas de rédaction.
Chaque fiche se termine par un **défi au format de l'examen** : 3 à 4 tâches énoncées comme à l'examen, 20 à 30 min,
documentation `istio.io` seule autorisée.

### F1 — `fiches/plateforme/06-istio-installation-sidecar-ambient.md`

- **Titre** : Istio — installer avec istioctl et Helm, mode sidecar et mode ambient
- **Niveau** : débutant (`plateforme_deb`)
- **Couvre** : ICA-01-01, ICA-01-02, ICA-01-03 (profils et `IstioOperator` de base)
- **Prérequis** : `plateforme_deb` suppose `kubernetes_conf` (Deployments, Services, namespaces, labels, RBAC, Helm 4,
  Gateway API) ; aucun chapitre Kubernetes n'est rédigé au 2026-10-02, le front matter cite le nœud.
- **Lab** : `kind` sur `linux-base` (chemin principal, deux nœuds workers pour voir ztunnel par nœud), variante
  `kubernetes-ha` (réglages Cilium, §2). Clés `versions.yaml` : `istio`, `helm`, `kind`, `kubernetes`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Installer Istio avec `istioctl install` (profil `default`, puis `minimal` + ingress gateway séparée), lire les
     composants (`istiod`, gateways, CRD), vérifier avec `istioctl verify-install` et `istioctl version` ;
     désinstaller proprement et réinstaller la même chose avec Helm (`base`, `istiod`, `gateway`) — ICA-01-01.
  2. Mode sidecar : activer l'injection (`istio-injection=enabled`, label `istio.io/rev`), déployer `bookinfo`,
     observer le conteneur `istio-proxy` et l'init container ; puis mode ambient (`istioctl install --set profile=ambient`) :
     label `istio.io/dataplane-mode=ambient`, ztunnel par nœud, déployer un waypoint (`istioctl waypoint apply`),
     comparer ce que voit chaque mode avec `istioctl ztunnel-config workloads` et `istioctl proxy-status` — ICA-01-02.
  3. Personnaliser : fichier `IstioOperator` (profil, `components`, `meshConfig.accessLogFile`, `values`),
     `istioctl manifest generate` pour lire le rendu, différence entre `--set` et un fichier, même chose avec
     `values.yaml` Helm ; régler les ressources de `istiod` et de la gateway pour le budget du lab — ICA-01-03.
- **Break-fix** : `break/plateforme/06-istio-injection-absente.sh` (namespace sans label ou label de révision
  erroné : pods sans sidecar, `istioctl analyze` le signale) — ICA-04-01.
- **Défi au format de l'examen** : installer Istio en mode ambient, enrôler un namespace, déployer un waypoint et prouver
  que le trafic passe par ztunnel, en moins de 20 min.

### F2 — `fiches/plateforme/07-istio-ingress-et-routage.md`

- **Titre** : Istio — gateway d'entrée, VirtualService et DestinationRule
- **Niveau** : débutant (`plateforme_deb`)
- **Couvre** : ICA-02-01 (ingress), ICA-02-02, ICA-02-03
- **Prérequis** : F1
- **Lab** : `kind` sur `linux-base` (chemin principal, gateway exposée par `port-forward` ou `metallb`), variante
  `kubernetes-ha` (`GatewayClass` `istio`, adresse du pool `loadbalancer_pool`). Clés `versions.yaml` : `istio`, `kind`, `metallb`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Exposer `bookinfo` : API Istio (`Gateway` + `VirtualService` liés par `hosts`/`gateways`) puis Kubernetes Gateway
     API (`Gateway` de classe `istio` + `HTTPRoute`) ; comparer les deux objets rendus par `istioctl proxy-config
     listeners/routes` sur le pod gateway — ICA-02-01, CKA-03-04.
  2. Router dans le mesh : `VirtualService` avec `match` (`uri`, `headers`, `queryParams`), `rewrite`, `redirect`,
     `route` vers plusieurs `destination`, `hosts` courts vs FQDN, priorité des règles ; en ambient, attacher un
     waypoint au namespace puis au service (`istio.io/use-waypoint`) et vérifier que le routage L7 s'applique — ICA-02-02.
  3. `DestinationRule` : `subsets` par label de version, `trafficPolicy` (`loadBalancer` `ROUND_ROBIN`, `LEAST_REQUEST`,
     `consistentHash` sur en-tête), `connectionPool`, `tls.mode` ; portée `exportTo` ; conflit entre deux
     `DestinationRule` sur le même hôte et comment `istioctl analyze` le signale — ICA-02-03.
- **Break-fix** : `break/plateforme/07-istio-virtualservice-subset-inconnu.sh` (subset référencé sans
  `DestinationRule` : 503 `NR`/`UH` dans les access logs) — ICA-04-01.
- **Défi au format de l'examen** : exposer un service sur l'hôte `app.lab.home.arpa` avec routage par en-tête vers
  deux versions, en moins de 20 min.

### F3 — `fiches/plateforme/08-istio-traffic-shifting-resilience-fault-injection.md`

- **Titre** : Istio — bascule de trafic, résilience et injection de pannes
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : ICA-02-04, ICA-02-06, ICA-02-07
- **Prérequis** : F2, `kubernetes_conf`
- **Lab** : `kubernetes-ha` (plusieurs réplicas par version ; charge générée avec `fortio` du dépôt `samples/` d'Istio,
  sans clé `versions.yaml` propre). Clés `versions.yaml` : `istio`, `prometheus`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Traffic shifting : `weight` 90/10 → 50/50 → 0/100 entre subsets, mirroring (`mirror`, `mirrorPercentage`),
     bascule par en-tête pour un canary d'utilisateur ; mesurer la répartition avec 100 requêtes `curl` et dans
     Prometheus (`istio_requests_total` par `destination_version`) ; en ambient, même exercice via `HTTPRoute`
     `backendRefs` pondérés sur le waypoint — ICA-02-04.
  2. Résilience : `timeout` et `retries` (`attempts`, `perTryTimeout`, `retryOn`) dans le `VirtualService` ;
     `outlierDetection` (`consecutive5xxErrors`, `interval`, `baseEjectionTime`) et `connectionPool` dans la
     `DestinationRule` pour un circuit breaker, observation des `UO`/`URX` dans les access logs ; `localityLbSetting`
     avec `failover` entre deux zones simulées par labels de nœuds — ICA-02-06.
  3. Fault injection : `fault.delay` (`fixedDelay`, `percentage`) et `fault.abort` (`httpStatus`) ciblés par en-tête ;
     combiner avec un `timeout` pour reproduire le cas d'école `bookinfo` (`ratings` lent → `reviews` en erreur) ;
     retirer la panne et prouver le retour à la normale — ICA-02-07.
- **Break-fix** : `break/plateforme/08-istio-retries-amplification.sh` (`retries` sans `retryOn` adapté + `timeout`
  trop court : latence multipliée, à lire dans les access logs) — ICA-04-01.
- **Défi au format de l'examen** : canary 20 % avec timeout 2 s, 3 retries et éjection après 3 erreurs 5xx, en moins de 20 min.

### F4 — `fiches/plateforme/10-istio-securite-mtls-jwt-autorisation.md`

- **Titre** : Istio — mTLS, authentification JWT et AuthorizationPolicy
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : ICA-03-01, ICA-03-02
- **Prérequis** : F2 ; `securite_deb` recommandé (TLS, certificats, notions de JWT) ; `services_deb` recommandé si
  l'IdP du lab (Keycloak, clé `keycloak`) sert d'émetteur JWT, sinon le jeton de démonstration de la documentation Istio.
- **Lab** : `kubernetes-ha`. Clés `versions.yaml` : `istio`, `keycloak` (variante).
- **Temps** : 7 h
- **3 exercices clés** :
  1. mTLS : lire le mode par défaut (`PERMISSIVE`), passer en `STRICT` au niveau mesh, namespace, puis charge de travail
     (`PeerAuthentication` avec `selector` et `portLevelMtls`) ; prouver le chiffrement avec `istioctl proxy-config
     secret`, `istioctl x describe pod`, un `curl` depuis un pod hors mesh qui échoue ; en ambient, vérifier le
     tunnel HBONE de ztunnel avec `istioctl ztunnel-config` — ICA-03-02, CKS-04-04.
  2. JWT : `RequestAuthentication` (`issuer`, `jwksUri` ou `jwks` inline, `forwardOriginalToken`, `outputClaimToHeaders`) ;
     tester jeton valide, invalide, absent ; comprendre pourquoi l'absence de jeton passe sans `AuthorizationPolicy`
     et fermer avec `requestPrincipals` — ICA-03-02, ICA-03-01.
  3. Autorisation : `AuthorizationPolicy` `ALLOW`, `DENY`, `CUSTOM`, `AUDIT` ; ordre d'évaluation ; `from.source.principals`
     (identité SPIFFE), `namespaces`, `to.operation` (`methods`, `paths`, `hosts`), `when` (`request.auth.claims`) ;
     politique par défaut « tout refuser » dans un namespace puis ouverture minimale ; en ambient, politique L4 appliquée
     par ztunnel vs L7 par le waypoint, et ce qui se passe quand on utilise un champ L7 sans waypoint — ICA-03-01.
- **Break-fix** : `break/plateforme/10-istio-mtls-strict-client-hors-mesh.sh` (`STRICT` global, un client sans sidecar :
  connexion refusée, diagnostic par `istioctl x describe` et `proxy-config`) — ICA-04-03.
- **Défi au format de l'examen** : mTLS `STRICT` sur un namespace, JWT obligatoire sur `/api`, `GET` seul autorisé
  depuis un `ServiceAccount` donné, en moins de 25 min.

### F5 — `fiches/plateforme/13-istio-troubleshooting.md`

- **Titre** : Istio — diagnostiquer la configuration, le plan de contrôle et le plan de données
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : ICA-04-01, ICA-04-02, ICA-04-03
- **Prérequis** : F1 à F4 et F6 à F8 (le break-fix aléatoire tire dans toutes les fiches) ; `observabilite_deb` recommandé
  (Prometheus, PromQL de base).
- **Lab** : `kubernetes-ha` avec Prometheus, Grafana et Kiali. Clés `versions.yaml` : `istio`, `prometheus`, `grafana`,
  `kiali` (à créer).
- **Temps** : 7 h
- **3 exercices clés** :
  1. Configuration : `istioctl analyze` (messages, sévérités, `--all-namespaces`), `istioctl validate`, `istioctl x describe
     pod`, `istioctl proxy-config` (`cluster`, `listener`, `route`, `endpoint`, `secret`, `log`) ; lire un `VirtualService`
     qui ne s'applique pas (hôte, gateway, namespace, ordre) et un `DestinationRule` en conflit — ICA-04-01.
  2. Plan de contrôle : `istioctl proxy-status` (`SYNCED`, `STALE`, `NOT SENT`), logs et niveau de log de `istiod`
     (`istioctl admin log`), métriques `pilot_xds_pushes`, `pilot_proxy_convergence_time`, dashboard Grafana du control
     plane ; pannes : `istiod` indisponible, webhook d'injection cassé, certificats racine expirés — ICA-04-02.
  3. Plan de données : access logs Envoy et codes `response_flags` (`UH`, `NR`, `UF`, `UO`, `URX`, `DC`), `istioctl
     proxy-config log --level debug`, `/stats` et `/clusters` du sidecar, `istioctl ztunnel-config` (`workloads`, `services`,
     `policies`, `certificates`) et logs ztunnel/waypoint en ambient, graphe Kiali pour localiser l'arête rouge — ICA-04-03.
- **Break-fix** : `break/plateforme/13-istio-random.sh` (tire au sort une des pannes de F1 à F4 et F6 à F8, sans dire
  laquelle) ; `break/plateforme/13-istiod-webhook-casse.sh` ; `break/plateforme/13-istio-ztunnel-arrete.sh` — ICA-04-01 à 04-03.
- **Défi au format de l'examen** : trois pannes injectées à l'aveugle, diagnostic écrit et correction en moins de 30 min.

### F6 — `fiches/plateforme/09-istio-services-externes-et-egress.md`

- **Titre** : Istio — ServiceEntry, egress gateway et charges de travail hors cluster
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : ICA-02-05, ICA-02-01 (egress)
- **Prérequis** : F2, `kubernetes_conf` ; `reseau_conf` implicite par `plateforme_deb` (DNS, routage, pare-feu OPNsense).
- **Lab** : `kubernetes-ha` + une VM du profil `linux-base` (service « externe » sur le VLAN 10, et charge de travail
  hors cluster pour `WorkloadEntry`). Clés `versions.yaml` : `istio`, `opnsense` (règle de sortie pour prouver le
  passage par la gateway), `bind9` si le DNS interne est utilisé.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Contrôler la sortie : `meshConfig.outboundTrafficPolicy` `ALLOW_ANY` → `REGISTRY_ONLY`, observer le `502`/`BlackHoleCluster`,
     déclarer un `ServiceEntry` (`hosts`, `ports`, `resolution` `DNS`/`STATIC`/`NONE`, `location MESH_EXTERNAL`),
     appliquer `timeout` et `retries` à un service externe via `VirtualService` — ICA-02-05.
  2. Egress gateway : déployer la gateway de sortie, `Gateway` + `VirtualService` + `DestinationRule` pour forcer un
     hôte HTTP puis HTTPS (origination TLS sur la gateway), prouver le chemin avec les access logs de la gateway et une
     règle OPNsense n'autorisant que son adresse — ICA-02-01.
  3. Charges de travail hors cluster : `WorkloadGroup` + `WorkloadEntry` pour la VM (`istioctl x workload entry configure`,
     agent Istio sur la VM) ou, en version courte, `ServiceEntry` + `WorkloadEntry` statiques vers la VM ; appeler la VM
     depuis le mesh en mTLS ; marquer `[lecture + simulation]` la partie multi-réseau — ICA-02-05.
- **Break-fix** : `break/plateforme/09-istio-registry-only-sans-serviceentry.sh` (sortie bloquée après passage en
  `REGISTRY_ONLY`, `BlackHoleCluster` dans les logs) — ICA-04-01.
- **Défi au format de l'examen** : mesh en `REGISTRY_ONLY`, un seul hôte externe autorisé, via la egress gateway, en moins de 20 min.

### F7 — `fiches/plateforme/11-istio-tls-en-bordure.md`

- **Titre** : Istio — TLS, mTLS et passthrough sur la gateway d'entrée
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : ICA-03-03
- **Prérequis** : F2, F4 ; `services_deb` recommandé (CA interne du lab, cert-manager, clé `cert_manager`, `step_ca`).
- **Lab** : `kubernetes-ha` (CA interne du socle `core`, cert-manager). Clés `versions.yaml` : `istio`, `cert_manager`, `step_ca`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Terminaison TLS `SIMPLE` : secret TLS dans le namespace de la gateway, `Gateway` avec `tls.mode: SIMPLE` et
     `credentialName`, même chose en Gateway API (`listeners[].tls.certificateRefs`) ; certificat émis par cert-manager
     depuis la CA interne ; rotation du secret et vérification sans redémarrage (SDS) — ICA-03-03.
  2. mTLS en bordure (`tls.mode: MUTUAL`, certificat client), redirection HTTP → HTTPS (`httpsRedirect`), plusieurs hôtes
     sur un même port (SNI), `PASSTHROUGH` vers un service qui termine lui-même TLS — ICA-03-03.
  3. Diagnostiquer : `istioctl proxy-config secret` sur la gateway, `openssl s_client -servername`, erreurs classiques
     (secret dans le mauvais namespace, `credentialName` erroné, chaîne incomplète) — ICA-03-03, ICA-04-03.
- **Break-fix** : `break/plateforme/11-istio-gateway-secret-mauvais-namespace.sh` (secret TLS créé hors `istio-system`
  ou hors du namespace de la gateway : handshake refusé) — ICA-04-03.
- **Défi au format de l'examen** : exposer deux hôtes en HTTPS sur la même gateway avec redirection HTTP, en moins de 15 min.

### F8 — `fiches/plateforme/12-istio-personnalisation-et-mises-a-jour.md`

- **Titre** : Istio — personnaliser l'installation, mettre à jour en canary et en place
- **Niveau** : confirmé (`plateforme_conf`)
- **Couvre** : ICA-01-03 (avancé), ICA-01-04
- **Prérequis** : F1, F2 ; `gitops_deb` recommandé (les valeurs Helm vivent dans Git)
- **Lab** : `kubernetes-ha` (deux versions mineures d'Istio nécessaires : la version `istio` et la précédente de
  `supported_lines`, à ajouter sur la clé par la veille). Clés `versions.yaml` : `istio`, `helm`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Personnalisation avancée : `MeshConfig` (`accessLogFormat`, `defaultConfig.tracing`, `outboundTrafficPolicy`),
     overlays `k8s` dans `IstioOperator` (`hpaSpec`, `nodeSelector`, `tolerations`), annotations de pod
     (`sidecar.istio.io/inject`, `proxyCPU`, `traffic.sidecar.istio.io/excludeOutboundPorts`), objet `Sidecar` pour
     limiter la portée de la configuration poussée — ICA-01-03.
  2. Mise à jour canary : installer une révision (`istioctl install --revision`), `istioctl tag set` (`default`, `stable`),
     migrer namespace par namespace (`istio.io/rev`), redémarrer les charges de travail, `istioctl proxy-status` pour voir
     les deux plans de contrôle, retirer l'ancienne révision ; même séquence avec Helm (`istiod-<rev>`) — ICA-01-04.
  3. Mise à jour en place (`istioctl upgrade`, `helm upgrade`), pré-vérifications (`istioctl x precheck`), mise à jour
     des gateways et de ztunnel/waypoints en ambient, retour arrière ; lire les notes de version et la politique de
     support (n-1) dans la documentation — ICA-01-04.
- **Break-fix** : `break/plateforme/12-istio-revision-orpheline.sh` (namespace étiqueté sur une révision supprimée :
  injection en échec, `istioctl analyze` et logs du webhook) — ICA-04-02.
- **Défi au format de l'examen** : passer un namespace de la révision `1-x` à `1-y` sans interruption mesurable
  (`fortio` en continu), en moins de 20 min.

### S1 — `scenarios/NN-service-mesh-bout-en-bout/README.md`

- **Titre** : NN — Mettre une application sous mesh : de l'entrée TLS au canary analysé (numéro `NN` attribué à la création)
- **Niveau** : expert (`plateforme_exp`) ; prérequis F1 à F8 complets, pas de saut direct
- **Couvre** : les 17 compétences ICA en situation ; CKS-04-04, CKA-03-04 ; lien avec CAPA-03-02 si Argo Rollouts
  (`gitops/05-argo-rollouts`, planifié) sert de moteur de canary avec le plugin de routage Istio.
- **Lab** : `kubernetes-ha` + une VM `linux-base` (service externe), Prometheus, Grafana, Kiali, cert-manager, Keycloak.
  Clés `versions.yaml` : `istio`, `kiali`, `prometheus`, `grafana`, `cert_manager`, `keycloak`, `argo_cd`, `argo_rollouts` (si disponible).
- **Temps** : 8 h en deux séances
- **Livrable** : runbook « mettre un service sous mesh » + postmortem d'une panne de plan de contrôle
- **3 exercices clés** :
  1. Migrer une application de trois services hors mesh vers le mesh sans coupure : mode ambient pour deux services,
     sidecar pour le troisième, mTLS `PERMISSIVE` → `STRICT`, autorisation minimale, entrée TLS depuis la CA interne.
  2. Publier une version en canary 10 → 50 → 100 % avec timeouts, retries et outlier detection, décision sur les métriques
     Istio dans Prometheus (manuellement, ou par Argo Rollouts si la fiche `gitops/05` existe).
  3. Break-fix transverse : `istiod` indisponible pendant un déploiement, sortie bloquée par `REGISTRY_ONLY`, certificat
     de gateway expiré ; diagnostiquer de bout en bout en moins de 30 min et rédiger le postmortem.

### E1 — `exams/ica-01/`

- **Titre** : Examen blanc ICA — 16 tâches en 120 min sur `kubernetes-ha`
- **Niveau** : confirmé (`plateforme_conf`), à faire après F1 à F8, avant S1 ou après
- **Couvre** : les 17 compétences, pondérées comme le programme (3 tâches ICA-01, 6 ICA-02, 4 ICA-03, 3 ICA-04)
- **Lab** : `kubernetes-ha` ; `setup.sh` déploie les namespaces et pannes, `grade.sh` note sur 100 avec seuil à 68 %
  (seuil officiel, `examen.md`). Produit par `prompts/06-examen-blanc.md`.
- **Temps** : 2 h d'épreuve + 2 h de correction
- **Règles** : documentation `istio.io` et `kubernetes.io` seules autorisées, un seul terminal, `k` et `istioctl` avec
  complétion, comme à l'examen.

## 5. Récapitulatif des estimations

| Chapitre | Fichier | Niveau | Profil de lab | Temps |
|---|---|---|---|---|
| F1 Installation sidecar / ambient | `fiches/plateforme/06-…` | débutant | linux-base (kind) ou kubernetes-ha | 6 h |
| F2 Ingress et routage | `fiches/plateforme/07-…` | débutant | linux-base (kind) ou kubernetes-ha | 6 h |
| F3 Traffic shifting, résilience, fault injection | `fiches/plateforme/08-…` | confirmé | kubernetes-ha | 6 h |
| F4 Sécurité mTLS / JWT / autorisation | `fiches/plateforme/10-…` | confirmé | kubernetes-ha | 7 h |
| F5 Troubleshooting | `fiches/plateforme/13-…` | confirmé | kubernetes-ha | 7 h |
| F6 Services externes et egress | `fiches/plateforme/09-…` | confirmé | kubernetes-ha + linux-base | 4 h |
| F7 TLS en bordure | `fiches/plateforme/11-…` | confirmé | kubernetes-ha | 4 h |
| F8 Personnalisation et mises à jour | `fiches/plateforme/12-…` | confirmé | kubernetes-ha | 5 h |
| S1 Service mesh bout en bout | `scenarios/NN-…` | expert | kubernetes-ha + linux-base | 8 h |
| E1 Examen blanc | `exams/ica-01/` | confirmé | kubernetes-ha | 4 h |
| Révision (flashcards, quiz, second passage de l'examen blanc) | — | — | — | 6 h |
| **Total** | | | | **63 h** |

À 5 h par semaine, compter 12 à 13 semaines : deux cycles de `docs/roadmap.md` §7, cohérent avec le bloc
`reseau_conf` → `plateforme_conf` partagé avec CCA et KCA (ICA est le plus lourd des trois parce qu'il est pratique).

## 6. Ce que le lab ne couvre pas

- **Multi-cluster et multi-réseau** (gateways est-ouest, `meshID`/`network`) : hors programme ICA ; au plus
  `[lecture + simulation]` dans F6 pour situer `WorkloadEntry` multi-réseau.
- **Ambient avec Cilium** : dépend des réglages de §2 ; si la combinaison n'est pas validée, la variante ambient de
  chaque fiche se joue sur `kind` (CNI par défaut) et `kubernetes-ha` garde le mode sidecar. À trancher au plan de F1.
- **Istio managé** (Anthos, AKS add-on, Solo Gloo) : hors lab et hors programme.
- **Version d'examen** : Istio 1.29 à l'examen contre 1.31.1 au lab (`versions.yaml`). Les API utilisées par le
  programme sont `v1` et stables ; chaque fiche signale les commandes `istioctl` ou champs ambient qui différeraient,
  après vérification à la veille.
- **L'examen est pratique avec la documentation `istio.io` ouverte** (`examen.md`) : les flashcards servent à ne pas
  chercher ce qui coûte du temps (noms de CRD, champs, codes `response_flags`), les défis chronométrés et l'examen
  blanc `exams/ica-01/` sont la préparation directe.
