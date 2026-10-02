# break/plateforme/ — pannes scriptées du domaine `plateforme` (Backstage, mesh, opérateurs…)

Un script par panne, préfixé du numéro de la fiche (`01-backstage-*.sh` pour `fiches/plateforme/01`).
Chaque script est idempotent : sans argument il injecte la panne, `--undo` la retire, `--reveal` l'explique sans rien toucher.
Les scripts Backstage agissent sur le dépôt de l'app désigné par `APP_DIR` (défaut `$HOME/lab-portal`) et sauvegardent
ce qu'ils modifient dans `$APP_DIR/.break-01/`.
