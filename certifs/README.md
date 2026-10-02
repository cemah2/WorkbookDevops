# Programmes officiels des certifications

Un dossier par certification, avec `programme.md` au format uniforme :
front matter (code, version, source, licence, dates), tableau des domaines pondérés,
puis une compétence par ligne avec un identifiant stable `CODE-DD-CC`
(DD = domaine, CC = compétence, dans l'ordre du document officiel).

Ces identifiants sont la clé du mapping objectifs → chapitres (`objectifs.md`, à générer)
et de la veille : un diff de `programme.md` montre exactement ce qui a changé entre deux versions.

## Conventions

- Le texte des compétences est **en anglais, tel quel** : c'est la formulation de l'examen.
- Une compétence supprimée par l'éditeur est conservée **barrée** avec la mention `(retiré vX)` pendant un cycle,
  pour ne pas casser les références ; un ajout prend le numéro suivant, jamais un numéro libéré.
- `status` reste « à revérifier » tant que la veille mensuelle n'a pas confirmé la version.

## Sources et licences

- CNCF : <https://github.com/cncf/curriculum> (PDF officiels, CC-BY 4.0), consultés le 2026-09-28.
- Red Hat, HashiCorp, OpenInfra, Linux Foundation (LFCS) : objectifs publics retranscrits depuis les pages officielles le 2026-09-28.
- Conversion en Markdown : 2026-10-02.

## Golden Kubestronaut

KCNA, KCSA, CKA, CKAD, CKS, PCA, ICA, CCA, CAPA, CGOA, CBA, OTCA, KCA, CNPA, CNPE + LFCS, toutes valides simultanément.

## Points à vérifier avant chaque jalon

- CKS : programme en 1.34 dans le dépôt alors que CKA/CKAD sont en 1.35 ; la page d'examen annonce « v1.35 » (`CKS/examen.md`).
- CKA/CKAD : le dépôt `cncf/curriculum` a passé CKAD en v1.37 et ajouté une certification CKNE le 2026-10-01
  (constaté le 2026-10-02 lors de la cartographie CKS) : à traiter à la veille.
- RHCE EX294 : passage annoncé à RHEL 10.
- COA : version 2026.1 Gazpacho à confirmer dans le handbook.
- Durées, nombre de questions et validité : non reprises des PDF (absentes), à confirmer sur la page de chaque examen et à consigner dans
  `examen.md`.

## Index

| Code | Certification | Émetteur | Version | Format | Golden Kubestronaut |
|---|---|---|---|---|---|
| [KCNA](KCNA/programme.md) | Kubernetes and Cloud Native Associate | CNCF / LF | — | QCM | oui |
| [KCSA](KCSA/programme.md) | Kubernetes and Cloud Native Security Associate | CNCF / LF | — | QCM | oui |
| [CKA](CKA/programme.md) | Certified Kubernetes Administrator | CNCF / LF | Kubernetes 1.35 | pratique (terminal) | oui |
| [CKAD](CKAD/programme.md) | Certified Kubernetes Application Developer | CNCF / LF | Kubernetes 1.35 | pratique (terminal) | oui |
| [CKS](CKS/programme.md) | Certified Kubernetes Security Specialist | CNCF / LF | Kubernetes 1.34 (⚠️ vérifier la version en vigueur avant ce jalon) | pratique (terminal) | oui |
| [PCA](PCA/programme.md) | Prometheus Certified Associate | CNCF / LF | — | QCM | oui |
| [OTCA](OTCA/programme.md) | OpenTelemetry Certified Associate | CNCF / LF | — | QCM | oui |
| [CGOA](CGOA/programme.md) | Certified GitOps Associate | CNCF / LF | — | QCM | oui |
| [CAPA](CAPA/programme.md) | Certified Argo Project Associate | CNCF / LF | — | QCM | oui |
| [CCA](CCA/programme.md) | Cilium Certified Associate | CNCF / LF | — | QCM | oui |
| [ICA](ICA/programme.md) | Istio Certified Associate | CNCF / LF | — | pratique (terminal) | oui |
| [KCA](KCA/programme.md) | Kyverno Certified Associate | CNCF / LF | — | QCM | oui |
| [CBA](CBA/programme.md) | Certified Backstage Associate | CNCF / LF | — | QCM | oui |
| [CNPA](CNPA/programme.md) | Certified Cloud Native Platform Engineering Associate | CNCF / LF | — | QCM | oui |
| [CNPE](CNPE/programme.md) | Certified Cloud Native Platform Engineer | CNCF / LF | — | pratique (terminal) | oui |
| [LFCS](LFCS/programme.md) | Linux Foundation Certified System Administrator | The Linux Foundation | distribution non imposée (vérifier le handbook) | pratique (terminal) | oui |
| [RHCSA](RHCSA/programme.md) | Red Hat Certified System Administrator (EX200) | Red Hat | Red Hat Enterprise Linux 10 | pratique | non |
| [RHCE](RHCE/programme.md) | Red Hat Certified Engineer (EX294) | Red Hat | RHEL 9 + Ansible Automation Platform (⚠️ version RHEL 10 annoncée, à vérifier) | pratique | non |
| [TFA](TFA/programme.md) | HashiCorp Certified: Terraform Associate (004) | HashiCorp | Terraform 1.12 | QCM / vrai-faux | non |
| [VA](VA/programme.md) | HashiCorp Certified: Vault Associate (003) | HashiCorp | Vault 1.16.x | QCM / vrai-faux | non |
| [COA](COA/programme.md) | Certified OpenStack Administrator | OpenInfra Foundation | OpenStack 2026.1 Gazpacho (⚠️ à confirmer dans le handbook) | pratique (terminal) | non |
