---
chapitre: "fiches/plateforme/06-istio-installation-sidecar-ambient.md"
domaine: "plateforme"
niveau: "débutant"
statut: "validé le 2026-10-02 — arbitrages retenus en fin de plan, rédaction à démarrer après fusion de la PR #40"
duree_estimee: "6 h"
profil_lab: "linux-base (kind sur une VM) ; variante kubernetes-ha"
versions: "istio, helm, kind, kubernetes"
certifications:
  - "ICA-01-01"
  - "ICA-01-02"
  - "ICA-01-03"
  - "KCSA-05-04 (à confirmer par la cartographie KCSA)"
---

# Plan — 06 Istio : installer avec istioctl et Helm, mode sidecar et mode ambient

Chapitre `F1` de `certifs/ICA/objectifs.md` §4, nœud `plateforme/06-istio-installation-sidecar-ambient` de
`docs/prerequis.md` §6.4 (cartographie ICA, PR #40). Première fiche Istio du domaine `plateforme` : les numéros 01 à 05
sont pris par Backstage (cartographie CBA, fusionnée le 2026-10-02) et aucun n'est rédigé, le modèle de structure est
donc `fiches/gitops/01-argo-cd-fondamentaux.md`.
Pourquoi lui d'abord : les sept autres fiches ICA en dépendent, il porte trois des quatre compétences du domaine
ICA-01 (15 % de l'examen), et c'est l'une des deux seules fiches débutant du plan.

Arbitrages hérités (DECISIONS.md, 2026-10-02) : chemin principal `kind` sur `linux-base` pour une fiche débutant,
`kubernetes-ha` en variante ; installation depuis une version épinglée de `versions.yaml`, jamais `latest` ; Helm 4 ;
Gateway API Cilium pour exposer les UI du lab, `port-forward` sur `kind`.

## Objectifs mesurables

- Installer Istio en mode sidecar avec `istioctl install` (profil `default`) depuis la version `istio` de `versions.yaml`,
  et prouver l'installation avec `istioctl verify-install`, en moins de 15 min.
- Désinstaller proprement (`istioctl uninstall --purge`, namespace supprimé) puis réinstaller l'équivalent avec les charts
  Helm `base`, `istiod`, `gateway`, en moins de 20 min.
- Enrôler un namespace dans le mesh en mode sidecar (label `istio-injection=enabled`) et prouver la présence du conteneur
  `istio-proxy` et de l'init container, en moins de 5 min.
- Installer le profil `ambient`, enrôler un namespace (`istio.io/dataplane-mode=ambient`), déployer un waypoint et prouver
  qu'un pod est capturé par ztunnel (`istioctl ztunnel-config workloads`), en moins de 20 min.
- Expliquer sans notes, en trois phrases, la différence sidecar / ambient (ztunnel L4 par nœud, waypoint L7 par namespace
  ou service) et ce que chaque mode coûte en ressources.
- Écrire un `IstioOperator` qui change le profil, active les access logs et borne les ressources d'`istiod`, lire le rendu
  avec `istioctl manifest generate`, et obtenir le même résultat avec un `values.yaml` Helm, en moins de 20 min.
- Diagnostiquer un namespace dont les pods ne reçoivent pas de sidecar (`istioctl analyze`, message `IST0102`, label de
  révision erroné) en moins de 10 min.

## Niveau et prérequis

- Débutant, nœud `plateforme_deb` (`docs/prerequis.md` §6.4).
- Prérequis : nœud `kubernetes_conf` (Deployments, Services, namespaces et labels, RBAC, Helm 4, notions Gateway API) et
  `gitops_deb` par héritage du graphe (non utilisé dans cette fiche). Aucun chapitre Kubernetes n'existe au 2026-10-02 :
  le front matter cite les nœuds, pas des fichiers.
- Infrastructure : une VM Ubuntu du profil `linux-base` avec Docker et `kind` (celle des fiches `gitops`, 4 vCPU / 8 Go /
  60 Go) ; en variante, `kubernetes-ha` avec Cilium, sous réserve des réglages Cilium ci-dessous.

## Compétences couvertes

| Section | ICA | Autres (à confirmer) |
|---|---|---|
| 1 Installer avec istioctl, lire les composants, désinstaller | ICA-01-01, ICA-01-03 (profils) | KCSA-05-04 (concept de mesh) |
| 2 Installer avec Helm, mode sidecar et injection | ICA-01-01, ICA-01-02 | — |
| 3 Mode ambient : ztunnel, waypoint | ICA-01-02 | — |
| 4 Personnaliser : `IstioOperator`, `--set`, `values.yaml`, `manifest generate` | ICA-01-03 | — |

Hors périmètre, renvoyé aux fiches suivantes : révisions et mises à jour canary/in-place (12), `MeshConfig` avancé et
objet `Sidecar` (12), gateways d'entrée au-delà de l'installation (07), toute règle de trafic ou de sécurité (07 à 11),
`istioctl proxy-config` en détail (13). Trois à cinq flashcards les nomment car l'examen les cite.

## Sections et exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Lire `istio` dans `versions.yaml`, télécharger l'archive de la release (binaire `istioctl` + `samples/`), `istioctl version`, `istioctl x precheck`, `istioctl install --set profile=default -y`, `istioctl verify-install` | `istiod` et `istio-ingressgateway` `Running`, `verify-install` sans erreur |
| 1.2 | 1 | guidé | Lire les composants : `istiod` (discovery, CA, webhooks), CRD `networking`/`security`/`telemetry`, `istio-ingressgateway`, `istioctl profile list` / `profile dump default` / `profile diff default minimal` ; schéma Mermaid du plan de contrôle et du plan de données | schéma complété par l'apprenant |
| 1.3 | 1 | autonome | Réinstaller en profil `minimal` + une gateway d'entrée installée séparément (`istioctl install -f` avec un composant `ingressGateways` nommé), puis expliquer ce que `demo` ajoute et pourquoi on ne l'utilise pas sur un lab réaliste | `istio-ingressgateway` absent après `minimal`, présent après l'ajout, `istioctl uninstall --purge` laisse zéro CRD |
| 1.4 | 1 | break-fix | `break/plateforme/11-istio-crd-partielles.sh` | `istiod` repart `Running`, `verify-install` propre |
| 1.5 | 1 | chronométré | Depuis un cluster vierge : Istio profil `default` installé et vérifié, `bookinfo` déployé hors mesh | 15 min |
| 2.1 | 2 | guidé | Désinstaller istioctl, `helm repo add istio` épinglé sur la version `istio`, `helm install istio-base` (`--set defaultRevision=default`), `istiod`, `gateway` dans `istio-ingress` ; `helm ls -A`, `helm get values` ; comparer avec `istioctl manifest generate` ce que Helm a rendu | trois releases `deployed`, `istioctl version` identique |
| 2.2 | 2 | guidé | Mode sidecar : `kubectl label ns bookinfo istio-injection=enabled`, déployer `bookinfo`, lire `istio-proxy` et `istio-init` (`kubectl get pod -o jsonpath`), `istioctl proxy-status`, `sidecar.istio.io/inject=false` sur un pod, règles de précédence des labels | tous les pods à 2/2 sauf celui exclu |
| 2.3 | 2 | autonome | Enrôler un namespace par label de révision (`istio.io/rev=default`) plutôt que `istio-injection`, redémarrer les Deployments, expliquer la précédence si les deux labels coexistent | pods injectés, `istioctl proxy-status` les liste |
| 2.4 | 2 | break-fix | `break/plateforme/11-istio-injection-absente.sh` | pods de nouveau 2/2, cause nommée (`IST0102` ou révision inconnue) |
| 2.5 | 2 | chronométré | Depuis un cluster vierge : installation Helm `base` + `istiod`, namespace enrôlé, `httpbin` injecté et joignable depuis `curl` | 15 min |
| 3.1 | 3 | guidé | `istioctl uninstall --purge`, `istioctl install --set profile=ambient`, lire `istio-cni-node` et `ztunnel` (DaemonSets), `kubectl label ns bookinfo istio.io/dataplane-mode=ambient`, pods restent 1/1, `istioctl ztunnel-config workloads` montre `HBONE` | charge capturée sans redémarrage des pods |
| 3.2 | 3 | guidé | Waypoint : `istioctl waypoint apply -n bookinfo --enroll-namespace`, lire la `Gateway` de classe `istio-waypoint` et le pod créé, `istio.io/waypoint-for` (`service`, `workload`, `all`), `istio.io/use-waypoint` sur un seul service, `istioctl waypoint list` | requêtes vers ce service passent par le waypoint (access log du waypoint) |
| 3.3 | 3 | autonome | Même cluster, deux namespaces : l'un en sidecar, l'autre en ambient ; un `curl` de l'un vers l'autre réussit ; relever pour chaque mode le nombre de pods, la RAM consommée (`kubectl top`) et ce que `istioctl proxy-status` liste | tableau comparatif rempli par mesure, pas récité |
| 3.4 | 3 | break-fix | `break/plateforme/11-istio-ztunnel-absent.sh` | charges de nouveau capturées, cause expliquée |
| 3.5 | 3 | chronométré | Depuis un cluster vierge : profil `ambient`, namespace enrôlé, waypoint déployé, preuve de capture par ztunnel | 20 min |
| 4.1 | 4 | guidé | `IstioOperator` : `spec.profile`, `components.ingressGateways`, `meshConfig.accessLogFile: /dev/stdout`, `values.pilot.resources`, `k8s.resources` ; `istioctl install -f` puis `istioctl manifest generate -f` et `diff` entre deux fichiers ; équivalent `--set` ; `istioctl profile diff` | access logs visibles dans `istio-proxy`, limites d'`istiod` posées |
| 4.2 | 4 | autonome | Reproduire la même personnalisation avec Helm (`values.yaml` de `istiod` et de `gateway`), `helm upgrade`, vérifier avec `helm get values` et `kubectl get deploy istiod -o yaml` ; dire quel champ `IstioOperator` correspond à quelle valeur Helm | deux installations rendues identiques sur les champs choisis |
| 4.3 | 4 | break-fix | `break/plateforme/11-istio-istiod-ressources.sh` | `istiod` repart, `proxy-status` `SYNCED` |
| 4.4 | 4 | chronométré | Installer Istio depuis un `IstioOperator` fourni à compléter (profil, access logs, gateway nommée, ressources), vérifier, exposer `bookinfo` sur la gateway avec le manifeste `bookinfo-gateway.yaml` des `samples/` | 20 min |

Les flashcards (15 à 20) couvrent en plus : noms des charts Helm et leur ordre, composants par profil, labels d'injection
et leur précédence, `istio.io/dataplane-mode`, `istio.io/use-waypoint`, `istio.io/waypoint-for`, commandes
`istioctl` de vérification, et les notions hors manipulation citées par l'examen (révisions, `istioctl tag`, `MeshConfig`,
objet `Sidecar`, compatibilité CNI/ztunnel à ±1 mineure).

## Scénarios de panne (`break/plateforme/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `06-istio-crd-partielles.sh` | suppression d'une CRD `networking.istio.io` (ex. `destinationrules`) | `istiod` en `CrashLoopBackOff` ou logs d'erreur « no matches for kind », `verify-install` échoue |
| `06-istio-injection-absente.sh` | label `istio-injection` retiré, ou remplacé par `istio.io/rev=1-99-0` inexistant ; redémarrage des Deployments | pods à 1/1, `istioctl analyze` sort `IST0102` ou un avertissement de révision, `proxy-status` vide |
| `06-istio-ztunnel-absent.sh` | DaemonSet `ztunnel` à `nodeSelector` impossible | `ztunnel-config workloads` vide, trafic ambient passe en clair ou échoue (selon `PeerAuthentication`), pods toujours 1/1 |
| `06-istio-istiod-ressources.sh` | `istiod` patché avec `limits.memory` trop bas | `OOMKilled`, `proxy-status` `STALE`, sidecars continuent de servir (plan de données découplé) |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck, même convention que `break/gitops/01-argocd-*.sh`.
Le script `13-istio-random.sh` de la fiche 13 tirera dans cette liste.

## Profil de lab et budget

- Chemin principal : `linux-base`, la VM des fiches `gitops` (4 vCPU / 8 Go / 60 Go sur les 8 vCPU / 16 Go / 180 Go du profil),
  Docker + `kind`. Cluster `kind` à **deux workers** (un `kind` config dédié) pour voir un ztunnel par nœud ; CNI par défaut
  (kindnet). Istio seul : environ 1 vCPU / 1,5 Go (`istiod` + gateway + `bookinfo` injecté), ambient ajoute `istio-cni-node`
  et `ztunnel` par nœud (quelques centaines de Mo). Le profil `demo` est écarté (deux gateways, ressources non bornées).
- Variante : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go). Préalable non négociable : la page « Platform prerequisites »
  d'Istio et la page « Istio » de Cilium imposent `cni.exclusive=false` et `socketLB.hostNamespaceOnly=true` ; Cilium
  recommande `kubeProxyReplacement=false` avec Istio, alors que le profil l'active (DECISIONS.md, Gateway API Cilium).
  Le masquerading BPF doit rester désactivé. La fiche décrit la variante seulement si ces réglages sont ajoutés au profil ;
  sinon elle est `[non testé]` avec cette raison, et ambient reste sur `kind`.
