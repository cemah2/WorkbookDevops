---
code: CKA
title: "Certified Kubernetes Administrator"
issuer: "CNCF / The Linux Foundation"
version: "Kubernetes 1.35"
exam_format: "pratique (terminal), 120 min, en ligne surveillé, documentation officielle autorisée"
weighted_domains: true
golden_kubestronaut: true
source_url: "https://github.com/cncf/curriculum (dernier commit consulté : 2026-03-14)"
source_file: "CKA_v1.35.pdf"
license: "CC-BY-4.0 (curriculum CNCF) — attribution : Cloud Native Computing Foundation"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# CKA — Certified Kubernetes Administrator

Programme officiel retranscrit tel quel (en anglais). Les identifiants `CKA-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Domaines

| ID | Domaine | Poids |
|---|---|---|
| CKA-01 | [Storage](#cka-01--storage) | 10 % |
| CKA-02 | [Workloads and Scheduling](#cka-02--workloads-and-scheduling) | 15 % |
| CKA-03 | [Servicing and Networking](#cka-03--servicing-and-networking) | 20 % |
| CKA-04 | [Troubleshooting](#cka-04--troubleshooting) | 30 % |
| CKA-05 | [Cluster Architecture, Installation and Configuration](#cka-05--cluster-architecture-installation-and-configuration) | 25 % |
| | **Total** | **100 %** |

## Compétences

### CKA-01 — Storage (10 %)

- **CKA-01-01** Implement storage classes and dynamic volume provisioning
- **CKA-01-02** Configure volume types, access modes and reclaim policies
- **CKA-01-03** Manage persistent volumes and persistent volume claims

### CKA-02 — Workloads and Scheduling (15 %)

- **CKA-02-01** Understand application deployments and how to perform rolling update and rollbacks
- **CKA-02-02** Use ConfigMaps and Secrets to configure applications
- **CKA-02-03** Configure workload autoscaling
- **CKA-02-04** Understand the primitives used to create robust, self-healing, application deployments
- **CKA-02-05** Configure Pod admission and scheduling (limits, node affinity, etc.)

### CKA-03 — Servicing and Networking (20 %)

- **CKA-03-01** Understand connectivity between Pods
- **CKA-03-02** Define and enforce Network Policies
- **CKA-03-03** Use ClusterIP, NodePort, LoadBalancer service types and endpoints
- **CKA-03-04** Use the Gateway API to manage Ingress traffic
- **CKA-03-05** Know how to use Ingress controllers and Ingress resources
- **CKA-03-06** Understand and use CoreDNS

### CKA-04 — Troubleshooting (30 %)

- **CKA-04-01** Troubleshoot clusters and nodes
- **CKA-04-02** Troubleshoot cluster components
- **CKA-04-03** Monitor cluster and application resource usage
- **CKA-04-04** Manage and evaluate container output streams
- **CKA-04-05** Troubleshoot services and networking

### CKA-05 — Cluster Architecture, Installation and Configuration (25 %)

- **CKA-05-01** Manage role based access control (RBAC)
- **CKA-05-02** Prepare underlying infrastructure for installing a Kubernetes cluster
- **CKA-05-03** Create and manage Kubernetes clusters using kubeadm
- **CKA-05-04** Manage the lifecycle of Kubernetes clusters
- **CKA-05-05** Implement and configure a highly-available control plane
- **CKA-05-06** Use Helm and Kustomize to install cluster components
- **CKA-05-07** Understand extension interfaces (CNI, CSI, CRI, etc.)
- **CKA-05-08** Understand CRDs, install and configure operators
