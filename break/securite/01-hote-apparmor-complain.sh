#!/usr/bin/env bash
# break/securite/01-hote-apparmor-complain.sh — fiche 01 Durcir un hôte Linux (section 4).
# Desserre le confinement du service lecteur : profil AppArmor repassé en complain (SELinux en permissive sur EL),
# drop-in de durcissement mis de côté et remplacé par un drop-in « dépannage » qui relance le service en root.
# Usage : sudo ./01-hote-apparmor-complain.sh [--undo|--reveal]
set -euo pipefail
STATE=/var/lib/break-securite/01-apparmor-complain
PROFILE=/etc/apparmor.d/usr.local.bin.lecteur
DROPIN=/etc/systemd/system/lecteur.service.d/99-break.conf
HARDENING=/etc/systemd/system/lecteur.service.d/hardening.conf

reveal() {
  cat <<TXT
Panne : deux desserrages.
  1. Le profil AppArmor $PROFILE est passé en mode complain (ou SELinux en permissive sur EL) :
     les accès interdits sont journalisés mais plus bloqués ; sudo lecteur /etc/shadow (en root) fonctionne.
  2. Le drop-in $HARDENING a été mis de côté (sauvegardé sous $STATE.hardening) et remplacé par
     $DROPIN qui remet User=root : « pour corriger un problème de droits ». Le service tourne en root, sans
     aucune des protections ; systemd-analyze security lecteur.service remonte au niveau UNSAFE.
Symptôme : aa-status montre lecteur en complain ; systemctl cat lecteur.service affiche 99-break.conf et plus
hardening.conf ; ps -o user= -C lecteur rend root.
Diagnostic : aa-status ; journalctl -k | grep apparmor ; systemctl cat lecteur ; systemd-analyze security lecteur.
Correction : aa-enforce $PROFILE ; rm $DROPIN ; remettre hardening.conf (copie dans le dossier de la fiche) ;
systemctl daemon-reload ; systemctl restart lecteur ; ou --undo.
TXT
}

[ "${1:-}" = "--reveal" ] && { reveal; exit 0; }
[ "$(id -u)" -eq 0 ] || { echo "à lancer en root (sudo)" >&2; exit 1; }
has_systemd() { [ -d /run/systemd/system ]; }
aa_available() { [ -d /sys/kernel/security/apparmor ] && command -v apparmor_parser >/dev/null; }
EL=0
grep -qiE '^ID_LIKE=.*(rhel|fedora)|^ID="?(rocky|almalinux|rhel|centos)' /etc/os-release && EL=1

case "${1:-}" in
  --undo)
    if [ ! -f "$STATE" ]; then echo "undo: panne non injectée, rien à faire"; exit 0; fi
    if [ "$EL" -eq 1 ]; then
      [ -f "$STATE.selinux" ] && setenforce 1 2>/dev/null || true
    elif aa_available && [ -f "$PROFILE" ]; then
      apparmor_parser -r "$PROFILE"
    fi
    rm -f "$DROPIN"
    [ -f "$STATE.hardening" ] && mv "$STATE.hardening" "$HARDENING"
    if has_systemd; then systemctl daemon-reload; systemctl restart lecteur.service 2>/dev/null || true; fi
    rm -f "$STATE" "$STATE.selinux"
    echo "undo: confinement rétabli (profil en enforce, drop-in retiré)"
    ;;
  "")
    if [ -f "$STATE" ]; then echo "panne déjà injectée"; exit 0; fi
    mkdir -p "$(dirname "$STATE")" "$(dirname "$DROPIN")"
    if [ "$EL" -eq 1 ]; then
      if getenforce 2>/dev/null | grep -q Enforcing; then setenforce 0; touch "$STATE.selinux"; fi
    elif aa_available && [ -f "$PROFILE" ]; then
      apparmor_parser -r -C "$PROFILE"
    else
      echo "AppArmor indisponible ou profil absent : seul le drop-in systemd est injecté" >&2
    fi
    [ -f "$HARDENING" ] && mv "$HARDENING" "$STATE.hardening"
    cat > "$DROPIN" <<'EOF'
# dépannage rapide : le service n'arrivait plus à lire ses fichiers, relancé en root (à nettoyer)
[Service]
User=root
Group=root
EOF
    if has_systemd; then systemctl daemon-reload; systemctl restart lecteur.service 2>/dev/null || true; fi
    touch "$STATE"
    echo "panne injectée : confinement desserré (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
