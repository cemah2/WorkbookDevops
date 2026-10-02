# Kit de démarrage — workbook DevOps cloud privé

Contenu :
- `CLAUDE.md` — instructions permanentes lues par Claude Code à chaque session (à la racine du dépôt).
- `DECISIONS.md` — journal des arbitrages déjà pris.
- `docs/roadmap.md` — axes pédagogiques et feuille de route.
- `certifs/` — 21 programmes de certification en Markdown avec IDs stables, README d'index,
  PDF CNCF d'origine et script de régénération dans `certifs/_sources_pdf/`.
- `prompts/` — les prompts numérotés et leur ordre d'utilisation (`prompts/README.md`).

Démarrage :
1. Ouvrir une session Claude Code (ou Claude avec accès GitHub) dans un dossier vide contenant ce kit.
2. Coller `prompts/00-amorcage-depot.md`. Il crée le dépôt, le squelette, la CI, versions.yaml,
   le plan réseau, les profils de lab, et pousse sur GitHub.
3. Ensuite, suivre l'ordre de `prompts/README.md`.
