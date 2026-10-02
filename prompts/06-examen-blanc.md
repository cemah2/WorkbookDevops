# 06 — Construire un examen blanc

Certification : <CODE>   Numéro : <01>

À partir de certifs/<CODE>/programme.md, objectifs.md et examen.md, génère `exams/<CODE>/mock-<NN>/` :
- des tâches réparties selon les pondérations officielles (nombre et durée calqués sur examen.md) ;
- `setup.sh` qui prépare l'environnement sur le profil de lab indiqué ;
- `grade.sh` qui vérifie automatiquement chaque tâche et affiche un score pondéré ;
- `consignes.md` : durée, documentation autorisée, règles ;
- `correction.md` dans un fichier séparé, jamais dans les consignes.
Les tâches exigent la manipulation, pas la récitation. Pour un examen QCM, génère un banque de
questions au format Markdown avec réponse et explication séparées, et un script de tirage aléatoire.
