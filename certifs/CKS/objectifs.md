---
code: CKS
titre: "CKS — mapping compétences → chapitres"
programme: "certifs/CKS/programme.md (converti le 2026-10-02 depuis CKS_Curriculum v1.34.pdf, commit cncf/curriculum du 2025-10-30)"
chapitres_existants: 0
generated: 2026-10-02
status: "0 chapitre rédigé sur 15 ; à mettre à jour à chaque PR de chapitre"
---

# CKS — objectifs et couverture

Mapping entre les 26 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : aucun chapitre `securite` ni `kubernetes` n'existe ; les deux fiches `gitops` rédigées
touchent deux compétences de façon indirecte (section 3). Les 26 compétences sont donc des trous.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices »
et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| CKS-01 Cluster Setup | 15 % | 5 | 3,0 % | 3 fiches |
| CKS-02 Cluster Hardening | 15 % | 4 | 3,75 % | 2 fiches |
| CKS-03 System Hardening | 10 % | 4 | 2,5 % | 2 fiches |
| CKS-04 Minimize Microservice Vulnerabilities | 20 % | 4 | 5,0 % | 3 fiches |
| CKS-05 Supply Chain Security | 20 % | 4 | 5,0 % | 2 fiches |
| CKS-06 Monitoring, Logging and Runtime Security | 20 % | 5 | 4,0 % | 2 fiches |
| Transverse | — | 26 | — | 1 scénario + 1 examen blanc |

Convention de pondération : le programme CNCF ne pondère que les domaines ; le poids d'une compétence est
le poids du domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité
de révision, pas une donnée officielle. L'examen est pratique (15 à 20 tâches en 2 h, `examen.md`) :
une tâche vaut en général une compétence, parfois deux.

Ordre de rédaction recommandé (du plus lourd au plus léger, en respectant les prérequis) :
F2 RBAC et ServiceAccounts → F7 Pod Security Standards → F9 Secrets → F11 chaîne d'approvisionnement →
F13 Falco → F14 audit logs et immutabilité → F4 NetworkPolicy → F10 isolation et chiffrement →
F3 API server et upgrade → F6 CIS benchmark → F1 durcissement de l'hôte → F8 AppArmor et seccomp →
F5 Ingress TLS, métadonnées, binaires → F12 analyse statique → S1 scénario → examen blanc.

Ordre de **lecture** (numéros des fiches) : il suit les prérequis, pas le poids. F1 (débutant) ouvre la série ;
tout le reste est au niveau confirmé et suppose le bloc CKA (`kubernetes_conf`).

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- **Version d'examen** : `programme.md` est en 1.34 (PDF du dépôt `cncf/curriculum`, commit du 2025-10-30), alors que
  la page officielle de l'examen annonce un environnement « v1.35 » (extrait indirect, `examen.md` §1) et que le lab
  est en `kubernetes` 1.37. La veille (`prompts/07-veille.md`) doit trancher la version en vigueur et ajouter un champ
  `exam_version_cks` à l'entrée `kubernetes` de `versions.yaml` ; les fiches s'écrivent sur la version du lab et
  l'examen blanc (`exams/CKS/`) sur la version d'examen.
- `versions.yaml` : clés à créer (datasource `github-releases` sauf mention) : `kube_bench` (`aquasecurity/kube-bench`),
  `trivy` (`aquasecurity/trivy`), `cosign` (`sigstore/cosign`), `bom` (`kubernetes-sigs/bom`), `kubesec`
  (`controlplaneio/kubesec`), `kube_linter` (`stackrox/kube-linter`), `gvisor` (`google/gvisor`, tags datés),
  `syft` (`anchore/syft`, optionnel). Déjà présentes et réutilisées : `kubernetes`, `kubeadm`, `containerd`, `etcd`,
  `cilium`, `istio`, `kyverno`, `falco`, `tetragon`, `harbor`, `cert_manager`, `step_ca`, `openbao`, `kind`,
  `compliance_as_code`.
- `labs/profiles/kubernetes-ha.yaml` : ajouter `falco`, `kyverno`, `istio` (variante), `gvisor` à `components`.
  Harbor reste porté par `core-mirror01` du profil `airgap` (`can_run_with: kubernetes-ha`, budget RAM cumulé
  48 + 24 + 8 + 8 = 88 Go ≤ 128 Go).
