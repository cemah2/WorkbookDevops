---
chapitre: "fiches/kubernetes/01-conteneurs-et-images-oci.md"
domaine: "kubernetes"
niveau: "débutant"
statut: "proposé le 2026-10-02 — en attente de validation (questions en fin de plan)"
duree_estimee: "4 h"
profil_lab: "linux-base (1 VM Ubuntu, variante 2 VM avec Rocky pour Podman)"
versions: "containerd, nerdctl (à créer), podman (à créer), trivy (à créer), skopeo (à créer), harbor (variante)"
certifications:
  - "KCNA-01-04"
  - "CKAD-01-01 (à confirmer par la cartographie CKAD)"
  - "LFCS-01-07 (à confirmer par la cartographie LFCS)"
  - "KCSA-01-05, KCSA-02-05 (à confirmer par la cartographie KCSA)"
---

# Plan — 01 Conteneurs : namespaces, cgroups, images OCI et runtimes

Chapitre `F1` de `certifs/KCNA/objectifs.md` §4, nœud `kubernetes/01-conteneurs-et-images-oci` de `docs/prerequis.md` §6.2
(numéro réservé par la cartographie KCNA, DECISIONS.md 2026-10-02 « fiches numérotées par série »).
Pourquoi lui en premier : c'est la seule fiche de la série qui ne demande aucun cluster, elle pèse 11 % de l'examen
(KCNA-01-04), et F2 (architecture Kubernetes) suppose que l'apprenant sait ce qu'un runtime fait d'une image.
Le prompt de planification a été envoyé sans chemin ; ce choix est l'hypothèse de travail, à confirmer (question 1).

Arbitrages hérités (DECISIONS.md, 2026-10-02) : open source d'abord ; image Linux de référence Ubuntu 24.04 LTS ;
versions lues dans `versions.yaml`, jamais en dur ; scripts de panne `break/kubernetes/01-*.sh` avec `--undo` et `--reveal`.

## Objectifs mesurables

À la fin de la fiche tu sais :

- isoler un processus à la main avec `unshare` (PID, mount, net, UTS) et le borner en mémoire avec un cgroup v2
  (`systemd-run`), puis retrouver ces namespaces et ce cgroup dans `/proc/<pid>/ns` et `/sys/fs/cgroup`, en moins de 10 min ;
- expliquer en trois phrases, sans notes, ce qui distingue une image, un conteneur, un runtime bas niveau (`runc`)
  et un moteur (containerd, Podman), et dessiner la chaîne kubelet → CRI → containerd → `runc` ;
- écrire un Containerfile multi-étapes pour une petite application, construire une image non-root, la taguer, la pousser
  sur un registre du lab et la tirer par digest, en moins de 15 min ;
- lire un manifeste OCI avec `skopeo inspect` et dire ce que sont un tag, un digest, une couche et une liste de
  manifestes (multi-architecture), en moins de 5 min ;
- scanner une image avec `trivy`, lire le rapport, et réduire la surface (image de base minimale, utilisateur non-root,
  système de fichiers en lecture seule, capabilities retirées), en moins de 15 min ;
- faire la même opération (run, build, push) avec `nerdctl` sur containerd et avec `podman`, et vérifier avec `crictl`
  ce que Kubernetes verrait ;
- diagnostiquer un conteneur qui ne démarre pas ou ne se tire pas (registre non approuvé, digest changé, port privilégié
  en rootless, plugin CRI désactivé) en moins de 10 min.

## Niveau et prérequis

- Débutant, nœud `kubernetes_deb`, mais commençable dès `linux_deb` : processus, permissions, systemd, réseau local,
  `curl`. Arête `linux_deb` → F1 justifiée dans `docs/prerequis.md` §6.2.