- Exposition : `port-forward` sur `kind` ; sur `kubernetes-ha`, la gateway Istio prend une adresse du pool MetalLB
  (`10.10.40.200-219`), pas de `HTTPRoute` Cilium pour le trafic du mesh (proposition d'ajout daté à `DECISIONS.md`,
  `certifs/ICA/objectifs.md` §2).
- Aucune dépendance à `core-jump01` : les manifests viennent de l'archive Istio (`samples/`) et du dépôt du workbook cloné.

## Préalables à régler dans la PR du chapitre

- `versions.yaml` : clé `istio` existante (1.31.1, releases 1.31.1 / 1.30.5 / 1.29.8 lues sur GitHub le 2026-10-02) ;
  ajouter `exam_note` (« ICA sur Istio 1.29 selon la FAQ, à confirmer ») et `supported_lines` (« 1.31.1 · 1.30.5 · 1.29.8 »).
  Ajouter la clé `kiali` seulement à la fiche 13.
- `labs/profiles/kubernetes-ha.yaml` : ajouter `istio` à `components` ; ajouter les valeurs Cilium ci-dessus si la variante
  est retenue (question 1).
- `certifs/ICA/objectifs.md` §3 (ICA-01-01 à 01-03) et §4 (F1 → rédigé), `docs/prerequis.md` §6.4 (nœud `rédigé`) : ces
  fichiers n'existent que sur la branche de la cartographie (PR #40) tant qu'elle n'est pas fusionnée.
