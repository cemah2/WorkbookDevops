---
code: CKS
title: "Certified Kubernetes Security Specialist"
issuer: "CNCF / The Linux Foundation"
version: "Kubernetes 1.34 (⚠️ vérifier la version en vigueur avant ce jalon)"
exam_format: "pratique (terminal), 120 min, en ligne surveillé, documentation officielle autorisée ; prérequis : CKA valide"
weighted_domains: true
golden_kubestronaut: true
source_url: "https://github.com/cncf/curriculum (dernier commit consulté : 2026-03-14)"
source_file: "CKS_v1.34.pdf"
license: "CC-BY-4.0 (curriculum CNCF) — attribution : Cloud Native Computing Foundation"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# CKS — Certified Kubernetes Security Specialist

Programme officiel retranscrit tel quel (en anglais). Les identifiants `CKS-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Notes

- Le dépôt CNCF était encore en 1.34 au 2026-09-28 alors que CKA/CKAD sont en 1.35 : vérifier la version de l'examen avant de figer le lab.

## Domaines

| ID | Domaine | Poids |
|---|---|---|
| CKS-01 | [Cluster Setup](#cks-01--cluster-setup) | 15 % |
| CKS-02 | [Cluster Hardening](#cks-02--cluster-hardening) | 15 % |
| CKS-03 | [System Hardening](#cks-03--system-hardening) | 10 % |
| CKS-04 | [Minimize Microservice Vulnerabilities](#cks-04--minimize-microservice-vulnerabilities) | 20 % |
| CKS-05 | [Supply Chain Security](#cks-05--supply-chain-security) | 20 % |
| CKS-06 | [Monitoring, Logging and Runtime Security](#cks-06--monitoring-logging-and-runtime-security) | 20 % |
| | **Total** | **100 %** |

## Compétences

### CKS-01 — Cluster Setup (15 %)

- **CKS-01-01** Use Network security policies to restrict cluster level access
- **CKS-01-02** Use CIS benchmark to review the security configuration of Kubernetes components (etcd, kubelet, kubedns, kubeapi)
- **CKS-01-03** Properly set up Ingress objects with TLS
- **CKS-01-04** Protect node metadata and endpoints
- **CKS-01-05** Verify platform binaries before deploying

### CKS-02 — Cluster Hardening (15 %)

- **CKS-02-01** Use Role Based Access Controls to minimize exposure
- **CKS-02-02** Exercise caution in using service accounts e.g. disable defaults, minimize permissions on newly created ones
- **CKS-02-03** Restrict access to Kubernetes API
- **CKS-02-04** Upgrade Kubernetes to avoid vulnerabilities

### CKS-03 — System Hardening (10 %)

- **CKS-03-01** Minimize host OS footprint (reduce attack surface)
- **CKS-03-02** Using least-privilege identity and access management
- **CKS-03-03** Minimize external access to the network
- **CKS-03-04** Appropriately use kernel hardening tools such as AppArmor, seccomp

### CKS-04 — Minimize Microservice Vulnerabilities (20 %)

- **CKS-04-01** Use appropriate pod security standards
- **CKS-04-02** Manage kubernetes secrets
- **CKS-04-03** Understand and implement isolation techniques (multi-tenancy, sandboxed containers, etc.)
- **CKS-04-04** Implement Pod-to-Pod encryption (Cilium, Istio)

### CKS-05 — Supply Chain Security (20 %)

- **CKS-05-01** Minimize base image footprint
- **CKS-05-02** Understand your supply chain (e.g. SBOM, CI/CD, artifact repositories)
- **CKS-05-03** Secure your supply chain (permitted registries, sign and validate artifacts, etc.)
- **CKS-05-04** Perform static analysis of user workloads and container images (e.g. Kubesec, KubeLinter)

### CKS-06 — Monitoring, Logging and Runtime Security (20 %)

- **CKS-06-01** Perform behavioral analytics to detect malicious activities
- **CKS-06-02** Detect threats within physical infrastructure, apps, networks, data, users and workloads
- **CKS-06-03** Investigate and identify phases of attack and bad actors within the environment
- **CKS-06-04** Ensure immutability of containers at runtime
- **CKS-06-05** Use Kubernetes audit logs to monitor access
