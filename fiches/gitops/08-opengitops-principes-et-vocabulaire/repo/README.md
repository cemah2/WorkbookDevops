# Dépôt du lab pour la fiche 08

Deux dossiers avec la même application (nginx + page HTML dans une ConfigMap + Service) :

- `push/` : déployé par le CronJob « CI » de `manifests/cronjob-ci-push.yaml` (`kubectl apply`), dans le namespace `demo-push` ;
- `pull/` : déployé par l'Application Argo CD `demo-pull` de `manifests/application-demo-pull.yaml`, dans le namespace `demo-pull`.

À copier à la racine du dépôt bare du lab (`gitops-principes.git`), voir la fiche, section 1.
