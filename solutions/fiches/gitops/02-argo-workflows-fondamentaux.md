# Solutions — 02 Argo Workflows : installer, écrire et lancer un premier workflow

Trois indices progressifs par exercice, puis la correction commentée. Lis un indice, retourne manipuler, reviens si besoin.
Les commandes sont marquées `[non testé : pas de cluster dans la session de rédaction]` sauf mention contraire ;
les drapeaux du CLI ont été vérifiés avec `argo … --help` et les workflows passés à `argo lint --offline`
à la version `argo_workflows` de `versions.yaml`.

## Section 1 — Exercice autonome

### Indices

1. En mode `client`, `argo-server` ne fait **rien** lui-même : il rejoue tes requêtes vers l'API Kubernetes avec le jeton
   que tu lui donnes. Le jeton d'un ServiceAccount se lit dans le Secret annoté `kubernetes.io/service-account.name`,
   et l'UI attend la chaîne complète `Bearer <jeton>`.
2. Le CLI a deux modes : kubeconfig (défaut) ou `argo-server`. Regarde les variables `ARGO_*` dans `argo --help` :
   il en faut quatre pour forcer le second et neutraliser le premier.
3. Pour la Gateway, tout est dans `argo server --help` : un drapeau pour le TLS, un pour l'authentification. Et la sonde
   de disponibilité du Deployment parle `HTTPS` : si tu changes l'un, change l'autre.

### Correction commentée

**Point 1, jeton et UI.**

```bash
kubectl apply -f fiches/gitops/02-argo-workflows-fondamentaux/manifests/rbac-ui-token.yaml
sleep 3   # le contrôleur de jetons remplit le Secret
ARGO_TOKEN="Bearer $(kubectl -n argo get secret lab-ui.service-account-token -o jsonpath='{.data.token}' | base64 -d)"
echo "$ARGO_TOKEN" | cut -c1-30
```

`[non testé : pas de cluster dans la session de rédaction]`. Dans l'UI (`https://localhost:2746`, *Login*, champ *client
authentication*), colle `$ARGO_TOKEN` tel quel, préfixe `Bearer` compris. L'onglet *Cluster Workflow Templates* affichera
une erreur 403 : le RoleBinding est limité au namespace `argo`, et c'est le but.

**Point 1, CLI vers `argo-server`.** Quatre variables : où est le serveur, quel jeton, ignorer le certificat auto-signé,
et surtout **plus de kubeconfig**, sinon le CLI l'utiliserait en silence.

```bash
export ARGO_SERVER=localhost:2746 ARGO_TOKEN ARGO_INSECURE_SKIP_VERIFY=true KUBECONFIG=/dev/null
argo list -n argo                 # attendu : la liste, servie par argo-server
argo list -n default              # attendu : forbidden : le jeton ne voit que argo
unset ARGO_SERVER ARGO_TOKEN ARGO_INSECURE_SKIP_VERIFY KUBECONFIG
argo list -n argo                 # retour au mode kubeconfig
```

`[non testé : pas de cluster dans la session de rédaction]`. Pourquoi le ClusterRole `admin` suffit : `install.yaml` livre
trois ClusterRoles `argo-aggregate-to-{admin,edit,view}` portant le label `rbac.authorization.k8s.io/aggregate-to-admin`
(lu avec `yq`, exécuté) ; Kubernetes y fusionne les CRD Argo. Un RoleBinding sur `admin` donne donc les droits Argo dans
**un** namespace sans écrire une ligne de règle.

**Point 2.** `workflow-controller` lit les `Workflow`, crée un pod par étape et met à jour le statut ; `argo-server` sert
l'UI et l'API REST et n'exécute rien ; le conteneur `init` prépare le pod (volumes, artefacts d'entrée) ; le conteneur `wait`
observe `main`, collecte sorties et artefacts et écrit un `WorkflowTaskResult` ; le `WorkflowTaskResult` est la ressource
par laquelle le pod rend compte au contrôleur, d'où le droit `create`/`patch` du ServiceAccount. Test :

