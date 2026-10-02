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