- `break/securite/` : dossier à créer (un `README.md` d'une ligne, comme `break/kubernetes/`).
- `docs/prerequis.md` §6.2 : nœuds planifiés ajoutés par cette PR.
- Décisions à proposer dans la PR du chapitre concerné (pas ici) :
  - F5 : contrôleur Ingress pour l'objectif CKS-01-03. ingress-nginx est retiré (DECISIONS.md 2026-10-02) ; proposer le
    contrôleur Ingress intégré à Cilium (`ingressController.enabled=true`) et garder Gateway API en chemin principal.
  - F10 : runtime sandbox par défaut gVisor (`runsc`, fonctionne dans une VM sans virtualisation imbriquée) ; Kata Containers
    en `[lecture + simulation]` tant que la virtualisation imbriquée n'est pas activée sur Proxmox.
  - F10 : chiffrement pod-à-pod par Cilium WireGuard (CNI déjà en place), Istio ambient en variante car l'examen cite les deux.
- Les compétences CKA sous-jacentes (créer une NetworkPolicy, un Role, faire un `kubeadm upgrade`) relèvent de la
  cartographie CKA (`certifs/CKA/objectifs.md`, à produire). Les fiches CKS les supposent acquises et prennent l'angle
  « durcissement » ; si le bloc CKA n'est pas encore rédigé, chaque fiche CKS rappelle le minimum en démo guidée.

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. « indirect » = une fiche d'un autre domaine manipule
la notion sans viser la compétence ; ne compte pas comme couverture. La colonne « chapitre cible » renvoie à la section 4.

### CKS-01 — Cluster Setup (15 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKS-01-01 | Use Network security policies to restrict cluster level access | 3,0 % | — | — | F4 |
| CKS-01-02 | Use CIS benchmark to review the security configuration of Kubernetes components (etcd, kubelet, kubedns, kubeapi) | 3,0 % | — | — | F6 |
| CKS-01-03 | Properly set up Ingress objects with TLS | 3,0 % | — | — | F5 |
| CKS-01-04 | Protect node metadata and endpoints | 3,0 % | — | — | F5 |
| CKS-01-05 | Verify platform binaries before deploying | 3,0 % | — | — | F5 |

### CKS-02 — Cluster Hardening (15 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKS-02-01 | Use Role Based Access Controls to minimize exposure | 3,75 % | indirect : `fiches/gitops/02-argo-workflows-fondamentaux.md` | S1 : Role minimal `wf-runner`, break-fix `02-argo-workflows-rbac.sh` | F2 |
| CKS-02-02 | Exercise caution in using service accounts e.g. disable defaults, minimize permissions on newly created ones | 3,75 % | indirect : `fiches/gitops/02-argo-workflows-fondamentaux.md` | S1 : ServiceAccount dédié au lieu de `default` | F2 |
| CKS-02-03 | Restrict access to Kubernetes API | 3,75 % | — | — | F3 |
| CKS-02-04 | Upgrade Kubernetes to avoid vulnerabilities | 3,75 % | — | — | F3 |

### CKS-03 — System Hardening (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKS-03-01 | Minimize host OS footprint (reduce attack surface) | 2,5 % | — | — | F1 |
| CKS-03-02 | Using least-privilege identity and access management | 2,5 % | — | — | F1 |
| CKS-03-03 | Minimize external access to the network | 2,5 % | — | — | F1 |
| CKS-03-04 | Appropriately use kernel hardening tools such as AppArmor, seccomp | 2,5 % | — | — | F1 (hôte), F8 (pods) |

### CKS-04 — Minimize Microservice Vulnerabilities (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKS-04-01 | Use appropriate pod security standards | 5,0 % | — | — | F7 |
| CKS-04-02 | Manage kubernetes secrets | 5,0 % | indirect : `fiches/gitops/01-argo-cd-fondamentaux.md` | S1 : suppression de `argocd-initial-admin-secret` | F9 |
| CKS-04-03 | Understand and implement isolation techniques (multi-tenancy, sandboxed containers, etc.) | 5,0 % | — | — | F10 |
| CKS-04-04 | Implement Pod-to-Pod encryption (Cilium, Istio) | 5,0 % | — | — | F10 |

### CKS-05 — Supply Chain Security (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKS-05-01 | Minimize base image footprint | 5,0 % | — | — | F11 |
| CKS-05-02 | Understand your supply chain (e.g. SBOM, CI/CD, artifact repositories) | 5,0 % | — | — | F11 |
| CKS-05-03 | Secure your supply chain (permitted registries, sign and validate artifacts, etc.) | 5,0 % | — | — | F11 |
| CKS-05-04 | Perform static analysis of user workloads and container images (e.g. Kubesec, KubeLinter) | 5,0 % | — | — | F12 |

### CKS-06 — Monitoring, Logging and Runtime Security (20 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| CKS-06-01 | Perform behavioral analytics to detect malicious activities | 4,0 % | — | — | F13 |
| CKS-06-02 | Detect threats within physical infrastructure, apps, networks, data, users and workloads | 4,0 % | — | — | F13 |
| CKS-06-03 | Investigate and identify phases of attack and bad actors within the environment | 4,0 % | — | — | F13 |
| CKS-06-04 | Ensure immutability of containers at runtime | 4,0 % | — | — | F14 (et F7 pour `readOnlyRootFilesystem`) |
| CKS-06-05 | Use Kubernetes audit logs to monitor access | 4,0 % | — | — | F14 |

### Compétences partagées avec KCSA et CKA

KCSA se passe avant CKS dans le même bloc (`docs/prerequis.md`, parcours Kubestronaut, jalon `securite_conf`) ;
CKA est le prérequis officiel. Les chapitres ci-dessous citent les IDs KCSA et CKA dans leur front matter pour
éviter un doublon. Les cartographies KCSA et CKA seront faites par leur propre session `prompts/01-cartographie-certification.md`
et pourront ajouter leurs propres fiches (lecture, modèle de menace) sans toucher à celles-ci.

| Chapitre | IDs CKS | IDs KCSA réutilisables | IDs CKA réutilisables |
|---|---|---|---|
| F1 Durcissement de l'hôte | CKS-03-01 à 03-04 | KCSA-02-04, 02-05 | — |
| F2 RBAC et ServiceAccounts | CKS-02-01, 02-02 | KCSA-03-03, 02-10 | CKA-05-01 |
| F3 API server et upgrade | CKS-02-03, 02-04 | KCSA-02-01, 02-10 | CKA-05-04 |
| F4 NetworkPolicy | CKS-01-01 | KCSA-03-07, 03-05, 02-09 | CKA-03-02 |
| F5 Ingress TLS, métadonnées, binaires | CKS-01-03 à 01-05 | KCSA-05-05, 05-06 | CKA-03-04, 03-05 |
| F6 CIS benchmark | CKS-01-02 | KCSA-02-01 à 02-08, 06-01, 06-04 | CKA-04-02 |
| F7 Pod Security Standards | CKS-04-01 | KCSA-03-01, 03-02, 05-07 | CKA-02-05 |
| F8 AppArmor et seccomp pour les pods | CKS-03-04 | KCSA-02-05, 02-07 | — |
| F9 Secrets | CKS-04-02 | KCSA-03-04, 02-08, 04-06 | CKA-02-02 |
| F10 Isolation et chiffrement pod-à-pod | CKS-04-03, 04-04 | KCSA-01-04, 03-05, 05-04, 04-05 | — |
| F11 Chaîne d'approvisionnement | CKS-05-01 à 05-03 | KCSA-01-05, 05-01, 05-02, 06-03 | — |
| F12 Analyse statique | CKS-05-04 | KCSA-01-06, 06-04 | — |
| F13 Falco | CKS-06-01 à 06-03 | KCSA-04-04, 04-07, 05-03 | — |
| F14 Audit logs et immutabilité | CKS-06-04, 06-05 | KCSA-03-06, 04-02 | CKA-04-04 |

Les compétences Cilium (CCA), Kyverno (KCA) et Istio (ICA) touchées par F4, F10 et F11 seront reliées par leurs cartographies.

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de lecture recommandé (DECISIONS.md, 2026-10-02) et vivent dans `fiches/securite/`
(domaine `securite`, certifications KCSA, CKS, VA, KCA dans `docs/prerequis.md` §1).
Profil principal : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go, `labs/profiles/kubernetes-ha.yaml`), cluster kubeadm,
CNI Cilium, trois control planes et trois workers accessibles en SSH, comme à l'examen.
Tant que `lab up kubernetes-ha` n'existe pas, les fiches marquées « kind : oui » ont pour chemin principal un cluster
`kind` sur une VM du profil `linux-base` (8 vCPU / 16 Go / 180 Go) ; « kind : partiel » signifie que les sections qui
touchent au système des nœuds ou aux static pods sont faisables mais plus fragiles ; « kind : non » exige le profil complet.
Les durées sont des estimations d'apprentissage (lecture ≤ 20 %, le reste en manipulation), pas de rédaction.
Chaque fiche se termine par un défi au format examen : énoncé en anglais, contexte `kubectl config use-context`,
hôte désigné, minuteur.

