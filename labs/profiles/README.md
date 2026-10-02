# labs/profiles/ — profils de lab déclaratifs

Un fichier YAML par profil, consommé par `lab up <profil>` / `lab down` (OpenTofu `bpg/proxmox` + cloud-init + Ansible).
Budget hôte : **16 vCPU / 128 Go RAM**, NVMe 2 To (VM performantes), SSD 2 To (OSD Ceph), HDD 2 To (PBS, ISO, templates).

Règles :

- L'hôte Proxmox garde en permanence **2 vCPU / 8 Go** ; le socle `core` (routeur, DNS, PKI, PBS) coûte **4 vCPU / 8 Go**
  et est toujours actif. Reste disponible pour un profil : **10 vCPU / 112 Go** sans surallocation CPU.
- Les vCPU sont surallouables (ratio ≤ 2:1 accepté sur un lab), la RAM ne l'est pas : la somme `ram_gb` des profils
  actifs + `core` + hôte doit rester ≤ 128 Go. Les profils ci-dessous respectent cette règle **individuellement**.
- Combinaisons autorisées simultanément : `linux-base` + un profil lourd ; `ceph-3n` + `kubernetes-ha` (budget vérifié
  dans chaque fichier) ; jamais `openstack-kolla` + `kubernetes-ha`.
- Adresses, VLAN et noms : `labs/network.md`. Versions : `versions.yaml`.

| Profil | VM | vCPU (alloués) | RAM | Disque | VLAN | Pour |
|---|---|---|---|---|---|---|
| `core` | 5 | 7 | 8 Go | 240 Go | lan, 10, 20, 50 | socle permanent (toujours actif) |
| `linux-base` | 4 | 8 | 16 Go | 180 Go | 10 | Linux, réseau, LFCS, RHCSA/RHCE |
| `kubernetes-ha` | 6 | 16 | 48 Go | 300 Go | 10, 30, 40 | Kubernetes HA kubeadm/Talos, Cilium, GitOps, observabilité |
| `ceph-3n` | 3 | 12 | 48 Go | 60 Go + 3×200 Go OSD | 10, 20, 21 | Ceph, Rook, Velero/CSI |
| `openstack-kolla` | 4 | 20 | 96 Go | 420 Go + 60 Go OSD | 10, 20, 30, 40 | OpenStack Kolla-Ansible (+ Ceph RGW mono-nœud pour l'API Swift), COA |
| `airgap` | 2 | 6 | 24 Go | 400 Go | 50 | hors-ligne : miroirs, Harbor proxy, cluster déconnecté |

Les vCPU « alloués » peuvent dépasser 10 grâce à la surallocation ; la RAM, jamais.
