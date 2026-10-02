# Solutions — 01 Argo CD : installer, déclarer une Application, synchroniser

Trois indices progressifs par exercice, puis la correction commentée. Lis un indice, retourne manipuler, reviens si besoin.
Les commandes sont marquées `[non testé : pas de cluster dans la session de rédaction]` sauf mention contraire ;
les drapeaux du CLI ont été vérifiés avec `argocd … --help` à la version `argo_cd` de `versions.yaml`.

## Section 1 — Exercice autonome

### Indices

1. Sur `kind`, un `NodePort` n'est joignable depuis la VM que si le port est publié par le conteneur de nœud :
   regarde `kind create cluster --config` et `extraPortMappings`, ou plus simple, `docker inspect` l'IP du nœud.
2. Pour la variante Gateway, `argocd-server` sert déjà du TLS : soit tu passes en `Passthrough`, soit tu le mets
   en `--insecure` et la Gateway termine. Le manifest fourni choisit la seconde option ; cherche la clé `server.insecure`.
3. La méthode de suivi est dans `argocd-cm`, clé `application.resourceTrackingMethod`. Si la clé est absente,
   c'est le défaut de la version qui s'applique : lis les notes de montée de version 2.14 → 3.0.

### Correction commentée

**Point 1, `kind`.** Le plus simple pour une VM de lab :

```bash
kubectl -n argocd patch svc argocd-server -p '{"spec":{"type":"NodePort"}}'
NODE_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' argocd-lab-control-plane)
NODE_PORT=$(kubectl -n argocd get svc argocd-server -o jsonpath='{.spec.ports[?(@.port==443)].nodePort}')
curl -k -s -o /dev/null -w '%{http_code}\n' "https://${NODE_IP}:${NODE_PORT}/"   # attendu : 200
```

Pourquoi ça marche : le réseau Docker de `kind` est routable depuis la VM. Depuis un autre poste, il faudrait
`extraPortMappings` à la création du cluster. C'est volontairement moche : la bonne réponse est la Gateway du lab complet.

**Point 1, `kubernetes-ha`.** Le manifest `variante-gateway-argocd.yaml` suppose un `ClusterIssuer` `lab-root-ca`
(fiche `services` à venir) et la `GatewayClass` `cilium`. Avant de l'appliquer :

```bash
kubectl -n argocd patch cm argocd-cmd-params-cm --type merge -p '{"data":{"server.insecure":"true"}}'
kubectl -n argocd rollout restart deploy/argocd-server
kubectl apply -f fiches/gitops/01-argo-cd-fondamentaux/manifests/variante-gateway-argocd.yaml
kubectl -n argocd get gateway,httproute,certificate
```

Le `HTTPRoute` vise le port 80 du Service `argocd-server` : en `--insecure`, ce port sert l'UI en clair,
et la Gateway porte le TLS avec le certificat de la CA interne. Enregistrement DNS : `*.apps.lab.home.arpa` (plan réseau).

**Point 2.** Rôles : `repo-server` clone et rend les manifests (Helm, Kustomize, plain) ; `application-controller`
compare et applique ; `server` expose UI, API et gRPC pour le CLI ; `redis` cache les manifests rendus et l'état.
Test : `kubectl -n argocd scale deploy argocd-server --replicas=0`, puis `kubectl -n guestbook scale deploy guestbook-ui --replicas=2`
sur une Application en `automated` + `selfHeal` : le contrôleur répare quand même, l'UI et le CLI sont juste injoignables.
Pense à `--replicas=1` ensuite.

**Point 3.** En 3.x, le défaut est `annotation` (clé absente de `argocd-cm` = défaut). Avec les labels, un outil qui copiait les labels
d'une ressource vers une autre faisait croire à Argo CD qu'il gérait la copie ; l'annotation `argocd.argoproj.io/tracking-id` est
spécifique à l'Application et ne se propage pas. Pour revenir aux labels : `application.resourceTrackingMethod: label`.

## Section 2 — Exercice autonome

### Indices