```bash
kubectl -n argo scale deploy argo-server --replicas=0
argo submit -n argo --wait --serviceaccount wf-runner \
  "https://raw.githubusercontent.com/argoproj/argo-workflows/v$(yq -r .components.argo_workflows.version versions.yaml)/examples/hello-world.yaml"
kubectl -n argo scale deploy argo-server --replicas=1
```

`[non testé : pas de cluster dans la session de rédaction]`. Attendu : `Succeeded`. Le CLI parle à l'API Kubernetes, le
contrôleur fait le travail ; seul l'UI manque.

**Point 3, Gateway sur `kubernetes-ha`.** La Gateway termine le TLS, donc `argo-server` doit servir en clair, et sa sonde
aussi :

```bash
kubectl -n argo patch deploy argo-server --type=json -p '[
  {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--secure=false"},
  {"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/scheme","value":"HTTP"}]'
kubectl -n argo rollout status deploy/argo-server
kubectl apply -f fiches/gitops/02-argo-workflows-fondamentaux/manifests/variante-gateway-argo.yaml
kubectl -n argo get gateway,httproute,certificate
curl -s -o /dev/null -w '%{http_code}\n' https://argo.apps.lab.home.arpa/   # avec la CA interne dans le trust store
```

`[non testé : pas de cluster dans la session de rédaction]`. Le `HTTPRoute` vise le port 2746 du Service `argo-server`,
désormais en clair ; le manifest suppose le `ClusterIssuer` `lab-root-ca` et la `GatewayClass` `cilium` (fiche 01, mêmes
hypothèses). `--auth-mode=server` : l'UI agirait avec le ServiceAccount `argo-server`, qui a un ClusterRole large, sans
demander qui tu es. Confortable sur un `kind` jetable, inacceptable dès que quelqu'un d'autre atteint l'URL : pas d'identité,
pas d'audit, pas de limite de namespace.

## Section 2 — Exercice autonome

### Indices

1. Le squelette : `arguments.parameters` pour `version`, un template `steps` à trois étapes dont une double, un template
   `script` qui écrit dans `/tmp/build-id.txt`, un `outputs.parameters` avec `valueFrom.path`. `argo lint --offline` nomme
   précisément la référence qu'il ne résout pas.
2. Pour `wf-03`, le message est dans `argo get` sur le nœud `create-note`, et il parle de `forbidden` et de `configmaps`.
   Le ServiceAccount a besoin d'un droit de plus, et d'un seul : `manifests/rbac-resource-configmaps.yaml` le montre.
3. `{{= … }}` ouvre une expression `expr` ; `jsonpath(texte, chemin)` y est une fonction prête. La sortie de l'étape doit
   être un paramètre (fichier), pas `result`, pour que le JSON arrive intact.

### Correction commentée

**Point 1.** Workflow complet, passé à `argo lint --offline` (exécuté, `✔ no linting errors found!`) :

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: release-
  namespace: argo
spec:
  entrypoint: release
  serviceAccountName: wf-runner
  arguments:
    parameters:
      - name: version
        value: "0.1.0"
  templates:
    - name: release
      steps:
        - - name: prepare
            template: prepare
        - - name: lint
            template: say
            arguments:
              parameters: [{name: msg, value: "lint OK"}]
          - name: unit-tests
            template: unit
        - - name: publish
            template: say
            arguments:
              parameters:
                - name: msg
                  value: "publish {{workflow.parameters.version}} build {{steps.prepare.outputs.parameters.build-id}}"
    - name: prepare
      script:
        image: alpine:3.23
        command: [sh]
        source: echo -n "{{workflow.parameters.version}}-$(date +%s)" > /tmp/build-id.txt
      outputs:
        parameters:
          - name: build-id
            valueFrom: {path: /tmp/build-id.txt}
    - name: unit
      script:
        image: python:3.13-alpine
        command: [python]
        source: print("42 tests passed")
    - name: say
      inputs:
        parameters: [{name: msg}]
      container:
        image: busybox:1.37
        command: [echo]
        args: ["{{inputs.parameters.msg}}"]
