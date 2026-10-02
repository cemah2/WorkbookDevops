# Solutions — 08 OpenGitOps : les quatre principes et le vocabulaire

Trois indices progressifs par exercice, puis la correction commentée. Lis un indice, retourne manipuler, reviens si besoin.
Les commandes Git ont été exécutées (serveur SSH de la session de rédaction) ; les commandes cluster sont marquées
`[non testé : pas de cluster dans la session de rédaction]`. Citations en anglais : `PRINCIPLES.md` et `GLOSSARY.md`
de `open-gitops/documents` à la version `opengitops_documents` de `versions.yaml`.

## Défi de la section 1 — les trois textes (sans corrigé)

Tire un texte au sort, lance le minuteur (10 min), liste les violations avec le terme du glossaire et la correction.
Le corrigé est en fin de fichier.

**Texte A.** Chaque vendredi, l'équipe se connecte au cluster de production avec `kubectl` et déroule le runbook
`deploy.md` : `kubectl set image` sur chaque Deployment, puis `kubectl scale` selon la charge prévue. Le runbook est dans
un wiki modifiable par tous, sans historique. Les valeurs réellement en place sont relevées dans un tableur partagé.
Quand une image pose problème, on relance la commande de la semaine précédente de mémoire. Personne ne regarde le cluster
entre deux vendredis ; une alerte Slack arrive si un pod redémarre plus de dix fois.

**Texte B.** Les manifests sont dans un dépôt Git. Un pipeline GitLab, déclenché par chaque merge sur `main`, fait
`kubectl apply -k overlays/prod` avec un compte admin du cluster. La branche `main` est protégée, mais les mainteneurs
peuvent `push --force` et le font pour « nettoyer l'historique » avant les releases. Un développeur pressé a aussi un accès
`kubectl` direct et corrige parfois une ConfigMap à la main ; le pipeline ne le voit pas tant qu'aucun merge n'arrive.
La seule trace des déploiements est le journal du pipeline, purgé après 30 jours.

**Texte C.** Argo CD tourne dans le cluster avec une `Application` par équipe, en sync automatique. Pour aller plus vite,
le dépôt de déploiement est un dépôt bare sur un serveur interne où tout le monde a la clé de l'utilisateur `git`, y compris
le compte de service d'Argo CD. L'image à déployer est choisie par un script qui, chaque nuit, modifie directement le
Deployment dans le cluster avec le dernier tag `latest` du registre, « parce que c'est plus simple que de committer ».
Le script a aussi désactivé `selfHeal`, qui « annulait ses changements ».

## Section 1 — Exercice autonome

### Indices

1. Les trois parties sont dans la définition de *Software System* ; les *policies* ne sont pas que des objets Kubernetes :
   un `AppProject`, un fichier `authorized_keys` et une option `receive.*` sont des politiques.
2. Pour `demo-push`, demande-toi **où** vit l'état désiré que l'agent applique, et qui peut le modifier sans laisser de trace.
3. Un `kubectl apply` toutes les minutes reconcilie contre quoi ? Cherche ce que `apply` ne fait jamais avec une ressource
   qui a disparu du dossier, et ce qu'il fait d'une `ConfigMap` que personne ne reconstruit.

### Correction commentée

**Point 1, `demo-pull`.**

| Partie (glossaire) | Objets réels sur le lab |
|---|---|
| *runtime environments consisting of resources under management* | le cluster `kind` `argocd-lab`, namespace `demo-pull` : `Deployment` `web`, `ConfigMap` `web-content`, `Service` `web` |
| *management agents within each runtime* | `argocd-application-controller` (compare, applique), `argocd-repo-server` (tire et rend `pull/`) ; l'`Application` `demo-pull` est leur contrat |
| *policies for controlling access and management of repositories, deployments, runtimes* | `AppProject` `lab` (dépôts et destinations permis), `authorized_keys` de l'utilisateur `git` (qui lit, qui écrit), `receive.denyNonFastForwards` / `denyDeletes`, RBAC Kubernetes du contrôleur |

