---
code: COA
titre: "COA — mapping compétences → chapitres"
programme: "certifs/COA/programme.md (converti le 2026-10-02, page officielle des exigences relevée le 2026-09-28)"
chapitres_existants: 0
generated: 2026-10-02
status: "0 chapitre rédigé sur 11, plan de F1 validé le 2026-10-02 ; à mettre à jour à chaque PR de chapitre"
---

# COA — objectifs et couverture

Mapping entre les 40 compétences de [`programme.md`](programme.md) et les chapitres du workbook.
État au 2026-10-02 : aucun chapitre `openstack` n'existe (`fiches/openstack/` et `break/openstack/` ne contiennent
que leur README), les deux seules fiches rédigées du dépôt sont dans `gitops/`. Les 40 compétences sont donc des trous.
Ce fichier sert de plan de création ; chaque PR de chapitre remplit les colonnes « chapitre » et « exercices »
et marque le chapitre « rédigé » dans la section 4.

## 1. Lecture rapide

| Domaine | Poids | Compétences | Poids par compétence (hérité) | Chapitres à créer |
|---|---|---|---|---|
| COA-01 Identity Management | 15 % | 5 | 3,0 % | 2 fiches |
| COA-02 Compute | 35 % | 9 | 3,9 % | 2 fiches |
| COA-03 Networking | 30 % | 13 | 2,3 % | 2 fiches |
| COA-04 Block Storage | 10 % | 6 | 1,7 % | 1 fiche |
| COA-05 Object Storage | 5 % | 2 | 2,5 % | 1 fiche |
| COA-06 Image Management | 5 % | 5 | 1,0 % | 1 fiche |
| Socle (déploiement du lab) | — | — | — | 1 fiche |
| Transverse | — | 40 | — | 1 scénario |

Convention de pondération : l'éditeur ne pondère que les domaines ; le poids d'une compétence est le poids du
domaine divisé par le nombre de compétences du domaine. C'est une estimation de priorité de révision, pas une donnée
officielle. Lecture utile : une compétence Compute pèse presque quatre fois une compétence Image.

L'examen est pratique (180 min, environnement OpenStack réel, CLI et Horizon, documentation officielle autorisée :
voir [`examen.md`](examen.md)). Les chapitres privilégient donc la vitesse d'exécution au `openstack` CLI, avec une
variante Horizon par section, et des défis chronométrés calqués sur la durée moyenne d'une tâche d'examen.

Ordre de rédaction recommandé (prérequis d'abord, puis du plus lourd au plus léger) :
déploiement Kolla-Ansible → Keystone (identités) → Glance → Neutron fondamentaux → Nova instances →
Neutron sécurité et quotas → Nova consoles/snapshots/quotas → Cinder → Swift → Keystone policies → scénario.

## 2. Préalables au premier chapitre

À régler **avant** d'ouvrir la PR du premier chapitre (sinon le gabarit ne peut pas être rempli honnêtement) :

- `versions.yaml` : les clés `openstack` (série 2026.1 Gazpacho, `channel: exam`), `kolla_ansible`, `kolla`,
  `python_openstackclient`, `ubuntu_lts` et `ansible` existent. Ajouter `cirros` (image de test Glance,
  dépôt `cirros-dev/cirros`, datasource `github-releases`) par la veille ou la PR de F3. Aucune version en dur dans les fiches.
- **Version d'examen** : `programme.md` et `versions.yaml` annoncent 2026.1 Gazpacho « à confirmer dans le handbook ».
  La fiche F1 déploie la série de `versions.yaml` ; si le handbook dit autre chose, la veille met `versions.yaml` à jour
  et F1 suit sans réécriture (DECISIONS.md, 2026-10-02, « Un seul fichier de versions »).
- **Object Storage** (COA-05, 5 %) : **Kolla-Ansible 2026.1 ne déploie plus Swift** (constat du plan de F1, 2026-10-02).
  Décision (`DECISIONS.md`, 2026-10-02) : une quatrième VM `openstack-kolla-stg01` porte un Ceph mono-nœud avec RadosGW,
  intégré par `enable_ceph_rgw` (endpoints Swift dans Keystone, `rgw_swift_account_in_url` pour les ACL inter-projets de
  COA-05-02) ; le RGW est aussi la cible `s3` de `cinder-backup` (COA-04-05). Glance reste `file`, Cinder reste LVM.
  Le profil passe à 4 VM / 20 vCPU / 96 Go / 480 Go ; `cmp01` et `cmp02` descendent à 28 Go.
- **Consoles** (COA-02-07) : Kolla-Ansible déploie noVNC par défaut ; SPICE est une variante (`nova_console: spice`,
  `kolla-ansible reconfigure`). F7 enseigne noVNC en chemin principal et SPICE en variante reconfigurée, pas en lecture.
- **Accès au cloud** : le `openstack` CLI s'exécute depuis `core-jump01` (VLAN `mgmt`) avec un `clouds.yaml` par projet ;
  Horizon et les API sont servis sur la VIP externe `10.10.40.221` (`*.os.lab.home.arpa`, `labs/network.md` §6), en HTTP ;
  le TLS par la CA interne est une variante de F1 (DECISIONS.md, 2026-10-02). `ctl01` a deux NIC VLAN 40 : une avec adresse
  pour la VIP, une sans adresse pour `br-ex` (DECISIONS.md, 2026-10-02).
- **Contrainte Ansible** : Kolla-Ansible 22.x exige `ansible-core>=2.19,!=2.19.0,<2.21` et Python ≥ 3.11 ; la clé
  `ansible_core` (2.21.4) de `versions.yaml` ne s'applique pas au venv Kolla (note à ajouter sur l'entrée `kolla_ansible`).