### F1 — `fiches/securite/01-durcissement-hote-linux.md`

- **Titre** : Durcir un hôte Linux — surface d'attaque, comptes, réseau, AppArmor et seccomp
- **Niveau** : débutant (`securite_deb`)
- **Couvre** : CKS-03-01, CKS-03-02, CKS-03-03, CKS-03-04 (partie hôte)
- **Prérequis** : `linux_deb` (systemd, paquets, utilisateurs, SSH) ; `reseau_deb` recommandé (ports, nftables)
- **Lab** : `linux-base` (`linux-base-lx01` Ubuntu, `linux-base-lx02` Rocky pour la variante EL). kind : sans objet.
  Clés `versions.yaml` : `ubuntu_lts`, `rocky_linux`, `compliance_as_code` (variante OpenSCAP).
- **Temps** : 4 h
- **3 exercices clés** :
  1. Inventorier et réduire : `systemctl list-units --type=service`, `ss -lntup`, `apt list --installed`, désactiver et
     masquer les services inutiles, retirer les paquets, désactiver un module noyau (`/etc/modprobe.d/`), vérifier avec
     un second `ss` — CKS-03-01.
  2. Comptes à moindre privilège : utilisateur de service sans shell, `sudoers` ciblé (`NOPASSWD` sur une commande),
     SSH par clé seule (`PasswordAuthentication no`, `PermitRootLogin no`), `AllowUsers`, vérifier avec `sshd -T` — CKS-03-02.
  3. Réseau et noyau : pare-feu nftables/ufw en deny-all entrant sauf SSH et le port kubelet, `aa-status`,
     `aa-enforce` d'un profil fourni, `aa-complain` et lecture de `/var/log/syslog`, `SystemCallFilter=` d'un service
     systemd comme première rencontre avec seccomp — CKS-03-03, CKS-03-04.
- **Break-fix** : `break/securite/01-hote-port-ouvert.sh` (service inconnu en écoute sur toutes les interfaces, profil
  AppArmor passé en complain).
- **Défi chronométré** : réduire un hôte livré « gras » à SSH + kubelet en écoute, root interdit en SSH, profil AppArmor
  en enforce, en moins de 15 min.

### F2 — `fiches/securite/02-rbac-serviceaccounts-moindre-privilege.md`

- **Titre** : RBAC et ServiceAccounts — moindre privilège sur l'API Kubernetes
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-02-01, CKS-02-02
- **Prérequis** : `kubernetes_conf` (RBAC de base, CKA-05-01), F1 recommandé
- **Lab** : `kubernetes-ha` ; kind : oui. Clés `versions.yaml` : `kubernetes`, `kind`, `cilium`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Auditer l'existant : `kubectl auth can-i --list --as=system:serviceaccount:ns:sa`, `kubectl auth whoami`,
     repérer les ClusterRoleBindings vers `cluster-admin`, les verbes `*`, les droits `escalate`/`bind`/`impersonate`,
     réduire un ClusterRole trop large en Role par namespace — CKS-02-01.
  2. ServiceAccounts : `automountServiceAccountToken: false` sur le ServiceAccount `default` et sur les pods, ServiceAccount
     dédié par workload, jeton projeté à durée courte (`projected` volume, `expirationSeconds`, `audience`),
     `kubectl create token`, lecture d'un JWT, révocation — CKS-02-02.
  3. Vérifier par l'attaque : depuis un pod, lire `/var/run/secrets/kubernetes.io/serviceaccount/token` et appeler l'API avec
     `curl --cacert`, constater ce que le jeton permet, corriger, re-tester — CKS-02-01, CKS-02-02.
- **Break-fix** : `break/securite/02-rbac-sa-trop-large.sh` (ServiceAccount applicatif lié à `cluster-admin`, pods avec
  jeton monté par défaut).
