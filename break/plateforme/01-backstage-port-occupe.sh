#!/usr/bin/env bash
# break/plateforme/01-backstage-port-occupe.sh — fiche 01 Backstage.
# Usage : ./01-backstage-port-occupe.sh            injecte la panne (idempotent)
#         ./01-backstage-port-occupe.sh --undo     retire la panne
#         ./01-backstage-port-occupe.sh --reveal   explique la panne (ne touche à rien)
# Variables : PORT (défaut 7007), APP_DIR (défaut $HOME/lab-portal, pour le fichier de pid).
set -euo pipefail
PORT="${PORT:-7007}"
APP_DIR="${APP_DIR:-$HOME/lab-portal}"
PIDFILE="$APP_DIR/.break-01/port-occupe.pid"

reveal() {
  cat <<'TXT'
Panne : un autre processus (python3 -m http.server) écoute déjà sur le port 7007, celui du backend Backstage.
Pourquoi ça casse : backend.listen.port vaut 7007 ; au démarrage, Node tente de s'y lier et reçoit EADDRINUSE.
Le backend s'arrête, le serveur de développement du frontend continue : l'UI se charge mais aucune API ne répond.
Symptôme : dans la sortie de `yarn start`, « backstage error Unhandled rejection listen EADDRINUSE: address already in use 0.0.0.0:7007 » ;
`curl http://localhost:7007/api/catalog/entities` renvoie une page HTML de listing de répertoire, pas du JSON.
Diagnostic : `ss -ltnp | grep 7007` donne le pid et le programme ; `curl -s localhost:7007 | head` montre qui répond.
Correction : arrêter le processus intrus (`--undo`), ou changer backend.listen.port ET backend.baseUrl ensemble.
TXT
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    if [ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null; then echo "undo: processus intrus arrêté"; else echo "undo: rien à arrêter"; fi
    rm -f "$PIDFILE"
    ;;
  "")
    if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then echo "panne déjà injectée (pid $(cat "$PIDFILE"))"; exit 0; fi
    if command -v ss >/dev/null && ss -ltn | awk '{print $4}' | grep -q ":$PORT\$"; then
      echo "le port $PORT est déjà occupé (backend lancé ? arrête-le d'abord)"; exit 0
    fi
    mkdir -p "$(dirname "$PIDFILE")"
    nohup python3 -m http.server "$PORT" --bind 0.0.0.0 --directory /tmp >/dev/null 2>&1 &
    echo $! > "$PIDFILE"
    sleep 1
    echo "panne injectée : port $PORT occupé par le pid $(cat "$PIDFILE") (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
