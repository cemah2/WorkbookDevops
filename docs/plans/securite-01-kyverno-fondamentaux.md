---
chapitre: "fiches/securite/01-kyverno-fondamentaux.md"
domaine: "securite"
niveau: "débutant"
statut: "validé le 2026-10-02 — rédaction à lancer (prompts/03)"
duree_estimee: "5 h"
profil_lab: "linux-base (kind sur une VM) ; variante kubernetes-ha"
versions: "kyverno, helm, kind, kubernetes, kubeconform"
certifications:
  - "KCA-01-01"
  - "KCA-01-02"
  - "KCA-01-03"
  - "KCA-01-04"
  - "KCA-02-01"
  - "KCA-04-01"
  - "KCA-04-02"
  - "KCA-04-03"
  - "KCSA-05-07"
  - "KCSA-03-02"
  - "CKAD-04-02"
---

# Plan — 01 Kyverno : admission controllers, première policy, sélection des ressources

Arbitrages hérités (`DECISIONS.md`, 2026-10-02) : fiches numérotées ; Helm 4 partout ; `kind` en chemin principal
tant que `lab up kubernetes-ha` n'existe pas ; Gateway API Cilium (sans objet ici : Kyverno n'a pas d'UI).
Cartographie : `certifs/KCA/objectifs.md` §4 (F1). IDs KCSA et CKAD cités dès maintenant, à confirmer par leur cartographie.

Arbitrages de validation (2026-10-02, questions du plan proposé) :

1. Chapitre confirmé : `fiches/securite/01-kyverno-fondamentaux.md`.
2. Numérotation : la série `securite` démarre à `01` avec Kyverno ; une future fiche de bases (RBAC, PSA, secrets)
   prendra le numéro suivant, l'ordre de lecture est recommandé, pas imposé (DECISIONS.md, 2026-10-02).
3. Exécution : la session de rédaction n'a pas de démon Docker (vérifié le 2026-10-02). Elle exécute pour de vrai tout ce
   qui ne demande pas de cluster (`kyverno apply` et `kyverno test` sur les manifests du chapitre, `helm template` du chart
   épinglé, `kubeconform`, scripts de panne en `--reveal`) et marque `[non testé : pas de cluster dans la session de
   rédaction]` le reste, comme `fiches/gitops/01`. Le passage au statut « validé en conditions réelles » se fait sur le
   lab via `prompts/08-retour-apres-pratique.md`.
