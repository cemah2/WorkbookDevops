# Plan d'adressage et de VLAN du lab

Référence unique pour tous les chapitres : on ne réinvente jamais une adresse, on cite ce fichier.
Hôte : un serveur Proxmox VE (16 vCPU, 128 Go RAM, NVMe 2 To + SSD 2 To + HDD 2 To).
LAN existant : `192.168.0.0/24`, passerelle `192.168.0.254` (box/routeur du site, hors de notre contrôle).

## 1. Principes

- Le LAN `192.168.0.0/24` reste le réseau **domestique** : on n'y met que l'hôte Proxmox, le poste
  de travail et quelques services exposés. Tout le reste vit dans des réseaux internes au serveur.
- Un **routeur virtuel OPNsense** (`core-rtr01`, décision du 2026-10-02) route entre les réseaux internes et fait NAT vers le LAN.
  C'est lui qui porte les règles de filtrage inter-VLAN et la coupure du VLAN air-gap.
- Les réseaux internes sont des VLAN sur un bridge dédié `vmbr1` (VLAN-aware), sans carte physique :
  rien ne sort du serveur sans passer par le routeur virtuel. Le SDN Proxmox (zone VLAN, puis EVPN/VXLAN
  avec FRR dans les chapitres experts) s'appuie sur ce même bridge.
- Plage d'agrégat interne : `10.10.0.0/16` (un `/24` par VLAN, numéro de VLAN = troisième octet).
  Aucun chevauchement avec le LAN ni avec les CIDR Kubernetes/OpenStack ci-dessous.
- Adresses `.1` = routeur virtuel, `.2`–`.9` = infrastructure (DNS, miroirs), `.10`–`.99` = VM statiques,
  `.100`–`.199` = DHCP/cloud-init, `.200`–`.254` = pools (MetalLB, VIP, floating IP).

## 2. Bridges Proxmox

| Bridge | Rôle | Carte physique | VLAN-aware | Réseaux |
|---|---|---|---|---|
| `vmbr0` | LAN domestique | oui (NIC du serveur) | non | `192.168.0.0/24` |
| `vmbr1` | fabric interne du lab | aucune | oui | VLAN 10 à 60 ci-dessous |

## 3. VLAN et sous-réseaux

| VLAN | Nom | CIDR | Passerelle (routeur virtuel) | Usage | Sort vers le LAN ? |
|---|---|---|---|---|---|
| — | `lan` | `192.168.0.0/24` | `192.168.0.254` | hôte Proxmox, poste de travail, routeur virtuel (patte externe) | — |
| 10 | `mgmt` | `10.10.10.0/24` | `10.10.10.1` | management : SSH, API Proxmox/OpenStack, Ansible, DNS, PKI, IdP, NetBox | oui (NAT) |
| 20 | `storage` | `10.10.20.0/24` | `10.10.20.1` | Ceph public (clients, mons), NFS, iSCSI, PBS | non |
| 21 | `storage-cluster` | `10.10.21.0/24` | aucune (L2 seul) | Ceph cluster (réplication OSD), isolé, MTU 9000 | non |
| 30 | `overlay` | `10.10.30.0/24` | `10.10.30.1` | underlay des overlays : VXLAN/Geneve Cilium, Neutron tunnels, EVPN | non |
| 40 | `provider` | `10.10.40.0/24` | `10.10.40.1` | réseau provider/externe OpenStack (floating IP), VIP et LoadBalancer Kubernetes | oui (NAT) |
| 50 | `airgap` | `10.10.50.0/24` | `10.10.50.1` (filtrage : deny all sauf miroirs) | VLAN coupé d'Internet : VM miroirs (apt-mirror, Harbor proxy, Nexus, CA) et clusters hors-ligne | non (bloqué au routeur) |
| 60 | `wan-sim` | `10.10.60.0/24` | `10.10.60.1` | « site B » pour le multi-site simulé (`tc netem`), stretch cluster, quorum | non |

Réservations dans chaque `/24` :

| Plage | Usage |
|---|---|
| `.1` | routeur virtuel |
| `.2`–`.9` | infrastructure fixe (DNS `.2`, PKI `.3`, IdP `.4`, miroir `.5`, PBS `.6`, NetBox `.7`) |
| `.10`–`.99` | VM à adresse statique (cloud-init), par profil (voir §5) |
| `.100`–`.199` | DHCP (routeur virtuel) et VM éphémères |
| `.200`–`.254` | pools : MetalLB (`.200`–`.219`), VIP kube-apiserver (`.220`), floating IP OpenStack (`.230`–`.254`) |

## 4. CIDR réservés aux plateformes (ne chevauchent rien ci-dessus)

| Plateforme | Pods / tenants | Services | Remarque |
|---|---|---|---|
| Kubernetes (tous clusters, kubeadm/Talos/k3s/RKE2) | `10.244.0.0/16` | `10.96.0.0/12` | un seul cluster actif par profil ; cluster « site B » en `10.245.0.0/16` / `10.112.0.0/12` |
| Cilium ClusterMesh (expert) | distincts par cluster, cf. ligne précédente | — | `[lecture + simulation]` si budget insuffisant |
| OpenStack Neutron (tenants, overlay Geneve) | `10.200.0.0/16` (réseaux projets) | — | provider = VLAN 40 ; floating IP dans `10.10.40.230`–`.254` |
| Docker / Podman sur les VM | `172.17.0.0/16` (défaut) | — | ne jamais exposer sur `vmbr1` |

## 5. Nommage des VM