- **Création des VM** : aucun `lab up` n'existe ; F1 démarre sur des VM créées à la main avec une annexe de 15 min
  (DECISIONS.md, 2026-10-02) ; le module OpenTofu du profil viendra d'une fiche `iac`.
  Floating IP dans `10.10.40.230`–`.254`, réseaux projets dans `10.200.0.0/16` (`labs/network.md` §3 et §4).
- **Virtualisation imbriquée** : les computes tournent en KVM imbriqué (`nested_virtualization: true`). Les fiches
  utilisent l'image `cirros` et des flavors minimales ; aucune mesure de performance n'est demandée.
- `docs/prerequis.md` : les nœuds de chapitres planifiés sont ajoutés en §6.2 (cette PR).
- Pas de nouvelle décision d'outillage : OpenTofu `bpg/proxmox` + cloud-init + Ansible pour `lab up openstack-kolla`
  (`docs/roadmap.md` §2) ; Ubuntu 24.04 LTS tant que Kolla-Ansible ne supporte pas 26.04 (DECISIONS.md, 2026-10-02).

## 3. Couverture par compétence

Colonnes « chapitre » et « exercices » : `—` tant que rien n'existe. La colonne « chapitre cible » renvoie à la section 4.

### COA-01 — Identity Management (15 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| COA-01-01 | Manage and create domains, projects, users, and roles | 3,0 % | — | — | F2 |
| COA-01-02 | Understand the differences between the member and admin roles | 3,0 % | — | — | F2 |
| COA-01-03 | Create roles for the environment | 3,0 % | — | — | F2 |
| COA-01-04 | Create and manage policy files and user access rules | 3,0 % | — | — | F10 |
| COA-01-05 | Create and manage RC files to authenticate with Keystone for command line use | 3,0 % | — | — | F1, F2 |

### COA-02 — Compute (35 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| COA-02-01 | Create and manage flavors | 3,9 % | — | — | F5 |
| COA-02-02 | Create and manage compute instances (for example, launch, shutdown, terminate) | 3,9 % | — | — | F5, F7 |
| COA-02-03 | Generate and manage SSH keys for use when connecting to instances | 3,9 % | — | — | F5 |
| COA-02-04 | Access an instance using an SSH key | 3,9 % | — | — | F5 |
| COA-02-05 | Configure an instance with a floating IP address; use it to connect to the instance | 3,9 % | — | — | F5 |
| COA-02-06 | Create instances with security groups | 3,9 % | — | — | F5, F6 |
| COA-02-07 | Manage Nova host consoles (VNC, NOVNC, spice) | 3,9 % | — | — | F7 |
| COA-02-08 | Manage instance snapshots | 3,9 % | — | — | F7 |
| COA-02-09 | Manage instance quotas | 3,9 % | — | — | F7 |

