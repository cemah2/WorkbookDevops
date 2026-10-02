---
chapitre: "fiches/openstack/01-deployer-openstack-kolla-ansible.md"
domaine: "openstack"
niveau: "débutant"
statut: "proposé le 2026-10-02 — en attente de validation (questions ouvertes en fin de plan)"
duree_estimee: "8 h en deux séances"
profil_lab: "openstack-kolla (3 VM) ; CLI depuis core-jump01"
versions: "openstack, kolla_ansible, kolla, python_openstackclient, ubuntu_lts, cirros (à créer)"
certifications:
  - "COA-01-05"
---

# Plan — 01 Kolla-Ansible : déployer OpenStack 2026.1 sur trois VM du lab

Première fiche du domaine `openstack`, F1 de `certifs/COA/objectifs.md`. Elle ne couvre qu'une compétence d'examen
(COA-01-05, fichiers RC) mais elle est le prérequis technique des neuf autres fiches : sans cloud, pas de manipulation.
Sources lues pour ce plan : `CLAUDE.md`, `versions.yaml`, `templates/fiche.md`, `certifs/COA/objectifs.md`,
`docs/prerequis.md`, `labs/network.md`, `labs/profiles/openstack-kolla.yaml`, et la documentation Kolla-Ansible de la
branche `stable/2026.1` lue sur le miroir GitHub du dépôt officiel (`docs.openstack.org` et `opendev.org` bloqués depuis
la session) : `user/quickstart`, `user/support-matrix`, `user/multinode`, `user/operating-kolla`,
`admin/production-architecture-guide`, `admin/advanced-configuration`, `reference/networking/neutron`,
`reference/storage/cinder-guide`, `reference/storage/external-ceph-guide`, `reference/compute/nova-guide`,
`etc/kolla/globals.yml`, `requirements.txt`, `tools/init-runonce`.

## Deux constats qui changent la cartographie COA (PR #47)

1. **Swift n'existe plus dans Kolla-Ansible.** Aucune variable `enable_swift`, aucun guide Swift dans les branches
   `stable/2025.1` et `stable/2026.1` (vérifié dans `globals.yml`, `README.rst` et l'index `reference/storage`).
   Le préalable « Swift via Kolla-Ansible, trois disques de 20 Go » écrit dans `certifs/COA/objectifs.md` §2 est faux.
   La seule voie Kolla pour l'API Swift est un **Ceph RadosGW externe** (`enable_ceph_rgw: true`, endpoints Swift
   enregistrés dans Keystone, options `ceph_rgw_swift_compatibility` et `ceph_rgw_swift_account_in_url`, cette dernière
   indispensable aux ACL inter-projets de COA-05-02). Voir question 1.
2. **Contrainte Ansible.** `requirements.txt` de Kolla-Ansible 22.x impose `ansible-core>=2.19,!=2.19.0,<2.21` et
   `python>=3.11`. `versions.yaml` porte `ansible_core: 2.21.4` : la fiche ne doit pas le réutiliser. Le venv Kolla
   installe la contrainte de Kolla, et `versions.yaml` gagne une note sur l'entrée `kolla_ansible`.

## Objectifs mesurables

- Préparer les trois VM (`ctl01`, `cmp01`, `cmp02`), l'inventaire `multinode`, `globals.yml` et `passwords.yml` et obtenir
  un `kolla-ansible prechecks` vert en moins de 30 min à partir de VM Ubuntu nues.
- Déployer OpenStack 2026.1 avec `bootstrap-servers`, `deploy`, `post-deploy` et vérifier que Keystone, Glance, Nova,
  Neutron, Cinder et Horizon répondent (`openstack endpoint list`, `compute service list`, `network agent list`,
  `volume service list`) en moins de 10 min après la fin du déploiement.
- Écrire un fichier RC admin et un `clouds.yaml` sur `core-jump01`, basculer entre les deux (`source`, `--os-cloud`,
  `OS_CLOUD`) et obtenir un token en moins de 5 min.
- Lancer une première instance de bout en bout (image, réseau de démonstration, flavor, clé) et lire sa console
  en moins de 10 min.
- Retrouver, à partir d'un symptôme côté API, le conteneur fautif, ses logs dans `/var/log/kolla/` et le relancer
  en moins de 10 min.
- Appliquer un changement de `globals.yml` ou de `/etc/kolla/config/` avec `kolla-ansible reconfigure` et prouver sa prise
  en compte en moins de 15 min.
- Expliquer sans notes, en trois phrases, le rôle des groupes `control`, `network`, `compute`, `storage` et de la VIP interne.

