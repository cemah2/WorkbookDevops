#!/usr/bin/env bash
# check.sh — fiche securite/01. Vérifie l'état attendu de l'hôte à la fin de la fiche (défi final).
# Un contrôle par ligne : OK / KO. Code de retour 1 si au moins un KO.
# Usage : sudo ./check.sh [--el]   (--el force la variante Enterprise Linux ; détectée sinon)
set -uo pipefail

EL=0
[ "${1:-}" = "--el" ] && EL=1
if [ "$EL" -eq 0 ] && grep -qiE '^ID_LIKE=.*(rhel|fedora)|^ID="?(rocky|almalinux|rhel|centos)' /etc/os-release; then
  EL=1
fi
[ "$(id -u)" -eq 0 ] || { echo "à lancer en root (sudo) : ss -p, sudo -l, aa-status" >&2; exit 1; }

KO=0
ok() { printf '\033[32m[OK]\033[0m %s\n' "$1"; }
ko() { printf '\033[31m[KO]\033[0m %s\n' "$1"; KO=$((KO + 1)); }
check() { # check "libellé" commande...
  local label=$1; shift
  if "$@" >/dev/null 2>&1; then ok "$label"; else ko "$label"; fi
}

# --- Section 1 : surface d'attaque -------------------------------------------------------------
# Ports TCP en écoute autorisés : 22 (sshd), 8080 (demo-app) et le résolveur local (53 sur 127.0.0.53/54).
ports_ok() {
  local bad
  bad=$(ss -Hlnt | awk '{print $4}' | grep -vE ':(22|8080)$' | grep -vE '^127\.0\.0\.5[34]:53$' || true)
  [ -z "$bad" ]
}
check "seuls 22/tcp, 8080/tcp (et le résolveur local) écoutent" ports_ok
check "pas d'écoute UDP hors DNS local (avahi, rpcbind…)" bash -c "! ss -Hlnu | awk '{print \$4}' | grep -vE '^127\.0\.0\.5[34]:53$|:68$|:323$' | grep -q ."
if [ "$EL" -eq 1 ]; then
  check "httpd, vsftpd, rpcbind, avahi retirés ou masqués" bash -c '! rpm -q httpd vsftpd rpcbind avahi 2>/dev/null | grep -vq "not installed"'
else
  check "apache2, vsftpd, rpcbind, avahi-daemon retirés" bash -c '! dpkg -l apache2 vsftpd rpcbind avahi-daemon 2>/dev/null | grep -q "^ii"'
fi
check "module usb-storage non chargé" bash -c '! lsmod | grep -q "^usb_storage"'
check "module usb-storage interdit (install /bin/false)" bash -c 'modprobe -n -v usb-storage 2>/dev/null | grep -q "install /bin/false"'
check "aucun binaire setuid sous /usr/local/bin" bash -c '! find /usr/local/bin -perm -4000 -type f | grep -q .'
if [ "$EL" -eq 1 ]; then
  check "mises à jour automatiques (dnf-automatic.timer) actives" systemctl is-enabled dnf-automatic.timer
else
  check "mises à jour de sécurité automatiques (unattended-upgrades)" bash -c 'apt-config dump 2>/dev/null | grep -q "APT::Periodic::Unattended-Upgrade \"1\""'
fi

# --- Section 2 : comptes et SSH ----------------------------------------------------------------
check "compte deploy verrouillé" bash -c 'passwd -S deploy 2>/dev/null | awk "{print \$2}" | grep -q "^L"'
check "compte deploy sans shell interactif" bash -c 'getent passwd deploy | grep -qE "nologin|/bin/false"'
check "deploy : pas de sudo ALL" bash -c '! sudo -l -U deploy 2>/dev/null | grep -q "(ALL.*) NOPASSWD: ALL"'
check "deploy : sudo limité à systemctl restart demo-app.service" bash -c 'sudo -l -U deploy 2>/dev/null | grep -q "systemctl restart demo-app.service"'
check "compte root verrouillé" bash -c 'passwd -S root | awk "{print \$2}" | grep -q "^L"'
SSHD_T=$(sshd -T 2>/dev/null || true)
check "sshd : PermitRootLogin no" grep -qi '^permitrootlogin no' <<<"$SSHD_T"
check "sshd : PasswordAuthentication no" grep -qi '^passwordauthentication no' <<<"$SSHD_T"
check "sshd : KbdInteractiveAuthentication no" grep -qi '^kbdinteractiveauthentication no' <<<"$SSHD_T"
check "sshd : AllowGroups contient ops" grep -qiE '^allowgroups .*\bops\b' <<<"$SSHD_T"
check "sshd : MaxAuthTries <= 3" bash -c "grep -i '^maxauthtries' <<<\"\$0\" | awk '\$2 <= 3 {f=1} END {exit !f}'" "$SSHD_T"
check "groupe ops existe et contient au moins un humain" bash -c 'getent group ops | cut -d: -f4 | grep -q .'