1. Un dépôt bare + un utilisateur `git` + `authorized_keys` suffisent : pas besoin d'un serveur Git complet pour Argo CD.
   Le CLI a deux commandes pour un dépôt SSH : une pour la clé d'hôte (`argocd cert add-ssh --batch`), une pour le dépôt (`argocd repo add`).
2. Le projet `lab` n'autorise que `guestbook` et `demo-*` comme namespaces : `demo-web` passe, `prod-web` non.
   L'erreur est dans `.status.conditions` de l'Application, pas dans les logs.
3. Une destination se corrige dans `spec.destinations` de l'`AppProject`. Le motif `demo-*` est un glob, pas une regex.

### Correction commentée

**Point 1, dépôt du lab.** Sur la machine qui héberge Git (`core-jump01` sur le lab complet, la VM `kind` sinon) :

```bash
sudo useradd --system --create-home --home-dir /srv/git --shell /usr/bin/git-shell git 2>/dev/null || true
sudo -u git git init --bare --initial-branch=main /srv/git/gitops-demo.git
ssh-keygen -t ed25519 -N '' -f ~/.ssh/argocd_ed25519 -C argocd-lab
sudo install -d -m 700 -o git -g git /srv/git/.ssh
sudo install -m 600 -o git -g git ~/.ssh/argocd_ed25519.pub /srv/git/.ssh/authorized_keys
```

Côté Argo CD, la clé d'hôte d'abord (3.5 vérifie strictement `known_hosts` pour tout dépôt SSH), le dépôt ensuite :

```bash
GIT_HOST=git.lab.home.arpa          # ou l'adresse de la VM kind
ssh-keyscan -t ed25519 "$GIT_HOST" | argocd cert add-ssh --batch
argocd repo add "git@${GIT_HOST}:/srv/git/gitops-demo.git" --ssh-private-key-path ~/.ssh/argocd_ed25519
argocd repo list                     # attendu : CONNECTION STATUS Successful
```