- **Défi chronométré** : donner à un ServiceAccount le strict droit de lister les pods d'un namespace, jeton non monté
  ailleurs, vérifié par `auth can-i`, en moins de 8 min.

### F3 — `fiches/securite/03-api-server-acces-restreint-upgrade.md`

- **Titre** : API server — restreindre l'accès et mettre à niveau pour corriger une CVE
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-02-03, CKS-02-04
- **Prérequis** : F2 ; `kubernetes_conf` (kubeadm, static pods, CKA-05-03, 05-04)
- **Lab** : `kubernetes-ha` (trois control planes pour un upgrade HA réel) ; kind : partiel (flags de l'API server oui,
  upgrade non). Clés `versions.yaml` : `kubernetes`, `kubeadm`, `containerd`, `etcd`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Fermer les accès : `--anonymous-auth=false`, `--authorization-mode=Node,RBAC` (jamais `AlwaysAllow`),
     `--enable-admission-plugins=NodeRestriction`, `--insecure-port` absent, `--profiling=false`, kubelet
     `authentication.anonymous.enabled=false` et `authorization.mode=Webhook`, redémarrage du static pod et vérification
     avec `curl -k https://<vip>:6443/version` — CKS-02-03.
  2. Clients : kubeconfig par utilisateur signé par la CA du cluster (CSR `kubernetes.io/kube-apiserver-client`,
     `kubectl certificate approve`), expiration courte, retrait d'un accès, exposition réseau de l'API limitée par
     NetworkPolicy et pare-feu (lien F1, F4) — CKS-02-03.
  3. Mettre à niveau un cluster kubeadm de `n-1` à `n` (plan, control plane 1 puis 2 et 3, `drain`, kubelet, `uncordon`),
     lire une annonce CVE Kubernetes (`kubernetes-security-announce`) et dire si le cluster est concerné — CKS-02-04.
- **Break-fix** : `break/securite/03-apiserver-anonymous.sh` (`--anonymous-auth=true` et `AlwaysAllow` réintroduits dans
  le manifest du static pod).
- **Défi chronométré** : corriger un API server ouvert et mettre à niveau un control plane d'une version mineure
  en moins de 20 min.

### F4 — `fiches/securite/04-network-policies-deny-par-defaut.md`

