---
code: TFA
title: "HashiCorp Certified: Terraform Associate (004)"
issuer: "HashiCorp"
version: "Terraform 1.12"
exam_format: "QCM / vrai-faux, 60 min, en ligne surveillé ; pas de pondération officielle"
weighted_domains: false
golden_kubestronaut: false
source_url: "https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004"
source_file: "programmes-certifications/autres/Terraform_Associate_004.md (retranscription)"
license: "Objectifs d'examen publics, retranscrits depuis la page officielle ; texte © éditeur, usage de référence"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# TFA — HashiCorp Certified: Terraform Associate (004)

Programme officiel retranscrit tel quel (en anglais). Les identifiants `TFA-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Notes

- Version testée : Terraform 1.12. QCM / vrai-faux, 1 h, en ligne. Pas de pondération officielle par objectif.
- Note cloud privé : l'objectif 8 porte sur un service SaaS de HashiCorp. Il se travaille avec un compte HCP Terraform gratuit ; c'est la seule exception « cloud public » du workbook.

## Domaines

| ID | Domaine |
|---|---|
| TFA-01 | [Infrastructure as Code (IaC) with Terraform](#tfa-01--infrastructure-as-code-iac-with-terraform) |
| TFA-02 | [Terraform fundamentals](#tfa-02--terraform-fundamentals) |
| TFA-03 | [Core Terraform workflow](#tfa-03--core-terraform-workflow) |
| TFA-04 | [Terraform configuration](#tfa-04--terraform-configuration) |
| TFA-05 | [Terraform modules](#tfa-05--terraform-modules) |
| TFA-06 | [Terraform state management](#tfa-06--terraform-state-management) |
| TFA-07 | [Maintain infrastructure with Terraform](#tfa-07--maintain-infrastructure-with-terraform) |
| TFA-08 | [HCP Terraform](#tfa-08--hcp-terraform) |

## Compétences

### TFA-01 — Infrastructure as Code (IaC) with Terraform

- **TFA-01-01** Explain what IaC is
- **TFA-01-02** Describe the advantages of IaC patterns
- **TFA-01-03** Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows

### TFA-02 — Terraform fundamentals

- **TFA-02-01** Install and version Terraform providers
- **TFA-02-02** Describe how Terraform uses providers
- **TFA-02-03** Write Terraform configuration using multiple providers
- **TFA-02-04** Explain how Terraform uses and manages state

### TFA-03 — Core Terraform workflow

- **TFA-03-01** Describe the Terraform workflow
- **TFA-03-02** Initialize a Terraform working directory
- **TFA-03-03** Validate a Terraform configuration
- **TFA-03-04** Generate and review an execution plan for Terraform
- **TFA-03-05** Apply changes to infrastructure with Terraform
- **TFA-03-06** Destroy Terraform-managed infrastructure
- **TFA-03-07** Apply formatting and style adjustments to a configuration

### TFA-04 — Terraform configuration

- **TFA-04-01** Use and differentiate resource and data blocks
- **TFA-04-02** Refer to resource attributes and create cross-resource references
- **TFA-04-03** Use variables and outputs
- **TFA-04-04** Understand and use complex types
- **TFA-04-05** Write dynamic configuration using expressions and functions
- **TFA-04-06** Define resource dependencies in configuration
- **TFA-04-07** Validate configuration using custom conditions
- **TFA-04-08** Understand best practices for managing sensitive data, including secrets management with Vault

### TFA-05 — Terraform modules

- **TFA-05-01** Explain how Terraform sources modules
- **TFA-05-02** Describe variable scope within modules
- **TFA-05-03** Use modules in configuration
- **TFA-05-04** Manage module versions

### TFA-06 — Terraform state management

- **TFA-06-01** Describe the local backend
- **TFA-06-02** Describe state locking
- **TFA-06-03** Configure remote state using the backend block
- **TFA-06-04** Manage resource drift and Terraform state

### TFA-07 — Maintain infrastructure with Terraform

- **TFA-07-01** Import existing infrastructure into your Terraform workspace
- **TFA-07-02** Use the CLI to inspect state
- **TFA-07-03** Describe when and how to use verbose logging

### TFA-08 — HCP Terraform

- **TFA-08-01** Use HCP Terraform to create infrastructure
- **TFA-08-02** Describe HCP Terraform collaboration and governance features
- **TFA-08-03** Describe how to organize and use HCP Terraform workspaces and projects
- **TFA-08-04** Configure and use HCP Terraform integrations
