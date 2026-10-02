---
code: ICA
title: "Istio Certified Associate"
issuer: "CNCF / The Linux Foundation"
version: "non versionné"
exam_format: "pratique (terminal), 120 min, en ligne surveillé"
weighted_domains: true
golden_kubestronaut: true
source_url: "https://github.com/cncf/curriculum (dernier commit consulté : 2026-03-14)"
source_file: "ICA.pdf"
license: "CC-BY-4.0 (curriculum CNCF) — attribution : Cloud Native Computing Foundation"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# ICA — Istio Certified Associate

Programme officiel retranscrit tel quel (en anglais). Les identifiants `ICA-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Domaines

| ID | Domaine | Poids |
|---|---|---|
| ICA-01 | [Installation, Upgrades, and Configuration](#ica-01--installation-upgrades-and-configuration) | 20 % |
| ICA-02 | [Traffic Management](#ica-02--traffic-management) | 35 % |
| ICA-03 | [Securing Workloads](#ica-03--securing-workloads) | 25 % |
| ICA-04 | [Troubleshooting](#ica-04--troubleshooting) | 20 % |
| | **Total** | **100 %** |

## Compétences

### ICA-01 — Installation, Upgrades, and Configuration (20 %)

- **ICA-01-01** Installing Istio with istioctl or Helm
- **ICA-01-02** Installing Istio in Sidecar or Ambient Mode
- **ICA-01-03** Customizing your Istio Installation
- **ICA-01-04** Upgrading Istio (Canary, In-Place)

### ICA-02 — Traffic Management (35 %)

- **ICA-02-01** Configuring Ingress and Egress Traffic
- **ICA-02-02** Configuring Routing within a Service Mesh
- **ICA-02-03** Defining Traffic Policies with Destination Rules
- **ICA-02-04** Configuring Traffic Shifting
- **ICA-02-05** Connecting In-Mesh Workloads to External Workloads and Services
- **ICA-02-06** Using Resilience Features (circuit breaking, failover, outlier detection, timeouts, retries)
- **ICA-02-07** Using Fault Injection

### ICA-03 — Securing Workloads (25 %)

- **ICA-03-01** Configuring Authorization
- **ICA-03-02** Configuring Authentication (mTLS, JWT)
- **ICA-03-03** Securing Edge Traffic with TLS

### ICA-04 — Troubleshooting (20 %)

- **ICA-04-01** Troubleshooting Configuration
- **ICA-04-02** Troubleshooting the Mesh Control Plane
- **ICA-04-03** Troubleshooting the Mesh Data Plane
