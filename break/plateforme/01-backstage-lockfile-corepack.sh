#!/usr/bin/env bash
# break/plateforme/01-backstage-lockfile-corepack.sh — fiche 01 Backstage.
# Usage : ./01-backstage-lockfile-corepack.sh            injecte la panne (idempotent)
#         ./01-backstage-lockfile-corepack.sh --undo     retire la panne
#         ./01-backstage-lockfile-corepack.sh --reveal   explique la panne (ne touche à rien)
# Variables : APP_DIR (défaut $HOME/lab-portal).
set -euo pipefail
APP_DIR="${APP_DIR:-$HOME/lab-portal}"
BACKUP_DIR="$APP_DIR/.break-01"
BACKUP_PKG="$BACKUP_DIR/lockfile.package.json"
BACKUP_LOCK="$BACKUP_DIR/lockfile.yarn.lock"

reveal() {
  cat <<'TXT'
Deux pannes en une, dans l'ordre où tu les rencontres.
1. Le champ packageManager du package.json racine pointe sur une version de Yarn qui n'existe pas (yarn@4.99.0).
   Avec corepack activé, la commande `yarn` lit ce champ avant toute chose et tente de télécharger cette version :
   « Error when performing the request to https://repo.yarnpkg.com/4.99.0/... ». Rien ne tourne, même `yarn --version`.
   Contournement : `node .yarn/releases/yarn-4.13.0.cjs` (le binaire embarqué par create-app, clé yarnPath de .yarnrc.yml)
   fonctionne toujours, corepack ou pas. Correction : remettre la version de .yarn/releases/ dans packageManager.
2. Une entrée de yarn.lock a été retirée. `yarn install` la recrée en silence (le lockfile « bouge ») ; `yarn install --immutable`,
   celui de la CI et du Dockerfile, refuse : « The lockfile would have been modified by this install, which is explicitly forbidden ».
Diagnostic : `git diff package.json yarn.lock` (tout est dans Git), `node .yarn/releases/yarn-*.cjs --version`.
Correction : `--undo`, ou `git checkout package.json yarn.lock` puis `yarn install --immutable` qui doit passer sans modifier le lockfile.
TXT
}

need_app() {
  if [ ! -f "$APP_DIR/package.json" ] || [ ! -f "$APP_DIR/yarn.lock" ]; then
    echo "pas d'app Backstage dans $APP_DIR (variable APP_DIR)" >&2; exit 1
  fi
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    need_app
    if [ ! -f "$BACKUP_PKG" ]; then echo "undo: aucune sauvegarde dans $BACKUP_DIR, rien à faire"; exit 0; fi
    cp "$BACKUP_PKG" "$APP_DIR/package.json"; cp "$BACKUP_LOCK" "$APP_DIR/yarn.lock"
    rm -f "$BACKUP_PKG" "$BACKUP_LOCK"
    echo "undo: package.json et yarn.lock restaurés dans $APP_DIR"
    ;;
  "")
    need_app
    if [ -f "$BACKUP_PKG" ]; then echo "panne déjà injectée (sauvegarde présente dans $BACKUP_DIR)"; exit 0; fi
    mkdir -p "$BACKUP_DIR"; cp "$APP_DIR/package.json" "$BACKUP_PKG"; cp "$APP_DIR/yarn.lock" "$BACKUP_LOCK"
    tmp=$(mktemp)
    jq '.packageManager = "yarn@4.99.0"' "$APP_DIR/package.json" > "$tmp" && mv "$tmp" "$APP_DIR/package.json"
    # retire le premier bloc d'une dépendance npm « ordinaire » (pas un workspace) : lockfile incomplet.
    awk '
      BEGIN { skipping = 0; done = 0 }
      /^"[^@][^"]*@npm:/ && !done { skipping = 1; done = 1; next }
      skipping && /^$/ { skipping = 0; next }
      !skipping { print }
    ' "$BACKUP_LOCK" > "$APP_DIR/yarn.lock"
    echo "panne injectée : packageManager = yarn@4.99.0 et une entrée retirée de yarn.lock (--reveal, --undo)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
