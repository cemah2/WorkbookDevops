# 01 — Cartographier une certification (une session par certification)

Certification à cartographier : <CODE>   (ex. CKA)

Lis CLAUDE.md, certifs/<CODE>/programme.md, docs/prerequis.md et la liste des chapitres existants
(`fiches/`, `scenarios/`).
Produis `certifs/<CODE>/objectifs.md` : pour chaque compétence (ID `<CODE>-DD-CC`), sa pondération
héritée du domaine, les chapitres et exercices existants qui la couvrent, et les trous.
Pour chaque trou, propose le chapitre à créer : chemin cible, titre, niveau, 3 exercices clés,
type de lab requis, estimation de temps d'apprentissage.
Produis aussi `certifs/<CODE>/examen.md` : durée, format, nombre de questions, documentation autorisée,
environnement d'examen, prérequis, validité, prix indicatif, simulateur inclus — chaque information
avec son URL officielle et sa date de vérification ; marque « non trouvé » plutôt que d'inventer.
Mets à jour docs/prerequis.md avec les nouveaux nœuds.
Ne rédige pas les chapitres. Ouvre une PR.
