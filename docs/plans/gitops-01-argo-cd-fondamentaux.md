---
chapitre: "fiches/gitops/01-argo-cd-fondamentaux.md"
domaine: "gitops"
niveau: "débutant"
statut: "validé le 2026-10-02 — à rédiger avec prompts/03-redaction-chapitre.md dans une nouvelle session"
duree_estimee: "5 h"
profil_lab: "linux-base (kind sur une VM) ; variante kubernetes-ha"
versions: "argo_cd, kind, kubernetes, cilium, cert_manager"
certifications:
  - "CAPA-02-01"
  - "CAPA-02-02"
  - "CAPA-02-03"
  - "CGOA-01-03"
  - "CGOA-01-04"
  - "CGOA-01-05"
  - "CGOA-02-03"
  - "CGOA-02-04"
---

# Plan — 01 Argo CD : installer, déclarer une Application, synchroniser

Arbitrages pris le 2026-10-02 (voir `DECISIONS.md` à cette date) : fiches numérotées ; Git du lab = dépôt bare SSH
sur `core-jump01` ; Gateway API Cilium par défaut ; installation par manifests officiels ; `kind` en chemin principal
tant que `lab up kubernetes-ha` n'existe pas ; IDs CGOA cités dès maintenant, à confirmer par la cartographie CGOA.

## Objectifs mesurables

- Installer Argo CD depuis les manifests de la version `argo_cd` et me connecter avec le CLI en moins de 20 min.
- Déclarer un `AppProject` et une `Application` vers un dépôt Git et obtenir `Synced` / `Healthy` en moins de 10 min.
- Provoquer un drift manuel, le lire avec `argocd app diff`, le corriger dans les deux sens en moins de 5 min.
- Diagnostiquer une Application `OutOfSync`, `Degraded` ou `ComparisonError` en moins de 10 min.
- Revenir à la révision précédente avec `argocd app history` et `argocd app rollback` en moins de 5 min.
- Expliquer sans notes, en trois phrases, les composants d'Argo CD et la différence sync manuelle / automatique / `prune` / `selfHeal`.

## Niveau et prérequis

- Débutant, nœud `gitops_deb` (`docs/prerequis.md` §6).
- Prérequis : nœuds `kubernetes_deb` (kubectl, Deployments, namespaces, Services) et `iac_deb` (Git de base).
  Aucun chapitre n'existe pour ces nœuds au 2026-10-02 : le front matter cite les nœuds, pas des fichiers.
- Infrastructure : une VM Ubuntu du profil `linux-base` avec Docker et `kind` ; en variante, `kubernetes-ha` avec Cilium
  Gateway API et cert-manager.

## Compétences couvertes

| Section | CAPA | CGOA (à confirmer) |
|---|---|---|
| 1 Installer et comprendre | CAPA-02-01 | CGOA-01-06 |
| 2 AppProject et Application | CAPA-02-03 | CGOA-01-02, CGOA-01-03 |
| 3 Synchroniser, drift, rollback | CAPA-02-02 | CGOA-01-04, CGOA-01-05, CGOA-01-09, CGOA-02-03, CGOA-02-04 |

## Exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Installer Argo CD par manifests (`argo_cd`), lire les pods, CLI à la même version, `argocd login` par port-forward | `argocd version` renvoie le serveur |
| 1.2 | 1 | autonome | Changer le mot de passe admin, exposer l'UI (port-forward sur kind ; `Gateway` + `HTTPRoute` Cilium + certificat CA interne sur `kubernetes-ha`) | UI joignable en TLS |
| 1.3 | 1 | break-fix | `break/gitops/01-argocd-repo-server-down.sh` | refresh rétabli |
| 1.4 | 1 | chronométré | Installation propre + connexion CLI | 20 min |
| 2.1 | 2 | guidé | Première `Application` depuis `argoproj/argocd-example-apps` (guestbook), puis dépôt bare SSH du lab avec clé déposée dans Argo CD, `AppProject` restreint | `Synced` / `Healthy` |
| 2.2 | 2 | autonome | Application vers un namespace interdit par le projet, lire l'erreur, corriger le projet | sync réussie |
| 2.3 | 2 | break-fix | `break/gitops/01-argocd-repo-credentials.sh` | `ComparisonError` disparu |
| 2.4 | 2 | chronométré | Dépôt vierge → application `Synced` / `Healthy` | 10 min |
| 3.1 | 3 | guidé | Sync manuelle, `automated`, `prune`, `selfHeal` ; `kubectl scale` à la main ; `argocd app diff` ; `history` / `rollback` et effet sur l'auto-sync | drift vu puis corrigé |
| 3.2 | 3 | autonome | Supprimer un manifest dans Git avec et sans `prune` ; pousser une image inexistante, observer `Degraded` | comportement expliqué |
| 3.3 | 3 | break-fix | `break/gitops/01-argocd-app-degraded.sh` | plus de ressource dégradée |
| 3.4 | 3 | chronométré | Diagnostiquer et corriger une app `Degraded` | 10 min |