**Point 2, `demo-push`.** Le runtime existe (namespace `demo-push`) et un agent aussi (le CronJob `ci-push`), mais l'état
désiré qu'il applique est une `ConfigMap` du cluster, construite une fois depuis `push/` : elle n'est **ni versionnée ni
immuable**, et n'importe qui ayant `edit` sur `ci-legacy` peut la changer sans commit. La partie manquante est donc le
**state store** conforme ; la politique d'accès existe sur Git mais ne protège plus rien, puisque l'agent ne lit pas Git.

**Point 3, ce que `demo-push` ne garantit pas, même avec un run par minute.**

1. *Declarative* : oui, les manifests sont déclaratifs ; mais la **suppression** d'une ressource n'est pas déclarée, `apply`
   ne retire jamais ce qui a disparu du dossier (test de la grille : le `Service` survit).
2. *Versioned and Immutable* : l'état appliqué est la `ConfigMap`, pas Git ; un `kubectl edit cm push-manifests` change
   la production sans historique.
3. *Pulled Automatically* : rien n'est tiré de la source ; un commit sur `push/` ne change rien tant qu'un humain ne
   « relance le pipeline » (reconstruit la `ConfigMap`).
4. *Continuously Reconciled* : un `apply` périodique ressemble à une réconciliation, mais il réconcilie contre un snapshot
   et ignore les suppressions ; et entre deux runs, personne n'observe (`selfHeal` d'Argo CD réagit en secondes aux
   événements du cluster, le CronJob attend son tour).

## Section 2 — Exercice autonome

### Indices

1. Les quatre critères sont dans la définition de *State Store* : *immutable versions*, *access control*, *auditing*, et
   le versionnage est implicite dans « versions ». Chaque mécanisme Git côté serveur correspond à un seul critère.
2. Pour l'audit, un dépôt bare n'a pas de reflog tant que `core.logAllRefUpdates` n'est pas à `true` ; pour l'accès,
   `authorized_keys` accepte une option `command=`.
3. Pour la signature : `git config gpg.format ssh`, `user.signingkey <clé .pub>`, `commit.gpgsign true` côté client ;
   côté serveur, `git verify-commit` a besoin de `gpg.ssh.allowedSignersFile`. Un hook `pre-receive` lit `old new ref` sur
   son entrée standard.

### Correction commentée

**Point 1.** Tableau de conformité, chaque preuve rejouable (toutes exécutées).

| Critère | Mécanisme | Commande de preuve | Résultat obtenu |
|---|---|---|---|
| immuable | `receive.denyNonFastForwards true` | `git push --force` d'un historique réécrit | `! [remote rejected] … (non-fast-forward)` |
| immuable (bis) | `receive.denyDeletes true` | `git push origin --delete <branche>` | `! [remote rejected] … (deletion prohibited)` |
| versionné | historique Git complet, rollback par `revert` | `git log --oneline -3` | `2bc83dd Revert "v2…"`, `5833e33 v2…`, `4950094 v1…` |
| contrôle d'accès | clé Argo CD forcée sur `git-upload-pack '<dépôt>'` | `git ls-remote` puis `git push` avec cette clé | lecture OK, push `error: failed to push some refs` |
| audit | `core.logAllRefUpdates true` + `git log --format='%h %ci %an'` | `sudo -u git git -C $BARE reflog show main` | `2bc83dd main@{0}: push`, `5833e33 main@{1}: push` |

**Point 2.** `git revert` publie un **nouvel état désiré** dans le store : l'historique est complet, l'agent le tire et le
réconcilie comme n'importe quel commit, l'audit dit qui a reculé et quand. `argocd app rollback` rejoue une révision déjà
déployée **sans toucher au store** : dès qu'il est fait, l'état vivant ne correspond plus à ce que Git déclare
(`OutOfSync` par construction), et Argo CD le refuse d'ailleurs tant que `automated` est actif. C'est un outil d'urgence
à suivre immédiatement d'un `revert`.

