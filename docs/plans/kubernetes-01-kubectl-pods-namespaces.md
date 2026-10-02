---
chapitre: "fiches/kubernetes/01-kubectl-pods-namespaces.md"
domaine: "kubernetes"
niveau: "débutant"
statut: "réalisé le 2026-10-02 — chapitre en brouillon, relecture critique à faire (prompts/04)"
duree_estimee: "5 h"
profil_lab: "linux-base (kind sur une VM) ; variante kubernetes-ha"
versions: "kubernetes, kind, cilium"
certifications:
  - "CKAD-01-02"
  - "CKAD-03-03"
  - "CKAD-03-04"
  - "CKA-02-04"
  - "CKA-04-04"
  - "KCNA-01-01"
---

# Plan — 01 kubectl, Pods et namespaces : le poste de travail de l'examen

Première fiche du domaine `kubernetes` (`certifs/CKAD/objectifs.md` §4, K1). Elle ouvre le nœud `kubernetes_deb` que
`fiches/gitops/01` et `02` citent comme prérequis sans qu'aucun chapitre n'existe. Arbitrages repris de `DECISIONS.md`
(2026-10-02) : fiches numérotées ; `kind` en chemin principal tant que `lab up kubernetes-ha` n'existe pas ; versions lues
dans `versions.yaml` avec `yq`, jamais en dur ; Gateway API seulement en variante `kubernetes-ha` (hors sujet ici).
Même convention de VM que `docs/plans/gitops-01-argo-cd-fondamentaux.md` (Docker + `kind` sur `linux-base-lx01`).

## Objectifs mesurables

- Créer un cluster `kind` à la version d'examen (`kind` de `versions.yaml`, image de nœud livrée) avec un `kubectl`
  configuré, complété et aliasé, en moins de 15 min.
- Produire le manifest d'un Pod avec `kubectl run --dry-run=client -o yaml`, l'adapter dans `vim` et l'appliquer,
  en moins de 3 min, sans ouvrir la documentation.
- Changer de contexte et de namespace par défaut (`kubectl config use-context`, `set-context --current --namespace`)
  et le vérifier, en moins de 30 s.
- Extraire une valeur précise d'un objet avec `-o jsonpath` ou `-o custom-columns` et la mettre dans un fichier,
  en moins de 2 min.
- Lire les logs du conteneur précédent d'un Pod redémarré, exécuter une commande dedans et copier un fichier,
  en moins de 2 min.
- Diagnostiquer un `kubectl` qui ne répond plus, un Pod `CrashLoopBackOff` et un Pod `Pending` en moins de 5 min chacun,
  avec `describe`, `events` et `logs` seulement.
- Expliquer sans notes, en trois phrases, la différence `create` / `apply` / `replace` et ce qu'est un contexte kubeconfig.

## Niveau et prérequis

- Débutant, nœud `kubernetes_deb` (`docs/prerequis.md` §6.2, premier chapitre de la série).
- Prérequis : nœuds `linux_conf` (shell, `vim`, SSH, systemd, un conteneur déjà lancé une fois) et `reseau_deb`
  (adresse IP, port, DNS). Aucun chapitre n'existe pour ces nœuds au 2026-10-02 : le front matter cite les nœuds.
