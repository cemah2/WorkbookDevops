---
chapitre: "fiches/plateforme/01-platform-engineering-fondamentaux.md"
domaine: "plateforme"
niveau: "débutant"
statut: "validé le 2026-10-02 — rédaction à faire (prompts/03-redaction-chapitre.md)"
duree_estimee: "4 h"
profil_lab: "linux-base (kind sur une VM, état final de gitops/01) ; variante kubernetes-ha"
versions: "kubernetes, kind, argo_cd, podinfo"
certifications:
  - "CNPA-01-02"
  - "CNPA-01-03"
  - "CNPA-01-04"
  - "CNPA-01-05"
  - "CNPA-01-01 (partiel)"
  - "CNPA-03-05 (partiel)"
  - "CNPA-05-01 (partiel)"
---

# Plan — 01 Platform engineering : capacités, environnements et pratiques DevOps

Chapitre F1 de `certifs/CNPA/objectifs.md` §4, premier de l'ordre de rédaction CNPA et première fiche du domaine `plateforme`.
Arbitrages pris en session de plan le 2026-10-02 (questions posées, réponse « fais ce qui est mieux ») :

- **Point de départ** : l'état final de `fiches/gitops/01-argo-cd-fondamentaux.md` (cluster `kind` + Argo CD à la version `argo_cd`).
  La section 1 contient un encart « remise à zéro » de cinq commandes (recréer le cluster, réappliquer `install.yaml`), pas de script
  générique tant qu'aucune session de rédaction n'a pu l'exécuter sur un vrai démon Docker.
- **ADR** : gabarit générique `templates/adr.md` (créé avec ce plan) ; l'ADR de l'apprenant est écrit dans `journal/`, les ADR du
  workbook iront dans `docs/adr/` quand le premier existera.
- **Application de démonstration** : `podinfo` (image `ghcr.io/stefanprodan/podinfo`, clé `podinfo` de `versions.yaml`), choisie
  pour ses tags de version nombreux, nécessaires à une promotion `dev` → `prod` réaliste ; guestbook reste dans gitops/01.
- **Revue de PR** : simulée par branche et fusion `--no-ff` sur le dépôt bare de `core-jump01`, avec une checklist de revue.
  La décision « forge Git du lab » (`certifs/CNPA/objectifs.md` §2) remplacera cette simulation par de vraies merge requests
  dans une révision ultérieure de la section 3, sans changer les exercices.
- **Dosage concept** : la section 1 peut dépasser localement 20 % de lecture ; la fiche entière reste sous 20 % grâce aux
  sections 2 et 3. Les définitions utiles au QCM sont doublées en flashcards.
- Le nœud `plateforme_deb` suppose `kubernetes_conf` et `gitops_deb` (`docs/prerequis.md` §2) : « débutant » est relatif au domaine.

## Objectifs mesurables

- Dresser la carte des capacités de la plateforme du lab (profils `core` et `kubernetes-ha`) selon le modèle du CNCF Platforms
  White Paper, avec pour chaque capacité le composant qui la porte ou « absent », en moins de 30 min.
- Rédiger un ADR « plateforme minimale viable » sur `templates/adr.md` (contexte, décision, périmètre refusé, trois objectifs
  mesurables) en moins de 30 min.
- Créer un environnement complet (namespace, `ResourceQuota`, `LimitRange`, labels de propriété, overlay Kustomize, `Application`
  Argo CD) et obtenir `Synced` / `Healthy` en moins de 15 min.
- Promouvoir une version de `dev` à `prod` par changement de tag dans l'overlay, revue, fusion, et vérifier le déploiement en moins de 10 min.
- Diagnostiquer un environnement dont les Pods ne se créent plus et le remettre en service en moins de 10 min.
- Expliquer sans notes, en trois phrases chacune : environnement / infrastructure / configuration ; plateforme « as a product » et
  golden path ; les pratiques DevOps d'une équipe plateforme (trunk-based, revue, boucle de feedback, mesure).

## Niveau et prérequis

