#!/bin/bash
# lecteur — service d'exemple de la fiche securite/01, installé en /usr/local/bin/lecteur.
# Compte les lignes des fichiers .txt de /var/lib/lecteur (LECTEUR_DIR). C'est tout ce qu'il a le droit de faire.
# Usage : lecteur            → un passage, puis sortie
#         lecteur --daemon   → un passage toutes les 60 s (unité systemd)
#         lecteur <fichier>  → affiche ce fichier (sert à tester le confinement : lecteur /etc/shadow)
set -u
DIR="${LECTEUR_DIR:-/var/lib/lecteur}"

passage() {
  local total=0 n
  for f in "$DIR"/*.txt; do
    [ -r "$f" ] || { echo "lecteur: $f illisible" >&2; continue; }
    n=$(wc -l < "$f")
    echo "$(basename "$f"): $n ligne(s)"
    total=$((total + n))
  done
  echo "total: $total ligne(s)"
}

case "${1:-}" in
  --daemon)
    while true; do passage; sleep 60; done
    ;;
  "")
    passage
    ;;
  *)
    cat "$1"
    ;;
esac