Contenu à pousser (copie de l'exemple officiel, renommée) :

```bash
git clone "git@${GIT_HOST}:/srv/git/gitops-demo.git" ~/gitops-demo && cd ~/gitops-demo
mkdir demo
curl -sSL https://raw.githubusercontent.com/argoproj/argocd-example-apps/master/guestbook/guestbook-ui-deployment.yaml \
  | sed 's/guestbook-ui/demo-ui/g' > demo/demo-ui-deployment.yaml
curl -sSL https://raw.githubusercontent.com/argoproj/argocd-example-apps/master/guestbook/guestbook-ui-svc.yaml \
  | sed 's/guestbook-ui/demo-ui/g' > demo/demo-ui-svc.yaml
git add demo && git commit -m "demo: copie de guestbook" && git push -u origin main
```

Si tu as remplacé l'hôte par une adresse, mets la même URL dans `sourceRepos` du projet et dans `repoURL` de l'Application :
Argo CD compare les URL de dépôt **telles quelles**.

**Point 2.** `kubectl apply -f …/application-lab-demo.yaml`, puis `argocd app sync lab-demo` et `argocd app wait lab-demo --sync --health`.

**Point 3.** Après `argocd app set lab-demo --dest-namespace prod-web`, `argocd app get lab-demo` montre une condition
`InvalidSpecError` dont le message dit que la destination (serveur + namespace) n'est pas permise dans le projet `lab`.
Correction côté projet, parce que c'est le projet qui porte la politique :

```bash
kubectl -n argocd patch appproject lab --type json \
  -p '[{"op":"add","path":"/spec/destinations/-","value":{"server":"https://kubernetes.default.svc","namespace":"prod-*"}}]'
argocd app get lab-demo --refresh    # la condition disparaît
argocd app set lab-demo --dest-namespace demo-web
```

Piège d'examen : modifier `spec.project` de l'Application vers `default` ferait aussi disparaître l'erreur. C'est la mauvaise réponse :
`default` autorise tout, et le QCM attend « restreindre via l'AppProject ».

## Section 3 — Exercice autonome

### Indices

1. Sans `prune`, une ressource retirée de Git reste vivante et l'Application est `OutOfSync` avec la ressource marquée
   « à élaguer » (`argocd app diff` la montre en suppression). `argocd app sync --prune` ou `--auto-prune` règle le cas.
2. Un `Deployment` avec `ImagePullBackOff` reste `Progressing` jusqu'à `progressDeadlineSeconds`, puis passe `Degraded`.
   Argo CD reflète la condition `ProgressDeadlineExceeded` du Deployment.
3. `git revert` crée un nouveau commit : Git reste la source de vérité et l'historique raconte l'incident.
   `argocd app rollback` rejoue une ancienne révision **sans** toucher à Git : au prochain commit, l'erreur revient.

### Correction commentée

**Point 1.**

```bash
cd ~/gitops-demo && git rm demo/demo-ui-svc.yaml && git commit -m "demo: retire le Service" && git push
argocd app get lab-demo --refresh      # OutOfSync ; le Service apparaît avec le statut de prune en attente
kubectl -n demo-web get svc            # le Service existe toujours
argocd app sync lab-demo               # toujours là : prune non demandé
argocd app sync lab-demo --prune       # supprimé
kubectl -n demo-web get svc            # No resources found
```

Avec `argocd app set lab-demo --sync-policy automated --auto-prune`, le même commit aurait supprimé le Service seul.
`prune` est désactivé par défaut parce qu'une faute de frappe dans un chemin de dépôt viderait un namespace.

**Point 2.**

```bash
git revert --no-edit HEAD && git push     # remets d'abord le Service, proprement
sed -i 's#gb-frontend:v5#gb-frontend:does-not-exist#' demo/demo-ui-deployment.yaml
sed -i 's/^  replicas: 1/  replicas: 1\n  progressDeadlineSeconds: 30/' demo/demo-ui-deployment.yaml
git commit -am "demo: image cassée (exercice)" && git push
argocd app sync lab-demo
watch -n5 argocd app get lab-demo         # Progressing puis Degraded après ~30 s
kubectl -n demo-web get pods              # ImagePullBackOff
git revert --no-edit HEAD && git push
argocd app sync lab-demo && argocd app wait lab-demo --health
```

Note la séquence des états : `Synced` + `Progressing` (Git et le cluster sont d'accord, mais l'objet ne va pas bien)
puis `Synced` + `Degraded`. Sync et health sont indépendants : c'est la question piège classique.

**Point 3.** Au point 2, Git contient l'erreur : rejouer une ancienne révision avec `rollback` masque le problème et l'auto-sync
(si réactivée) le ramènerait. Le `rollback` a sa place quand Git est bon mais qu'une release doit être retirée vite,
avant que le correctif Git n'arrive : sync automatique coupée, `argocd app rollback`, puis commit de correction et retour en `automated`.

## Break-fix — pistes de diagnostic

Les causes sont dans `--reveal` de chaque script. Chemin de diagnostic commun, dans l'ordre :

1. `argocd app list` : quel état sync / health, quelle Application touchée, les autres vont-elles bien ?
2. `argocd app get <app> --refresh` : lire `CONDITIONS` avant tout (`ComparisonError`, `InvalidSpecError`, `SyncError`).
3. `kubectl -n argocd get pods` et `kubectl -n argocd logs deploy/argocd-repo-server --tail=50` si la condition parle de dépôt ou de manifests.
4. `kubectl -n <ns-app> get pods` et `kubectl describe` si c'est la health qui est mauvaise.
5. `argocd app diff <app>` pour voir qui a dérivé de qui.

## Défis chronométrés — critères rappelés

- Section 1 : `argocd version` montre `argocd-server:` et `kubectl -n argocd get secret argocd-initial-admin-secret` renvoie `NotFound`.
- Section 2 : `argocd app get lab-demo -o json | jq -r '.status.sync.status + " " + .status.health.status'` → `Synced Healthy`.
- Section 3 : toutes les lignes de `argocd app list -o json | jq -r '.[] | .metadata.name + " " + .status.sync.status + " " + .status.health.status'`
  finissent par `Synced Healthy`.