- Débutant, nœud `plateforme_deb` (`docs/prerequis.md` §6.2).
- Prérequis : `fiches/gitops/01-argo-cd-fondamentaux.md` (rédigé, brouillon) et le nœud `kubernetes_conf` (namespaces, quotas,
  Kustomize, RBAC). Aucun chapitre n'existe pour `kubernetes_conf` au 2026-10-02 : le front matter cite le nœud, pas un fichier.
- Infrastructure : la VM `linux-base` de gitops/01 (Docker, `kind`, Argo CD installé, CLI `argocd`) ; dépôts bare SSH sur `core-jump01`.

## Compétences couvertes

| Section | CNPA (cibles) | CNPA (partiels) | Autres programmes (à confirmer par leur cartographie) |
|---|---|---|---|
| 1 Capacités et objectifs d'une plateforme | CNPA-01-04, CNPA-01-05 | CNPA-05-01 | CNPE-01-01 |
| 2 Environnements d'application | CNPA-01-03 | CNPA-01-01, CNPA-03-05 | CGOA-02-01, CGOA-05-01 |
| 3 Pratiques DevOps de l'équipe plateforme | CNPA-01-02 | CNPA-01-05, CNPA-05-01 | CGOA-03-03 |

## Exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Inventorier le lab avec `yq` sur `labs/profiles/*.yaml` et `kubectl api-resources` / `kubectl get -A` sur le cluster ; remplir le tableau capacité → composant ; schéma Mermaid | tableau et schéma produits |
| 1.2 | 1 | autonome | Marquer les capacités absentes, rédiger l'ADR « plateforme minimale viable » sur `templates/adr.md` | grille de relecture du gabarit cochée |
| 1.3 | 1 | break-fix | `break/plateforme/01-capacite-cassee.sh` | composant identifié depuis le symptôme, remis à 1 réplica |
| 1.4 | 1 | chronométré | Carte des capacités d'un profil non étudié (`openstack-kolla`) depuis son YAML | 30 min |
| 2.1 | 2 | guidé | Base Kustomize de `podinfo` + overlays `dev` / `staging` / `prod` (`namespace`, `replicas`, `images`, `configMapGenerator`) ; `ResourceQuota` et `LimitRange` par namespace ; `AppProject` `envs` à destinations restreintes ; trois `Application` | trois `Synced` / `Healthy` |
| 2.2 | 2 | autonome | Comparer deux overlays rendus (`kubectl kustomize`, `kubectl diff -k`, `argocd app manifests`) ; ajouter un overlay `qa` avec son quota | diff expliqué, `qa` synchronisé |
| 2.3 | 2 | break-fix | `break/plateforme/01-quota-bloquant.sh` | Pods recréés, quota corrigé par Git, pas à la main |
| 2.4 | 2 | chronométré | Environnement `qa` complet depuis zéro | 15 min |
| 3.1 | 3 | guidé | Deux dépôts bare (`platform-envs.git` : projets, quotas, overlays ; `app-demo.git` : base) ; branche, revue sur checklist, fusion `--no-ff`, promotion `dev` → `prod` ; mesurer à la main le délai commit → `Synced` (`git log`, `argocd app history`) et le noter dans `journal/` | délai mesuré, référence pour F11 (DORA) |
| 3.2 | 3 | autonome | Écrire le golden path « obtenir un environnement » : README + script `new-env.sh` qui génère overlay, quota et `Application` depuis un gabarit (self-service manuel, précurseur de Backstage en F9) | un environnement créé par le script en une commande |
| 3.3 | 3 | break-fix | `break/plateforme/01-kustomize-build-casse.sh` | `ComparisonError` résolu par un commit correctif |
| 3.4 | 3 | chronométré | Promotion `dev` → `prod` par branche et fusion, vérifiée par `argocd app get` | 10 min |

## Scénarios de panne (`break/plateforme/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-capacite-cassee.sh` | `argocd-application-controller` à 0 réplica | plus aucune `Application` ne se réconcilie, UI vivante, `kubectl scale` sans effet sur l'app |
| `01-quota-bloquant.sh` | `ResourceQuota` de `dev` réduit sous les requêtes de `podinfo` | `Progressing` sans fin, événements `FailedCreate` sur le ReplicaSet |
| `01-kustomize-build-casse.sh` | ressource référencée mais absente dans l'overlay `prod` | `ComparisonError` « unable to build kustomize » |
| `01-limitrange-incompatible.sh` (optionnel) | `LimitRange` avec minimum supérieur aux requêtes de l'app | Pods refusés « forbidden: minimum cpu usage per Container » |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck, même structure que `break/gitops/01-*.sh`.

