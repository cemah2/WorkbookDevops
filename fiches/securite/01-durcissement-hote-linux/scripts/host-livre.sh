#!/usr/bin/env bash
# host-livre.sh — fiche securite/01. Transforme une VM fraîche en hôte « livré par un intégrateur » :
# services inutiles, compte deploy avec mot de passe et sudo total, root SSH par mot de passe, pare-feu coupé,
# module usb-storage chargé, binaire setuid oublié, service lecteur non confiné (profil AppArmor en complain),
# service demo-app exposé, sysctl relâchés, mises à jour automatiques coupées.
# Usage : sudo ./host-livre.sh [--undo|--el]   (--el force la variante Enterprise Linux ; détectée sinon)
# Idempotent : marqueur /var/lib/host-livre/state. --undo remet la VM dans l'état d'origine.
set -euo pipefail

STATE_DIR=/var/lib/host-livre
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
EL=0
MODE=inject

for arg in "$@"; do
  case "$arg" in
    --undo) MODE=undo ;;
    --el) EL=1 ;;
    *) echo "usage: $0 [--undo|--el]" >&2; exit 2 ;;
  esac
done

[ "$(id -u)" -eq 0 ] || { echo "à lancer en root (sudo)" >&2; exit 1; }

# Détection de la famille de distribution (Ubuntu/Debian = AppArmor + ufw ; EL = SELinux + firewalld).
if [ "$EL" -eq 0 ] && grep -qiE '^ID_LIKE=.*(rhel|fedora)|^ID="?(rocky|almalinux|rhel|centos)' /etc/os-release; then
  EL=1
fi

has_systemd() { [ -d /run/systemd/system ]; }
svc() { has_systemd && systemctl "$@" || echo "systemd absent : systemctl $* ignoré"; }

PKGS_DEB="apache2 vsftpd rpcbind avahi-daemon"
PKGS_EL="httpd vsftpd rpcbind avahi"

install_pkgs() {
  if [ "$EL" -eq 1 ]; then
    # shellcheck disable=SC2086
    dnf -y -q install $PKGS_EL
    for s in httpd vsftpd rpcbind avahi-daemon; do svc enable --now "$s" || true; done
  else
    export DEBIAN_FRONTEND=noninteractive
    # shellcheck disable=SC2086
    apt-get -y -qq install $PKGS_DEB >/dev/null
    for s in apache2 vsftpd rpcbind avahi-daemon; do svc enable --now "$s" || true; done
  fi
}

remove_pkgs() {
  if [ "$EL" -eq 1 ]; then
    # shellcheck disable=SC2086
    dnf -y -q remove $PKGS_EL || true
  else
    export DEBIAN_FRONTEND=noninteractive
    # shellcheck disable=SC2086
    apt-get -y -qq purge $PKGS_DEB >/dev/null || true
    apt-get -y -qq autoremove >/dev/null || true
  fi
}

