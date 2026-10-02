---
code: KCA
title: "Kyverno Certified Associate"
issuer: "CNCF / The Linux Foundation"
version: "non versionné"
exam_format: "QCM, 90 min, en ligne surveillé"
weighted_domains: true
golden_kubestronaut: true
source_url: "https://github.com/cncf/curriculum (dernier commit consulté : 2026-03-14)"
source_file: "KCA.pdf"
license: "CC-BY-4.0 (curriculum CNCF) — attribution : Cloud Native Computing Foundation"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# KCA — Kyverno Certified Associate

Programme officiel retranscrit tel quel (en anglais). Les identifiants `KCA-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Domaines

| ID | Domaine | Poids |
|---|---|---|
| KCA-01 | [Fundamentals of Kyverno](#kca-01--fundamentals-of-kyverno) | 18 % |
| KCA-02 | [Installation, Configuration, and Upgrades](#kca-02--installation-configuration-and-upgrades) | 18 % |
| KCA-03 | [Kyverno CLI](#kca-03--kyverno-cli) | 12 % |
| KCA-04 | [Applying Policies](#kca-04--applying-policies) | 10 % |
| KCA-05 | [Writing Policies](#kca-05--writing-policies) | 32 % |
| KCA-06 | [Policy Management](#kca-06--policy-management) | 10 % |
| | **Total** | **100 %** |

## Compétences

### KCA-01 — Fundamentals of Kyverno (18 %)

- **KCA-01-01** Kyverno Policies & Rules
- **KCA-01-02** YAML Manifests
- **KCA-01-03** Admission Controllers
- **KCA-01-04** OCI Images

### KCA-02 — Installation, Configuration, and Upgrades (18 %)

- **KCA-02-01** Helm-based Installation and Configuration
- **KCA-02-02** Kyverno Custom Resource Definitions (CRDs)
- **KCA-02-03** Controller Configuration with Flags
- **KCA-02-04** Configuring Kyverno RBAC, roles, and permissions
- **KCA-02-05** High Availability Installations
- **KCA-02-06** Upgrading Kyverno

### KCA-03 — Kyverno CLI (12 %)

- **KCA-03-01** apply
- **KCA-03-02** test
- **KCA-03-03** jp
- **KCA-03-04** Installing Kyverno CLI

### KCA-04 — Applying Policies (10 %)

- **KCA-04-01** Applying Policy in Cluster
- **KCA-04-02** Resource Selection
- **KCA-04-03** Common Policy Settings for Kyverno Rules

### KCA-05 — Writing Policies (32 %)

- **KCA-05-01** Validation Rules
- **KCA-05-02** Preconditions
- **KCA-05-03** Background Scans
- **KCA-05-04** Mutation Rules
- **KCA-05-05** Generation Rules
- **KCA-05-06** VerifyImage Rules
- **KCA-05-07** Variables & API Calls in Policies
- **KCA-05-08** JSON Patches
- **KCA-05-09** Autogen Rules
- **KCA-05-10** Cleanup Policies
- **KCA-05-11** Common Expression Language (CEL)

### KCA-06 — Policy Management (10 %)

- **KCA-06-01** Policy Reports
- **KCA-06-02** PolicyExceptions
- **KCA-06-03** Kyverno Metrics