```

```bash
argo lint --offline ~/wf-release.yaml
argo submit -n argo --wait ~/wf-release.yaml -p version=2.0.0 && argo logs -n argo @latest | grep publish
```

`[non testé : pas de cluster dans la session de rédaction]`. Avec `{{steps.nope.outputs.parameters.build-id}}` à la place,
le lint hors ligne répond (exécuté) :

```text
✖ in "release-" (Workflow): templates.release.steps failed to resolve {{steps.nope.outputs.parameters.build-id}}
```

Le contrôleur aurait refusé le workflow à la soumission avec le même message : le lint hors ligne utilise son validateur.

**Point 2.** Diagnostic puis correction minimale :

```bash
argo submit -n argo --wait fiches/gitops/02-argo-workflows-fondamentaux/manifests/wf-03-resource-configmap.yaml
argo get -n argo @latest        # create-note : Error, message « configmaps is forbidden: User "system:serviceaccount:argo:wf-runner" cannot create resource "configmaps" … »
kubectl apply -f fiches/gitops/02-argo-workflows-fondamentaux/manifests/rbac-resource-configmaps.yaml
argo retry -n argo @latest && argo wait -n argo @latest
kubectl -n argo get cm -l '!app' | grep release-note
kubectl -n argo get cm "$(argo get -n argo @latest -o json | jq -r '.status.nodes[] | select(.displayName=="create-note") | .outputs.parameters[] | select(.name=="cm-name") | .value')" \
  -o jsonpath='{.metadata.ownerReferences[0].kind}{"\n"}'   # attendu : Workflow
argo delete -n argo @latest ; sleep 5 ; kubectl -n argo get cm | grep -c release-note   # attendu : 0
```

`[non testé : pas de cluster dans la session de rédaction]`. Pourquoi « minimal » : un template `resource` agit avec le
ServiceAccount du **workflow**, pas celui du contrôleur. Donner `admin` à `wf-runner` marcherait aussi et serait une faute :
le workflow peut alors supprimer n'importe quoi dans le namespace. `setOwnerReference: true` rattache le ConfigMap au
Workflow ; la suppression du Workflow (manuelle ou par `ttlStrategy`) entraîne la sienne.

**Point 3.** L'étape `unit` écrit un fichier JSON et l'expose en paramètre ; `summary` extrait une clé :

```yaml
    - name: unit
      script:
        image: python:3.13-alpine
        command: [python]
        source: |
          import json
          json.dump({"passed": 42, "failed": 0}, open("/tmp/report.json", "w"))
      outputs:
        parameters:
          - name: report
            valueFrom: {path: /tmp/report.json}
    # dans l'étape summary :
    #   value: "passed={{=jsonpath(steps['unit-tests'].outputs.parameters.report, '$.passed')}}"