## Scénarios de panne (`break/gitops/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-argocd-repo-server-down.sh` | `repo-server` à 0 réplica | UI vivante, refresh en échec, manifests introuvables |
| `01-argocd-repo-credentials.sh` | clé SSH du secret de dépôt remplacée | `ComparisonError`, authentification refusée |
| `01-argocd-app-degraded.sh` | tag d'image inexistant patché sur le Deployment vivant, `selfHeal` coupé | `OutOfSync` + `Degraded`, `ImagePullBackOff` |
| `01-argocd-destination-forbidden.sh` (optionnel) | destination retirée de l'`AppProject` | « application destination not permitted » |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck.

## Profil de lab et budget

- Chemin principal : `linux-base`, une VM (4 vCPU / 8 Go / 60 Go pris sur le budget 8 vCPU / 16 Go / 180 Go), Docker + `kind`
  (`kind` 0.33.0, image de nœud à vérifier pour Kubernetes 1.37). Argo CD seul : environ 1 vCPU / 1,5 Go.
- Variante : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go), Cilium Gateway API, cert-manager, hôte `argocd.apps.lab.home.arpa`.
- Git du lab : `core-jump01`, dépôt bare `/srv/git/gitops-demo.git`, alias `git.lab.home.arpa`.

## Points de vigilance `versions.yaml`

- `argo_cd` 3.5.3 : la série 3.x a changé des défauts par rapport à la 2.x que citent beaucoup de supports d'examen
  (suivi des ressources par annotation, RBAC des logs séparé, champ `status` dans le diff). À vérifier dans les notes
  de version avant rédaction ; la fiche signale l'écart sans enseigner la 2.x.
- CLI `argocd` à la version exacte du serveur, jamais `latest`.
- Helm embarqué dans l'image Argo CD : à vérifier avec `argocd version` ; l'écart éventuel avec Helm 4.3.0
  (DECISIONS.md) est noté et traité dans la fiche 04.
- Kubernetes 1.37.1 : matrice de compatibilité d'Argo CD 3.5 à vérifier ; image `kind` pour 1.37 à vérifier.
- Cilium 1.20.2 : Gateway API nécessite `kubeProxyReplacement` et `gatewayAPI.enabled` ; variante seulement.

## `[lecture + simulation]`

- Rien pour cause de matériel.
- Hors périmètre débutant, lecture seule avec renvoi vers les fiches suivantes : destinations multi-cluster
  (`argocd cluster add`), SSO Dex / Keycloak, `ApplicationSet`. Trois à cinq flashcards les couvrent car l'examen les cite.

## Livrables attendus de la session de rédaction

- `fiches/gitops/01-argo-cd-fondamentaux.md` (gabarit `templates/fiche.md`)
- `solutions/fiches/gitops/01-argo-cd-fondamentaux.md` (3 indices puis correction)
- `break/gitops/01-*.sh` (3 scripts, 1 optionnel)
- `revision/flashcards/gitops-01-argo-cd-fondamentaux.csv` (10 à 20 cartes)
- mise à jour de `certifs/CAPA/objectifs.md` §3 et §4, de `docs/prerequis.md` §6 (nœud `rédigé`) et de ce plan (`statut: réalisé`)
