---
code: CNPE
title: "Certified Cloud Native Platform Engineer"
issuer: "CNCF / The Linux Foundation"
version: "non versionné"
exam_format: "pratique (terminal), 120 min, en ligne surveillé"
weighted_domains: true
golden_kubestronaut: true
source_url: "https://github.com/cncf/curriculum (dernier commit consulté : 2026-03-14)"
source_file: "CNPE.pdf"
license: "CC-BY-4.0 (curriculum CNCF) — attribution : Cloud Native Computing Foundation"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# CNPE — Certified Cloud Native Platform Engineer

Programme officiel retranscrit tel quel (en anglais). Les identifiants `CNPE-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Domaines

| ID | Domaine | Poids |
|---|---|---|
| CNPE-01 | [Platform Architecture and Infrastructure](#cnpe-01--platform-architecture-and-infrastructure) | 15 % |
| CNPE-02 | [GitOps and Continuous Delivery](#cnpe-02--gitops-and-continuous-delivery) | 25 % |
| CNPE-03 | [Platform APIs and Self-Service Capabilities](#cnpe-03--platform-apis-and-self-service-capabilities) | 25 % |
| CNPE-04 | [Observability and Operations](#cnpe-04--observability-and-operations) | 20 % |
| CNPE-05 | [Security and Policy Enforcement](#cnpe-05--security-and-policy-enforcement) | 15 % |
| | **Total** | **100 %** |

## Compétences

### CNPE-01 — Platform Architecture and Infrastructure (15 %)

- **CNPE-01-01** Applying Platform Architecture Best Practices for Networking, Storage, and Compute
- **CNPE-01-02** Using Cost Management Solutions for Right-Sizing and Scaling
- **CNPE-01-03** Optimizing Multi-Tenancy Resource Usage

### CNPE-02 — GitOps and Continuous Delivery (25 %)

- **CNPE-02-01** Implementing GitOps Workflows for Application and Infrastructure Deployment
- **CNPE-02-02** Building and Configuring CI/CD Pipelines Integrated with Kubernetes
- **CNPE-02-03** Deploying Applications Using Progressive Delivery Strategies (e.g., Blue/Green or Canary)

### CNPE-03 — Platform APIs and Self-Service Capabilities (25 %)

- **CNPE-03-01** Designing and Creating Custom Resource Definitions (CRDs) for Platform Services
- **CNPE-03-02** Implementing Workflows for Self-Service Provisioning Using Platform APIs
- **CNPE-03-03** Using Kubernetes Operators for Platform Automation and Integration
- **CNPE-03-04** Using Automation Frameworks for Self-Service Provisioning

### CNPE-04 — Observability and Operations (20 %)

- **CNPE-04-01** Implementing Monitoring, Alerting, Logging, and Tracing Solutions
- **CNPE-04-02** Measuring and Improving Platform Efficiency Using Deployment Metrics and Performance Indicators
- **CNPE-04-03** Diagnosing and Remediating Platform Issue and Incident Scenarios

### CNPE-05 — Security and Policy Enforcement (15 %)

- **CNPE-05-01** Configuring Secure Service-to-Service Communication
- **CNPE-05-02** Applying RBAC and Security Controls Across Platform Resources
- **CNPE-05-03** Generating Audit Trails and Enforcing Policy Compliance (SBOM, Compliance Reports, etc.)
- **CNPE-05-04** Using Policy Engines and Admission Controllers for Governance
- **CNPE-05-05** Integrating Security Scanning and Compliance Checks into Deployment Pipelines

## Outils cités par le programme (page 3 du PDF)

Le candidat doit savoir accomplir des tâches avec des outils qu'il ne connaît pas, en s'appuyant sur la documentation disponible pendant l'examen. Les projets ci-dessous sont donnés par la CNCF comme exemples de ce qui peut apparaître ; il n'y a pas de question sur les détails internes d'un outil s'il n'est pas cité dans les compétences.

Argo · Crossplane · Flagger · Flux · Gatekeeper · Grafana · Istio · Jaeger · Kyverno · Linkerd · OPA · OpenCost · OpenTelemetry · Prometheus · Tekton
