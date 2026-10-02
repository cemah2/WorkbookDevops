#!/usr/bin/env bash
# break/securite/01-hote-sudo-ouvert.sh — fiche 01 Durcir un hôte Linux (section 2).
# Rouvre les accès : deploy reçoit sudo ALL sans mot de passe et un mot de passe connu, root peut se connecter
# en SSH par mot de passe. Le drop-in sshd est nommé pour passer AVANT 00-hardening.conf.
# Usage : sudo ./01-hote-sudo-ouvert.sh [--undo|--reveal]
set -euo pipefail
STATE=/var/lib/break-securite/01-sudo-ouvert
SUDOERS=/etc/sudoers.d/00-break-deploy
SSHD_DROPIN=/etc/ssh/sshd_config.d/00-break.conf

reveal() {
  cat <<TXT
Panne : trois choses ont été rouvertes.
  1. $SUDOERS donne « deploy ALL=(ALL) NOPASSWD: ALL » : deploy est root sans le dire.
  2. deploy a de nouveau un mot de passe (deploy) et son compte est déverrouillé.
  3. $SSHD_DROPIN remet PermitRootLogin yes et PasswordAuthentication yes ; comme il est trié avant
     00-hardening.conf, c'est lui qui gagne (première valeur rencontrée).
Symptôme : sudo -l -U deploy rend (ALL) NOPASSWD: ALL ; sshd -T | grep -i passwordauthentication rend yes ;
depuis lx02, ssh deploy@lx01 accepte un mot de passe.
Diagnostic : ls -l /etc/sudoers.d/ ; ls /etc/ssh/sshd_config.d/ ; sshd -T.
Correction : supprimer les deux fichiers, passwd -l deploy, systemctl restart ssh ; ou --undo.
TXT
}

[ "${1:-}" = "--reveal" ] && { reveal; exit 0; }
[ "$(id -u)" -eq 0 ] || { echo "à lancer en root (sudo)" >&2; exit 1; }
has_systemd() { [ -d /run/systemd/system ]; }
restart_ssh() { has_systemd && { systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null || true; }; }

case "${1:-}" in
  --undo)
    if [ ! -f "$STATE" ]; then echo "undo: panne non injectée, rien à faire"; exit 0; fi
    rm -f "$SUDOERS" "$SSHD_DROPIN"
    id deploy >/dev/null 2>&1 && passwd -l deploy >/dev/null
    restart_ssh
    rm -f "$STATE"
    echo "undo: sudo et sshd refermés, deploy verrouillé"
    ;;
  "")
    if [ -f "$STATE" ]; then echo "panne déjà injectée"; exit 0; fi
    mkdir -p "$(dirname "$STATE")" /etc/ssh/sshd_config.d
    id deploy >/dev/null 2>&1 || useradd -m -s /bin/bash deploy
    echo 'deploy:deploy' | chpasswd
    passwd -u deploy >/dev/null 2>&1 || true
    install -m 0440 /dev/stdin "$SUDOERS" <<'EOF'
deploy ALL=(ALL) NOPASSWD: ALL
EOF
    cat > "$SSHD_DROPIN" <<'EOF'
PermitRootLogin yes
PasswordAuthentication yes
KbdInteractiveAuthentication yes
EOF
    restart_ssh
    touch "$STATE"
    echo "panne injectée : accès rouverts (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
