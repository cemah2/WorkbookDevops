#!/usr/bin/env bash
# break/securite/01-hote-pare-feu-ouvert.sh — fiche 01 Durcir un hôte Linux (section 3).
# Coupe le pare-feu de l'hôte (ufw sur Ubuntu/Debian, firewalld sur Enterprise Linux) : tout ce qui écoute
# redevient joignable depuis n'importe quelle source.
# Usage : sudo ./01-hote-pare-feu-ouvert.sh [--undo|--reveal]
set -euo pipefail
STATE=/var/lib/break-securite/01-pare-feu-ouvert

reveal() {
  cat <<'TXT'
Panne : le pare-feu a été désactivé (ufw disable, ou systemctl disable --now firewalld sur EL).
Symptôme : depuis lx02, nc -zv lx01 8080 réussit quelle que soit la source ; ufw status rend « inactive »
(firewall-cmd --state rend « not running » sur EL) ; nft list ruleset ne montre plus la table ufw.
Diagnostic : ufw status verbose ; nft list ruleset ; journalctl -u ufw (ou -u firewalld).
Correction : ufw enable (les règles sont conservées dans /etc/ufw/user.rules) ; systemctl enable --now firewalld
sur EL ; ou --undo.
TXT
}

[ "${1:-}" = "--reveal" ] && { reveal; exit 0; }
[ "$(id -u)" -eq 0 ] || { echo "à lancer en root (sudo)" >&2; exit 1; }
has_systemd() { [ -d /run/systemd/system ]; }
EL=0
grep -qiE '^ID_LIKE=.*(rhel|fedora)|^ID="?(rocky|almalinux|rhel|centos)' /etc/os-release && EL=1

case "${1:-}" in
  --undo)
    if [ ! -f "$STATE" ]; then echo "undo: panne non injectée, rien à faire"; exit 0; fi
    if [ "$EL" -eq 1 ]; then
      has_systemd && systemctl enable --now firewalld
    else
      ufw --force enable >/dev/null
    fi
    rm -f "$STATE"
    echo "undo: pare-feu réactivé avec ses règles"
    ;;
  "")
    if [ -f "$STATE" ]; then echo "panne déjà injectée"; exit 0; fi
    mkdir -p "$(dirname "$STATE")"
    if [ "$EL" -eq 1 ]; then
      has_systemd && systemctl disable --now firewalld
    else
      command -v ufw >/dev/null || { echo "ufw absent : rien à couper" >&2; exit 1; }
      ufw --force disable >/dev/null
    fi
    touch "$STATE"
    echo "panne injectée : pare-feu coupé (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
