#!/usr/bin/env bash
# break/plateforme/01-backstage-baseurl.sh — fiche 01 Backstage.
# Usage : ./01-backstage-baseurl.sh            injecte la panne (idempotent)
#         ./01-backstage-baseurl.sh --undo     retire la panne
#         ./01-backstage-baseurl.sh --reveal   explique la panne (ne touche à rien)
# Variables : APP_DIR (défaut $HOME/lab-portal).
set -euo pipefail
APP_DIR="${APP_DIR:-$HOME/lab-portal}"
LOCAL="$APP_DIR/app-config.local.yaml"
BACKUP_DIR="$APP_DIR/.break-01"
BACKUP="$BACKUP_DIR/baseurl.app-config.local.yaml"
MARK="# break/plateforme/01-backstage-baseurl"

reveal() {
  cat <<'TXT'
Panne : app-config.local.yaml (chargé après app-config.yaml, ignoré par Git) remplace backend.baseUrl par
http://localhost:7008 et backend.cors.origin par http://localhost:3001.
Pourquoi ça casse : backend.baseUrl est l'adresse que le NAVIGATEUR utilise pour appeler l'API ; le frontend la reçoit
du backend au chargement. Le backend écoute toujours sur 7007 (backend.listen n'a pas bougé), mais l'UI appelle 7008 :
connexion refusée. Même si tu corriges le port, le CORS refuse l'origine http://localhost:3000.
Symptôme : l'UI se charge (elle est servie par le serveur de développement sur 3000), le catalogue reste vide,
la console du navigateur montre des erreurs réseau puis CORS ; `curl http://localhost:7007/api/catalog/entities`
répond normalement, ce qui prouve que le backend va bien.
Diagnostic : `yarn backstage-cli config:print --frontend` (ce que voit le navigateur), `ls app-config*.yaml`,
`curl -sI -H 'Origin: http://localhost:3000' http://localhost:7007/api/catalog/entities | grep -i access-control`.
Correction : supprimer ou corriger app-config.local.yaml (ou `--undo`) puis relancer `yarn start`.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    if [ ! -f "$LOCAL" ] || ! grep -q "$MARK" "$LOCAL"; then echo "undo: panne absente, rien à faire"; exit 0; fi
    if [ -f "$BACKUP" ]; then mv "$BACKUP" "$LOCAL"; echo "undo: app-config.local.yaml d'origine restauré"
    else rm -f "$LOCAL"; echo "undo: app-config.local.yaml supprimé"; fi
    ;;
  "")
    if [ ! -f "$APP_DIR/app-config.yaml" ]; then echo "pas d'app Backstage dans $APP_DIR (variable APP_DIR)" >&2; exit 1; fi
    if [ -f "$LOCAL" ] && grep -q "$MARK" "$LOCAL"; then echo "panne déjà injectée"; exit 0; fi
    mkdir -p "$BACKUP_DIR"
    [ -f "$LOCAL" ] && cp "$LOCAL" "$BACKUP"
    cat > "$LOCAL" <<YAML
$MARK
backend:
  baseUrl: http://localhost:7008
  cors:
    origin: http://localhost:3001
YAML
    echo "panne injectée : $LOCAL (--reveal pour l'explication, --undo pour réparer ; relance yarn start)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