- **Titre** : NetworkPolicy — deny par défaut, egress contrôlé, sélecteurs de namespace
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-01-01
- **Prérequis** : `kubernetes_conf` (NetworkPolicy de base, CKA-03-02), `reseau_conf` recommandé
- **Lab** : `kubernetes-ha` (Cilium) ; kind : oui à condition d'installer Cilium (kindnet n'applique pas les NetworkPolicy).
  Clés `versions.yaml` : `kubernetes`, `cilium`, `kind`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Deny-all ingress et egress par namespace, puis autoriser DNS (UDP/TCP 53 vers `kube-system`), tester avec un pod
     `netshoot` et `kubectl exec ... -- nc -zv` — CKS-01-01.
  2. Politiques ciblées : `podSelector` + `namespaceSelector` (label `kubernetes.io/metadata.name`), `ipBlock` avec `except`,
     ports nommés, combinaison ET/OU des règles `from` ; lire l'effet avec `cilium policy get` / Hubble — CKS-01-01.
  3. Cas d'examen : isoler un namespace entier sauf un backend précis, interdire l'egress Internet sauf un CIDR,
     diagnostiquer une NetworkPolicy qui bloque trop (ordre d'évaluation, politique additive) — CKS-01-01.
- **Break-fix** : `break/securite/04-netpol-dns-bloque.sh` (deny-all egress sans exception DNS, résolution en échec).
- **Défi chronométré** : deny par défaut sur un namespace et trois autorisations ciblées, vérifiées par `nc`, en moins de 10 min.

### F5 — `fiches/securite/05-ingress-tls-metadata-binaires.md`

- **Titre** : Cluster Setup — Ingress avec TLS, métadonnées de nœud, vérification des binaires
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-01-03, CKS-01-04, CKS-01-05
- **Prérequis** : F4 ; `kubernetes_conf` (Services, Gateway API, CKA-03-04, 03-05) ; `services_deb` (PKI interne step-ca,
  cert-manager)
- **Lab** : `kubernetes-ha` (Gateway API Cilium par défaut, contrôleur Ingress Cilium pour l'objectif d'examen) ;
  kind : oui (exposition par `port-forward`). Clés `versions.yaml` : `kubernetes`, `cilium`, `cert_manager`, `step_ca`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Ingress TLS : Secret `kubernetes.io/tls` créé à la main (`openssl`), puis émis par cert-manager depuis la CA interne,
     objet `Ingress` avec `tls:` et `rules:`, test `curl --resolve ... --cacert`, puis le même service en `Gateway` +
     `HTTPRoute` avec `tls.certificateRefs` — CKS-01-03.
  2. Métadonnées de nœud : simuler un service de métadonnées `169.254.169.254` (pod `hostNetwork` ou service sur un nœud),
     constater qu'un pod y accède, le bloquer par NetworkPolicy egress `ipBlock` avec `except`, puis protéger le
     kubelet (`--read-only-port=0`, `--anonymous-auth=false`) `[simulation : pas de fournisseur cloud sur le lab]` — CKS-01-04.
  3. Binaires : télécharger `kubectl`, `kubeadm`, `kubelet` et l'archive `kubernetes-server` de la version `kubernetes`,
     vérifier `sha256sum` contre `dl.k8s.io/release/<v>/bin/linux/amd64/*.sha256`, comparer avec un binaire altéré,
     vérifier la signature d'une image (`cosign verify`, lien F11) — CKS-01-05.
- **Break-fix** : `break/securite/05-ingress-tls-cert-expire.sh` (Secret TLS remplacé par un certificat expiré, `curl` en échec).
- **Défi chronométré** : exposer un service en HTTPS avec un certificat fourni et bloquer l'egress vers
  `169.254.169.254` en moins de 12 min.

### F6 — `fiches/securite/06-cis-benchmark-kube-bench.md`

- **Titre** : CIS Kubernetes Benchmark — auditer et corriger avec kube-bench
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-01-02
- **Prérequis** : F3 (flags de l'API server et du kubelet), F1
- **Lab** : `kubernetes-ha` (nœuds kubeadm réels, chemins `/etc/kubernetes/manifests`, `/var/lib/kubelet`) ; kind : partiel.
  Clés `versions.yaml` : `kube_bench` (à créer), `kubernetes`, `etcd`. Le document CIS lui-même n'est pas committé
  (DECISIONS.md 2026-10-02) : on travaille sur les contrôles tels que kube-bench les restitue.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Lancer kube-bench en Job sur un control plane et un worker, lire `FAIL`/`WARN`, retrouver le contrôle dans la
     sortie (`1.2.x` API server, `1.3.x` controller manager, `2.x` etcd, `4.2.x` kubelet) — CKS-01-02.
  2. Corriger cinq échecs typiques : permissions `/etc/kubernetes/manifests/*.yaml` (`644`, `root:root`), `--profiling`,
     `--audit-log-*`, etcd `--client-cert-auth`, kubelet `--protect-kernel-defaults`, `--rotate-certificates`,
     `streamingConnectionIdleTimeout`, relancer kube-bench et mesurer le gain — CKS-01-02.
  3. kubedns/CoreDNS : vérifier la ConfigMap `coredns` (plugins exposés, `health`, `ready`), restreindre l'accès aux
     métriques, comparer avec un rapport kube-bench sur un cluster `kind` — CKS-01-02.
- **Break-fix** : `break/securite/06-cis-etcd-sans-auth.sh` (etcd en `--client-cert-auth=false`, manifests en `666`).
- **Défi chronométré** : passer trois contrôles CIS de `FAIL` à `PASS` sur un control plane en moins de 15 min.

### F7 — `fiches/securite/07-pod-security-standards-securitycontext.md`

- **Titre** : Pod Security Standards — Pod Security Admission et securityContext
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-04-01 (et CKS-06-04 pour `readOnlyRootFilesystem`)
- **Prérequis** : F2 ; `kubernetes_conf` (admission, CKA-02-05)
- **Lab** : `kubernetes-ha` ; kind : oui. Clés `versions.yaml` : `kubernetes`, `kind`, `kyverno` (variante).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Labels PSA par namespace (`pod-security.kubernetes.io/enforce|audit|warn` et `-version`), niveaux `privileged`,
     `baseline`, `restricted`, lire les refus (`kubectl apply` et événements), `--dry-run=server` pour tester — CKS-04-01.
  2. Rendre un pod conforme à `restricted` : `runAsNonRoot`, `runAsUser`, `allowPrivilegeEscalation: false`,
     `capabilities.drop: [ALL]`, `seccompProfile: RuntimeDefault`, `readOnlyRootFilesystem: true` avec `emptyDir` pour
     les répertoires d'écriture — CKS-04-01, CKS-06-04.
  3. Politique par défaut du cluster : `AdmissionConfiguration` du plugin `PodSecurity` (`defaults`, `exemptions`),
     fichier passé à l'API server par `--admission-control-config-file`, puis variante Kyverno `validate` pour une règle
     que PSA ne couvre pas (registre imposé, lien F11) — CKS-04-01.
- **Break-fix** : `break/securite/07-pss-namespace-privileged.sh` (namespace applicatif repassé en `enforce=privileged`,
  pod `privileged: true` admis).
- **Défi chronométré** : rendre un namespace `restricted` et corriger un Deployment refusé en moins de 10 min.

### F8 — `fiches/securite/08-apparmor-seccomp-pods.md`

- **Titre** : AppArmor et seccomp appliqués aux pods
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-03-04
- **Prérequis** : F1 (AppArmor et seccomp côté hôte), F7 (`securityContext`)
- **Lab** : `kubernetes-ha` (profils chargés sur les workers Ubuntu, `/var/lib/kubelet/seccomp/`) ; kind : partiel
  (profils seccomp oui, AppArmor dépend de l'hôte). Clés `versions.yaml` : `kubernetes`, `containerd`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. AppArmor : écrire un profil qui interdit l'écriture dans `/`, le charger sur chaque worker (`apparmor_parser -r`,
     `aa-status`), l'appliquer par `securityContext.appArmorProfile: {type: Localhost, localhostProfile: ...}`,
     observer le refus dans le pod, comparer avec `RuntimeDefault` et `Unconfined`, et connaître l'ancienne annotation — CKS-03-04.
  2. seccomp : profil JSON `defaultAction: SCMP_ACT_ERRNO` + liste blanche, déposé sous `/var/lib/kubelet/seccomp/profiles/`,
     appliqué par `seccompProfile: {type: Localhost}`, construit à partir d'un `strace -c` ou d'un profil `SCMP_ACT_LOG`
     et de `journalctl -k` — CKS-03-04.
  3. Capacités et contexte : retirer `ALL` puis rajouter `NET_BIND_SERVICE`, `privileged` vs `hostPID`/`hostNetwork`,
     mesurer ce que chaque réglage ferme avec `capsh --print` et `grep Cap /proc/1/status` — CKS-03-04.
- **Break-fix** : `break/securite/08-apparmor-profil-absent.sh` (pod en `CreateContainerError`, profil non chargé sur un worker).
- **Défi chronométré** : charger un profil AppArmor fourni sur un nœud désigné et l'appliquer à un pod existant,
  profil seccomp `RuntimeDefault` sur un second, en moins de 10 min.

### F9 — `fiches/securite/09-secrets-chiffrement-etcd.md`

- **Titre** : Secrets Kubernetes — usage sûr et chiffrement au repos dans etcd
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-04-02
- **Prérequis** : F2 (RBAC sur les Secrets), F3 (static pod de l'API server) ; `kubernetes_conf` (CKA-02-02)
- **Lab** : `kubernetes-ha` ; kind : oui (static pod édité dans le conteneur nœud). Clés `versions.yaml` : `kubernetes`,
  `etcd`, `openbao` (variante External Secrets / CSI).
- **Temps** : 5 h
- **3 exercices clés** :
  1. Créer et consommer : `kubectl create secret generic|tls|docker-registry`, montage en volume (préféré) vs variables
     d'environnement, `immutable: true`, décodage `base64`, lecture directe dans etcd avec `etcdctl get /registry/secrets/...`
     (certificats etcd du control plane) pour constater le clair — CKS-04-02.
  2. Chiffrer au repos : `EncryptionConfiguration` (`aescbc` ou `secretbox`, `identity` en dernier), flag
     `--encryption-provider-config`, redémarrage de l'API server, `kubectl get secrets -A -o json | kubectl replace -f -`
     pour rechiffrer, vérifier le préfixe `k8s:enc:` dans etcd, rotation de clé ; KMS v2 `[lecture + simulation]` — CKS-04-02.
  3. Limiter l'exposition : RBAC sans `list`/`watch` sur les Secrets, ServiceAccount sans jeton, Secret par
     namespace, variante OpenBao (secret injecté par CSI ou External Secrets Operator) pour sortir le secret du
     dépôt Git — CKS-04-02.
- **Break-fix** : `break/securite/09-secret-en-clair-etcd.sh` (chiffrement retiré, secret lisible dans etcd, pod qui
  l'expose en variable d'environnement et dans ses logs).
- **Défi chronométré** : activer le chiffrement `aescbc`, rechiffrer tous les Secrets et le prouver avec `etcdctl`
  en moins de 15 min.

### F10 — `fiches/securite/10-isolation-sandbox-chiffrement-pod-a-pod.md`

- **Titre** : Isolation — multi-tenant, conteneurs sandbox (gVisor) et chiffrement pod-à-pod (Cilium, Istio)
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-04-03, CKS-04-04
- **Prérequis** : F4, F7, F8 ; `reseau_conf`
- **Lab** : `kubernetes-ha` (runsc installé sur les workers, Cilium WireGuard, Istio ambient en variante) ; kind : partiel
  (WireGuard oui, gVisor fragile). Clés `versions.yaml` : `gvisor` (à créer), `containerd`, `cilium`, `istio`.
- **Temps** : 6 h
- **3 exercices clés** :
  1. Multi-tenant : un namespace par équipe, `ResourceQuota`, `LimitRange`, NetworkPolicy deny par défaut, RBAC par
     namespace, `nodeSelector`/`taints` pour dédier des nœuds ; expliquer les limites (noyau partagé) — CKS-04-03.
  2. Sandbox : installer `runsc` et le shim sur un worker, déclarer le handler dans `containerd`, créer la `RuntimeClass`
     `gvisor`, lancer un pod avec `runtimeClassName`, prouver l'isolation (`dmesg`, `uname -r` différent) ; Kata
     `[lecture + simulation]` — CKS-04-03.
  3. Chiffrement : activer `encryption.type=wireguard` dans Cilium, vérifier avec `cilium encrypt status` et une
     capture `tcpdump` sur le VLAN overlay (trafic UDP 51871 illisible) ; puis Istio ambient avec `PeerAuthentication`
     `STRICT` et vérification mTLS par `istioctl` — CKS-04-04.
- **Break-fix** : `break/securite/10-runtimeclass-handler-absent.sh` (RuntimeClass pointant vers un handler inconnu,
  pods en `ContainerCreating`).
- **Défi chronométré** : exécuter un pod existant sous gVisor et prouver le chiffrement WireGuard entre deux pods
  en moins de 15 min.

### F11 — `fiches/securite/11-images-minimales-sbom-signature-registres.md`

- **Titre** : Chaîne d'approvisionnement — images minimales, SBOM, signature, registres autorisés
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-05-01, CKS-05-02, CKS-05-03
- **Prérequis** : F7 ; `gitops_deb` recommandé (Argo Workflows pour le build, `fiches/gitops/02-argo-workflows-fondamentaux.md`)
- **Lab** : `kubernetes-ha` + `airgap` (Harbor sur `core-mirror01`, `can_run_with` vérifié) ; kind : oui avec un registre
  local en variante. Clés `versions.yaml` : `trivy`, `cosign`, `bom`, `syft` (à créer), `harbor`, `kyverno`, `kubernetes`.
- **Temps** : 7 h
- **3 exercices clés** :
  1. Réduire l'image : Dockerfile multi-stage, base `distroless`/`scratch`/Alpine, `USER` non root, pas de shell ni de
     gestionnaire de paquets, comparer taille et CVE avec `trivy image` avant/après — CKS-05-01.
  2. Connaître sa chaîne : générer un SBOM (`bom generate`, `syft`), l'attacher à l'image, scanner le SBOM, lire un
     `Dockerfile` et un pipeline pour repérer les dépendances non épinglées (`:latest`, digest absent) — CKS-05-02.
  3. Sécuriser : signer avec `cosign sign` (clé locale), vérifier `cosign verify`, pousser sur Harbor, imposer le registre
     et la signature à l'admission (`ImagePolicyWebhook` avec `AdmissionConfiguration` tel que l'examen le demande, puis
     Kyverno `verifyImages`), images par digest — CKS-05-03.
- **Break-fix** : `break/securite/11-image-non-signee-admise.sh` (webhook d'admission en `defaultAllow: true`, image
  `:latest` d'un registre public admise).
- **Défi chronométré** : configurer un `ImagePolicyWebhook` à partir de fichiers fournis et faire refuser une image
  hors registre en moins de 15 min.

### F12 — `fiches/securite/12-analyse-statique-kubesec-kubelinter.md`

- **Titre** : Analyse statique des manifests et des images — Kubesec, KubeLinter, Trivy
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-05-04
- **Prérequis** : F7, F11
- **Lab** : poste de travail ou `linux-base-lx01` (outils en CLI), cluster facultatif pour appliquer les corrections ;
  kind : oui. Clés `versions.yaml` : `kubesec`, `kube_linter`, `trivy` (à créer).
- **Temps** : 3 h
- **3 exercices clés** :
  1. `kubesec scan` sur un Deployment : lire le score, les `critical`/`advise`, corriger jusqu'à un score positif — CKS-05-04.
  2. `kube-linter lint` sur un dossier de manifests et un chart Helm : activer/désactiver des checks par fichier de
     configuration, intégrer dans un pre-commit ou un job CI (Argo Workflows) — CKS-05-04.
  3. `trivy config` et `trivy image --severity HIGH,CRITICAL` dans le même pipeline, seuil d'échec, rapport SARIF ;
     comparer ce que chaque outil voit et ne voit pas — CKS-05-04.
- **Break-fix** : `break/securite/12-manifest-dangereux.sh` (manifest avec `privileged`, `hostPID`, image `:latest`, à faire
  passer au vert).
- **Défi chronométré** : trouver et corriger quatre défauts d'un manifest fourni avec Kubesec en moins de 8 min.

### F13 — `fiches/securite/13-falco-detection-runtime.md`

- **Titre** : Falco — détecter et investiguer un comportement malveillant à l'exécution
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-06-01, CKS-06-02, CKS-06-03
- **Prérequis** : F8 (syscalls, capacités), F7 ; `observabilite_deb` recommandé (Loki/Prometheus pour les sorties)
- **Lab** : `kubernetes-ha` (Falco en DaemonSet, sonde `modern_ebpf`, Tetragon en variante) ; kind : partiel.
  Clés `versions.yaml` : `falco`, `tetragon`, `kubernetes`, `loki` (variante).
- **Temps** : 6 h
- **3 exercices clés** :
  1. Installer Falco (Helm 4, `modern_ebpf`), lire `/etc/falco/falco_rules.yaml`, déclencher les règles par défaut
     (shell dans un conteneur, lecture de `/etc/shadow`, écriture sous `/bin`), lire les alertes avec `kubectl logs`
     et `journalctl -u falco` sur l'hôte — CKS-06-01.
  2. Écrire une règle : `macro`, `list`, `rule` avec `condition`, `output` formaté (`%container.id %proc.cmdline %user.name`),
     `priority`, surcharge dans `falco_rules.local.yaml`, format de sortie texte vs JSON, `falcoctl` — CKS-06-01, CKS-06-02.
  3. Investiguer : un pod « compromis » fourni (reverse shell, mineur, exfiltration) ; reconstituer les phases
     (accès initial, exécution, persistance, mouvement latéral) à partir de Falco, des audit logs (F14), de
     `crictl`, `ps`, `ss` et des NetworkPolicy ; isoler puis supprimer le pod ; menaces sur l'infrastructure physique
     `[lecture]` — CKS-06-02, CKS-06-03.
- **Break-fix** : `break/securite/13-falco-regle-muette.sh` (règle désactivée par surcharge, shell dans un conteneur sans alerte).
- **Défi chronométré** : identifier le pod qui lance un shell et exfiltre, produire un log Falco au format demandé
  en moins de 12 min.

### F14 — `fiches/securite/14-audit-logs-immutabilite.md`

- **Titre** : Audit logs de l'API server et immutabilité des conteneurs
- **Niveau** : confirmé (`securite_conf`)
- **Couvre** : CKS-06-04, CKS-06-05
- **Prérequis** : F3 (static pod de l'API server), F7 (`securityContext`)
- **Lab** : `kubernetes-ha` ; kind : partiel. Clés `versions.yaml` : `kubernetes`, `loki` (variante d'export).
- **Temps** : 4 h
- **3 exercices clés** :
  1. `Policy` d'audit : niveaux `None`/`Metadata`/`Request`/`RequestResponse`, `omitStages`, règles par `resources`,
     `namespaces`, `users`, `verbs` ; flags `--audit-policy-file`, `--audit-log-path`, `--audit-log-maxage`,
     `--audit-log-maxbackup`, `--audit-log-maxsize` et le `hostPath` à monter dans le static pod ; lecture avec `jq` — CKS-06-05.
  2. Enquête : retrouver qui a lu un Secret, qui a supprimé un Deployment, quelle ServiceAccount appelle l'API hors
     horaires ; backend webhook vers Loki ou Falco `[lecture + simulation]` — CKS-06-05.
  3. Immutabilité : `readOnlyRootFilesystem: true`, `emptyDir` pour les écritures nécessaires, interdire `kubectl exec`
     par RBAC, `startupProbe` plutôt que `postStart` qui modifie l'image, prouver avec Falco qu'aucune écriture
     n'a lieu — CKS-06-04.
- **Break-fix** : `break/securite/14-audit-policy-invalide.sh` (policy YAML invalide, API server qui ne redémarre pas,
  `crictl logs` comme seule piste).
- **Défi chronométré** : activer l'audit avec une policy fournie, montages inclus, et retrouver une action précise
  dans le log en moins de 12 min.

### S1 — `scenarios/NN-durcir-un-cluster-livre/README.md`

- **Titre** : NN — Durcir un cluster livré par un intégrateur : audit, correction, preuve (numéro `NN` attribué à la création)
- **Niveau** : expert (`securite_exp`) ; prérequis F1 à F14 complets, pas de saut direct
- **Couvre** : les 26 compétences CKS en situation, plus KCSA-04-01 à 04-07 (modèle de menace)
- **Lab** : `kubernetes-ha` + `airgap` (Harbor), Falco, Loki. Clés `versions.yaml` : `kubernetes`, `cilium`, `falco`,
  `kube_bench`, `trivy`, `cosign`, `harbor`, `kyverno`.
- **Temps** : 8 h en deux séances
- **Livrable** : rapport d'audit « constat → correctif → preuve » (gabarit « exigence → contrôle → preuve » du parcours
  SecNumCloud) + postmortem d'une compromission simulée
- **3 exercices clés** :
  1. Un cluster livré avec quinze défauts injectés (`cluster-admin` généralisé, API anonyme, secrets en clair, images
     `:latest` non signées, pas de NetworkPolicy, pas d'audit, PSA absent…) : kube-bench, Trivy, Kubesec et lecture
     manuelle pour tout lister en moins de 45 min.
  2. Corriger dans l'ordre de risque, sans casser les applications métier (tests de non-régression fournis), en gardant
     une trace par commit dans le dépôt GitOps du lab.
  3. Break-fix transverse : pod compromis actif pendant la correction ; détecter (Falco), reconstituer (audit logs),
     isoler (NetworkPolicy), éradiquer, puis rédiger le postmortem en moins de 30 min.

### Examen blanc — `exams/CKS/mock-01/`

Produit par `prompts/06-examen-blanc.md` après S1 : 16 tâches en anglais, 2 h, `setup.sh` qui prépare les namespaces et
les défauts, `grade.sh` qui note (seuil 67 %, `examen.md`), sur la version d'examen. Complète les deux sessions
killer.sh incluses dans l'achat de l'examen ; ne les remplace pas.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | kind possible | Temps |
|---|---|---|---|---|
| F1 Durcissement de l'hôte | débutant | linux-base | sans objet | 4 h |
| F2 RBAC et ServiceAccounts | confirmé | kubernetes-ha | oui | 5 h |
| F3 API server et upgrade | confirmé | kubernetes-ha | partiel | 5 h |
| F4 NetworkPolicy | confirmé | kubernetes-ha | oui (Cilium) | 4 h |
| F5 Ingress TLS, métadonnées, binaires | confirmé | kubernetes-ha | oui | 4 h |
| F6 CIS benchmark | confirmé | kubernetes-ha | partiel | 4 h |
| F7 Pod Security Standards | confirmé | kubernetes-ha | oui | 5 h |
| F8 AppArmor et seccomp pour les pods | confirmé | kubernetes-ha | partiel | 5 h |
| F9 Secrets | confirmé | kubernetes-ha | oui | 5 h |
| F10 Isolation et chiffrement | confirmé | kubernetes-ha | partiel | 6 h |
| F11 Chaîne d'approvisionnement | confirmé | kubernetes-ha + airgap | oui (registre local) | 7 h |
| F12 Analyse statique | confirmé | linux-base ou poste | oui | 3 h |
| F13 Falco | confirmé | kubernetes-ha | partiel | 6 h |
| F14 Audit logs et immutabilité | confirmé | kubernetes-ha | partiel | 4 h |
| S1 Durcir un cluster livré | expert | kubernetes-ha + airgap | non | 8 h |
| Révision (flashcards, checklists), examen blanc `exams/CKS/`, deux sessions killer.sh | — | — | — | 10 h |
| **Total** | | | | **85 h** |

À 5 h par semaine, compter 17 semaines ; à 8 h par semaine, 11 semaines. C'est trois cycles de 4 à 6 semaines de
`docs/roadmap.md` §7, à placer juste après CKA et CKAD (CKA est le prérequis officiel, la validité de 2 ans court
dès CKA pour le Kubestronaut : `examen.md` §3). Huit fiches sur quatorze exigent le profil `kubernetes-ha` complet
ou n'y sont que partiellement praticables sur `kind` : lever `lab up kubernetes-ha` avant F3.

## 6. Ce que le lab ne couvre pas

- **Service de métadonnées cloud** (CKS-01-04) : pas de fournisseur cloud sur Proxmox ; simulé par un pod exposant
  `169.254.169.254`, marqué `[simulation]` dans F5. La logique (egress bloqué par NetworkPolicy) est la même qu'à l'examen.
- **Kata Containers** (CKS-04-03) : nécessite la virtualisation imbriquée ; `[lecture + simulation]` dans F10, gVisor fait
  la pratique.
- **KMS v2 pour le chiffrement etcd** (CKS-04-02) : pas de plugin KMS sur le lab ; `[lecture + simulation]`, `aescbc`/`secretbox`
  font la pratique.
- **Menaces sur l'infrastructure physique** (CKS-06-02) : un seul hôte, pas de BMC réel ; `[lecture]` dans F13.
- **Contrôleur Ingress NGINX** : retiré du workbook (DECISIONS.md 2026-10-02) alors que sa documentation est autorisée à
  l'examen (`examen.md` §1). F5 enseigne l'objet `Ingress` avec le contrôleur Cilium ; une section « à connaître pour
  l'examen » liste les annotations NGINX les plus citées, en lecture seule.
- **Version de Kubernetes** : le lab suit `kubernetes` 1.37 ; l'examen blanc `exams/CKS/` et les sessions killer.sh font
  la pratique sur la version d'examen. Les écarts connus (champ `appArmorProfile` GA en 1.30, PSA GA en 1.25,
  jetons liés) sont signalés dans chaque fiche, pas enseignés à part.