Format : `<profil>-<rôle><nn>` en minuscules, sans underscore. Le profil est un des `labs/profiles/*.yaml`.

| Rôle | Préfixe | Exemples |
|---|---|---|
| routeur virtuel | `rtr` | `core-rtr01` (unique, hors profil) |
| services de base | `svc` | `core-dns01`, `core-pki01`, `core-idp01`, `core-mirror01`, `core-pbs01` |
| Linux générique | `lx` | `linux-base-lx01` … `lx04` |
| control plane Kubernetes | `cp` | `kubernetes-ha-cp01` … `cp03` |
| worker Kubernetes | `wk` | `kubernetes-ha-wk01` … `wk03` |
| nœud Ceph | `osd` | `ceph-3n-osd01` … `osd03` |
| contrôleur OpenStack | `ctl` | `openstack-kolla-ctl01` |
| compute OpenStack | `cmp` | `openstack-kolla-cmp01`, `cmp02` |
| nœud air-gap | `ag` | `airgap-ag01` |
| bastion / poste de travail | `jump` | `core-jump01` |

VMID Proxmox : `<VLAN principal><nn>` sur quatre chiffres, ex. `1001` pour `core-dns01` (VLAN 10), `3001`
pour `kubernetes-ha-cp01`. Le routeur virtuel est `100`.

Attribution d'adresses statiques par profil (dans `.10`–`.99` du VLAN `mgmt`, les autres VLAN
reprennent le même dernier octet) :

| Profil | Plage `mgmt` | Détail |
|---|---|---|
| `core` (services permanents) | `10.10.10.2`–`.9` | voir réservations §3 |
| `linux-base` | `10.10.10.10`–`.19` | `lx01` = `.11` |
| `kubernetes-ha` | `10.10.10.20`–`.39` | `cp01`–`cp03` = `.21`–`.23`, `wk01`–`wk03` = `.31`–`.33`, VIP API = `10.10.40.220` |
| `ceph-3n` | `10.10.10.40`–`.49` | `osd01`–`osd03` = `.41`–`.43` (idem en `10.10.20.x` et `10.10.21.x`) |
| `openstack-kolla` | `10.10.10.50`–`.69` | `ctl01` = `.51`, `cmp01`–`cmp02` = `.61`–`.62`, VIP interne = `.70`, VIP externe = `10.10.40.221` |
| `airgap` | `10.10.50.10`–`.49` | `ag01` = `10.10.50.11`, miroir = `10.10.50.5` |

Pas plus d'un profil « lourd » (`kubernetes-ha`, `openstack-kolla`, `ceph-3n`) actif à la fois : les plages
ne se chevauchent pas pour permettre de les combiner quand le budget le permet (voir `labs/profiles/README.md`).

## 6. DNS interne

- Zone interne : `lab.local` est proscrit (mDNS). Zone retenue : **`lab.home.arpa`** (RFC 8375, non résolue publiquement).
  Sous-zones par VLAN : `mgmt.lab.home.arpa`, `storage.lab.home.arpa`, `provider.lab.home.arpa`, `airgap.lab.home.arpa`.
- Chaque VM a un enregistrement `A` dans la sous-zone de chacun de ses VLAN : `kubernetes-ha-cp01.mgmt.lab.home.arpa`.
  Le nom court (`kubernetes-ha-cp01.lab.home.arpa`) pointe vers l'adresse `mgmt`.
- Alias de service (`CNAME`) découplés des VM : `dns.lab.home.arpa`, `pki.lab.home.arpa`, `idp.lab.home.arpa`,
  `mirror.lab.home.arpa`, `registry.lab.home.arpa`, `git.lab.home.arpa`, `api.k8s.lab.home.arpa` (VIP),
  `*.apps.lab.home.arpa` (wildcard vers le pool MetalLB / Gateway API), `*.os.lab.home.arpa` (OpenStack).
- Reverse DNS (`PTR`) maintenu pour `10.10.0.0/16`.
- Serveur : `core-dns01` (`10.10.10.2`, PowerDNS ou BIND, à décider ; OPNsense ne porte que le relais DHCP/DNS).
  Récurseur vers le LAN pour Internet,
  sauf dans le VLAN `airgap` où `core-mirror01` fait autorité sans récursion.
- Le routeur virtuel distribue `10.10.10.2` comme DNS en DHCP ; le LAN domestique n'est pas modifié.
- PKI : CA interne `Lab Root CA` (step-ca ou OpenBao PKI) émettant pour `*.lab.home.arpa` ; la CA est
  distribuée par cloud-init à toutes les VM.

## 7. Flux autorisés (résumé, règles dans le routeur virtuel)

| De → vers | `lan` | `mgmt` | `storage` | `overlay` | `provider` | `airgap` | `wan-sim` |
|---|---|---|---|---|---|---|---|
| `lan` (poste) | — | SSH, HTTPS, API | non | non | HTTPS, VIP | non | non |
| `mgmt` | NAT Internet | — | oui | oui | oui | miroirs seulement | oui |
| `storage` / `storage-cluster` | non | non | — | non | non | non | non |
| `overlay` | non | non | non | — | non | non | `tc netem` |
| `provider` | NAT Internet | non | non | non | — | non | non |
| `airgap` | **bloqué** | miroirs seulement | non | non | non | — | non |
| `wan-sim` | non | oui | non | `tc netem` | non | non | — |

## 8. Ce qui n'est pas tranché

- Serveur DNS : PowerDNS (API, NetBox) ou BIND (classique, LFCS/RHCE).
- Un second NIC physique pour `vmbr1` si un switch managé est disponible (non requis).