**Point 3, signature SSH (exécuté).** Côté client, dans le clone :

```bash
git config gpg.format ssh
git config user.signingkey ~/.ssh/lab_ed25519.pub
git config commit.gpgsign true
git commit --allow-empty -m 'commit signé' && git log --show-signature -1 | head -3
```

```text
commit 8d33059c600796f072670e4197d9c03e73b59593
Good "git" signature for apprenant@lab.home.arpa with ED25519 key SHA256:Jd+iIlDDK+R39cY0+mrnOAyIOA17WKxf1nOItItSEi8
Author: apprenant <apprenant@lab.home.arpa>
```

Côté serveur, la liste des signataires (`<identité> <type> <clé>`) et le hook :

```bash
printf 'apprenant@lab.home.arpa %s\n' "$(cut -d' ' -f1,2 ~/.ssh/lab_ed25519.pub)" | sudo -u git tee /srv/git/allowed_signers
sudo -u git install -m 755 pre-receive /srv/git/gitops-principes.git/hooks/pre-receive
```

```sh
#!/bin/sh
# hooks/pre-receive — refuse tout commit dont la signature SSH n'est pas vérifiable avec /srv/git/allowed_signers.
git config gpg.ssh.allowedSignersFile /srv/git/allowed_signers
zero=0000000000000000000000000000000000000000
while read -r old new ref; do
  [ "$new" = "$zero" ] && continue
  if [ "$old" = "$zero" ]; then range="$new"; else range="$old..$new"; fi
  for c in $(git rev-list "$range"); do
    if ! git verify-commit "$c" >/dev/null 2>&1; then
      echo "refusé : commit $c non signé ou signataire inconnu ($ref)" >&2
      exit 1
    fi
  done
done
exit 0
```

Preuve : le commit signé passe, un commit non signé est refusé.

```text
$ git push origin main
   2bc83dd..8d33059  main -> main
$ git -c commit.gpgsign=false commit --allow-empty -m 'commit non signé' && git push origin main
remote: refusé : commit c276f20ab91f406ca4d9133eac2e905d78785396 non signé ou signataire inconnu (refs/heads/main)
 ! [remote rejected] main -> main (pre-receive hook declined)
```