inject() {
  if [ -f "$STATE_DIR/state" ]; then
    echo "hôte déjà « livré » ($STATE_DIR/state présent) ; --undo pour revenir en arrière"; exit 0
  fi
  mkdir -p "$STATE_DIR"

  echo "[1/8] paquets et services inutiles"
  install_pkgs

  echo "[2/8] compte deploy : mot de passe, shell, sudo total"
  id deploy >/dev/null 2>&1 || useradd -m -s /bin/bash deploy
  echo 'deploy:deploy' | chpasswd
  passwd -u deploy >/dev/null 2>&1 || true
  install -m 0440 /dev/stdin /etc/sudoers.d/90-deploy <<'EOF'
deploy ALL=(ALL) NOPASSWD: ALL
EOF

  echo "[3/8] sshd : root et mots de passe autorisés"
  # Le mot de passe root n'existe pas sur une image cloud : on le pose pour rendre la faille réelle.
  if passwd -S root | awk '{print $2}' | grep -q '^L'; then touch "$STATE_DIR/root-was-locked"; fi
  echo 'root:livre' | chpasswd
  mkdir -p /etc/ssh/sshd_config.d
  cat > /etc/ssh/sshd_config.d/99-livre.conf <<'EOF'
PermitRootLogin yes
PasswordAuthentication yes
KbdInteractiveAuthentication yes
EOF
  rm -f /etc/ssh/sshd_config.d/00-hardening.conf
  svc restart sshd 2>/dev/null || svc restart ssh || true

  echo "[4/8] pare-feu coupé"
  if [ "$EL" -eq 1 ]; then
    svc disable --now firewalld || true
  else
    command -v ufw >/dev/null && ufw --force disable >/dev/null || true
    rm -f /etc/ufw/user.rules.livre
  fi

  echo "[5/8] module usb-storage chargé, binaire setuid oublié"
  rm -f /etc/modprobe.d/blacklist-lab.conf
  modprobe usb-storage 2>/dev/null || true
  cp /bin/bash /usr/local/bin/bash-suid && chmod 4755 /usr/local/bin/bash-suid

  echo "[6/8] services lecteur (non confiné) et demo-app (exposé)"
  id lecteur >/dev/null 2>&1 || useradd -r -s /usr/sbin/nologin -d /var/lib/lecteur lecteur
  id app >/dev/null 2>&1 || useradd -r -s /usr/sbin/nologin -d /var/lib/demo-app app
  install -d -o lecteur -g lecteur -m 0750 /var/lib/lecteur
  printf 'ligne 1\nligne 2\nligne 3\n' > /var/lib/lecteur/inventaire.txt
  printf 'a\nb\n' > /var/lib/lecteur/journal.txt
  chown lecteur:lecteur /var/lib/lecteur/*.txt
  install -d -o app -g app -m 0755 /var/lib/demo-app
  echo '<h1>demo-app</h1>' > /var/lib/demo-app/index.html
  install -m 0755 "$HERE/scripts/lecteur.sh" /usr/local/bin/lecteur
  install -m 0644 "$HERE/systemd/lecteur.service" /etc/systemd/system/lecteur.service
  install -m 0644 "$HERE/systemd/demo-app.service" /etc/systemd/system/demo-app.service
  rm -rf /etc/systemd/system/lecteur.service.d
  if [ "$EL" -eq 0 ]; then
    install -m 0644 "$HERE/apparmor/usr.local.bin.lecteur" /etc/apparmor.d/usr.local.bin.lecteur
    # Profil chargé en mode complain : il journalise, il n'interdit rien.
    if command -v apparmor_parser >/dev/null && [ -d /sys/kernel/security/apparmor ]; then
      apparmor_parser -r -C /etc/apparmor.d/usr.local.bin.lecteur || true
    fi
  fi
  svc daemon-reload
  svc enable --now lecteur.service || true
  svc enable --now demo-app.service || true

  echo "[7/8] sysctl relâchés"
  cat > /etc/sysctl.d/90-livre.conf <<'EOF'
kernel.dmesg_restrict = 0
kernel.kptr_restrict = 0
fs.protected_regular = 0
EOF
  sysctl -q --system >/dev/null 2>&1 || true
  rm -f /etc/sysctl.d/90-hardening.conf

  echo "[8/8] mises à jour automatiques coupées"
  if [ "$EL" -eq 1 ]; then
    svc disable --now dnf-automatic.timer 2>/dev/null || true
    if getenforce 2>/dev/null | grep -q Enforcing; then touch "$STATE_DIR/selinux-was-enforcing"; fi
    setenforce 0 2>/dev/null || true
    sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config 2>/dev/null || true
  else
    cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
EOF
  fi

  date -Is > "$STATE_DIR/state"
  echo "hôte « livré » prêt. Lance scripts/check.sh pour voir l'étendue des dégâts."
}

undo() {
  if [ ! -f "$STATE_DIR/state" ]; then echo "rien à défaire ($STATE_DIR/state absent)"; exit 0; fi
  echo "[1/6] paquets"; remove_pkgs
  echo "[2/6] comptes"
  rm -f /etc/sudoers.d/90-deploy /etc/sudoers.d/deploy
  id deploy >/dev/null 2>&1 && userdel -r deploy 2>/dev/null || true
  if [ -f "$STATE_DIR/root-was-locked" ]; then passwd -l root >/dev/null; fi
  echo "[3/6] sshd"
  rm -f /etc/ssh/sshd_config.d/99-livre.conf /etc/ssh/sshd_config.d/00-hardening.conf
  svc restart sshd 2>/dev/null || svc restart ssh || true
  echo "[4/6] pare-feu, modules, setuid, sysctl"
  if [ "$EL" -eq 1 ]; then svc enable --now firewalld || true; else command -v ufw >/dev/null && ufw --force disable >/dev/null || true; fi
  rm -f /etc/modprobe.d/blacklist-lab.conf /usr/local/bin/bash-suid /etc/sysctl.d/90-livre.conf /etc/sysctl.d/90-hardening.conf
  rmmod usb-storage 2>/dev/null || true
  sysctl -q --system >/dev/null 2>&1 || true
  echo "[5/6] services lecteur et demo-app"
  for s in lecteur demo-app; do svc disable --now "$s.service" 2>/dev/null || true; done
  rm -rf /etc/systemd/system/lecteur.service /etc/systemd/system/lecteur.service.d /etc/systemd/system/demo-app.service
  svc daemon-reload
  if [ "$EL" -eq 0 ] && [ -f /etc/apparmor.d/usr.local.bin.lecteur ]; then
    [ -d /sys/kernel/security/apparmor ] && apparmor_parser -R /etc/apparmor.d/usr.local.bin.lecteur 2>/dev/null || true
    rm -f /etc/apparmor.d/usr.local.bin.lecteur
  fi
  rm -f /usr/local/bin/lecteur
  rm -rf /var/lib/lecteur /var/lib/demo-app
  for u in lecteur app; do id "$u" >/dev/null 2>&1 && userdel "$u" 2>/dev/null || true; done
  echo "[6/6] mises à jour automatiques"
  if [ "$EL" -eq 1 ]; then
    if [ -f "$STATE_DIR/selinux-was-enforcing" ]; then
      sed -i 's/^SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config 2>/dev/null || true
      setenforce 1 2>/dev/null || true
    fi
  else
    cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
  fi
  rm -rf "$STATE_DIR"
  echo "VM remise dans l'état d'origine."
}

case "$MODE" in
  inject) inject ;;
  undo) undo ;;
esac
