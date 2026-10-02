# 07 — Veille mensuelle (tâche planifiée ou session dédiée)

Pour chaque entrée de versions.yaml et chaque dossier de certifs/, vérifie sur la source officielle
si une nouvelle version, un nouveau programme ou un changement de conditions d'examen est publié.
Pour les programmes CNCF, compare avec <https://github.com/cncf/curriculum.>
Produis `docs/veille/<AAAA-MM>.md` : ce qui a changé, les chapitres impactés (grep des IDs de compétence
et des composants), l'effort estimé de mise à jour.
Si un programme a changé : régénère programme.md en respectant la règle des IDs (DECISIONS.md),
puis liste les IDs ajoutés/retirés/reformulés.
Ouvre une issue par impact. Ne modifie aucun chapitre.
