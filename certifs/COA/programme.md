---
code: COA
title: "Certified OpenStack Administrator"
issuer: "OpenInfra Foundation"
version: "OpenStack 2026.1 Gazpacho (⚠️ à confirmer dans le handbook)"
exam_format: "pratique (terminal), 180 min, en ligne surveillé"
weighted_domains: true
golden_kubestronaut: false
source_url: "https://www.openstack.org/coa/requirements"
source_file: "programmes-certifications/autres/COA_OpenStack.md (retranscription)"
license: "Objectifs d'examen publics, retranscrits depuis la page officielle ; texte © éditeur, usage de référence"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# COA — Certified OpenStack Administrator

Programme officiel retranscrit tel quel (en anglais). Les identifiants `COA-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Notes

- Version : la page des exigences indique OpenStack 2026.1 « Gazpacho » ; la page d'accueil affiche encore un visuel « Caracal ». ⚠️ À VÉRIFIER dans le handbook du candidat avant de figer la version du lab.
- Inscription : ouverte au 2026-09-28. Prérequis conseillé : bases de gestion des processus sous Ubuntu, environ 6 mois de pratique OpenStack.
- Note lab : l'objectif Object Storage implique Swift (ou l'API Swift de Ceph RGW). À prévoir dans le déploiement Kolla-Ansible.

## Domaines

| ID | Domaine | Poids |
|---|---|---|
| COA-01 | [Identity Management](#coa-01--identity-management) | 15 % |
| COA-02 | [Compute](#coa-02--compute) | 35 % |
| COA-03 | [Networking](#coa-03--networking) | 30 % |
| COA-04 | [Block Storage](#coa-04--block-storage) | 10 % |
| COA-05 | [Object Storage](#coa-05--object-storage) | 5 % |
| COA-06 | [Image Management](#coa-06--image-management) | 5 % |
| | **Total** | **100 %** |

## Compétences

### COA-01 — Identity Management (15 %)

- **COA-01-01** Manage and create domains, projects, users, and roles
- **COA-01-02** Understand the differences between the member and admin roles
- **COA-01-03** Create roles for the environment
- **COA-01-04** Create and manage policy files and user access rules
- **COA-01-05** Create and manage RC files to authenticate with Keystone for command line use

### COA-02 — Compute (35 %)

- **COA-02-01** Create and manage flavors
- **COA-02-02** Create and manage compute instances (for example, launch, shutdown, terminate)
- **COA-02-03** Generate and manage SSH keys for use when connecting to instances
- **COA-02-04** Access an instance using an SSH key
- **COA-02-05** Configure an instance with a floating IP address; use it to connect to the instance
- **COA-02-06** Create instances with security groups
- **COA-02-07** Manage Nova host consoles (VNC, NOVNC, spice)
- **COA-02-08** Manage instance snapshots
- **COA-02-09** Manage instance quotas

### COA-03 — Networking (30 %)

- **COA-03-01** Manage network resources (routers, networks, subnets)
- **COA-03-02** Create external/public networks
- **COA-03-03** Create project networks
- **COA-03-04** Create project routers
- **COA-03-05** Attach routers to public and project networks
- **COA-03-06** Manage network services for a virtual environment
- **COA-03-07** Manage network quotas
- **COA-03-08** Manage network interfaces on compute instances
- **COA-03-09** Create and manage project security groups and rules
- **COA-03-10** Assign security group to instance
- **COA-03-11** Create and manage floating IP addresses
- **COA-03-12** Assign floating IP address to instance
- **COA-03-13** Detach floating IP address from instance

### COA-04 — Block Storage (10 %)

- **COA-04-01** Create and manage volumes
- **COA-04-02** Attach volumes to instances
- **COA-04-03** Create a new Block Storage volume and mount it to a Nova instance
- **COA-04-04** Manage volume quotas
- **COA-04-05** Backup and restore volumes
- **COA-04-06** Manage volume snapshots (for example, create, list, recover)

### COA-05 — Object Storage (5 %)

- **COA-05-01** Use the command line client to upload and manage files to Swift containers
- **COA-05-02** Manage permissions on a container in object storage

### COA-06 — Image Management (5 %)

- **COA-06-01** Upload a new image to an OpenStack image repository
- **COA-06-02** Manage images (for example, add, update, remove)
- **COA-06-03** Understand the difference between public versus private images
- **COA-06-04** Manage image metadata/properties
- **COA-06-05** Manage image types and backends