4. Comparaison Pod Security Admission / Kyverno conservée en exercice autonome 1.3 (dix lignes, KCSA-03-02).
5. Nom des champs : vérifié dans `api/kyverno/v1` de la branche `release-1.19` : `spec.validationFailureAction`,
   `spec.validationFailureActionOverrides`, `spec.failurePolicy` et `spec.webhookTimeoutSeconds` sont **dépréciés** au profit
   de `validate.failureAction`, `validate.failureActionOverrides`, `spec.webhookConfiguration.failurePolicy` et
   `spec.webhookConfiguration.timeoutSeconds`. La fiche enseigne la forme courante en chemin principal (c'est ce que
   l'apprenant tape sur le lab) et consacre un encart « forme du programme 2024 » plus trois flashcards aux anciens noms,
   que le QCM peut encore citer.

## Objectifs mesurables

- Installer Kyverno par Helm (chart à la version `kyverno`) sur un cluster `kind`, vérifier les quatre contrôleurs
  et les webhooks créés, en moins de 15 min.
- Expliquer sans notes, en trois phrases, l'ordre d'admission (authentification → autorisation → webhooks mutants →
  validation de schéma → webhooks validants → etcd) et y placer Kyverno.
- Écrire une `ClusterPolicy` `validate` exigeant un label, la passer d'`Audit` à `Enforce` (`validate.failureAction`),
  obtenir et lire un refus, en moins de 10 min.
- Restreindre une règle à un namespace, à un label, à une opération ou à un sujet avec `match`/`exclude` (`any`/`all`),
  en moins de 5 min par cas, et prouver par une commande que le reste du cluster n'est pas touché.
- Diagnostiquer un refus inattendu, ou une absence de refus attendue, avec `kubectl get cpol`, `describe`, les events
  et les logs de l'admission controller, en moins de 10 min.
- Décomposer une référence d'image OCI (`registry/repo:tag@sha256:…`) et interdire `:latest` par `pattern`, en moins de 5 min.

## Niveau et prérequis

- Débutant, nœud `securite_deb` (`docs/prerequis.md` §6.2). Première fiche du domaine `securite`.
- Prérequis : nœud `kubernetes_deb` (kubectl, Pods, Deployments, namespaces, labels, lecture d'un manifest YAML).
  Aucun chapitre n'existe pour ce nœud au 2026-10-02 : le front matter cite le nœud, pas un fichier.
- Recommandé : `fiches/gitops/01-argo-cd-fondamentaux.md` §1 pour la création du cluster `kind` (procédure réutilisée telle quelle).
- Infrastructure : une VM Ubuntu du profil `linux-base` avec Docker et `kind` ; en variante, `kubernetes-ha`.

## Compétences couvertes

| Section | KCA | Autres (à confirmer) |
|---|---|---|
| 1 Admission et installation | KCA-01-03, KCA-02-01, KCA-01-01 | KCSA-05-07, CKAD-04-02, KCSA-03-02 (PSA, lecture seule) |
| 2 Première policy | KCA-01-01, KCA-01-02, KCA-04-01, KCA-04-03 (introduit KCA-05-01, couvert par F3) | — |
| 3 Sélection et paramètres communs | KCA-04-02, KCA-04-03, KCA-01-04 (références d'images ; signatures en F5) | — |

## Exercices

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 1.1 | 1 | guidé | Lire les webhooks existants (`kubectl get mutatingwebhookconfigurations,validatingwebhookconfigurations`), lire les plugins d'admission du kube-apiserver `kind` (`docker exec … ps`), schéma Mermaid du chemin d'une requête | schéma reproduit de tête |
| 1.2 | 1 | guidé | `helm repo add kyverno`, `helm install` avec version de chart correspondant à `kyverno`, `kubectl get pods -n kyverno`, les 4 Deployments, les webhooks `kyverno-*` apparus, `kubectl get crds \| grep kyverno` | 4 contrôleurs `Running` |
| 1.3 | 1 | autonome | Comparer Pod Security Admission (label `pod-security.kubernetes.io/enforce`) et Kyverno sur un même Pod privilégié ; dire qui refuse en premier et pourquoi | explication en 5 lignes |
| 1.4 | 1 | break-fix | `break/securite/01-kyverno-webhook-timeout.sh` | `kubectl run` accepté de nouveau |
| 1.5 | 1 | chronométré | Installation propre + vérification des contrôleurs et webhooks | 15 min |
| 2.1 | 2 | guidé | `ClusterPolicy` `require-team-label` (`validate.pattern` sur `metadata.labels.team`), `kyverno apply` local, puis `kubectl apply`, `kubectl get cpol` (`READY`, `ADMISSION`, `BACKGROUND`), Pod sans label en `Audit` (event `PolicyViolation`) puis en `Enforce` (refus, message) | refus lu et expliqué |
| 2.2 | 2 | guidé | Anatomie du manifest : `spec.rules[]`, un seul type d'action par règle, `message`, `validate.failureAction` (et l'ancien `spec.validationFailureAction`, déprécié, à reconnaître), `background`, `admission`, `Policy` namespacée vs `ClusterPolicy`, `kubectl explain clusterpolicy.spec` | fiche de lecture du schéma |
| 2.3 | 2 | autonome | Écrire une `Policy` namespacée qui exige `resources.requests` sur chaque conteneur ; vérifier qu'un Deployment sans requests est refusé via autogen (observé, expliqué en F3) | Deployment refusé, Pod d'un autre namespace accepté |
| 2.4 | 2 | break-fix | `break/securite/01-kyverno-enforce-silencieux.sh` | la policy refuse de nouveau |
| 2.5 | 2 | chronométré | De zéro à une policy `Enforce` refusant un Pod sans label | 10 min |
| 3.1 | 3 | guidé | `match`/`exclude` : `any`/`all`, `kinds` (`Pod`, `apps/v1/Deployment`, `Pod/exec`), `namespaces`, `names` avec joker, `selector`, `namespaceSelector`, `operations`, `subjects`, `roles`/`clusterRoles` ; un cas par champ, prouvé par `kubectl auth can-i`-style (`--as`) | chaque cas observé |
| 3.2 | 3 | guidé | Paramètres communs : `validate.failureActionOverrides` par namespace, `spec.webhookConfiguration.failurePolicy` et `.timeoutSeconds`, `admission`, `background`, `rules[].skipBackgroundRequests` ; anciens noms au niveau `spec` reconnus ; effet visible sur les webhooks (`kubectl get validatingwebhookconfiguration kyverno-resource-validating-webhook-cfg -o yaml`) | effet de chaque paramètre noté |
| 3.3 | 3 | autonome | Policy `disallow-latest-tag` : décomposer trois références d'images, interdire tag absent ou `latest`, exempter le namespace `kube-system` et le ClusterRole `cluster-admin` | refus sur `nginx` et `nginx:latest`, accepté sur `nginx:1.27@sha256:…` |
| 3.4 | 3 | break-fix | `break/securite/01-kyverno-exclude-admin.sh` | l'apprenant explique « ça marche pour moi, pas pour l'app » |
| 3.5 | 3 | chronométré | Refuser les Pods sans `requests` dans un seul namespace, prouver que les autres passent | 10 min |

## Scénarios de panne (`break/securite/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-kyverno-webhook-timeout.sh` | admission controller à 0 réplica, webhooks laissés en `failurePolicy: Fail` | tout `kubectl run`/`apply` de Pod échoue : « failed calling webhook … context deadline exceeded », même hors périmètre des policies |
| `01-kyverno-enforce-silencieux.sh` | `validate.failureActionOverrides` ajouté : le namespace de travail passe en `Audit` | la policy affiche `Enforce`, le Pod non conforme passe, seul un event `PolicyViolation` apparaît |
| `01-kyverno-exclude-admin.sh` | `exclude.any[].clusterRoles: [cluster-admin]` ajouté à la policy | l'admin (kubeconfig `kind`) crée librement, le ServiceAccount de l'application est refusé |
| `01-kyverno-namespace-selector.sh` (optionnel) | `webhooks.namespaceSelector` du ConfigMap `kyverno` exclut le namespace de travail | aucune policy ne s'applique dans ce namespace, sans erreur ni event (prépare F6 `resourceFilters`) |

Chaque script : idempotent, `--undo`, `--reveal`, shellcheck ; même squelette que `break/gitops/01-*.sh`.

## Profil de lab et budget

- Chemin principal : `linux-base`, une VM (4 vCPU / 8 Go / 60 Go pris sur le budget 8 vCPU / 16 Go / 180 Go), Docker + `kind`
  (`kind` 0.33.0, image de nœud pour Kubernetes 1.37 à vérifier, même point ouvert que `fiches/gitops/01`).
  Kyverno installé par défaut : 4 contrôleurs, environ 1 vCPU / 1 Go au repos ; `replicaCount` 1 (HA en F6).
- Variante : `kubernetes-ha` (16 vCPU / 48 Go / 300 Go). Pas d'exposition réseau à prévoir : Kyverno n'a pas d'interface web.
- Aucun registre ni dépôt Git nécessaire : les manifests vivent dans `fiches/securite/01-kyverno-fondamentaux/manifests/`
  (validés par `kubeconform` en CI).

## Points de vigilance `versions.yaml`

- `kyverno` 1.19.1 : la version du **chart** Helm ne suit pas celle de l'application. Vérifié le 2026-10-02 dans
  `charts/kyverno/Chart.yaml` de la branche `release-1.19` : chart **3.9.1** ↔ `appVersion` v1.19.1, `kubeVersion >= 1.25`.
  La fiche épingle `--version 3.9.1` (lu via `helm search repo kyverno/kyverno --versions`), jamais `latest`.
  CRD installées par le chart (`crds.install`), à mentionner pour F6.
- Nom des champs d'action et de webhook : dépréciation au niveau `spec` confirmée en 1.19 (arbitrage 5 ci-dessus).
  Le champ `validate.assert` est lui aussi déprécié et sans effet depuis 1.19 : ne pas l'enseigner.
- Types CEL (`ValidatingPolicy`, `MutatingPolicy`…) présents en 1.19 et absents du curriculum : une phrase en §2
  « à connaître », renvoi vers F3 ; aucune manipulation.
- Kubernetes 1.37.1 : accepté par le chart (`kubeVersion >= 1.25`) ; la matrice de compatibilité publiée par Kyverno reste
  à relire au moment de la rédaction. `kubectl apply` en validation stricte côté serveur signale les champs inconnus
  d'une policy (utile pour l'exercice 2.2).
- Helm 4.3.0 : le chart Kyverno est testé par l'éditeur avec Helm 3 ; vérifier `helm install` et `helm template`
  sous Helm 4 (hooks, `--wait`) et noter tout écart.
- `kubeconform` 0.8.0 : les schémas des CRD Kyverno ne sont pas dans le catalogue par défaut ; la CI tourne déjà avec
  `-ignore-missing-schemas`. La fiche propose `-schema-location` vers le catalogue `datreeio/CRDs-catalog` pour une
  validation réelle, à fixer dans la PR (cartographie §4, convention commune).

## `[lecture + simulation]`

- Rien pour cause de matériel.
- Hors périmètre débutant, lecture seule avec renvoi vers les fiches suivantes : haute disponibilité, flags et RBAC
  (F6), `verifyImages` (F5), `mutate`/`generate` (F4), variables et CEL (F3), `PolicyReport` et `PolicyException` (F7).
  Trois à cinq flashcards les couvrent car l'examen cite leurs noms.
- Pod Security Admission (exercice 1.3) : manipulé sur un seul namespace, pas de tour complet (KCSA).

## Livrables attendus de la session de rédaction

- `fiches/securite/01-kyverno-fondamentaux.md` (gabarit `templates/fiche.md`) + `manifests/`
- `solutions/fiches/securite/01-kyverno-fondamentaux.md` (3 indices puis correction)
- `break/securite/01-*.sh` (3 scripts, 1 optionnel)
- `revision/flashcards/securite-01-kyverno-fondamentaux.csv` (10 à 20 cartes)
- mise à jour de `certifs/KCA/objectifs.md` §3 et §4, de `docs/prerequis.md` §6.2 (nœud `rédigé`),
  de `labs/profiles/kubernetes-ha.yaml` (`kyverno` dans `components`) et de ce plan (`statut: réalisé`)
