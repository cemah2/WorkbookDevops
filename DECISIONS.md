# Journal des décisions

Une entrée par arbitrage. On n'efface pas : on ajoute une entrée qui remplace l'ancienne.
Format : date · décision · pourquoi · conséquences.

## 2026-10-02 — Le dépôt Git est la source de vérité

Tout le contenu (chapitres, solutions, labs, programmes de certification, décisions) vit dans ce dépôt.
Les conversations avec Claude n'ont pas de mémoire fiable ; les fichiers en ont une.
Conséquence : une session Claude Code par chapitre, contexte repart propre à chaque fois.

## 2026-10-02 — Programmes de certification versionnés dans `certifs/`

Convertis en Markdown avec identifiants stables `CODE-DD-CC`. Les PDF CNCF (CC-BY 4.0) sont conservés
dans `certifs/_sources_pdf/`. Les documents sous licence restrictive (CIS Benchmarks…) ne sont pas committés.

## 2026-10-02 — Open source d'abord

OpenTofu et OpenBao dans les scénarios ; Terraform et Vault seulement dans `certifs/TFA` et `certifs/VA`
avec une section « différences à connaître ». Pas de module VMware (contexte Broadcom) : au plus une fiche
« migrer depuis vSphere ».

## 2026-10-02 — Red Hat sur du vrai RHEL

Abonnement Red Hat Developer (gratuit, 16 systèmes) pour RHCSA/RHCE. Rocky/Alma acceptés pour les
scénarios génériques.

## 2026-10-02 — Trois niveaux, pas deux

Débutant / confirmé / expert dans chaque domaine. Le palier « confirmé » est explicite.

## 2026-10-02 — Ce que le lab ne peut pas faire est dit

Un seul socket, pas de GPU NVIDIA : NUMA, hugepages réels, SR-IOV, RDMA, MIG, OVS-DPDK sont
`[lecture + simulation]`. Le module GPU/IA est en deux temps : partie CPU (Ollama, Open WebUI, LiteLLM,
KServe CPU, modèles comme artefacts) faisable maintenant ; partie GPU conditionnée à l'achat d'une carte.

## 2026-10-02 — Ingress : former sur Gateway API

ingress-nginx est retiré ; les chapitres réseau Kubernetes enseignent Gateway API (Cilium ou Envoy Gateway)
et ne gardent Ingress que pour les objectifs d'examen qui le citent encore.

## 2026-10-02 — Un seul fichier de versions

`versions.yaml` est la seule source ; les chapitres sont templatés dessus ; Renovate ouvre les PR de mise à jour.

## 2026-10-02 — Les identifiants de compétence ne bougent pas

Une compétence retirée par l'éditeur reste barrée un cycle avec `(retiré vX)` ; un ajout prend le numéro
suivant, jamais un numéro libéré.

## 2026-10-02 — Dépôt GitHub `cemah2/WorkbookDevops`, branche `main`

Le workbook vit dans le dépôt existant `cemah2/WorkbookDevops` (public), pas dans un nouveau dépôt privé.
`main` est la branche de référence ; chaque chapitre arrive par une branche et une PR.
Conséquence : la CI tourne sur `main` et les PR ; GitHub Pages et Renovate restent à activer.

## 2026-10-02 — Routeur virtuel : OPNsense

`core-rtr01` est une VM OPNsense : routage inter-VLAN, NAT vers le LAN, filtrage, coupure du VLAN air-gap.
VyOS n'est pas retenu (au plus une fiche de comparaison). Le serveur DNS interne (PowerDNS ou BIND) reste à trancher.

## 2026-10-02 — Image Linux de référence : Ubuntu 24.04 LTS

Tant que Kolla-Ansible de la série cible (2026.1 Gazpacho) ne supporte pas 26.04, les VM du lab partent de 24.04 LTS.
26.04.1 LTS existe et sera adoptée à la bascule vers la série OpenStack qui la supporte (à vérifier à la veille).
Conséquence : `versions.yaml` garde 24.04 en `ubuntu_lts` et note la version plus récente.

## 2026-10-02 — Helm 4 partout

Les chapitres Kubernetes utilisent Helm 4 (Helm 3 est en fin de vie). Les différences utiles pour un examen qui
tournerait encore en Helm 3 sont signalées dans le chapitre concerné, pas enseignées à part.

## 2026-10-02 — Ceph 20 Tentacle

Le lab et les chapitres Ceph ciblent la série 20 (Tentacle). Pas de release candidate (21 Umbrella) sur le lab
avant sa première version stable x.2.0.

## 2026-10-02 — Terraform et Vault : version d'examen

Les chapitres `certifs/TFA` et `certifs/VA` sont préparés sur la version annoncée par l'examen
(`exam_version` dans `versions.yaml`), avec une section « différences avec la version courante » tenue à jour
par la veille. Le reste du workbook utilise OpenTofu et OpenBao.

## 2026-10-02 — Plan d'adressage, zone DNS et graphe de prérequis validés

`labs/network.md` (agrégat `10.10.0.0/16`, VLAN 10 à 60, zone `lab.home.arpa`), les six profils de `labs/profiles/`
et `docs/prerequis.md` (13 domaines, 3 niveaux, 4 parcours) sont la référence. Toute modification passe par une
nouvelle entrée ici.
