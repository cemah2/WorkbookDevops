#!/usr/bin/env bash
# break/securite/01-hote-service-fantome.sh — fiche 01 Durcir un hôte Linux (section 1).
# Installe et active une unité systemd « de maintenance » qui sert la racine du disque en HTTP, en root, à tout le monde.
# Usage : sudo ./01-hote-service-fantome.sh [--undo|--reveal]
set -euo pipefail
STATE=/var/lib/break-securite/01-service-fantome
UNIT=/etc/systemd/system/maintenance-http.service
PORT="${PORT:-8000}"

reveal() {
  cat <<TXT
Panne : une unité systemd maintenance-http.service a été ajoutée et activée au démarrage. Elle lance
python3 -m http.server $PORT --directory / en root : tout le système de fichiers est lisible depuis le réseau,
y compris /etc/shadow.
Symptôme : ss -lntp montre un port $PORT inconnu tenu par python3 ; curl http://<hôte>:$PORT/etc/hostname répond.
Diagnostic : ss -lntp, puis systemctl status \$(ss -lntp | grep ":$PORT " | grep -oE 'pid=[0-9]+' | cut -d= -f2 | xargs -I{} ps -o unit= -p {}),
ou plus simple : systemctl list-units --type=service --state=running et lire ce qui n'a rien à faire là.
Correction : systemctl disable --now maintenance-http.service ; rm $UNIT ; systemctl daemon-reload ; ou --undo.
TXT
}

[ "${1:-}" = "--reveal" ] && { reveal; exit 0; }
[ "$(id -u)" -eq 0 ] || { echo "à lancer en root (sudo)" >&2; exit 1; }
has_systemd() { [ -d /run/systemd/system ]; }

case "${1:-}" in
  --undo)
    if [ ! -f "$STATE" ]; then echo "undo: panne non injectée, rien à faire"; exit 0; fi
    has_systemd && systemctl disable --now maintenance-http.service 2>/dev/null || true
    rm -f "$UNIT"
    has_systemd && systemctl daemon-reload
    rm -f "$STATE"
    echo "undo: maintenance-http.service retiré"
    ;;
  "")
    if [ -f "$STATE" ]; then echo "panne déjà injectée"; exit 0; fi
    mkdir -p "$(dirname "$STATE")"
    cat > "$UNIT" <<EOF
[Unit]
Description=Maintenance HTTP (laissé par l'intégrateur)
After=network.target

[Service]
ExecStart=/usr/bin/python3 -m http.server $PORT --directory /
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    if has_systemd; then
      systemctl daemon-reload
      systemctl enable --now maintenance-http.service
    else
      echo "systemd absent : unité écrite mais non démarrée"
    fi
    touch "$STATE"
    echo "panne injectée : un service inconnu écoute (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