- `proxmox_deb` : savoir lever une VM du profil `linux-base` (ou utiliser celle de `fiches/gitops/01-argo-cd-fondamentaux.md`).
- Aucun chapitre rédigé pour `linux_deb` au 2026-10-02 : le front matter cite le nœud, comme les fiches `gitops`.
- Pas de prérequis Kubernetes : la fiche se termine là où F2 commence (`podman kube play` sert de passerelle).

## Compétences couvertes

| Section | KCNA | Autres (à confirmer par leur cartographie) |
|---|---|---|
| 1 Isolation Linux : namespaces, cgroups, capabilities | KCNA-01-04 | LFCS-01-07 |
| 2 Images OCI : construire, taguer, pousser, inspecter | KCNA-01-04 | CKAD-01-01, KCSA-01-05 |
| 3 Runtimes et CRI : containerd, `nerdctl`, `crictl`, Podman, durcissement | KCNA-01-04 | KCSA-02-05, LFCS-01-07 |

Hors périmètre, renvoyé : Pods multi-conteneurs et `initContainers` (F2, CKAD-01-03), politiques d'admission d'images et
signature cosign (F7, KCSA/CKS), sandboxes gVisor/Kata (CKS), Harbor comme registre d'entreprise (scénario S1).
Trois à cinq flashcards les nomment car le QCM les cite.

## Sections et exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | `unshare --pid --mount --net --uts --fork` + `mount -t proc`, `hostname` dans le namespace, `ls -l /proc/$$/ns`, `nsenter` depuis l'hôte ; `systemd-run --scope -p MemoryMax=64M` sur un `stress` ou `python -c`, lecture de `memory.max`, `memory.events` (`oom_kill`) | OOM observé dans `memory.events`, PID 1 dans le namespace |
| 1.2 | 1 | guidé | Le même conteneur avec `nerdctl run --memory 64m --pids-limit 50 --cap-drop ALL` : comparer `nerdctl inspect`, `/proc/<pid>/status` (`CapEff`), le cgroup créé sous `/sys/fs/cgroup` ; schéma Mermaid « ce que le runtime ajoute » | l'apprenant complète le schéma avec les 5 namespaces et le cgroup |
| 1.3 | 1 | autonome | Reproduire un conteneur « à la main » : rootfs extrait d'une image (`nerdctl image save` ou `skopeo copy … dir:`), `unshare` + `chroot` + limite mémoire + `capsh --drop` ; prouver que `ps` ne voit que le namespace et que `ping` échoue sans `CAP_NET_RAW` | 3 preuves par commande |
| 1.4 | 1 | break-fix | `break/kubernetes/01-rootless-privileged-port.sh` | conteneur rootless publie à nouveau le port 80, cause expliquée |
| 1.5 | 1 | chronométré | Isoler et borner un processus donné (PID, mount, 32 Mo), prouver l'isolement | 10 min |
| 2.1 | 2 | guidé | Containerfile multi-étapes (build Go ou Python, image finale `distroless`/`alpine` selon question 4), `nerdctl build` (BuildKit), couches avec `nerdctl history`, `.dockerignore`, `USER`, `HEALTHCHECK` ; tag, digest, `skopeo inspect --raw` du manifeste et de la config | image < 30 Mo, non-root, digest noté |
| 2.2 | 2 | guidé | Registre du lab : conteneur `registry` sur la VM (`registry.lab.home.arpa:5000`, TLS par certificat de la CA interne ou HTTP + `hosts.toml` / `registries.conf` selon question 5), `push`, `pull` par digest, `skopeo copy` entre registres, `skopeo list-tags` | pull par digest réussi depuis une VM vierge d'images |
| 2.3 | 2 | autonome | Prendre une image « sale » fournie (root, `latest`, 400 Mo, secret dans une couche) : la reconstruire propre, prouver que le secret n'est plus dans l'historique, la pousser sous un tag versionné et par digest | `trivy` sans CRITICAL, aucune couche ne contient le secret |
| 2.4 | 2 | break-fix | `break/kubernetes/01-image-digest-mismatch.sh` | l'apprenant épingle par digest et explique pourquoi `latest` a bougé |
| 2.5 | 2 | chronométré | Construire, scanner, pousser une image non-root d'une app fournie | 10 min |
| 3.1 | 3 | guidé | containerd côté Kubernetes : `config.toml` (version 3), plugin CRI, `crictl pull` / `run` / `ps` / `logs` avec un `pod-config.json`, `ctr` vs `nerdctl` vs `crictl` (qui voit quoi : namespaces containerd `default` / `k8s.io`), `runc list` ; schéma kubelet → CRI → containerd → shim → `runc` | l'apprenant retrouve un conteneur `crictl` dans `ctr -n k8s.io` et dans `ps` |
| 3.2 | 3 | guidé | Podman : rootless par défaut, `podman run`, `podman pod create`, `podman generate kube` puis `podman kube play` d'un YAML Pod : première rencontre avec le format Kubernetes ; lecture : Docker et la fin de dockershim (1.24), CRI-O | YAML généré, relu, rejoué ; différences Docker/containerd/Podman en 3 phrases |
| 3.3 | 3 | autonome | Durcir l'image de 2.3 à l'exécution : `--read-only` + `--tmpfs`, `--cap-drop ALL --cap-add` minimal, `--security-opt no-new-privileges`, utilisateur non-root, limites CPU/mémoire ; `trivy image` + `trivy config` sur le Containerfile ; livrer le YAML `podman kube play` correspondant | l'app fonctionne avec 0 capability ajoutée, ou la seule justifiée |
| 3.4 | 3 | break-fix | `break/kubernetes/01-containerd-cri-disabled.sh` (+ optionnel `01-registry-untrusted-ca.sh`) | `crictl ps` répond à nouveau, cause nommée |
| 3.5 | 3 | chronométré | Depuis un YAML Pod fourni qui référence une image du registre du lab : la faire tourner avec `podman kube play`, puis avec `crictl` sur containerd | 8 min |

