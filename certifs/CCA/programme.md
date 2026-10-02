---
code: CCA
title: "Cilium Certified Associate"
issuer: "CNCF / The Linux Foundation"
version: "non versionné"
exam_format: "QCM, 90 min, en ligne surveillé"
weighted_domains: true
golden_kubestronaut: true
source_url: "https://github.com/cncf/curriculum (dernier commit consulté : 2026-03-14)"
source_file: "CCA.pdf"
license: "CC-BY-4.0 (curriculum CNCF) — attribution : Cloud Native Computing Foundation"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# CCA — Cilium Certified Associate

Programme officiel retranscrit tel quel (en anglais). Les identifiants `CCA-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Domaines

| ID | Domaine | Poids |
|---|---|---|
| CCA-01 | [Architecture](#cca-01--architecture) | 20 % |
| CCA-02 | [Network Policy](#cca-02--network-policy) | 18 % |
| CCA-03 | [Service Mesh](#cca-03--service-mesh) | 16 % |
| CCA-04 | [Network Observability](#cca-04--network-observability) | 10 % |
| CCA-05 | [Installation and Configuration](#cca-05--installation-and-configuration) | 10 % |
| CCA-06 | [Cluster Mesh](#cca-06--cluster-mesh) | 10 % |
| CCA-07 | [eBPF](#cca-07--ebpf) | 10 % |
| CCA-08 | [BGP and External Networking](#cca-08--bgp-and-external-networking) | 6 % |
| | **Total** | **100 %** |

## Compétences

### CCA-01 — Architecture (20 %)

- **CCA-01-01** Understand the Role of Cilium in Kubernetes Environments
- **CCA-01-02** Cilium Architecture
- **CCA-01-03** IP Address Management (IPAM) with Cilium
- **CCA-01-04** Cilium Component Roles
- **CCA-01-05** Datapath Models

### CCA-02 — Network Policy (18 %)

- **CCA-02-01** Interpret Cilium Network Policies and Intent
- **CCA-02-02** Understand Cilium's Identity-based Network Security Model
- **CCA-02-03** Policy Enforcement Modes
- **CCA-02-04** Policy Rule Structure
- **CCA-02-05** Kubernetes Network Policies versus Cilium Network Policies

### CCA-03 — Service Mesh (16 %)

- **CCA-03-01** Know How to use Ingress or Gateway API for Ingress Routing
- **CCA-03-02** Service Mesh Use Cases
- **CCA-03-03** Understand the Benefits of Gateway API over Ingress
- **CCA-03-04** Encrypting Traffic in Transit with Cilium
- **CCA-03-05** Sidecar-based versus Sidecarless Architectures

### CCA-04 — Network Observability (10 %)

- **CCA-04-01** Understand the Observability Capabilities of Hubble
- **CCA-04-02** Enabling Layer 7 Protocol Visibility
- **CCA-04-03** Know How to Use Hubble from the Command Line or the Hubble UI

### CCA-05 — Installation and Configuration (10 %)

- **CCA-05-01** Know How to Use Cilium CLI to Query and Modify the Configuration
- **CCA-05-02** Using Cilium CLI to Install Cilium, Run Connectivity Tests, and Monitor its Status

### CCA-06 — Cluster Mesh (10 %)

- **CCA-06-01** Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
- **CCA-06-02** Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh

### CCA-07 — eBPF (10 %)

- **CCA-07-01** Understand the Role of eBPF in Cilium
- **CCA-07-02** eBPF Key Benefits
- **CCA-07-03** eBPF-based Platforms versus IPtables-based Platforms

### CCA-08 — BGP and External Networking (6 %)

- **CCA-08-01** Egress Connectivity Requirements
- **CCA-08-02** Understand Options to Connect Cilium-managed Clusters with External Networks
