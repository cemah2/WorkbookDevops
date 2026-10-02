#!/usr/bin/env bash
# break/securite/01-hote-module-noyau.sh — fiche 01 Durcir un hôte Linux (section 1, optionnel).
# Retire l'interdiction du module usb-storage et le charge.
# Usage : sudo ./01-hote-module-noyau.sh [--undo|--reveal]
set -euo pipefail
STATE=/var/lib/break-securite/01-module-noyau
BLACKLIST=/etc/modprobe.d/blacklist-lab.conf

reveal() {
  cat <<TXT
Panne : $BLACKLIST a été déplacé (sauvegardé sous $STATE.conf) et usb-storage chargé à la main.
Symptôme : lsmod | grep usb_storage rend une ligne ; modprobe -n -v usb-storage ne rend plus « install /bin/false ».
Diagnostic : lsmod ; ls /etc/modprobe.d/ ; modprobe -n -v usb-storage.
Correction : rmmod usb-storage ; remettre le fichier de blacklist ; ou --undo.
TXT
}

[ "${1:-}" = "--reveal" ] && { reveal; exit 0; }
[ "$(id -u)" -eq 0 ] || { echo "à lancer en root (sudo)" >&2; exit 1; }

case "${1:-}" in
  --undo)
    if [ ! -f "$STATE" ]; then echo "undo: panne non injectée, rien à faire"; exit 0; fi
    [ -f "$STATE.conf" ] && mv "$STATE.conf" "$BLACKLIST"
    rmmod usb-storage 2>/dev/null || true
    rm -f "$STATE"
    echo "undo: blacklist restaurée, module déchargé"
    ;;
  "")
    if [ -f "$STATE" ]; then echo "panne déjà injectée"; exit 0; fi
    mkdir -p "$(dirname "$STATE")"
    [ -f "$BLACKLIST" ] && mv "$BLACKLIST" "$STATE.conf"
    modprobe usb-storage 2>/dev/null || echo "modprobe usb-storage impossible ici (module absent du noyau ?)" >&2
    touch "$STATE"
    echo "panne injectée : usb-storage chargé, blacklist retirée (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