Les flashcards (15 à 20) couvrent en plus : OCI image-spec / runtime-spec / distribution-spec, CRI vs CNI vs CSI,
`runc` vs `crun` vs `youki`, `containerd-shim`, cgroup v1 vs v2, image minimale (scratch, distroless), multi-architecture.

## Scénarios de panne (`break/kubernetes/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-rootless-privileged-port.sh` | sysctl `net.ipv4.ip_unprivileged_port_start` remis à 1024 (drop-in dans `/etc/sysctl.d/`) | `podman run -p 80:80` ou `nerdctl` rootless : `permission denied` sur le bind, le même conteneur marche sur 8080 |
| `01-image-digest-mismatch.sh` | dans le registre du lab, le tag `app:latest` est réécrit vers une image dont l'entrypoint sort en erreur ; le digest d'origine est conservé dans une sauvegarde | le conteneur démarre puis sort en code 1 ; `skopeo inspect` montre un digest différent de celui noté en 2.1 |
| `01-containerd-cri-disabled.sh` | `disabled_plugins` de `config.toml` complété avec le plugin CRI, `systemctl restart containerd` | `crictl ps` : `connection refused` sur le socket CRI, `ctr` et `nerdctl` fonctionnent encore |
| `01-registry-untrusted-ca.sh` (optionnel) | certificat de la CA du registre retiré de `hosts.toml` / `registries.conf` | `pull` échoue en `x509: certificate signed by unknown authority`, `curl -k` sur le registre répond |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck, même convention que `break/gitops/01-argocd-*.sh`.
Les trois premiers sont obligatoires (un par section), le quatrième dépend de la question 5.

## Profil de lab et budget

- Chemin principal : `linux-base`, VM `linux-base-lx01` (Ubuntu 24.04, 2 vCPU / 4 Go / 40 Go, `10.10.10.11`). Le chapitre
  tient dans ce budget : containerd, `nerdctl`, BuildKit, un registre et `trivy` consomment moins de 1 Go au repos ;
  le cache d'images et la base `trivy` prennent environ 5 Go.