## Profil de lab et budget

- Chemin principal : la VM `linux-base` de gitops/01 (4 vCPU / 8 Go / 60 Go sur le budget 8 vCPU / 16 Go / 180 Go), Docker + `kind`,
  Argo CD déjà installé. Quatre environnements de deux réplicas de `podinfo` : moins de 0,5 vCPU et 512 Mo en plus.
- Variante : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go), exposition de `podinfo` par `Gateway` + `HTTPRoute` Cilium,
  hôte `podinfo-<env>.apps.lab.home.arpa`.
- Git du lab : `core-jump01`, dépôts bare `/srv/git/platform-envs.git` et `/srv/git/app-demo.git`, alias `git.lab.home.arpa`.

## Points de vigilance `versions.yaml`

- **Deux Kustomize** : `kubectl` 1.37.1 embarque sa propre version de Kustomize (à lire dans `kubectl version`), Argo CD 3.5.3 embarque
  la 5.8.1 (vérifié dans gitops/01). Les rendus locaux peuvent différer de ceux d'Argo CD : rendre en local avec `kubectl kustomize`,
  comparer avec `argocd app manifests`, ne pas installer de binaire `kustomize` séparé (pas de clé `versions.yaml`).
- `podinfo` 6.15.0 : la base Kustomize officielle (`kustomize/` du dépôt) inclut un `HorizontalPodAutoscaler` ; le retirer de la base
  du chapitre (un HPA et un `replicas` d'overlay se contredisent, c'est un pattern de réconciliation traité en gitops/04).
  Les tags de promotion sont `6.14.x` → `6.15.0`, à relire sur le registre au moment de la rédaction.
- `argo_cd` 3.5.3 : défauts 3.x déjà notés dans gitops/01 (suivi par annotation, `status` ignoré dans le diff) ; les `Application`
  de ce chapitre héritent d'un `AppProject` restreint (`destinations`, `sourceRepos`), ce qui prépare CNPA-03-05.
- `kubernetes` 1.37.1 sur `kind` 0.33.0 : même écart que gitops/01 avec la matrice de test d'Argo CD (1.33 à 1.36), accepté,
  image 1.36 en repli. `ResourceQuota`, `LimitRange`, champs Kustomize `images` / `replicas` : API stables, `kubeconform` en CI.

## `[lecture + simulation]`

- Rien pour cause de matériel.
- Lecture seule, avec schéma Mermaid de comparaison : un cluster par environnement et comptes cloud par environnement (le lab fait
  un namespace par environnement sur un seul cluster) ; Team Topologies ; le modèle de maturité CNCF (niveaux, cité par le QCM).
- Simulation assumée : la revue de PR par branche et fusion sur dépôt bare, en attendant la forge Git.
- Cinq flashcards couvrent ces points parce que l'examen les cite.

## Livrables attendus de la session de rédaction

- `fiches/plateforme/01-platform-engineering-fondamentaux.md` (gabarit `templates/fiche.md`) et `fiches/plateforme/01-platform-engineering-fondamentaux/manifests/`
  (base `podinfo`, overlays `dev` / `staging` / `prod` / `qa`, quotas et `LimitRange`, `AppProject`, `Application`, `new-env.sh`)
- `solutions/fiches/plateforme/01-platform-engineering-fondamentaux.md` (3 indices puis correction)
- `break/plateforme/01-*.sh` (3 scripts, 1 optionnel)
- `revision/flashcards/plateforme-01-platform-engineering-fondamentaux.csv` (15 cartes visées, 10 à 20)
- mise à jour de `certifs/CNPA/objectifs.md` §3 et §4, de `docs/prerequis.md` §6.2 (nœud `rédigé`) et de ce plan (`statut: réalisé`)