## Niveau et prérequis

- Débutant, nœud `openstack_deb` (`docs/prerequis.md` §6.2).
- Prérequis obligatoires : `linux_conf` (systemd, LVM, conteneurs, venv Python), `reseau_conf` (VLAN, bridges, routage
  inter-VLAN, MTU), `proxmox_conf` (VM multi-NIC, disques supplémentaires, KVM imbriqué). Recommandé : `iac_deb`
  (inventaire, variables et exécution d'un playbook Ansible). Aucun chapitre n'existe pour ces nœuds au 2026-10-02 :
  le front matter cite les nœuds, pas des fichiers.
- Infrastructure : les trois VM du profil `openstack-kolla` démarrées, résolues par `core-dns01`
  (`openstack-kolla-ctl01.lab.home.arpa`, etc. : RabbitMQ exige des noms d'hôtes résolus, pas des adresses),
  `core-jump01` comme poste CLI. Hôte de déploiement : `ctl01` (rôle `deploy host` du profil).

## Compétences couvertes

| Section | COA | Rôle dans la série |
|---|---|---|
| 1 Préparer | — | socle : inventaire, `globals.yml`, `passwords.yml`, prechecks |
| 2 Déployer et accéder | COA-01-05 | fichiers RC, `clouds.yaml`, premier accès CLI et Horizon |
| 3 Exploiter | — | socle : lire l'architecture, logs, `reconfigure`, `stop`, `destroy` ; base des pannes des fiches 02 à 10 |

Les ressources créées en section 2 par le script de démonstration (image `cirros`, réseau `demo-net`, routeur, réseau
externe, flavors, clé) sont des **objets de validation** : la fiche les supprime en fin de section 3 pour que F2 à F5
les refassent à la main, car c'est là que l'examen les évalue.

## Exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Vérifier les 3 VM : 4 NIC par VLAN (`ip -br a`), disque `/dev/sdb` libre sur les computes, résolution DNS des trois noms, `kvm-ok` ; créer le venv sur `ctl01`, `pip install kolla-ansible==<kolla_ansible>` (tire `ansible-core` dans la fenêtre de Kolla), `kolla-ansible install-deps` | `kolla-ansible --version` égal à `versions.yaml` |
| 1.2 | 1 | guidé | Copier `globals.yml`, `passwords.yml`, inventaire `multinode` ; renseigner `kolla_base_distro: ubuntu`, `network_interface` (VLAN 10), `tunnel_interface` (VLAN 30), `neutron_external_interface` (VLAN 40, sans IP), VIP interne `10.10.10.70`, VIP externe `10.10.40.221` (question 2), `enable_cinder` + `enable_cinder_backend_lvm`, `cinder_backup_driver` (question 1), `enable_heat: false` ; `kolla-genpwd` ; VG `cinder-volumes` sur `/dev/sdb` des computes | `kolla-ansible prechecks` vert |
| 1.3 | 1 | autonome | Écrire l'inventaire : `ctl01` dans `control`, `network`, `monitoring` ; `cmp01`, `cmp02` dans `compute` et `storage` ; `cinder-volume:children` = `storage` ; `ansible_user`, clé SSH ; justifier chaque groupe en une ligne | `ansible -i multinode all -m ping` OK |
| 1.4 | 1 | break-fix | `break/openstack/01-resolution-hotes-cassee.sh` | prechecks à nouveau vert |
| 1.5 | 1 | chronométré | VM nues → prechecks vert (venv, fichiers, VG) | 30 min |
| 2.1 | 2 | guidé | `bootstrap-servers`, `prechecks`, `deploy` (durée mesurée et notée), `post-deploy` ; lire `/etc/kolla/clouds.yaml` et `admin-openrc.sh` ; installer `python-openstackclient` sur `core-jump01` avec les `upper-constraints` 2026.1 ; `openstack endpoint list`, `compute service list`, `network agent list`, `volume service list` ; Horizon sur la VIP externe | tous les services `up`/`enabled`, Horizon affiche le tableau de bord |
| 2.2 | 2 | autonome | Construire à la main un second RC (`OS_AUTH_URL`, `OS_PROJECT_*`, `OS_USER_DOMAIN_NAME`, `OS_IDENTITY_API_VERSION=3`) et un `clouds.yaml` à deux entrées (`lab-admin`, `lab-admin-public` sur la VIP externe) ; comparer `source` / `--os-cloud` / `OS_CLOUD` ; `openstack token issue` ; télécharger le RC depuis Horizon et le diffuser — COA-01-05 | token obtenu par les trois méthodes |
| 2.3 | 2 | guidé | Validation de bout en bout : `init-runonce` avec les variables du lab (`EXT_NET_CIDR=10.10.40.0/24`, `EXT_NET_RANGE=start=10.10.40.230,end=10.10.40.254`, `EXT_NET_GATEWAY=10.10.40.1`, `DEMO_NET_CIDR=10.200.0.0/24`, `DEMO_NET_DNS=10.10.10.2`, `CIRROS_RELEASE=<cirros>`), `server create demo1`, `console log show`, `ping` depuis le namespace du routeur | instance `ACTIVE`, console affiche le login cirros |
| 2.4 | 2 | break-fix | `break/openstack/01-rabbitmq-arrete.sh` | `server create` repasse en `ACTIVE` |
| 2.5 | 2 | chronométré | De `post-deploy` à `openstack token issue` depuis `core-jump01` avec `clouds.yaml` écrit à la main | 10 min |
| 3.1 | 3 | guidé | Cartographier le déploiement : `docker ps` par hôte, un conteneur = un service, volumes nommés, `/etc/kolla/<service>/` (config rendue), `/var/log/kolla/<service>/` ; schéma Mermaid des flux API → HAProxy (VIP) → service → MariaDB/RabbitMQ ; `kolla-ansible validate-config` | schéma complété par l'apprenant |
| 3.2 | 3 | autonome | Reconfigurer : déposer `/etc/kolla/config/nova.conf` (`cpu_allocation_ratio` adapté au KVM imbriqué) puis `kolla-ansible reconfigure -t nova` ; vérifier dans le conteneur ; variante TLS externe avec la CA interne (question 3) | option visible dans `nova.conf` rendu, service redémarré une seule fois |
| 3.3 | 3 | break-fix | `break/openstack/01-keepalived-vip-perdue.sh` ; `break/openstack/01-nova-compute-arrete.sh` (optionnel) | VIP de retour, `compute service list` tout `up` |
| 3.4 | 3 | chronométré | Symptôme donné (API en erreur ou instance en `ERROR`) → conteneur fautif identifié, logs lus, service relancé | 10 min |
| 3.5 | 3 | guidé | Cycle de vie : `kolla-ansible stop`, `deploy-containers`, `mariadb_backup`, `destroy --yes-i-really-really-mean-it` puis redéploiement ; nettoyage des objets `demo-*` | cloud redéployé, `image list` vide |

## Scénarios de panne (`break/openstack/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-resolution-hotes-cassee.sh` | entrée de `cmp02` retirée de `/etc/hosts` de `ctl01` (et DNS court-circuité par `/etc/hosts`) | `prechecks` échoue sur la résolution ; après déploiement, RabbitMQ refuse un membre |
| `01-rabbitmq-arrete.sh` | `docker stop rabbitmq` sur `ctl01` | les API répondent, `server create` reste en `BUILD`/`scheduling`, `compute service list` finit par passer `down` |
| `01-keepalived-vip-perdue.sh` | `docker stop keepalived` sur `ctl01` | plus aucune API ne répond sur les VIP, Horizon injoignable, les conteneurs de service sont pourtant `Up` |
| `01-nova-compute-arrete.sh` (optionnel) | `docker stop nova_compute` sur `cmp02` | `compute service list` montre `cmp02` `down`, les instances se placent toutes sur `cmp01` |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck ; exécuté via SSH depuis `core-jump01` avec le nom d'hôte
en variable. Ce sont des pannes de **plateforme**, les fiches 02 à 10 injectent des pannes de **ressources** OpenStack.

## Profil de lab et budget

- `openstack-kolla` : `ctl01` 6 vCPU / 32 Go / 120 Go ; `cmp01` et `cmp02` 6 vCPU / 32 Go / 60 Go + 80 Go (VG `cinder-volumes`).
  Total 18 vCPU alloués / 96 Go / 400 Go, combinable avec `linux-base` seulement (`labs/profiles/README.md`).
- Pré-requis Kolla : 2 interfaces, 8 Go, 40 Go par hôte, largement couverts. Les images Kolla et les volumes Docker
  vivent dans `/var/lib/docker` : prévoir qu'il soit sur le disque système de 120 Go de `ctl01` (NVMe).
- Poste CLI : `core-jump01` (1 vCPU / 1 Go, budget `core` inchangé) ; venv `python-openstackclient`.
- Réseau (`labs/network.md`) : VIP interne `10.10.10.70` (VLAN 10), VIP externe `10.10.40.221` (VLAN 40), tunnels Geneve
  sur le VLAN 30, floating IP `10.10.40.230`–`.254`, réseaux projets `10.200.0.0/16`, DNS `10.10.10.2`.
  Enregistrements à créer dans BIND : les trois VM, `api.os.lab.home.arpa` → `10.10.40.221`, `horizon.os.lab.home.arpa`.
- Option question 1 : une VM `openstack-kolla-stg01` (2 vCPU / 8 Go / 20 Go + 60 Go OSD, VLAN 10 et 20, cephadm mono-nœud,
  RGW). Budget RAM : 96 + 8 + `core` 8 + hôte 8 = 120 Go ≤ 128 ; vCPU alloués 20 pour 10 disponibles, ratio 2,0 (plafond).

## Points de vigilance `versions.yaml`

- `kolla_ansible` 22.2.0 ↔ `openstack` 2026.1 : cohérents (série 22.x = Gazpacho, `openstack_release` par défaut `2026.1`).
  Installer **la version épinglée**, pas `git+https://opendev.org/...@stable/2026.1` que montre le quickstart (dépôt bloqué
  ici de toute façon). Ajouter à l'entrée `kolla_ansible` une note `ansible_core_constraint: ">=2.19,!=2.19.0,<2.21"` et
  `python_min: "3.11"` ; **ne pas** utiliser la clé `ansible_core` (2.21.4) ni `ansible` (14.4.0) pour ce venv.
- `ubuntu_lts` 24.04 : seul Ubuntu de la matrice de support 2026.1 (avec Rocky 10, Debian 13, CentOS Stream 10) ;
  26.04 absent, ce qui confirme la décision du 2026-10-02. `kolla_base_distro: ubuntu` pour aligner hôte et images.
- Images Kolla : tirées de `quay.io/openstack.kolla` au tag `2026.1-ubuntu-noble`. `quay.io` est bloqué depuis cette
  session : l'existence des tags sera vérifiée sur le lab, les commandes de `deploy` seront `[non testé]` jusqu'à la
  première exécution réelle (pas de Proxmox dans la session de rédaction).
- `python_openstackclient` 10.3.0 : le quickstart installe le client avec `-c https://releases.openstack.org/constraints/upper/2026.1`,
  qui peut épingler une autre version. La fiche installe la version de `versions.yaml` et note l'écart éventuel ; `releases.openstack.org`
  est bloqué depuis la session, à vérifier sur le lab.
- `cirros` : clé à créer (dépôt `cirros-dev/cirros`, datasource `github-releases`) ; `init-runonce` embarque `0.6.3` par
  défaut, à surcharger par `CIRROS_RELEASE`.
- Moteur de conteneurs : `kolla_container_engine: docker` par défaut, installé par `bootstrap-servers` depuis le dépôt
  Docker ; `podman` possible. Aucune clé `docker` dans `versions.yaml` (la clé `containerd` 2.4.1 est celle de Kubernetes) :
  la fiche note la version installée par Kolla sans la figer.
- Neutron : `neutron_plugin_agent: openvswitch` par défaut, conservé. OVN supprimerait les agents DHCP et L3 que
  COA-03-06 fait observer (`network agent list`), et `init-runonce` suppose `physnet1`.
- Cinder : `cinder_backup_driver` vaut `ceph` par défaut, options `nfs`, `ceph`, `s3` seulement ; sans Ceph il faut `nfs`
  (export sur `ctl01`) ou désactiver `enable_cinder_backup`. Deux hôtes dans `cinder-volume` déclenchent le precheck HA
  (`cinder_cluster_name`) alors que LVM n'est pas actif/actif : vérifier à la rédaction si `cinder_cluster_skip_precheck`
  est nécessaire ou si `storage` doit se limiter à `cmp01`.
- Nova : `nova_console: novnc` par défaut (F7 bascule en `spice` par `reconfigure`), `nova_compute_virt_type: kvm` en
  KVM imbriqué (`kvm-ok` dans la section 1 ; repli `qemu` documenté, dix fois plus lent).
- Heat, Fluentd, ProxySQL activés par défaut : `enable_heat: false` (hors COA, 2 Go économisés), le reste conservé.

## `[lecture + simulation]`

- **Haute disponibilité du plan de contrôle** (3 contrôleurs, quorum MariaDB Galera et RabbitMQ, `enable_neutron_agent_ha`) :
  un seul contrôleur dans le profil, budget RAM épuisé. Lecture du guide d'architecture de production, schéma, trois flashcards.
- **Mise à niveau** (`kolla-ansible upgrade`, SLURP, `kolla-mergepwd`) : aucune série précédente déployée ; lecture des notes
  de version, exercice de lecture d'un diff de `globals.yml`. Une vraie montée de version viendra avec la série 2027.1.
- **Construction d'images** (`kolla build`) et **registre local** (recommandé par le guide multinode) : inutiles à trois
  nœuds qui tirent `quay.io` ; mentionnés pour le profil `airgap` futur.
- **OVS-DPDK, SR-IOV, Ironic/Bifrost** : décision du 2026-10-02 (matériel) et hors COA.
- Rien d'autre : tout le reste est exécuté sur le lab.

## Livrables attendus de la session de rédaction

- `fiches/openstack/01-deployer-openstack-kolla-ansible.md` (gabarit `templates/fiche.md`), avec en annexe les fichiers
  `multinode`, `globals.yml` (expurgé) et un `globals.d/lab.yml` commentés, dans `fiches/openstack/01-deployer-openstack-kolla-ansible/kolla/`.
- `solutions/fiches/openstack/01-deployer-openstack-kolla-ansible.md` (3 indices puis correction).
- `break/openstack/01-*.sh` (3 scripts, 1 optionnel).
- `revision/flashcards/openstack-01-deployer-openstack-kolla-ansible.csv` (10 à 20 cartes).
- `versions.yaml` : clé `cirros`, note de contrainte sur `kolla_ansible` ; `labs/profiles/openstack-kolla.yaml` et
  `labs/network.md` si les questions 1 et 2 l'exigent, avec l'entrée `DECISIONS.md` correspondante.
- Mise à jour de `certifs/COA/objectifs.md` §2 (Swift), §3 et §4 ; `docs/prerequis.md` §6.2 (nœud `rédigé`) ; ce plan (`statut: réalisé`).

## Questions ouvertes (la réponse change le plan)

1. **Object Storage sans Swift.** Options : (A) ajouter `openstack-kolla-stg01` (Ceph mono-nœud cephadm + RGW, 2 vCPU / 8 Go /
   80 Go) au profil et l'intégrer par `enable_ceph_rgw` ; RGW sert aussi de cible `s3` à `cinder-backup`. Cinder LVM et Glance `file`
   inchangés. (B) comme A, mais Ceph porte aussi Glance et Cinder (`glance_backend_ceph`, `cinder_backend_ceph`) : plus proche
   d'une production, débloque COA-06-05 en vrai, mais abandonne le LVM du profil et met Ceph sur le chemin critique d'un débutant.
   (C) reporter : F1 sans object storage, F9 bloquée tant que la décision n'est pas prise. Recommandation : A, en entrée datée
   de `DECISIONS.md`, et correction de `certifs/COA/objectifs.md` §2 dans la même PR que ce plan.
2. **VIP externe et interface Neutron sur le même VLAN 40.** Kolla exige que `neutron_external_interface` n'ait pas d'adresse et
   que `kolla_external_vip_interface` en ait une. Le profil donne à `ctl01` une seule NIC VLAN 40 avec `10.10.40.51`.
   Options : (A) deuxième NIC VLAN 40 sur `ctl01` (sans IP, dédiée à `br-ex`), modification du profil ; (B) déplacer la VIP externe
   sur le VLAN 10 (`10.10.10.71`) et exposer `*.os.lab.home.arpa` par le routeur, modification de `labs/network.md` ; (C) bridge
   Linux + paire veth sur l'hôte, comme Kayobe, trop fragile pour une fiche débutant. Recommandation : A.
3. **TLS externe dès F1 ?** (A) HTTP en chemin principal, TLS avec la CA interne (`kolla_enable_tls_external`,
   `kolla_external_fqdn: api.os.lab.home.arpa`, `kolla_copy_ca_into_containers`) en variante de l'exercice 3.2 ; (B) TLS en chemin
   principal, conforme à `labs/network.md` §6 mais ajoute PKI et `OS_CACERT` au premier contact. Recommandation : A, l'examen
   n'évalue pas TLS.
4. **Création des VM.** Aucun `lab up` n'existe. (A) F1 commence « trois VM Ubuntu 24.04 prêtes » avec une annexe de 15 min
   « créer les VM dans Proxmox » (NIC, disques, `cpu: host`) ; le module OpenTofu du profil fera l'objet d'une fiche `iac`.
   (B) F1 inclut l'écriture du module OpenTofu `bpg/proxmox` du profil : fiche à 12 h et deux domaines mélangés.
   Recommandation : A.