- Variante recommandée (question 3) : `linux-base-lx02` (Rocky 10, 2 vCPU / 4 Go / 40 Go) pour la section Podman avec le
  paquet de la distribution, comme à RHCSA/LFCS ; Ubuntu garde containerd/`nerdctl`, ce que Kubernetes utilise.
- Réseau : le registre écoute sur `10.10.10.11:5000`, nom `registry.lab.home.arpa` déjà prévu dans `labs/network.md` ;
  tant que `core-dns01` n'existe pas, une entrée `/etc/hosts` suffit. Variante Harbor : quand son placement sera décidé
  (`certifs/KCNA/objectifs.md` §2), le registre du chapitre devient un projet Harbor, les commandes ne changent pas.
- Accès Internet nécessaire pour les images de base et la base de vulnérabilités `trivy` ; le profil `airgap` n'est
  pas utilisé ici (renvoi vers un futur chapitre air-gap).

## Préalables à régler dans la PR du chapitre

- `versions.yaml` : créer `nerdctl` (dépôt `containerd/nerdctl`), `podman` (`containers/podman`), `trivy` (`aquasecurity/trivy`),
  `skopeo` (`containers/skopeo`), datasource `github-releases`. Versions lues le 2026-10-02 par les tags git des dépôts
  officiels (API GitHub bloquée, donc `verification: indirect`) : nerdctl **2.4.1**, podman **6.1.3**, trivy **0.75.0**,
  skopeo **1.24.1**. `buildah` (1.45.1) seulement si la question 2 retient la chaîne Podman pour le build.
- `containerd` existe (2.4.1). Pas de clé `docker` : voir question 2.
- `certifs/KCNA/objectifs.md` §3 (KCNA-01-04) et §4 (F1 → rédigé), `docs/prerequis.md` §6.2 (nœud `rédigé`) : ces fichiers
  n'existent que sur la branche de la cartographie KCNA (PR #44), pas encore sur `main`.

## Points de vigilance `versions.yaml`

- **containerd 2.x** : `config.toml` en version 3, plugins CRI renommés (`io.containerd.cri.v1.runtime`,
  `io.containerd.cri.v1.images`), registres configurés par `hosts.toml` dans `/etc/containerd/certs.d/` et plus par
  `registry.mirrors`. La majorité des tutoriels en ligne décrivent la 1.x : la fiche n'enseigne que la 2.x et signale l'écart.
  À vérifier avant rédaction : le paquet `containerd` d'Ubuntu 24.04 est en 1.7.x ; il faut le binaire upstream ou le dépôt
  Docker pour avoir la 2.4 de `versions.yaml` (question 6).
- **nerdctl 2.x** : exige containerd 2 et BuildKit pour `build` ; mode rootless par `containerd-rootless-setuptool.sh`.
  Choisir une seule variante (root ou rootless) pour la démo guidée, l'autre en exercice.
- **Podman 6.x upstream vs distribution** : Ubuntu 24.04 livre Podman 4.9 (à vérifier), Rocky 10 une 5.x (à vérifier).
  Les options et le comportement (`kube play`, Quadlet, cgroup v2 obligatoire depuis la 5) diffèrent. La fiche écrit
  la version réellement installée dans sa section « Points de vigilance » et cite la clé `podman` pour l'upstream.
- **cgroup v2** : par défaut sur Ubuntu 24.04 et Rocky 10, hypothèse de toute la section 1 ; Podman 5+ ne supporte plus v1.
- **trivy** : la base de vulnérabilités se télécharge depuis `ghcr.io` ; vérifier le proxy de sortie du lab, prévoir
  `trivy image --download-db-only` à la préparation de séance.