- `break/plateforme/README.md` à créer (même ligne que `break/gitops/`).

## Points de vigilance `versions.yaml`

- **Istio 1.31.1 au lab, 1.29 à l'examen** (vérification indirecte, `certifs/ICA/examen.md`). Les commandes de cette fiche
  existent dans les deux lignes ; vérifier dans les notes de version 1.30 et 1.31 ce qui a bougé sur `istioctl x precheck`
  (passage ou non en commande stable), les valeurs par défaut du profil `ambient` et les charts Helm. La fiche ajoute une
  ligne « différences avec la version d'examen ».
- **Kubernetes 1.37.1 et image de nœud `kind` 0.33.0** : la matrice de support d'Istio n'a pas pu être lue (page générée
  dynamiquement, istio.io bloqué). Vérifier les versions Kubernetes testées pour 1.31 ; si 1.37 n'y figure pas, épingler
  l'image de nœud `kind` sur la dernière version testée et le dire dans la fiche.
- **Helm 4.3.0** : les charts Istio sont documentés pour Helm 3 ; vérifier que `helm install --wait` et `helm template`
  se comportent pareil, et que `defaultRevision` reste requis sur `base`.
- **Cilium 1.20.2** sur la variante : réglages ci-dessus, et la combinaison ambient + `kubeProxyReplacement` n'est pas
  recommandée par Cilium. C'est le point qui peut rendre la variante `[non testé]`.