- Aucune fiche Kubernetes en amont. `fiches/gitops/01` (VM `kind` déjà prête, réflexe `yq`) est un raccourci, pas un prérequis.
- Infrastructure : une VM Ubuntu du profil `linux-base` avec Docker et `kind` ; en variante, `kubernetes-ha` (le cluster
  existe, on saute la section 1 jusqu'à la configuration de `kubectl`).

## Compétences couvertes

| Section | CKAD | CKA (à confirmer à la cartographie CKA) | KCNA |
|---|---|---|---|
| 1 Le poste de travail : cluster, kubectl, contextes | CKAD-03-03 (bases) | — | KCNA-01-01 |
| 2 Pods et namespaces : impératif, déclaratif, formats de sortie | CKAD-01-02 (Pods seulement), CKAD-03-03 | CKA-02-04 (partiel) | KCNA-01-01 |
| 3 Lire un Pod : describe, logs, events, exec, premières pannes | CKAD-03-03, CKAD-03-04 | CKA-04-04 | KCNA-02-03 |

Ce que la fiche **ne** couvre pas, volontairement : Deployments et autres workloads (K3), `kubectl top` (metrics-server, K7),
`kubectl debug` et la méthode complète de diagnostic (K9), RBAC (K6). Chaque renvoi est écrit dans la fiche.

## Exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Lire `kind` et `kubernetes` dans `versions.yaml` avec `yq` ; installer `kind` et `kubectl` à ces versions ; créer `ckad-lab` depuis `manifests/kind-config.yaml` (1 control plane + 2 workers, CNI par défaut désactivé) ; installer Cilium (`cilium` de `versions.yaml`) ; `kubectl get nodes -o wide` | 3 nœuds `Ready` |
| 1.2 | 1 | guidé | `~/.kube/config` lu avec `kubectl config view --minify`, `get-contexts`, `use-context` ; `alias k=kubectl`, complétion bash (`complete -o default -F __start_kubectl k`), `~/.vimrc` (`set ts=2 sw=2 et`), `export KUBE_EDITOR=vim`, `kubectl explain` et `--help` comme seule documentation hors ligne | `k get po -A` fonctionne, `k ex<Tab>` complète |
| 1.3 | 1 | autonome | Créer un second cluster `ckad-lab2` d'un seul nœud (sans Cilium), fusionner les deux kubeconfigs (`KUBECONFIG=a:b kubectl config view --flatten`), renommer les contextes `ckad-lab` et `ckad-lab2`, basculer de l'un à l'autre, supprimer `ckad-lab2` et nettoyer le kubeconfig | `get-contexts` ne montre plus que `ckad-lab` |
| 1.4 | 1 | break-fix | `break/kubernetes/01-kubeconfig-casse.sh` | `kubectl get nodes` répond |
| 1.5 | 1 | chronométré | VM vierge (Docker présent) → cluster `kind` 3 nœuds, kubectl aliasé et complété, contexte renommé | 15 min |
| 2.1 | 2 | guidé | `kubectl run` (image, `--port`, `--env`, `--labels`, `--command -- …`, `--restart=Never`), `--dry-run=client -o yaml > pod.yaml`, lecture du YAML champ par champ avec `kubectl explain pod.spec.containers --recursive`, `apply`, `create`, `replace --force`, `edit`, `patch` (`-p` stratégique), `delete` ; `kubectl diff` | Pod `Running`, chaque verbe testé une fois |
| 2.2 | 2 | guidé | Namespaces : `create ns`, `-n`, `-A`, `set-context --current --namespace`, ce qui est namespacé ou non (`api-resources --namespaced=true`) ; labels et annotations (`label`, `annotate`, `-l`, `--show-labels`, `-L`) ; formats de sortie `-o wide/yaml/json/name/jsonpath/custom-columns`, `--sort-by`, `--field-selector` | une requête `jsonpath` qui liste image et nœud de chaque Pod |
| 2.3 | 2 | autonome | Depuis un énoncé type examen (« dans le namespace `shop`, un Pod `api` image X port 8080 label `tier=backend` et variable `MODE=dev` ; écris le YAML dans `/opt/ckad/api.yaml` »), tout en impératif puis en déclaratif, comparaison des deux YAML, sortie `custom-columns` nom/namespace/image dans un fichier | fichier et Pod conformes à un `grade.sh` fourni dans `solutions/` |
| 2.4 | 2 | break-fix | `break/kubernetes/01-namespace-fantome.sh` | `kubectl get pods` retrouve les Pods |
| 2.5 | 2 | chronométré | Trois Pods avec images, labels et namespaces imposés, un `jsonpath` à produire | 6 min, sans `--help` ni documentation |
| 3.1 | 3 | guidé | Cycle de vie d'un Pod (`Pending` → `Running` → `Succeeded`/`Failed`, `restartPolicy`, `CrashLoopBackOff` comme état de conteneur, pas de Pod) ; `describe` (section `Events`, `Conditions`, `Last State`), `kubectl events --for pod/x --types=Warning`, `logs` (`-c`, `--previous`, `-f`, `--since`, `--tail`, `-l`, `--all-containers`), `exec -it -- sh`, `cp`, `port-forward` + `curl`, `delete --now` vs `--force --grace-period=0` | logs du conteneur précédent récupérés après un crash provoqué |
| 3.2 | 3 | autonome | Un Pod à deux conteneurs fourni (un serveur, un client en boucle) : récupérer les 20 dernières lignes de chaque conteneur dans deux fichiers, exécuter `wget -qO-` depuis le client vers `localhost`, copier un fichier dans le serveur, exposer le serveur sur la VM par `port-forward` et le tester avec `curl` | 4 preuves (`ls`, `curl`, `cat`) dans `journal/` |
| 3.3 | 3 | break-fix | `break/kubernetes/01-pod-crashloop.sh` puis `break/kubernetes/01-pod-pending.sh` | cause écrite en une phrase, Pod `Running` |
| 3.4 | 3 | chronométré | Deux pannes injectées à l'aveugle parmi les quatre scripts, diagnostic et correction | 10 min |

Lecture ≤ 20 % : les trois « Concept (court) » tiennent chacun en une page avec un schéma Mermaid (1 : kubeconfig →
API server → nœuds ; 3 : automate des phases d'un Pod). Le reste est tapé.

## Scénarios de panne (`break/kubernetes/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-kubeconfig-casse.sh` | port du `server:` du cluster courant remplacé dans `~/.kube/config` (sauvegarde `~/.kube/config.bak`) | `The connection to the server 127.0.0.1:6444 was refused` ; Docker et le cluster vont bien |
| `01-namespace-fantome.sh` | namespace par défaut du contexte courant pointé sur `shop-prod` (inexistant) | `No resources found in shop-prod namespace.` alors que les Pods existent |
| `01-pod-crashloop.sh` | Pod `api` recréé avec une commande fausse (`--command -- /bin/shh -c …`) | `CrashLoopBackOff`, `RESTARTS` qui monte, logs du conteneur précédent explicites |
| `01-pod-pending.sh` | Pod `worker` recréé avec `nodeSelector: {disk: ssd}` qu'aucun nœud ne porte | `Pending`, événement `FailedScheduling … didn't match Pod's node affinity/selector` |

Chaque script : idempotent, `--undo`, `--reveal`, `shellcheck`, variables `KUBECONFIG`/`NS` surchargeables, même squelette
que `break/gitops/01-*.sh`. Les deux pannes de Pod s'injectent en aveugle avec `break.sh random` (à créer si absent,
sinon un `shuf` sur la liste dans la fiche).

## Profil de lab et budget

- Chemin principal : `linux-base`, une VM Ubuntu 24.04 (`ubuntu_lts`) avec Docker et `kind`. Budget pris sur le profil :
  4 vCPU / 8 Go / 60 Go, comme `gitops/01` (le fichier `labs/profiles/linux-base.yaml` dimensionne `lx01` à 2 vCPU / 4 Go / 40 Go :
  un cluster `kind` à 3 nœuds avec Cilium tient mal dans 4 Go ; voir arbitrage 4).
- Cluster `kind` : 1 control plane + 2 workers, config committée dans `fiches/kubernetes/01-kubectl-pods-namespaces/manifests/kind-config.yaml`
  (`disableDefaultCNI: true`, `kubeProxyMode: none` si Cilium remplace kube-proxy, `extraPortMappings` pour le `port-forward`
  de la section 3 depuis l'extérieur de la VM). Ce cluster est **réutilisé par K3 à K7** ; K13 a besoin de Cilium pour appliquer
  les NetworkPolicies, d'où son installation dès maintenant (arbitrage 2).
- Second cluster `ckad-lab2` (exercice 1.3) : un nœud, CNI par défaut, détruit en fin d'exercice ; coût temporaire 1 Go.
- Variante : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, Cilium déjà en CNI) ; seule la section 1 change (kubeconfig récupéré
  sur `kubernetes-ha-cp01`, pas de `kind`).

## Points de vigilance `versions.yaml`

- `kind` 0.33.0 livre une image de nœud `kindest/node` 1.37.0 (constat de `gitops/01`) ; `kubernetes` est en 1.37.1 et l'examen
  annonce 1.37 (`certifs/CKAD/examen.md`, indirecte). Écart de patch accepté. Si l'examen change de mineure avant le jalon, épingler
  `--image kindest/node:v1.3x.y` sur l'image publiée pour cette version de `kind` (le `sha256` est dans les notes de version de `kind`).
- `kubectl` : installer le binaire à la version `kubernetes` depuis `dl.k8s.io` (pas de clé séparée, `kubeadm` porte la même règle) ;
  le skew toléré est ±1 mineure, donc le même binaire servira pour un examen en 1.36 ou 1.38.
- Commandes à vérifier dans `kubectl --help` à la version `kubernetes` avant rédaction : `kubectl events` (remplace `get events`
  pour le filtrage), `kubectl auth whoami`, `kubectl run` ne crée plus que des Pods (pas de `--generator`), `kubectl create --dry-run=client`
  (l'ancien `--dry-run=true` est retiré), `kubectl replace --force`, comportement de `--now`.
- `cilium` 1.20.2 sur `kind` : suivre la page « Getting started on kind » de la version exacte (`cilium install --version`),
  `kubeProxyReplacement` non obligatoire ici (utile seulement pour la Gateway API, hors sujet) ; le CLI `cilium` prend une version
  distincte de l'agent, à lire dans la même page, pas de clé `versions.yaml` dédiée : la fiche cite celle que la doc 1.20 recommande
  et le signale.
- `yq` : prérequis implicite depuis `gitops/01` (lecture de `versions.yaml`) ; pas de clé `versions.yaml`, à installer par le
  paquet de la distribution ou le binaire `mikefarah/yq`. À signaler dans la fiche, pas à résoudre ici.
- Environnement d'examen : les aliases, la complétion et `vim` sont ceux que fournit le bureau distant PSI ; ce qu'il contient
  réellement est marqué « non trouvé » dans `examen.md`. La fiche enseigne une configuration **reproductible en 60 s** de mémoire
  (trois lignes), jamais un dotfile long.

## `[lecture + simulation]`

- Rien pour cause de matériel.
- L'interface d'examen elle-même (bureau distant PSI, un onglet Firefox) : lecture seule dans la section 1, avec renvoi vers
  `certifs/CKAD/examen.md` et les deux sessions killer.sh incluses.
- Multi-cluster réel (API server distant, authentification par certificat client, `kubectl config set-credentials`) : simulé par
  le second cluster `kind` de l'exercice 1.3 ; le cas `kubernetes-ha` est la variante.

## Livrables attendus de la session de rédaction

- `fiches/kubernetes/01-kubectl-pods-namespaces.md` (gabarit `templates/fiche.md`, 3 sections)
- `fiches/kubernetes/01-kubectl-pods-namespaces/manifests/` : `kind-config.yaml`, `pod-api.yaml`, `pod-deux-conteneurs.yaml`
  (validés par `kubeconform` en CI, `-ignore-missing-schemas` couvre `kind.x-k8s.io`)
- `solutions/fiches/kubernetes/01-kubectl-pods-namespaces.md` (3 indices puis correction, plus `grade.sh` de l'exercice 2.3)
- `break/kubernetes/01-kubeconfig-casse.sh`, `01-namespace-fantome.sh`, `01-pod-crashloop.sh`, `01-pod-pending.sh`
- `revision/flashcards/kubernetes-01-kubectl-pods-namespaces.csv` (15 à 20 cartes : verbes `kubectl`, drapeaux, phases d'un Pod)
- mise à jour de `certifs/CKAD/objectifs.md` §3 et §4 (K1 rédigé), de `docs/prerequis.md` §6.2 (nœud `rédigé`),
  de `docs/plans/README.md` et de ce plan (`statut: réalisé`)

## Arbitrages validés le 2026-10-02

1. **Runtime de `kind`** : Docker sur la VM (continuité avec `gitops/01`). Podman n'intervient qu'en K2 pour construire les images.
2. **CNI dès K1** : Cilium (`cilium` de `versions.yaml`) installé dans la section 1 en quatre commandes, sans explication
   (« c'est le réseau, CCA et K13 y reviennent »). Le cluster `ckad-lab` est réutilisé de K3 à K13.
3. **Second cluster pour les contextes** : oui, `ckad-lab2` à un nœud, détruit en fin d'exercice 1.3.
4. **Taille de la VM** : la PR du chapitre passe `linux-base-lx01` à 4 vCPU / 8 Go / 60 Go dans `labs/profiles/linux-base.yaml`
   (budget profil 10 vCPU / 20 Go / 200 Go, toujours combinable avec `kubernetes-ha` : 20 + 48 + 8 d'hôte + 8 de `core` = 84 Go ≤ 128)
   et ajoute l'entrée `DECISIONS.md` correspondante ; `gitops/01` et `02` deviennent cohérents avec le profil sans modification.
5. **Application fil rouge** (proposition non contestée) : K1 utilise des images publiques (`nginx`, `busybox`,
   `registry.k8s.io/e2e-test-images/agnhost`) étiquetées `app=api` / `app=worker` ; `lab-shop` réel à partir de K2.
