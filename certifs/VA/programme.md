---
code: VA
title: "HashiCorp Certified: Vault Associate (003)"
issuer: "HashiCorp"
version: "Vault 1.16.x"
exam_format: "QCM / vrai-faux, 60 min, en ligne surveillé ; pas de pondération officielle"
weighted_domains: false
golden_kubestronaut: false
source_url: "https://developer.hashicorp.com/vault/tutorials/associate-cert-003/associate-review-003"
source_file: "programmes-certifications/autres/Vault_Associate_003.md (retranscription)"
license: "Objectifs d'examen publics, retranscrits depuis la page officielle ; texte © éditeur, usage de référence"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# VA — HashiCorp Certified: Vault Associate (003)

Programme officiel retranscrit tel quel (en anglais). Les identifiants `VA-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Notes

- Version testée : Vault 1.16.x.

## Domaines

| ID | Domaine |
|---|---|
| VA-01 | [Authentication methods](#va-01--authentication-methods) |
| VA-02 | [Vault policies](#va-02--vault-policies) |
| VA-03 | [Vault tokens](#va-03--vault-tokens) |
| VA-04 | [Vault leases](#va-04--vault-leases) |
| VA-05 | [Secrets engines](#va-05--secrets-engines) |
| VA-06 | [Encryption as a Service](#va-06--encryption-as-a-service) |
| VA-07 | [Vault architecture fundamentals](#va-07--vault-architecture-fundamentals) |
| VA-08 | [Vault deployment architecture](#va-08--vault-deployment-architecture) |
| VA-09 | [Access management architecture](#va-09--access-management-architecture) |

## Compétences

### VA-01 — Authentication methods

- **VA-01-01** Define the purpose of authentication methods
- **VA-01-02** Choose an authentication method based on use case
- **VA-01-03** Explain the difference between human and system authentication methods
- **VA-01-04** Define the purpose of identities and groups
- **VA-01-05** Authenticate to Vault using the API, CLI, and UI
- **VA-01-06** Configure authentication methods using the API, CLI, and UI

### VA-02 — Vault policies

- **VA-02-01** Explain the value of Vault policies
- **VA-02-02** Describe Vault policy: path
- **VA-02-03** Describe Vault policy: capabilities
- **VA-02-04** Choose a Vault policy based on requirements
- **VA-02-05** Configure Vault policies using the UI and CLI

### VA-03 — Vault tokens

- **VA-03-01** Choose between service and batch tokens based on use case
- **VA-03-02** Describe root token uses and lifecycle
- **VA-03-03** Explain the purpose of token accessors
- **VA-03-04** Explain the impact of time-to-live
- **VA-03-05** Explain orphaned tokens
- **VA-03-06** Describe how to create tokens based on need

### VA-04 — Vault leases

- **VA-04-01** Explain the purpose of a lease ID
- **VA-04-02** Describe how to renew leases
- **VA-04-03** Describe how to revoke leases

### VA-05 — Secrets engines

- **VA-05-01** Choose a secrets engine based on use case
- **VA-05-02** Compare and contrast dynamic secrets vs. static secrets, know their use cases
- **VA-05-03** Describe the uses of transit secrets engine
- **VA-05-04** Describe the purpose of secrets engines
- **VA-05-05** Describe the use of response wrapping
- **VA-05-06** Explain the value of short-lived, dynamic secrets
- **VA-05-07** Enable secrets engines using the API, CLI, and UI
- **VA-05-08** Access Vault secrets using the CLI, API, and UI

### VA-06 — Encryption as a Service

- **VA-06-01** Encrypt and decrypt secrets
- **VA-06-02** Rotate the encryption key

### VA-07 — Vault architecture fundamentals

- **VA-07-01** Describe how Vault encrypts data
- **VA-07-02** Explain how to seal and unseal Vault
- **VA-07-03** Configure environment variables

### VA-08 — Vault deployment architecture

- **VA-08-01** Explain cluster strategy for self-managed and HashiCorp-managed clusters
- **VA-08-02** Explain the uses of storage backends
- **VA-08-03** Explain the uses of Shamir secret sharing and unsealing
- **VA-08-04** Explain the uses of disaster recovery and performance replication
- **VA-08-05** Differentiate between self-managed and HashiCorp-managed Vault clusters

### VA-09 — Access management architecture

- **VA-09-01** Describe the Vault Agent
- **VA-09-02** Vault Secrets Operator
