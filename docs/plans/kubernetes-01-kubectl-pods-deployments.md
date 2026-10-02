---
chapitre: "fiches/kubernetes/01-kubectl-pods-deployments.md"
domaine: "kubernetes"
niveau: "débutant"
statut: "validé le 2026-10-02 — rédaction à faire (prompts/03)"
duree_estimee: "5 h"
profil_lab: "linux-base (kind sur une VM) ; variante kubernetes-ha"
versions: "kubernetes, kind"
certifications:
  - "CKA-02-01"
  - "CKA-04-04"
  - "CKAD-01-02"
  - "CKAD-02-02"
  - "CKAD-03-03"
---

# Plan — 01 kubectl, Pods et Deployments : déployer, mettre à jour, revenir en arrière

Arbitrages pris le 2026-10-02 à la validation du plan : image de nœud `kind` par défaut (1.37.0, cohérente avec `kubernetes`),
l'examen en 1.35 est traité en « Points de vigilance » ; CNI `kindnet` par défaut de `kind`, Cilium n'arrive qu'en fiche 03 ;
réflexes de poste de travail (alias, autocomplétion, `vim`, `--dry-run`) intégrés à la section 1 ; installation de Docker incluse
dans la démo guidée 1.1 pour que cette première fiche du workbook soit autonome. Première fiche `kubernetes` : elle ne cite
aucune autre fiche en prérequis (la fiche `gitops/01` cite `kubernetes_deb`, donc K1 doit se suffire).
IDs CKAD cités dès maintenant, à confirmer par la cartographie CKAD.

## Objectifs mesurables

- Installer `kubectl` et `kind` aux versions de `versions.yaml`, créer un cluster à trois nœuds et me positionner sur son contexte
  en moins de 10 min.
- Générer un manifest de Pod avec `--dry-run=client -o yaml`, le modifier, l'appliquer et lire son IP, son nœud et ses logs
  en moins de 5 min.
- Déployer une application en `Deployment` à trois réplicas, la mettre à jour en `RollingUpdate` et suivre la bascule des ReplicaSets
  en moins de 5 min.
- Revenir à une révision précédente avec `kubectl rollout undo --to-revision` et le prouver avec `rollout history` en moins de 3 min.
- Diagnostiquer un déploiement bloqué (image introuvable, `maxUnavailable: 0`, deadline dépassée) avec `describe`,
  `get events --sort-by` et `logs -p` en moins de 5 min.
- Expliquer sans notes, en trois phrases, la chaîne Deployment → ReplicaSet → Pod et la différence `RollingUpdate` / `Recreate`.

## Niveau et prérequis

- Débutant, nœud `kubernetes_deb` (`docs/prerequis.md` §6.2). Première fiche de la série, aucune autre fiche en prérequis.
- Nœuds amont : `linux_conf` (shell, systemd, SSH, `curl`), `reseau_deb` (IP, ports), `proxmox_deb` (une VM Ubuntu prête).
  Aucun chapitre n'existe pour ces nœuds au 2026-10-02 : le front matter cite les nœuds, pas des fichiers.
- Infrastructure : une VM `linux-base-lx01` (Ubuntu `ubuntu_lts`) joignable en SSH, sans rien d'autre ; Docker est installé en 1.1.
  En variante, `kubernetes-ha` : le cluster existe déjà, seul l'exercice 1.1 change (on lit le kubeconfig).

## Compétences couvertes

| Section | CKA | CKAD (à confirmer) |
|---|---|---|
| 1 kubectl, cluster, Pods | CKA-04-04 (bases : `logs`, `describe`, `events`) | CKAD-03-03 |
| 2 Deployments et ReplicaSets | CKA-02-01 | CKAD-01-02, CKAD-02-02 |
| 3 Rollback et diagnostic | CKA-02-01, CKA-04-04 | CKAD-02-02, CKAD-03-03 |

## Exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Docker (dépôt officiel), `kubectl` et `kind` lus dans `versions.yaml` avec `yq`, cluster 1 control plane + 2 workers par `manifests/kind-config.yaml`, contextes, autocomplétion, alias `k`, `vim` à deux espaces, `kubectl explain` | `kubectl get nodes` : 3 nœuds `Ready` |
| 1.2 | 1 | autonome | Pod `nginx` généré en `--dry-run=client -o yaml`, label et namespace ajoutés, `exec`, `logs`, `port-forward`, sortie en `jsonpath` et `custom-columns`, suppression avec `--grace-period` | IP et nœud du Pod lus par `jsonpath` |
| 1.3 | 1 | break-fix | `break/kubernetes/01-kubeconfig-contexte.sh` | `kubectl get nodes` répond à nouveau |
| 1.4 | 1 | chronométré | Namespace, Pod avec label, IP et logs lus | 5 min |
| 2.1 | 2 | guidé | `create deployment` impératif, `scale`, `set image`, `rollout status`, `rollout history`, annotation `kubernetes.io/change-cause`, `pause`/`resume` | deux révisions visibles |
| 2.2 | 2 | autonome | Deployment écrit en YAML avec `maxSurge`/`maxUnavailable`, bascule observée avec `get rs --watch`, selector immuable (erreur à provoquer et expliquer) | ReplicaSets comptés pendant la mise à jour |
| 2.3 | 2 | break-fix | `break/kubernetes/01-rollout-bloque.sh` | `rollout status` termine |
| 2.4 | 2 | chronométré | Déployer, mettre à jour, revenir en arrière | 8 min, vérifié par `rollout history` |
| 3.1 | 3 | guidé | Image introuvable → `ImagePullBackOff`, `get events --sort-by=.lastTimestamp` et `kubectl events`, `undo --to-revision`, `Recreate` comparé, `logs -p` et `--all-containers`, `progressDeadlineSeconds` | révision restaurée |
| 3.2 | 3 | autonome | `revisionHistoryLimit`, `minReadySeconds`, suppression avec `--cascade=orphan` puis ré-adoption des Pods par un nouveau Deployment | Pods conservés puis réadoptés |
| 3.3 | 3 | break-fix | `break/kubernetes/01-undo-impossible.sh` | application à nouveau servie |
| 3.4 | 3 | chronométré | Deployment cassé injecté à l'aveugle (`break.sh random` sur les scripts 01), diagnostiqué et réparé | 5 min |