- **Kubernetes 1.37.1** : hors périmètre direct, mais le plugin CRI présenté en 3.1 doit être celui que F3 (kubeadm)
  réutilisera tel quel ; la matrice containerd / Kubernetes est à relire quand `kubernetes` bouge.

## `[lecture + simulation]`

- Multi-architecture (`arm64`) : le lab est `amd64` uniquement ; la liste de manifestes est lue avec `skopeo`, pas
  exécutée. Une émulation `qemu-user-static` est possible mais hors budget de 4 h.
- Docker Engine et dockershim : lecture seule, contexte historique attendu par le QCM ; pas d'installation (question 2).
- CRI-O : lecture seule, nommé comme l'autre runtime CRI courant ; installation renvoyée à une variante de F3 si utile.
- Sandboxes (gVisor, Kata) et signature d'images (cosign) : lecture seule, renvoi vers KCSA/CKS.
- Rien pour cause de matériel.

## Durée

4 h d'apprentissage, lecture ≤ 20 % (environ 45 min), le reste en manipulation :
section 1 ≈ 1 h, section 2 ≈ 1 h 30, section 3 ≈ 1 h 30, dont 28 min de défis chronométrés.

## Livrables attendus de la session de rédaction

- `fiches/kubernetes/01-conteneurs-et-images-oci.md` (gabarit `templates/fiche.md`) et
  `fiches/kubernetes/01-conteneurs-et-images-oci/` (Containerfile propre et « sale », application de démo, `pod-config.json`
  et `container-config.json` pour `crictl`, YAML Pod pour `podman kube play`, `hosts.toml` et `registries.conf` du registre)
- `solutions/fiches/kubernetes/01-conteneurs-et-images-oci.md` (3 indices puis correction commentée par exercice)
- `break/kubernetes/01-*.sh` (3 scripts, 1 optionnel)
- `revision/flashcards/kubernetes-01-conteneurs-et-images-oci.csv` (15 à 20 cartes)
- mises à jour : `versions.yaml`, `certifs/KCNA/objectifs.md`, `docs/prerequis.md` §6.2, ce plan avec `statut: validé`

## Questions dont la réponse change le plan

1. **Chapitre** : le prompt ne nommait pas de chemin ; `fiches/kubernetes/01-conteneurs-et-images-oci.md` (F1 KCNA) est
   l'hypothèse. Un autre chapitre ?
2. **Moteur de référence** : containerd + `nerdctl` (ce que Kubernetes utilise) et Podman (RHCSA/LFCS), Docker en lecture
   seule ; ou Docker en démo parce que la VM de `gitops/01` l'a déjà pour `kind` ? Le premier choix implique à terme
   de passer `kind` sur Podman ou `nerdctl` (fournisseur expérimental) ou de garder Docker sur cette VM sans l'enseigner.
3. **Une ou deux VM** : tout sur `lx01` Ubuntu, ou Podman sur `lx02` Rocky pour coller à l'environnement EL des examens Red Hat ?
4. **Langage de l'application de démo** : Go (binaire statique, image `scratch`, écart de taille spectaculaire) ou Python
   (plus proche des apps réelles, image finale plus grosse) ?
5. **Registre du lab** : conteneur `registry` en TLS avec un certificat de la CA interne (exige `core-pki01`, pas encore
   levé) ou en HTTP avec configuration « insecure » côté clients (plus simple, moins réaliste) ? Décide aussi du
   quatrième script de panne.
6. **Paquets distribution ou binaires upstream** : `versions.yaml` fixe containerd 2.4.1 et Podman 6.1.3, les distributions
   livrent plus ancien. Binaires upstream partout (versions maîtrisées, installation plus manuelle), ou paquets de la
   distribution avec la version réelle notée (plus proche d'un poste d'examen) ?
7. **Calendrier** : rédiger sur une branche partant de `main` après fusion de la PR #44 (cartographie KCNA), ou empiler
   sur la branche courante ?
