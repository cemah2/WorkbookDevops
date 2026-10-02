---
code: CKAD
title: "Certified Kubernetes Application Developer"
issuer: "CNCF / The Linux Foundation"
version: "Kubernetes 1.35"
exam_format: "pratique (terminal), 120 min, en ligne surveillé, documentation officielle autorisée"
weighted_domains: true
golden_kubestronaut: true
source_url: "https://github.com/cncf/curriculum (dernier commit consulté : 2026-03-14)"
source_file: "CKAD_v1.35.pdf"
license: "CC-BY-4.0 (curriculum CNCF) — attribution : Cloud Native Computing Foundation"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# CKAD — Certified Kubernetes Application Developer

Programme officiel retranscrit tel quel (en anglais). Les identifiants `CKAD-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Domaines

| ID | Domaine | Poids |
|---|---|---|
| CKAD-01 | [Application Design and Build](#ckad-01--application-design-and-build) | 20 % |
| CKAD-02 | [Application Deployment](#ckad-02--application-deployment) | 20 % |
| CKAD-03 | [Application Observability and Maintenance](#ckad-03--application-observability-and-maintenance) | 15 % |
| CKAD-04 | [Application Environment, Configuration and Security](#ckad-04--application-environment-configuration-and-security) | 25 % |
| CKAD-05 | [Services and Networking](#ckad-05--services-and-networking) | 20 % |
| | **Total** | **100 %** |

## Compétences

### CKAD-01 — Application Design and Build (20 %)

- **CKAD-01-01** Define, build and modify container images
- **CKAD-01-02** Choose and use the right workload resource (Deployment, DaemonSet, CronJob, etc.)
- **CKAD-01-03** Understand multi-container Pod design patterns (e.g. sidecar, init and others)
- **CKAD-01-04** Utilize persistent and ephemeral volumes

### CKAD-02 — Application Deployment (20 %)

- **CKAD-02-01** Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
- **CKAD-02-02** Understand Deployments and how to perform rolling updates
- **CKAD-02-03** Use the Helm package manager to deploy existing packages
- **CKAD-02-04** Kustomize

### CKAD-03 — Application Observability and Maintenance (15 %)

- **CKAD-03-01** Understand API deprecations
- **CKAD-03-02** Implement probes and health checks
- **CKAD-03-03** Use built-in CLI tools to monitor Kubernetes applications
- **CKAD-03-04** Utilize container logs
- **CKAD-03-05** Debugging in Kubernetes

### CKAD-04 — Application Environment, Configuration and Security (25 %)

- **CKAD-04-01** Discover and use resources that extend Kubernetes (CRD, Operators)
- **CKAD-04-02** Understand authentication, authorization and admission control
- **CKAD-04-03** Understand requests, limits, quotas
- **CKAD-04-04** Define resource requirements
- **CKAD-04-05** Understand ConfigMaps
- **CKAD-04-06** Create & consume Secrets
- **CKAD-04-07** Understand ServiceAccounts
- **CKAD-04-08** Understand Application Security (SecurityContexts, Capabilities, etc.)

### CKAD-05 — Services and Networking (20 %)

- **CKAD-05-01** Demonstrate basic understanding of NetworkPolicies
- **CKAD-05-02** Provide and troubleshoot access to applications via services
- **CKAD-05-03** Use Ingress rules to expose applications