Pourquoi `git config` dans le hook : le hook tourne en tant que `git` sur le serveur, sans configuration globale ; le fichier
des signataires doit lui être indiqué. Limite à connaître : un commit de `revert` fait par Argo CD lui-même (fiche 12,
automatisation d'image) devra avoir sa propre clé dans `allowed_signers`.

## Section 3 — Exercice autonome

### Indices

1. Écris d'abord, relis ensuite : l'intérêt est l'écart. Si tu n'as pas d'écart, tu as recopié.
2. Les deux pièges annoncés : *Continuous* dit explicitement *not that it must be instantaneous* ; *Desired State* dit
   *generally does not include persistent application data*.
3. Pour les trois mesures, le mot est **jitter** : `timeout.reconciliation.jitter` (60 s par défaut) ajoute un délai
   aléatoire entre 0 et sa valeur ; la dispersion observée est voulue, elle lisse la charge du `repo-server`.

### Correction commentée

**Points 1 et 2.** Définitions courtes avec l'écart le plus fréquent.

| Terme (CGOA-01) | Définition OpenGitOps (résumé) | Écart fréquent dans une première rédaction |
|---|---|---|
| Continuous | la réconciliation **continue d'avoir lieu**, pas forcément instantanément | « en temps réel » : faux, un pull périodique est continu |
| Declarative Description | décrit l'état voulu **sans** la procédure pour l'atteindre | confondre « déclaratif » et « YAML » : un script Ansible impératif en YAML n'est pas déclaratif |
| Desired State | **l'ensemble** des données de configuration suffisantes pour recréer un système équivalent, **hors** données persistantes | y inclure la base de données ; oublier que les identifiants d'accès en font souvent partie |
| State Drift | l'état réel **s'éloigne** ou est en train de s'éloigner de l'état désiré | ne voir que la modification manuelle ; un nœud qui tombe est aussi une dérive |
| State Reconciliation | faire correspondre l'état réel à l'état désiré, déclenchée par **toute** divergence (dérive ou nouveau commit) | « redéployer » : la réconciliation part de la divergence, pas d'un déclencheur |
| GitOps Managed Software System | runtimes + agents dans chaque runtime + politiques d'accès et de gestion | oublier les politiques ; oublier qu'il peut y avoir plusieurs runtimes |
| State Store | stockage de **versions immuables** de l'état désiré, avec contrôle d'accès et audit | « Git » : Git est l'exemple, pas la définition, et n'est conforme que configuré |
| Feedback Loop | boucle fermée : l'effet des tentatives précédentes sur l'état réel guide la suivante (réessai, rollback, alerte) | la réduire aux notifications : le contrôleur lui-même consomme le retour |
| Rollback | revenir à un état désiré **précédent**, donc publier une version antérieure dans le store | `argocd app rollback` seul : l'état vivant recule, le store non |

**Point 3.** `[non testé : pas de cluster dans la session de rédaction]`. Attendu avec les défauts de la version `argo_cd` :
trois délais entre 0 et 180 s (120 s de période plus 0 à 60 s de jitter, moins le temps déjà écoulé dans la période en cours),
dispersés. Avec `timeout.reconciliation.jitter: 0s`, les trois mesures tombent sous 120 s et se ressemblent. Le mot : **jitter**,
qui ne contredit pas *Continuous* : la réconciliation continue d'avoir lieu, à un rythme borné.

## Corrigé du défi de la section 1

**Texte A.** Quatre violations. *Declarative* : `kubectl set image` et `scale` sont une **procédure**, pas une description
(terme : Declarative Description). *Versioned and Immutable* : le runbook dans un wiki sans historique et le tableur ne sont
pas un **State Store**. *Pulled Automatically* : rien n'est tiré, un humain pousse le vendredi. *Continuously Reconciled* :
personne n'observe entre deux vendredis ; l'alerte Slack est un **Feedback** sans boucle (personne ne réconcilie).
Correction : manifests déclaratifs dans un dépôt verrouillé, un agent (Argo CD ou Flux) en sync automatique, l'alerte branchée
sur `argocd_app_info` plutôt que sur les redémarrages.

**Texte B.** Trois violations, une bonne pratique. *Declarative* : respecté (Kustomize). *Versioned and Immutable* : violé par
le `push --force` des mainteneurs (**State Store** non immuable) ; corriger par `receive.denyNonFastForwards` ou la protection
équivalente de la forge. *Pulled Automatically* : violé, le pipeline **pousse** avec un compte admin (terme : Pull) ; corriger
en remplaçant le job par un agent dans le cluster et en retirant le compte admin à la CI. *Continuously Reconciled* : violé,
la modification manuelle de la ConfigMap est une **State Drift** que rien ne répare avant le prochain merge. Audit : le journal
purgé à 30 jours n'est pas un audit du store ; l'historique Git l'est, s'il est immuable.

**Texte C.** Trois violations malgré Argo CD. *Versioned and Immutable* / *State Store* : la clé de l'utilisateur `git` partagée
par tous, y compris l'agent, annule le **contrôle d'accès** ; corriger par une clé par personne et une clé en lecture seule
pour Argo CD. *Pulled Automatically* : le script de nuit **pousse** une image dans le cluster sans passer par le store, et
`latest` n'est pas une version (terme : Desired State non versionné) ; corriger en faisant committer le tag par le script.
*Continuously Reconciled* : `selfHeal` désactivé pour laisser vivre une **State Drift** volontaire ; le symptôme (« Argo CD
annulait mes changements ») était le système qui fonctionnait. Le *Declarative* est respecté, et Argo CD est le bon outil :
c'est l'usage qui viole les principes, pas l'outillage.
