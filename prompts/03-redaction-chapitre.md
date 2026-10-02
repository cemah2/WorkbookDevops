# 03 — Rédiger le chapitre (après validation du plan)

Plan validé. Crée une branche `chapitre/<slug>`.
Rédige <chemin du chapitre> en suivant le gabarit à la lettre, puis :

- `solutions/<même chemin>` avec 3 indices progressifs puis correction commentée ;
- `break/<techno>/<numéro>-*.sh` : scripts de panne idempotents, avec `--reveal` qui explique la panne ;
- `revision/<techno>/<numéro>.csv` : 10 à 20 flashcards `question;réponse;tags` ;
- mise à jour de `certifs/<CODE>/objectifs.md` pour chaque ID couvert ;
- mise à jour de docs/prerequis.md.

Exécute chaque commande dans l'environnement le plus proche disponible (kind, conteneur, VM) ;
marque `[non testé]` avec la raison quand c'est impossible ici. Lance les linters.
Ouvre une PR dont la description contient la checklist « terminé » de CLAUDE.md cochée honnêtement,
la liste de ce qui n'a pas pu être vérifié, et le temps d'apprentissage estimé.