### COA-03 — Networking (30 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| COA-03-01 | Manage network resources (routers, networks, subnets) | 2,3 % | — | — | F4 |
| COA-03-02 | Create external/public networks | 2,3 % | — | — | F4 |
| COA-03-03 | Create project networks | 2,3 % | — | — | F4 |
| COA-03-04 | Create project routers | 2,3 % | — | — | F4 |
| COA-03-05 | Attach routers to public and project networks | 2,3 % | — | — | F4 |
| COA-03-06 | Manage network services for a virtual environment | 2,3 % | — | — | F6 |
| COA-03-07 | Manage network quotas | 2,3 % | — | — | F6 |
| COA-03-08 | Manage network interfaces on compute instances | 2,3 % | — | — | F6 |
| COA-03-09 | Create and manage project security groups and rules | 2,3 % | — | — | F6 |
| COA-03-10 | Assign security group to instance | 2,3 % | — | — | F5, F6 |
| COA-03-11 | Create and manage floating IP addresses | 2,3 % | — | — | F4, F5 |
| COA-03-12 | Assign floating IP address to instance | 2,3 % | — | — | F5 |
| COA-03-13 | Detach floating IP address from instance | 2,3 % | — | — | F5 |

### COA-04 — Block Storage (10 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| COA-04-01 | Create and manage volumes | 1,7 % | — | — | F8 |
| COA-04-02 | Attach volumes to instances | 1,7 % | — | — | F8 |
| COA-04-03 | Create a new Block Storage volume and mount it to a Nova instance | 1,7 % | — | — | F8 |
| COA-04-04 | Manage volume quotas | 1,7 % | — | — | F8 |
| COA-04-05 | Backup and restore volumes | 1,7 % | — | — | F8 |
| COA-04-06 | Manage volume snapshots (for example, create, list, recover) | 1,7 % | — | — | F8 |

### COA-05 — Object Storage (5 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| COA-05-01 | Use the command line client to upload and manage files to Swift containers | 2,5 % | — | — | F9 |
| COA-05-02 | Manage permissions on a container in object storage | 2,5 % | — | — | F9 |

### COA-06 — Image Management (5 %)

| ID | Compétence | Poids | Chapitre existant | Exercices existants | Chapitre cible |
|---|---|---|---|---|---|
| COA-06-01 | Upload a new image to an OpenStack image repository | 1,0 % | — | — | F3 |
| COA-06-02 | Manage images (for example, add, update, remove) | 1,0 % | — | — | F3 |
| COA-06-03 | Understand the difference between public versus private images | 1,0 % | — | — | F3 |
| COA-06-04 | Manage image metadata/properties | 1,0 % | — | — | F3 |
| COA-06-05 | Manage image types and backends | 1,0 % | — | — | F3 (backends Ceph RBD en `[lecture + simulation]`) |

### Compétences partagées avec d'autres certifications

COA se passe à la fin du parcours « Cloud privé OpenStack » (`docs/prerequis.md` §3, jalon `openstack_conf` → `openstack_exp`),
après RHCSA, RHCE et TFA. Aucune autre certification du dépôt ne cite OpenStack ; les chapitres ci-dessous ne portent
donc que des IDs COA. Deux recoupements de contenu, sans ID partagé :