## Scénarios de panne (`break/kubernetes/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-kubeconfig-contexte.sh` | `current-context` pointé sur une copie du contexte dont le `server` a un mauvais port | `connection refused`, le cluster tourne pourtant |
| `01-rollout-bloque.sh` | `maxUnavailable: 0`, `maxSurge: 1` et tag d'image inexistant patchés | `rollout status` ne termine jamais, un Pod en `ImagePullBackOff`, les anciens servent encore |
| `01-undo-impossible.sh` | `revisionHistoryLimit: 0` posé puis mauvaise image : l'ancien ReplicaSet est purgé | `rollout undo` répond qu'il n'y a pas de révision, il faut corriger l'image à la main |
| `01-selector-orphelin.sh` (optionnel) | label du template modifié sur les Pods vivants | le Deployment recrée des Pods, les anciens restent en double |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck, variables `NS` et `DEPLOY` avec défauts.

## Profil de lab et budget

- Chemin principal : `linux-base`, une VM (4 vCPU / 8 Go / 60 Go sur le budget 8 vCPU / 16 Go / 180 Go), Docker et `kind` 0.33.0.
  Cluster à trois nœuds : environ 2 vCPU / 3 Go.
- Variante : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go). Exercices identiques, 1.1 réduit à la lecture du kubeconfig.
- Clés `versions.yaml` : `kubernetes`, `kind`.

## Points de vigilance `versions.yaml`

- `kind` 0.33.0 livre l'image de nœud 1.37.0 par défaut, cohérente avec `kubernetes` 1.37.1. L'examen est en 1.35 et une image
  `kindest/node:v1.35.8` existe (Docker Hub, 2026-10-02) : la fiche donne la commande `kind create cluster --image` correspondante
  en « Points de vigilance », sans l'enseigner comme chemin principal (règle de `certifs/CKA/objectifs.md` §2).
- `kubectl rollout history` affiche `CHANGE-CAUSE` depuis l'annotation `kubernetes.io/change-cause`. Le flag `--record` est déprécié
  depuis longtemps ; vérifier dans la doc 1.37 s'il est encore accepté. La fiche enseigne l'annotation et signale que beaucoup de
  supports d'examen utilisent encore `--record`.
- `kubectl events` coexiste avec `kubectl get events --sort-by` : la fiche montre les deux, l'examen accepte les deux.
- CNI `kindnet` : pas de NetworkPolicy ni de Hubble sur ce cluster, c'est voulu ; Cilium arrive en fiche 03.
- Docker : dépôt officiel `download.docker.com`, version non épinglée dans `versions.yaml` (hors périmètre du workbook) ;
  l'utilisateur est ajouté au groupe `docker`, ce qui est signalé comme équivalent root.

## `[lecture + simulation]`

- Rien pour cause de matériel : tout se pratique sur `kind`.
- Hors périmètre, cité en lecture avec renvoi : probes, ConfigMaps, Secrets, `requests`/`limits` (fiche 02) ; Services et DNS (fiche 03) ;
  `kubectl debug` (fiche 12) ; Pods multi-conteneurs et `initContainers` (CKAD, deux flashcards).

## Livrables attendus de la session de rédaction

- `fiches/kubernetes/01-kubectl-pods-deployments.md` (gabarit `templates/fiche.md`) et `fiches/kubernetes/01-kubectl-pods-deployments/manifests/`
  (`kind-config.yaml`, deux Deployments)
- `solutions/fiches/kubernetes/01-kubectl-pods-deployments.md` (3 indices puis correction)
- `break/kubernetes/01-*.sh` (3 scripts, 1 optionnel)
- `revision/flashcards/kubernetes-01-kubectl-pods-deployments.csv` (10 à 20 cartes)
- mise à jour de `certifs/CKA/objectifs.md` §3 et §4, de `docs/prerequis.md` §6.2 (nœud `rédigé`), de `docs/plans/README.md`
  et de ce plan (`statut: réalisé`)