- `istioctl` à la version exacte du plan de contrôle, téléchargé depuis l'archive de la release, jamais `curl -L istio.io/downloadIstio`
  sans `ISTIO_VERSION`.

## `[lecture + simulation]`

- Rien pour cause de matériel : sidecar et ambient tournent sur `kind` et sur `kubernetes-ha`.
- Lecture seule avec renvoi : installation multi-cluster et plan de contrôle externe (profils `remote` et `empty`),
  mode ambient sur plateformes gérées (GKE, EKS, OpenShift), `istio-cni` en mode sidecar (remplacement de `istio-init`)
  présenté en une manipulation courte seulement si le temps le permet. Couverts par des flashcards.

## Durée

6 h d'apprentissage, lecture ≤ 20 % (environ 1 h 10), le reste en manipulation :
section 1 ≈ 1 h 30, section 2 ≈ 1 h 30, section 3 ≈ 1 h 45, section 4 ≈ 1 h 15, dont 70 min de défis chronométrés.

## Livrables attendus de la session de rédaction

- `fiches/plateforme/06-istio-installation-sidecar-ambient.md` (gabarit `templates/fiche.md`) et
  `fiches/plateforme/06-istio-installation-sidecar-ambient/manifests/` (`kind-config.yaml` à deux workers, `IstioOperator`
  de démo, `values-istiod.yaml`, `values-gateway.yaml`, waypoint généré)
