#!/usr/bin/env bash
# break/plateforme/01-backstage-node-version.sh — fiche 01 Backstage.
# Usage : ./01-backstage-node-version.sh            injecte la panne (idempotent)
#         ./01-backstage-node-version.sh --undo     retire la panne
#         ./01-backstage-node-version.sh --reveal   explique la panne (ne touche à rien)
# Variables : APP_DIR (défaut $HOME/lab-portal).
set -euo pipefail
APP_DIR="${APP_DIR:-$HOME/lab-portal}"
BACKUP_DIR="$APP_DIR/.break-01"
BUILD="$APP_DIR/node_modules/better-sqlite3/build"
BACKUP="$BACKUP_DIR/better-sqlite3-build"

reveal() {
  cat <<'TXT'
Panne : le module natif better-sqlite3 (la base de données de développement) n'a plus de binaire utilisable.
C'est exactement ce qui arrive quand on change de version majeure de Node (nvm use 24 après une installation faite
en 22, ou l'inverse) : le fichier .node compilé ne correspond plus à l'ABI du Node qui tourne.
Pourquoi ça casse : `yarn install` ne vérifie pas engines.node (Yarn 4 ne l'applique pas au projet) et ne recompile
rien tant que le lockfile n'a pas changé ; seul le backend, au démarrage, charge le module et échoue.
Symptôme : le frontend compile (« Rspack compiled successfully »), le backend s'arrête aussitôt avec une erreur sur better-sqlite3
(« Could not locate the bindings file » ou « was compiled against a different Node.js version »).
Diagnostic : `node -v`, `cat .nvmrc` s'il existe, `jq .engines package.json`, `ls node_modules/better-sqlite3/build/Release/`.
Correction : revenir au Node utilisé pour installer (`nvm use 22`), ou recompiler le module pour le Node courant :
`yarn rebuild better-sqlite3` (télécharge un binaire précompilé, sinon compile avec node-gyp). `--undo` restaure le binaire sauvegardé.
TXT
}

need_app() {
  if [ ! -f "$APP_DIR/package.json" ] || [ ! -d "$APP_DIR/node_modules/better-sqlite3" ]; then
    echo "pas d'app Backstage installée dans $APP_DIR (variable APP_DIR, yarn install fait ?)" >&2; exit 1
  fi
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    need_app
    if [ ! -d "$BACKUP" ]; then echo "undo: aucune sauvegarde $BACKUP, rien à faire (yarn rebuild better-sqlite3 l'a peut-être déjà réparé)"; exit 0; fi
    if [ -d "$BUILD" ]; then echo "undo: un binaire est déjà en place (rebuild fait), sauvegarde oubliée"; else mv "$BACKUP" "$BUILD"; echo "undo: binaire better-sqlite3 restauré"; fi
    [ -d "$BACKUP" ] && mv "$BACKUP" "$BACKUP.old-$(date +%s)"
    ;;
  "")
    need_app
    if [ -d "$BACKUP" ]; then echo "panne déjà injectée (sauvegarde $BACKUP présente)"; exit 0; fi
    if [ ! -d "$BUILD" ]; then echo "node_modules/better-sqlite3/build absent : module non compilé, rien à casser" >&2; exit 1; fi
    mkdir -p "$BACKUP_DIR" && mv "$BUILD" "$BACKUP"
    echo "panne injectée : binaire natif de better-sqlite3 retiré (--reveal pour l'explication, --undo pour réparer ; relance yarn start)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
