# Solutions — 01 kubectl, Pods et namespaces

Trois indices progressifs par exercice, puis la correction commentée. Lis un indice, retourne manipuler, reviens si besoin.
Les commandes marquées (exécuté) ont tourné le 2026-10-02 contre le control plane sans nœud de la session de rédaction
(voir l'en-tête de la fiche) ; celles qui exigent un nœud sont `[non testé : pas de nœud dans la session de rédaction]`,
leurs drapeaux ont été vérifiés avec `kubectl … --help` en 1.37.1.

## Section 1 — Exercice autonome (second cluster, fusion de kubeconfig)

### Indices

1. `kind create cluster --name ckad-lab2` écrit déjà dans `~/.kube/config` et bascule le contexte courant : regarde
   `kubectl config get-contexts` avant de chercher à fusionner quoi que ce soit. Si tu veux pratiquer la fusion quand même,
   exporte son kubeconfig à part : `kind get kubeconfig --name ckad-lab2 > /tmp/lab2.yaml`.
2. Plusieurs fichiers dans `KUBECONFIG` séparés par `:` sont lus comme un seul ; `kubectl config view --flatten` les écrit en un
   fichier avec les certificats inclus. Ne redirige jamais vers un fichier qui fait partie de `KUBECONFIG` au moment de la commande.
3. Les sous-commandes `rename-context`, `delete-context`, `delete-cluster`, `delete-user` de `kubectl config` font le ménage ;
   `kind delete cluster` retire aussi ses entrées, vérifie ce qui reste.

### Correction commentée

**Point 1.** Fusion (exécuté avec deux fichiers pointant sur le control plane de session, le second renommé `kind-ckad-lab2`) :

```bash
kind create cluster --name ckad-lab2                      # [non testé : pas de cluster dans la session]
kind get kubeconfig --name ckad-lab2 > /tmp/lab2.yaml     # [non testé]
cp ~/.kube/config ~/.kube/config.avant-fusion
KUBECONFIG=~/.kube/config.avant-fusion:/tmp/lab2.yaml kubectl config view --flatten > ~/.kube/config
kubectl config get-contexts
kubectl config rename-context kind-ckad-lab ckad-lab
kubectl config rename-context kind-ckad-lab2 ckad-lab2
kubectl config use-context ckad-lab2
kubectl config current-context
kubectl get nodes          # un seul nœud sur ckad-lab2 [non testé]
```

Sortie obtenue pour la partie kubeconfig (exécuté) :

```text
CURRENT   NAME             CLUSTER          AUTHINFO               NAMESPACE
*         ckad-lab         ckad-lab         ckad-lab-admin         shop
          kind-ckad-lab2   kind-ckad-lab2   kind-ckad-lab2-admin   shop
Context "kind-ckad-lab2" renamed to "ckad-lab2".
Switched to context "ckad-lab2".
ckad-lab2
```

Pourquoi `--flatten` : sans lui, `view` garde des références à des fichiers de certificats, inutilisables une fois le fichier déplacé.
La preuve « sur quel cluster je suis » : `kubectl get nodes` (un nœud contre trois) ou `kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'`
(deux ports différents sur la même VM).

**Point 2.** (exécuté sur le fichier fusionné)

```bash
kubectl config use-context ckad-lab
kind delete cluster --name ckad-lab2                      # [non testé] ; retire le contexte kind-ckad-lab2 s'il portait encore ce nom
kubectl config delete-context ckad-lab2
kubectl config delete-cluster kind-ckad-lab2
kubectl config delete-user kind-ckad-lab2
kubectl config get-contexts
kubectl config view -o jsonpath='{.clusters[*].name} {.users[*].name}{"\n"}'
```

```text
Switched to context "ckad-lab".
deleted context ckad-lab2 from /root/.kube/config
deleted cluster kind-ckad-lab2 from /root/.kube/config
deleted user kind-ckad-lab2-admin from /root/.kube/config
CURRENT   NAME       CLUSTER    AUTHINFO         NAMESPACE
*         ckad-lab   ckad-lab   ckad-lab-admin   shop
ckad-lab ckad-lab-admin
```

Un contexte renommé garde le cluster et le user d'origine : c'est pour ça que `delete-cluster` et `delete-user` prennent encore
le nom `kind-ckad-lab2`.

**Point 3.** `kubectl explain pod.spec.terminationGracePeriodSeconds` (entier, 30 s par défaut) et
`kubectl explain pod.metadata.labels` : `<map[string]string>`. (exécuté)

## Section 2 — Exercice autonome (énoncé type examen)

### Indices

1. Tout tient dans une seule commande `kubectl run` avec `--dry-run=client -o yaml`. Relis `kubectl run --help` : `--port`,
   `--labels`, `--env` existent ; la commande du conteneur vient après `--`.
2. Pour le fichier `pods.txt`, `custom-columns` produit déjà l'en-tête ; `--sort-by` prend un chemin JSON, pas un nom de colonne.
3. Changer un label ne recrée rien : `kubectl label … --overwrite`. Le sélecteur « différent de » s'écrit `-l 'tier!=backend'`
   (quotes : le `!` parle à bash).

### Correction commentée

(exécuté ; `/opt/ckad` remplacé par un dossier de session, le script de notation renvoie `score : 11 / 11`)

```bash
sudo mkdir -p /opt/ckad && sudo chown "$USER" /opt/ckad
kubectl run api --image=nginx:1.29 --port=80 --labels=app=api,tier=backend --env=MODE=dev -n shop \
  --dry-run=client -o yaml > /opt/ckad/api.yaml
kubectl apply -f /opt/ckad/api.yaml
kubectl run worker --image=busybox:1.37 --labels=tier=backend -n shop -- sleep 3600
kubectl run cache --image=redis:8 --labels=tier=data -n shop
kubectl get pods -n shop --sort-by=.metadata.name \
  -o custom-columns='NAME:.metadata.name,NS:.metadata.namespace,IMAGE:.spec.containers[*].image' > /opt/ckad/pods.txt
kubectl label pod worker -n shop tier=batch --overwrite
kubectl get pods -n shop -l 'tier!=backend'
solutions/fiches/kubernetes/01-kubectl-pods-namespaces/grade-2-3.sh
```

```text
pod/api created
pod/worker created
pod/cache created
pod/worker labeled
NAME     READY   STATUS    RESTARTS   AGE
cache    0/1     Pending   0          0s
worker   0/1     Pending   0          0s
OK  api.yaml existe et décrit un Pod api
OK  api : image nginx:1.29
…
score : 11 / 11
```

Points d'attention : l'énoncé ne dit pas `--restart=Never` pour `api`, donc le défaut `Always` convient (un serveur doit être relancé) ;
pour `worker` avec `sleep 3600`, `Always` relancera le `sleep` toutes les heures, ce n'est pas faux mais à l'examen on lit l'énoncé
et on ne rajoute rien. En déclaratif, le YAML écrit à la main doit être **identique** au dry-run moins `status: {}`,
`resources: {}` et `creationTimestamp: null` : compare avec `diff`.

## Section 3 — Exercice autonome (Pod `duo`)

### Indices

1. Un Pod à deux conteneurs oblige à nommer le conteneur : `-c web`, `-c client`. Sans `-c`, `kubectl logs` refuse et liste les
   noms disponibles.
2. `localhost` répond parce que les conteneurs d'un même Pod partagent le même espace réseau (même IP, mêmes ports) : c'est le concept
   central de la fiche 05. `kubectl exec duo -c client -- wget -qO- http://localhost/`.
3. `kubectl cp` prend `pod:chemin` avec `-c` ; `kubectl port-forward pod/duo 8081:80` écoute sur la VM, pas sur les nœuds.

### Correction commentée

`[non testé : pas de nœud dans la session de rédaction]` ; le manifest `pod-duo.yaml` est validé par `kubeconform` et accepté par
l'API (exécuté : `pod/duo created`, deux conteneurs `web,client`).

```bash
kubectl apply -f fiches/kubernetes/01-kubectl-pods-namespaces/manifests/pod-duo.yaml
kubectl get pod duo -w                              # jusqu'à 2/2 Running, Ctrl-C
kubectl logs duo -c web --tail=20 > /opt/ckad/web.log
kubectl logs duo -c client --tail=20 > /opt/ckad/client.log
kubectl exec duo -c client -- wget -qO- http://localhost/ | head -3
kubectl cp duo:/shared/journal.txt /opt/ckad/journal.txt -c client
sleep 10; kubectl cp duo:/shared/journal.txt /tmp/journal2.txt -c client; wc -l /opt/ckad/journal.txt /tmp/journal2.txt
kubectl port-forward pod/duo 8081:80 >/tmp/pf.log 2>&1 &
curl -s localhost:8081 | head -4
kill %1
```

Attendu : `client.log` montre `requete N: <!DOCTYPE html>…`, `web.log` montre les lignes d'accès `127.0.0.1 - - … "GET / HTTP/1.1" 200`
(l'IP source est `127.0.0.1` : même espace réseau), le second `journal.txt` a deux lignes de plus que le premier, `curl` renvoie
la page nginx.

## Break-fix

Chaque script explique la panne avec `--reveal` ; ne le lis qu'après avoir écrit ta cause en une phrase. Résumé :

| Script | Lecture qui donne la cause | Correction |
|---|---|---|
| `01-kubeconfig-casse.sh` | `kubectl config view --minify` : port `6444` ; `docker port ckad-lab-control-plane 6443/tcp` donne le vrai | `kubectl config set-cluster kind-ckad-lab --server=https://127.0.0.1:<port>` |
| `01-namespace-fantome.sh` | la fin du message : `in shop-prod namespace` ; `kubectl config get-contexts` colonne NAMESPACE | `kubectl config set-context --current --namespace=shop` |
| `01-pod-crashloop.sh` | `kubectl logs api --previous` : `fatal: config file /etc/api/config.yaml not found` ; `describe` : `Exit Code: 1` | `kubectl replace --force -f` d'un YAML sans la mauvaise commande, ou `delete` + `run` |
| `01-pod-pending.sh` | `kubectl describe pod worker` : `Node-Selectors: disk=ssd`, événement `FailedScheduling … didn't match Pod's node affinity/selector` | recréer le Pod sans `nodeSelector` (pas étiqueter un nœud) |

Les deux premiers ont été exécutés de bout en bout dans la session (symptôme exact reproduit) ; les deux derniers ont été injectés
et retirés, leurs symptômes sont `[non testé : pas de nœud dans la session de rédaction]`.

## Défis chronométrés

- Section 1 (15 min) : l'ordre qui tient dans le temps est binaires → `kind create cluster --config` → `cilium install` **sans attendre**
  → `.bashrc` / `.vimrc` pendant que Cilium démarre → `cilium status --wait` → `rename-context`.
- Section 2 (6 min) : `k create ns defi2 && k config set-context --current --namespace=defi2`, puis trois `k run`, puis un seul
  `jsonpath` avec `{range}`. Si tu dépasses 6 min, c'est que tu as ouvert `--help` : retravaille les flashcards.
- Section 3 (10 min) : commence toujours par `k get pods -A` et `k config get-contexts` ; une panne de kubeconfig se voit avant
  toute commande sur les Pods.