# --- Section 3 : réseau ------------------------------------------------------------------------
if [ "$EL" -eq 1 ]; then
  check "firewalld actif" systemctl is-active firewalld
  check "firewalld : ssh autorisé" bash -c 'firewall-cmd --list-services | grep -qw ssh'
  check "firewalld : 8080/tcp limité à 10.10.10.0/24 (rich rule)" bash -c 'firewall-cmd --list-rich-rules | grep -q "10.10.10.0/24.*port=\"8080\""'
  check "firewalld : http/ftp non autorisés" bash -c '! firewall-cmd --list-services | grep -qwE "http|ftp"'
else
  check "ufw actif" bash -c 'ufw status | grep -q "^Status: active"'
  check "ufw : deny incoming par défaut" bash -c 'ufw status verbose | grep -q "Default: deny (incoming)"'
  check "ufw : 22/tcp autorisé (ou limité)" bash -c 'ufw status | grep -E "^22/tcp" | grep -qE "ALLOW|LIMIT"'
  check "ufw : 8080/tcp autorisé depuis 10.10.10.0/24 seulement" bash -c 'ufw status | grep -E "^8080/tcp" | grep -q "10.10.10.0/24" && ! ufw status | grep -E "^8080/tcp" | grep -q "Anywhere"'
  check "ufw : journalisation activée" bash -c 'ufw status verbose | grep -qE "^Logging: on"'
fi
check "sysctl kernel.dmesg_restrict = 1" bash -c '[ "$(sysctl -n kernel.dmesg_restrict)" = 1 ]'
check "sysctl kernel.kptr_restrict >= 1" bash -c '[ "$(sysctl -n kernel.kptr_restrict)" -ge 1 ]'
check "sysctl fs.protected_regular >= 1" bash -c '[ "$(sysctl -n fs.protected_regular)" -ge 1 ]'
check "sysctl persistant (/etc/sysctl.d/90-hardening.conf)" test -s /etc/sysctl.d/90-hardening.conf

# --- Section 4 : confinement -------------------------------------------------------------------
if [ "$EL" -eq 1 ]; then
  check "SELinux en enforcing" bash -c '[ "$(getenforce)" = Enforcing ]'
  check "SELinux enforcing persistant" grep -q '^SELINUX=enforcing' /etc/selinux/config
else
  check "AppArmor : profil /usr/local/bin/lecteur en enforce" bash -c 'aa-status --json 2>/dev/null | jq -e ".profiles[\"/usr/local/bin/lecteur\"] == \"enforce\"" >/dev/null || aa-status 2>/dev/null | grep -A200 "profiles are in enforce mode" | grep -q "^ */usr/local/bin/lecteur$"'
fi
check "lecteur.service actif" systemctl is-active lecteur.service
check "lecteur.service : NoNewPrivileges=yes" bash -c '[ "$(systemctl show -p NoNewPrivileges --value lecteur.service)" = yes ]'
check "lecteur.service : ProtectSystem=strict" bash -c '[ "$(systemctl show -p ProtectSystem --value lecteur.service)" = strict ]'
check "lecteur.service : SystemCallFilter défini" bash -c 'systemctl show -p SystemCallFilter --value lecteur.service | grep -q "@system-service"'
score_ok() {
  local score
  score=$(systemd-analyze security --no-pager lecteur.service 2>/dev/null | grep -oE 'exposure level for lecteur.service: [0-9.]+' | grep -oE '[0-9.]+$')
  [ -n "$score" ] && awk -v s="$score" 'BEGIN {exit !(s < 5.0)}'
}
check "lecteur.service : score systemd-analyze security < 5.0" score_ok

echo
if [ "$KO" -eq 0 ]; then echo "tout est vert : hôte conforme à la fiche securite/01"; exit 0; fi
echo "$KO contrôle(s) en échec"; exit 1