| Chapitre | Recoupement | À signaler dans la fiche |
|---|---|---|
| F1 Déploiement Kolla-Ansible | `iac` (Ansible : inventaire, variables, playbooks) ; `ceph` (RGW mono-nœud sur `stg01`, script fourni) | prérequis `iac_deb` et `ceph_deb` recommandés ; aucun ID RHCE cité (Kolla n'est pas AAP) |
| F8 Cinder | `ceph` et `sauvegarde` (backend RBD, sauvegarde/restauration mesurée) | section backends en `[lecture + simulation]` ; renvoi vers les futures fiches `ceph/` |

## 4. Trous et chapitres à créer

Les fiches sont numérotées dans l'ordre de rédaction recommandé (DECISIONS.md, 2026-10-02). Tous les chapitres ciblent
le profil `openstack-kolla` (4 VM, 20 vCPU alloués / 96 Go / 480 Go, `labs/profiles/openstack-kolla.yaml`, combinable avec
`linux-base` seulement). Sans alternative légère (pas de DevStack sur le lab : même budget, moins représentatif),
F1 est le prérequis technique de tous les autres chapitres. Les durées sont des estimations d'apprentissage
(lecture ≤ 20 %, le reste en manipulation), pas de rédaction. Chaque section de fiche contient une variante Horizon
quand l'opération existe dans le tableau de bord, parce que l'examen évalue les deux interfaces.

### F1 — `fiches/openstack/01-deployer-openstack-kolla-ansible.md`

- **Titre** : Kolla-Ansible — déployer OpenStack 2026.1 sur quatre VM du lab
- **Niveau** : débutant (`openstack_deb`)
- **Couvre** : COA-01-05 (fichiers RC produits par `post-deploy`) ; socle pour les 39 autres compétences
- **Prérequis** : `linux_conf` (systemd, LVM, conteneurs), `reseau_conf` (VLAN, bridges, routage), `proxmox_conf`
  (VM, disques supplémentaires, KVM imbriqué) ; `iac_deb` et `ceph_deb` recommandés
- **Lab** : `openstack-kolla` complet (VM créées à la main, annexe). Clés `versions.yaml` : `openstack`, `kolla_ansible`, `kolla`,
  `python_openstackclient`, `ubuntu_lts`, `ceph`, `cirros` (à créer).
- **Plan validé** : `docs/plans/openstack-01-deployer-openstack-kolla-ansible.md` (2026-10-02).
- **Temps** : 9 h en deux séances
- **3 exercices clés** :
  1. Vérifier les quatre VM (NIC par VLAN, disques Cinder et OSD), préparer `stg01` (cephadm mono-nœud + RGW, script fourni),
     installer Kolla-Ansible dans un venv sur `ctl01`, écrire `globals.yml` (VIP interne `10.10.10.70`, VIP externe `10.10.40.221`,
     `neutron_external_interface` sur la seconde NIC VLAN 40, tunnels sur le VLAN 30, `enable_ceph_rgw`) et générer `passwords.yml` — socle.
  2. `bootstrap-servers`, `prechecks`, `deploy`, `post-deploy` ; installer le CLI sur `core-jump01`, construire
     `admin-openrc.sh` et `clouds.yaml`, vérifier `openstack endpoint list` et Horizon via `*.os.lab.home.arpa` — COA-01-05.
  3. Lire l'architecture déployée : un conteneur par service, `docker ps`, `/var/log/kolla/`, `kolla-ansible reconfigure`
     après un changement de `/etc/kolla/config/` ; variante TLS externe ; `stop`, `destroy`, redéploiement — socle.
- **Break-fix** : `break/openstack/01-rabbitmq-arrete.sh` (conteneur RabbitMQ arrêté : `openstack server create` reste en `BUILD`).
- **Défi chronométré** : relancer un service reconfiguré et prouver le retour à `enabled`/`up` dans `openstack compute service list`
  en moins de 15 min.

### F2 — `fiches/openstack/02-keystone-domaines-projets-utilisateurs-roles.md`

- **Titre** : Keystone — domaines, projets, utilisateurs, rôles et fichiers RC
- **Niveau** : débutant (`openstack_deb`)
- **Couvre** : COA-01-01, COA-01-02, COA-01-03, COA-01-05
- **Prérequis** : F1
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `python_openstackclient`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Créer un domaine, deux projets, trois utilisateurs et affecter les rôles `member`, `reader`, `admin` à des périmètres
     différents (projet, domaine, système) ; lire `openstack role assignment list --names` — COA-01-01, COA-01-02.
  2. Créer un rôle personnalisé et un rôle implicite (`openstack implied role create`), vérifier ce qu'il autorise ou non
     avec un token de l'utilisateur ; comparer `member` et `admin` sur `server list --all-projects` — COA-01-02, COA-01-03.
  3. Écrire un fichier RC par utilisateur (`OS_*`), un `clouds.yaml` multi-projets, basculer avec `--os-cloud`, obtenir et
     inspecter un token (`openstack token issue`) ; faire la même chose dans Horizon (téléchargement du RC) — COA-01-05.
- **Break-fix** : `break/openstack/02-keystone-role-retire.sh` (rôle `member` retiré à l'utilisateur de travail : `401`/`403` selon la commande).
- **Défi chronométré** : livrer un projet avec un utilisateur `member` et un `clouds.yaml` fonctionnel en moins de 5 min.

### F3 — `fiches/openstack/03-glance-images.md`

- **Titre** : Glance — téléverser, partager et décrire des images
- **Niveau** : débutant (`openstack_deb`)
- **Couvre** : COA-06-01, COA-06-02, COA-06-03, COA-06-04, COA-06-05
- **Prérequis** : F2 (projets et utilisateurs pour tester la visibilité)
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `python_openstackclient`, `cirros` (à créer).
- **Temps** : 3 h
- **3 exercices clés** :
  1. Téléverser l'image `cirros` (format `qcow2`, conteneur `bare`), lister, afficher, renommer, désactiver, supprimer ;
     refaire le téléversement dans Horizon — COA-06-01, COA-06-02.
  2. Comparer `public`, `private`, `shared` et `community` : partager une image avec un second projet
     (`image add project`, acceptation côté membre), vérifier qui voit quoi avec deux `clouds.yaml` — COA-06-03.
  3. Poser des propriétés (`hw_disk_bus`, `os_distro`, `min_disk`, `min_ram`), observer leur effet au lancement d'une
     instance ; lister les formats de disque et les stores (`openstack image stores`) du backend `file` de Kolla ;
     backend Ceph RBD en `[lecture + simulation]` (le profil ne se combine pas avec `ceph-3n`) — COA-06-04, COA-06-05.
- **Break-fix** : `break/openstack/03-glance-image-min-ram.sh` (`min_ram` supérieur à toute flavor : `Flavor's memory is too small`).
- **Défi chronométré** : image téléversée, partagée avec un projet et acceptée en moins de 5 min.

### F4 — `fiches/openstack/04-neutron-reseaux-sous-reseaux-routeurs.md`

- **Titre** : Neutron — réseau externe, réseaux projets, routeurs et floating IP
- **Niveau** : débutant (`openstack_deb`)
- **Couvre** : COA-03-01, COA-03-02, COA-03-03, COA-03-04, COA-03-05, COA-03-11
- **Prérequis** : F2 ; `reseau_conf` (déjà requis par `openstack_deb`)
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `python_openstackclient`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Créer le réseau externe `provider` (`--external --provider-network-type flat`, VLAN 40 du lab) et son sous-réseau
     avec le pool `10.10.40.230`–`.254` sans DHCP, passerelle `10.10.40.1` (`labs/network.md`) — COA-03-02.
  2. Créer deux réseaux projets dans `10.200.0.0/16` avec DHCP et DNS `10.10.10.2`, un routeur par projet, lui donner
     une passerelle externe et attacher les sous-réseaux ; lire `openstack router show` et les namespaces `qrouter-*`
     sur le nœud réseau — COA-03-01, COA-03-03, COA-03-04, COA-03-05.
  3. Réserver, lister, décrire et libérer des floating IP sans instance (`floating ip create/list/show/delete`) ;
     refaire la topologie complète dans Horizon (vue « Topologie du réseau ») — COA-03-11.
- **Break-fix** : `break/openstack/04-neutron-routeur-sans-passerelle.sh` (passerelle externe retirée du routeur : floating IP injoignables).
- **Défi chronométré** : réseau projet + routeur attaché au réseau externe avec `ping` de la passerelle externe depuis le
  namespace du routeur en moins de 7 min.

### F5 — `fiches/openstack/05-nova-flavors-instances-acces-ssh.md`

- **Titre** : Nova — flavors, clés SSH, instances, security groups et floating IP
- **Niveau** : débutant (`openstack_deb`)
- **Couvre** : COA-02-01, COA-02-02, COA-02-03, COA-02-04, COA-02-05, COA-02-06, COA-03-10, COA-03-11, COA-03-12, COA-03-13
- **Prérequis** : F3 (image), F4 (réseau et floating IP)
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `python_openstackclient`, `cirros`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Créer des flavors publiques et privées (`--vcpus`, `--ram`, `--disk`, `--ephemeral`, `--property`), les attribuer à un
     projet (`flavor set --project`), importer et générer des paires de clés (`keypair create`, `--public-key`) — COA-02-01, COA-02-03.
  2. Lancer une instance avec image, flavor, réseau, clé et security group ; cycle de vie `stop`, `start`, `reboot --hard`,
     `pause`, `suspend`, `shelve`, `rebuild`, `delete` ; lire `server show`, `server event list` et les logs console — COA-02-02, COA-02-06.
  3. Associer une floating IP (`server add floating ip`), ouvrir SSH et ICMP dans le security group, se connecter avec la
     clé depuis `core-jump01`, puis détacher la floating IP et prouver la perte d'accès ; changer le security group d'une
     instance en cours (`server add/remove security group`) — COA-02-04, COA-02-05, COA-03-10, COA-03-12, COA-03-13.
- **Break-fix** : `break/openstack/05-nova-cle-ssh-absente.sh` (instance lancée sans clé et règle SSH supprimée : `Permission denied`
  puis `timeout`, deux causes à séparer).
- **Défi chronométré** : de zéro à `ssh cirros@<floating-ip>` fonctionnel en moins de 8 min.

### F6 — `fiches/openstack/06-neutron-security-groups-ports-quotas.md`

- **Titre** : Neutron — security groups avancés, ports et interfaces, agents et quotas
- **Niveau** : confirmé (`openstack_conf`)
- **Couvre** : COA-03-06, COA-03-07, COA-03-08, COA-03-09, COA-03-10, COA-02-06
- **Prérequis** : F5
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `python_openstackclient`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Construire des security groups par rôle (web, db, bastion) avec règles par protocole, port, CIDR et
     `--remote-group` ; appliquer plusieurs groupes à une instance ; comparer avec `port set --no-security-group
     --disable-port-security` — COA-03-09, COA-03-10, COA-02-06.
  2. Ajouter et retirer des interfaces à chaud (`server add network`, `server add port`, `server remove port`), créer un
     port à adresse fixe choisie, lire `allowed-address-pairs`, vérifier dans l'instance avec `ip a` — COA-03-08.
  3. Lire et piloter les services réseau : `network agent list`, agents DHCP par réseau (`network agent add network`),
     L3 agent et routeurs, service de métadonnées ; fixer et vérifier des quotas réseau par projet
     (`quota set --networks --ports --security-groups --floating-ips`) et provoquer un dépassement — COA-03-06, COA-03-07.
- **Break-fix** : `break/openstack/06-neutron-agent-dhcp-desactive.sh` (agent DHCP désactivé : les nouvelles instances
  n'obtiennent pas d'adresse).
- **Défi chronométré** : trois security groups chaînés par `--remote-group` et une instance bi-réseau joignable en moins de 10 min.

### F7 — `fiches/openstack/07-nova-consoles-snapshots-quotas.md`

- **Titre** : Nova — consoles, snapshots d'instance et quotas de calcul
- **Niveau** : confirmé (`openstack_conf`)
- **Couvre** : COA-02-07, COA-02-08, COA-02-09, COA-02-02
- **Prérequis** : F5
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `kolla_ansible` (reconfigure SPICE), `python_openstackclient`.
- **Temps** : 4 h
- **3 exercices clés** :
  1. Obtenir une URL de console (`console url show --novnc`, `--spice`), lire le journal console (`console log show`),
     comprendre `nova-novncproxy` et la variable `nova_console` de Kolla ; basculer en SPICE par `reconfigure` puis
     revenir en noVNC — COA-02-07.
  2. Créer un snapshot d'instance (`server image create`), le relancer dans un autre projet après partage, nettoyer les
     images orphelines ; comparer snapshot d'instance (Glance) et snapshot de volume (Cinder, F8) — COA-02-08.
  3. Lire et modifier les quotas de calcul (`quota show --default`, `quota set --instances --cores --ram --key-pairs`),
     provoquer `Quota exceeded`, diagnostiquer avec `quota list --detail` ; même manipulation dans Horizon — COA-02-09.
- **Break-fix** : `break/openstack/07-nova-quota-zero.sh` (quota `cores` à 0 sur le projet : lancement refusé, message à décoder).
- **Défi chronométré** : snapshot d'une instance, relance depuis ce snapshot avec une floating IP en moins de 8 min.

### F8 — `fiches/openstack/08-cinder-volumes-snapshots-sauvegardes.md`

- **Titre** : Cinder — volumes, attachement, snapshots, sauvegardes et quotas
- **Niveau** : confirmé (`openstack_conf`)
- **Couvre** : COA-04-01, COA-04-02, COA-04-03, COA-04-04, COA-04-05, COA-04-06
- **Prérequis** : F5 ; RGW de `stg01` (cible `s3` de `cinder-backup`, F1)
- **Lab** : `openstack-kolla` (Cinder LVM sur les disques supplémentaires de `cmp01`/`cmp02`). Clés `versions.yaml` :
  `openstack`, `python_openstackclient`.
- **Temps** : 5 h
- **3 exercices clés** :
  1. Créer des volumes (vide, depuis image, bootable), les attacher et détacher (`server add volume`), partitionner, formater
     et monter dans l'instance, vérifier la persistance après `delete` de l'instance ; `volume type` et `volume set`
     (taille, bootable, lecture seule) — COA-04-01, COA-04-02, COA-04-03.
  2. Snapshots : créer, lister, créer un volume depuis un snapshot, restaurer un fichier supprimé ; sauvegardes
     (`volume backup create`, `--incremental`, `--force` sur volume attaché, `volume backup restore`) avec le RGW (`s3`) comme cible,
     mesurer la durée — COA-04-05, COA-04-06.
  3. Quotas de stockage par projet (`quota set --volumes --gigabytes --snapshots --backups`), provoquer un dépassement et le
     lire ; backend Ceph RBD et multi-backends en `[lecture + simulation]` — COA-04-04.
- **Break-fix** : `break/openstack/08-cinder-volume-bloque-detaching.sh` (volume figé en `detaching` : `volume set --state`
  et `server remove volume`).
- **Défi chronométré** : volume créé, attaché, formaté, monté, snapshot pris et restauré sur une seconde instance en moins de 12 min.

### F9 — `fiches/openstack/09-swift-conteneurs-et-acl.md`

- **Titre** : API Swift (Ceph RGW) — conteneurs, objets et permissions
- **Niveau** : confirmé (`openstack_conf`)
- **Couvre** : COA-05-01, COA-05-02
- **Prérequis** : F5 (bloc débutant terminé) ; RGW de `stg01` intégré à Keystone (F1). La fiche signale les écarts
  RGW / Swift natif (`ceph_rgw_swift_compatibility`, fonctions absentes) : l'examen tourne sur Swift.
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `python_openstackclient`.
- **Temps** : 3 h
- **3 exercices clés** :
  1. Créer des conteneurs, téléverser des fichiers et des arborescences (`object create`, pseudo-dossiers), lister avec
     préfixe, télécharger, supprimer ; lire `container show` et `object show` (taille, `etag`, métadonnées) — COA-05-01.
  2. Poser des métadonnées personnalisées sur objets et conteneurs, rendre un conteneur public en lecture
     (`container set --property Read=.r:*`), le vérifier avec `curl` sans token depuis `core-jump01` — COA-05-02.
  3. ACL croisées : autoriser en lecture et écriture un utilisateur d'un autre projet (`Read`/`Write` avec
     `projet:utilisateur`), tester avec deux `clouds.yaml`, retirer la permission et prouver le `403` — COA-05-02.
- **Break-fix** : `break/openstack/09-swift-acl-ecriture-retiree.sh` (ACL d'écriture retirée : `403 Forbidden` au téléversement).
- **Défi chronométré** : conteneur public en lecture, privé en écriture, vérifié par `curl` en moins de 4 min.

### F10 — `fiches/openstack/10-keystone-policies-et-regles-d-acces.md`

- **Titre** : Keystone — fichiers de policy et règles d'accès des application credentials
- **Niveau** : confirmé (`openstack_conf`)
- **Couvre** : COA-01-04
- **Prérequis** : F2, F5 (ressources Nova pour mesurer l'effet d'une policy)
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `kolla_ansible` (dépôt de policy via `/etc/kolla/config/`),
  `python_openstackclient`.
- **Temps** : 3 h
- **3 exercices clés** :
  1. Générer la policy par défaut d'un service (`oslopolicy-sample-generator`, `oslopolicy-policy-generator`) dans le
     conteneur, lire la syntaxe (`rule:`, `role:`, `project_id:%(project_id)s`), les rôles par défaut `reader`/`member`/`admin`
     et les scopes — COA-01-04.
  2. Surcharger une règle Nova (`os_compute_api:os-flavor-manage:create` ouverte au rôle `member`) dans un `policy.yaml`
     déposé via `/etc/kolla/config/nova/` puis `kolla-ansible reconfigure` ; prouver le changement avec deux utilisateurs — COA-01-04.
  3. Créer une application credential avec `--access-rules` (méthode, chemin, service), l'utiliser dans un `clouds.yaml`
     et montrer qu'un appel hors règle est refusé ; expirer et révoquer — COA-01-04.
- **Break-fix** : `break/openstack/10-keystone-policy-admin-only.sh` (règle `server create` restreinte à `admin` : `403` pour tout `member`).
- **Défi chronométré** : policy surchargée, déployée et vérifiée par deux utilisateurs en moins de 10 min.

### S1 — `scenarios/NN-coa-livrer-un-projet-locataire/README.md`

- **Titre** : NN — Livrer un projet locataire complet et tenir la cadence d'examen (numéro `NN` attribué à la création)
- **Niveau** : expert (`openstack_exp`) ; prérequis F1 à F10 complets, pas de saut direct
- **Couvre** : les 40 compétences COA en situation
- **Lab** : `openstack-kolla`. Clés `versions.yaml` : `openstack`, `kolla_ansible`, `python_openstackclient`, `cirros`.
- **Temps** : 6 h en deux séances (une de construction, une en conditions d'examen)
- **Livrable** : runbook « onboarder un projet locataire » + postmortem du break-fix transverse
- **3 exercices clés** :
  1. À partir d'un cahier des charges (domaine, projet, utilisateurs, quotas, réseau, image, flavors, instance bastion,
     volume de données, conteneur Swift de sauvegarde), tout livrer au CLI puis vérifier dans Horizon ; chronométrer chaque
     tâche pour calibrer `exams/COA/`.
  2. Rejouer la livraison en conditions d'examen (`prompts/06-examen-blanc.md` : `setup.sh`, `grade.sh`, 180 min, documentation
     officielle seulement) et comparer les deux temps.
  3. Break-fix transverse injecté à l'aveugle (`break/openstack/` en mode `random`) : trois pannes simultanées parmi les dix
     scripts des fiches ; diagnostiquer et rétablir en moins de 30 min, puis rédiger le postmortem.

## 5. Récapitulatif des estimations

| Chapitre | Niveau | Profil de lab | Temps |
|---|---|---|---|
| F1 Déployer OpenStack avec Kolla-Ansible | débutant | openstack-kolla | 9 h |
| F2 Keystone identités et fichiers RC | débutant | openstack-kolla | 4 h |
| F3 Glance images | débutant | openstack-kolla | 3 h |
| F4 Neutron réseaux, routeurs, floating IP | débutant | openstack-kolla | 5 h |
| F5 Nova flavors, instances, SSH | débutant | openstack-kolla | 5 h |
| F6 Neutron security groups, ports, quotas | confirmé | openstack-kolla | 4 h |
| F7 Nova consoles, snapshots, quotas | confirmé | openstack-kolla | 4 h |
| F8 Cinder volumes, snapshots, sauvegardes | confirmé | openstack-kolla | 5 h |
| F9 API Swift (RGW) conteneurs et ACL | confirmé | openstack-kolla | 3 h |
| F10 Keystone policies et règles d'accès | confirmé | openstack-kolla | 3 h |
| S1 Livrer un projet locataire | expert | openstack-kolla | 6 h |
| Révision (flashcards, quiz, examen blanc `exams/COA/`) | — | openstack-kolla | 6 h |
| **Total** | | | **57 h** |

À 5 h par semaine, compter 11 à 12 semaines, soit deux cycles de `docs/roadmap.md` §7. Le bloc COA ferme le parcours
« Cloud privé OpenStack » ; il ne démarre qu'une fois `linux_conf`, `reseau_conf`, `proxmox_conf` et `iac_conf` atteints
(`docs/prerequis.md` §2 et §3), domaines dont aucun chapitre n'existe au 2026-10-02.

## 6. Ce que le lab ne couvre pas

- **Backends de stockage** : Glance et Cinder tournent sur `file` et LVM ; le Ceph mono-nœud de `stg01` ne sert qu'au RGW.
  Ceph RBD pour Glance/Cinder, multi-backends et migration de volumes restent `[lecture + simulation]` (DECISIONS.md, 2026-10-02).
- **Swift natif** : l'API Swift du lab est celle de RadosGW, pas de Swift ; les commandes `openstack container` / `object` sont
  les mêmes, les écarts (fonctions non implémentées, `rgw_swift_account_in_url`) sont listés dans F9.
- **Environnement d'examen** : la version exacte, la distribution et la méthode de déploiement du cloud d'examen ne sont
  pas publiées (`examen.md`). Les chapitres n'enseignent rien qui dépende de Kolla côté API : `docker exec`, `/etc/kolla/`
  et `reconfigure` ne servent qu'au socle (F1), aux policies (F10) et aux pannes.
- **Performance** : KVM imbriqué, image `cirros`, flavors minimales ; aucun chapitre ne mesure de débit ni de latence.
- **Échelle** : un contrôleur et deux computes. Haute disponibilité des services, migration à chaud et évacuation d'hôte
  ne sont pas au programme COA et restent pour les fiches `openstack` expertes hors certification.
- **Documentation pendant l'épreuve** : autorisée, mais depuis la console d'examen seulement (`examen.md`). Les défis
  chronométrés se font avec `docs.openstack.org` ouvert dans un onglet et rien d'autre, pour reproduire la contrainte.