```

Passé à `argo lint --offline` (exécuté). Note la forme `steps['unit-tests']` : dans une expression, un nom avec tiret
n'est pas accessible par point. `outputs.result` suffit quand l'étape produit **une** valeur courte (un nombre, un nom)
et que tu ne veux pas gérer de fichier ; dès qu'il y a une structure ou plusieurs valeurs, un paramètre fichier est plus
lisible et ne dépend pas du moindre `print` parasite.

## Section 3 — Exercice autonome

### Indices

1. Quatre champs, quatre niveaux : `retryStrategy` et `activeDeadlineSeconds` sur le **template** `fetch`, `podGC` et
   `ttlStrategy` sur la **spec**. `limit` compte les nouvelles tentatives, pas le total.
2. `spec.retryStrategy` existe et s'applique à **tous** les templates : regarde l'arbre de `argo get`, `report` y gagne un
   nœud. `OnError` ne regarde que les erreurs d'infrastructure (pod évincé, conteneur `wait` en échec), pas un `exit 1`.
3. La clé s'appelle `workflowDefaults` dans `workflow-controller-configmap`, et c'est un bloc YAML **dans une chaîne**.
   Le contrôleur ne relit pas sa configuration à chaud pour tout : redémarre-le.

### Correction commentée

**Point 1.** Version robuste de `wf-06` (passée à `argo lint --offline`, exécuté) :

```yaml
spec:
  entrypoint: main
  serviceAccountName: wf-runner
  podGC:
    strategy: OnPodSuccess
  ttlStrategy:
    secondsAfterCompletion: 600
  templates:
    - name: main
      steps:
        - - name: fetch
            template: fetch
        - - name: report
            template: report
    - name: fetch
      activeDeadlineSeconds: 120
      retryStrategy:
        limit: "3"                 # 1 essai + 3 nouvelles tentatives = 4
        retryPolicy: OnFailure
        backoff:
          duration: "5s"
          factor: "2"
          maxDuration: "2m"
      script: { … inchangé … }
    - name: report
      container: { … inchangé … }
```

Mesure :

```bash
for i in $(seq 10); do argo submit -n argo --wait ~/wf-flaky-robuste.yaml >/dev/null; done
kubectl -n argo get wf -o json | jq -r '[.items[] | select(.metadata.generateName=="flaky-") | .status.phase] | group_by(.) | map("\(.[0]) \(length)") | .[]'
kubectl -n argo get pods -l workflows.argoproj.io/workflow --field-selector=status.phase=Succeeded --no-headers | wc -l
```

`[non testé : pas de cluster dans la session de rédaction]`. Attendu : `Succeeded 10` (la probabilité de quatre échecs
consécutifs est de 1/16 par lancement, donc un `Failed` sur dix reste possible : relance et explique-le), `0` pod réussi
résiduel, et `argo list` vide dix minutes plus tard.

**Point 2.** Avec `retryStrategy` sous `spec`, `argo get` montre `report` lui aussi enveloppé dans un nœud de type `Retry`
avec une tentative `report(0)` : chaque template hérite de la stratégie. Avec `retryPolicy: OnError`, le script qui sort en
`exit 1` est **Failed**, pas **Error** : aucune nouvelle tentative, le workflow échoue une fois sur deux comme au départ.
Vérification : `argo get -o json | jq '.status.nodes[] | select(.type=="Retry") | .displayName'` et le compteur de tentatives.

**Point 3.** Les défauts côté contrôleur :

```bash
kubectl -n argo patch cm workflow-controller-configmap --type merge -p '{"data":{"workflowDefaults":"spec:\n  activeDeadlineSeconds: 300\n  podGC:\n    strategy: OnPodSuccess\n  ttlStrategy:\n    secondsAfterCompletion: 600\n"}}'
kubectl -n argo rollout restart deploy/workflow-controller && kubectl -n argo rollout status deploy/workflow-controller
argo submit -n argo --wait fiches/gitops/02-argo-workflows-fondamentaux/manifests/wf-06-flaky.yaml
kubectl -n argo get pods -l workflows.argoproj.io/workflow   # plus aucun pod Completed du dernier workflow
```

`[non testé : pas de cluster dans la session de rédaction]`. Preuve par le comportement : les pods réussis disparaissent
et le workflow est supprimé dix minutes après sa fin alors que `wf-06` ne contient aucun de ces champs. Si `argo get -o yaml`
ne montre pas les champs fusionnés dans `spec`, lis les logs du contrôleur (`kubectl -n argo logs deploy/workflow-controller
| grep -i default`) plutôt que de conclure que ça ne marche pas. Un champ écrit dans le workflow garde la priorité sur le défaut.
Le `retryStrategy` reste à mettre dans le workflow : un défaut global de nouvelles tentatives masquerait de vrais bugs.