- `solutions/fiches/plateforme/06-istio-installation-sidecar-ambient.md` (3 indices puis correction commentée par exercice)
- `break/plateforme/11-istio-*.sh` (4 scripts) et `break/plateforme/README.md`
- `revision/flashcards/plateforme-06-istio-installation-sidecar-ambient.csv` (15 à 20 cartes)
- mises à jour : `versions.yaml` (`exam_note`, `supported_lines`), `labs/profiles/kubernetes-ha.yaml`,
  `certifs/ICA/objectifs.md`, `docs/prerequis.md` §6.4, ce plan avec `statut: validé`

## Arbitrages validés le 2026-10-02

1. **Variante `kubernetes-ha`** : les valeurs Cilium `cni.exclusive=false` et `socketLB.hostNamespaceOnly=true` sont
   ajoutées au profil par la PR du chapitre (coût nul pour les autres fiches, masquerading BPF déjà désactivé).
   `kubeProxyReplacement` reste activé parce que la Gateway API Cilium en dépend (DECISIONS.md, 2026-10-02) ; la réserve
   de Cilium est citée dans la fiche. La variante est décrite mais reste `[non testé]` tant qu'elle n'a pas tourné sur le
   profil réel ; le mode ambient se valide sur `kind`.
2. **Ordre d'enseignement** : istioctl d'abord (sections 1, 3, 4), Helm en section 2. C'est l'outil fourni à l'examen ;
   Helm est présenté comme le chemin GitOps et sert à prouver que les deux rendent la même chose.
3. **Cluster `kind`** : cluster dédié `istio-lab` à deux workers (`kind-config.yaml` dans les manifests), recréé pour
   chaque défi « cluster vierge ». `argocd-lab` n'est pas réutilisé : il n'a qu'un nœud et ses labels de namespace
   gêneraient les exercices d'injection.
4. **Version** : Istio 1.31.1 partout (clé `istio`), une ligne « différences avec la version d'examen » par section ;
   l'examen blanc `exams/ica-01/` pourra épingler 1.29 si la veille le confirme.
5. **Branche** : la PR du chapitre part de `main` après fusion de la PR #40 (cartographie ICA et ce plan), sur la branche
   `chapitre/plateforme-06-istio-installation-sidecar-ambient`.
