# Solutions — 01 Durcir un hôte Linux : surface d'attaque, comptes, réseau, AppArmor et seccomp

Trois indices progressifs par exercice, puis la correction commentée. Lis un indice, retourne manipuler, reviens si besoin.
Les commandes qui touchent un système vivant sont marquées `[non testé : pas de VM ni de systemd dans la session de rédaction]`
sauf mention contraire ; les fichiers de configuration ont été validés par leurs outils (`sshd -T`, `visudo -cf`,
`apparmor_parser`, `systemd-analyze verify` et `security --offline`).

## Section 1 — Exercice autonome

### Indices

1. Un service `running` n'est pas forcément `enabled`, et l'inverse. Croise les deux listes ; ce qui est `enabled` revient
   au redémarrage même si tu l'as arrêté.
2. `snapd` tire trois unités (`snapd.service`, `snapd.socket`, `snapd.seeded.service`) ; on ne les arrête pas, on purge
   le paquet. `multipathd`, `ModemManager` et `udisks2` se masquent.
3. Pour vérifier qu'il ne reste rien, ne lis pas `systemctl`, lis `ss -lntup` : c'est le réseau qui compte.

### Correction commentée

Tableau garde / retire (exemple, les paquets varient d'une image à l'autre) :

| Unité | Décision | Raison |
|---|---|---|
| `ssh` | garde | seul accès à la machine |
| `systemd-resolved`, `systemd-networkd`, `systemd-timesyncd` | garde | résolution, réseau, heure |
| `cron`, `rsyslog`, `unattended-upgrades` | garde | tâches, journaux, mises à jour |
| `demo-app`, `lecteur` | garde | ce sont nos services, à confiner (section 4) |
| `snapd*` | retire (purge) | aucun snap sur un serveur de lab |
| `multipathd`, `ModemManager`, `udisks2` | retire (mask) | matériel absent d'une VM |
| `rpcbind`, `avahi-daemon` | retiré en démo | NFS v3 et mDNS inutiles |

```bash
sudo apt-get purge -y snapd
sudo systemctl disable --now multipathd.socket multipathd.service ModemManager.service udisks2.service
sudo systemctl mask multipathd.socket multipathd.service ModemManager.service udisks2.service
sudo ss -lntup
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Sortie attendue de `ss`, trois lignes TCP et le résolveur :

```text
Netid State  Recv-Q Send-Q Local Address:Port  Peer Address:Port Process
udp   UNCONN 0      0         127.0.0.54:53         0.0.0.0:*     users:(("systemd-resolve",…))
udp   UNCONN 0      0      127.0.0.53%lo:53         0.0.0.0:*     users:(("systemd-resolve",…))
tcp   LISTEN 0      4096      127.0.0.54:53         0.0.0.0:*     users:(("systemd-resolve",…))
tcp   LISTEN 0      4096   127.0.0.53%lo:53         0.0.0.0:*     users:(("systemd-resolve",…))
tcp   LISTEN 0      4096         0.0.0.0:22         0.0.0.0:*     users:(("sshd",…))
tcp   LISTEN 0      5            0.0.0.0:8080       0.0.0.0:*     users:(("python3",…))
tcp   LISTEN 0      4096            [::]:22            [::]:*     users:(("sshd",…))
```

Pourquoi masquer plutôt que désactiver : `disable` retire le lien de démarrage, `mask` remplace l'unité par `/dev/null`,
donc même une dépendance (`Wants=`) ou un `systemctl start` à la main échoue. Pour un service dont on sait qu'il ne doit
jamais tourner, c'est `mask`.

Le `setuid` : `find / -xdev -perm -4000 -type f` liste une quinzaine de binaires légitimes (`sudo`, `su`, `passwd`,
`chsh`, `mount`, `umount`, `fusermount3`, `pkexec`…). Tout ce qui est sous `/usr/local`, `/opt`, `/home` ou `/tmp` est
suspect par construction. `check.sh` ne regarde que `/usr/local/bin` ; sur un vrai audit, compare la liste à celle d'une
image neuve.

## Section 2 — Exercice autonome

### Indices

1. Deux commandes suffisent pour un compte : une pour le mot de passe (`passwd -l`), une pour le shell (`usermod -s`).
   `passwd -S deploy` montre `L` quand c'est fait.
2. Une règle `sudo` se lit « qui, sur quelle machine, en tant que qui, peut lancer quoi ». Le « quoi » est un chemin
   absolu avec ses arguments exacts : `/usr/bin/systemctl restart demo-app.service`. Sans arguments, c'est tout `systemctl`.
3. `visudo -cf <fichier>` valide sans installer ; `install -m 0440` pose le bon mode (sudo ignore un fichier trop ouvert
   et le dit dans le journal).

### Correction commentée

```bash
sudo passwd -l deploy
sudo usermod -s /usr/sbin/nologin deploy
sudo passwd -S deploy                          # deploy L …
sudo rm -f /etc/sudoers.d/90-deploy
sudo install -m 0440 etc/sudoers.d/deploy /etc/sudoers.d/deploy
sudo visudo -cf /etc/sudoers.d/deploy          # parsed OK
sudo -l -U deploy
```

Le fichier `etc/sudoers.d/deploy` a été validé sur le conteneur (exécuté) :

```text
etc/sudoers.d/deploy: parsed OK
```

Son contenu :

```text
Cmnd_Alias DEMO_APP = /usr/bin/systemctl restart demo-app.service, /usr/bin/systemctl status demo-app.service
deploy ALL=(root) NOPASSWD: DEMO_APP
```

Preuve `[non testé : pas de VM ni de systemd dans la session de rédaction]` :

```bash
sudo -u deploy sudo -n /usr/bin/systemctl restart demo-app.service && echo "autorisé"
sudo -u deploy sudo -n /usr/bin/systemctl restart ssh ; echo "code $?"   # attendu : refus, code 1
```

Points qui font échouer l'exercice : un alias de commande sans chemin absolu (`systemctl` seul est refusé par `visudo`),
`(ALL)` au lieu de `(root)` (fonctionne, mais donne plus que nécessaire), oublier `NOPASSWD` sur un compte sans mot de
passe (la commande attend un mot de passe qui n'existe pas, et bloque), et un fichier en `0644` (sudo le rejette :
`/etc/sudoers.d/deploy is world readable`).

Pourquoi `nologin` et pas `/bin/false` : les deux empêchent une session, mais `nologin` affiche un message et apparaît
dans `/etc/shells` ; c'est la convention des comptes de service Debian/Ubuntu. Un `sudo -u deploy <commande>` depuis root
fonctionne toujours : `nologin` bloque la **connexion**, pas l'exécution d'un processus sous ce compte.

## Section 3 — Exercice autonome

### Indices

1. `man ufw`, rubrique `limit` : six connexions en 30 secondes depuis la même adresse, au-delà c'est refusé. Utile contre
   la force brute SSH ; ça n'a aucun effet sur une clé déjà acceptée.
2. Les refus `ufw` partent dans le journal noyau avec le préfixe `[UFW BLOCK]` ; `journalctl -k` est le bon endroit,
   `/var/log/ufw.log` aussi si `rsyslog` est présent.
3. `ufw` est un service systemd (`ufw.service`, `enabled` par `ufw enable`) qui recharge `/etc/ufw/user.rules` au démarrage ;
   les `sysctl` sont rejoués par `systemd-sysctl` depuis `/etc/sysctl.d/`. Après le redémarrage, lis les deux.

### Correction commentée

```bash
sudo ufw delete allow 22/tcp
sudo ufw limit 22/tcp comment 'ssh ops, anti force brute'
sudo ufw status numbered
# depuis lx02 :
nc -zv -w 3 10.10.10.11 111
# sur lx01 :
sudo journalctl -k --since -5min | grep '\[UFW BLOCK\]' | tail -1
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Ligne de journal attendue (forme) :

```text
kernel: [UFW BLOCK] IN=ens18 OUT= MAC=… SRC=10.10.10.12 DST=10.10.10.11 LEN=60 … PROTO=TCP SPT=41552 DPT=111 … SYN
```

`DPT=111` est le port demandé, `SRC` l'attaquant, `SYN` dit que c'est une tentative d'ouverture. Avec `ufw logging medium`
tu verrais aussi les paquets acceptés ; `on` (= `low`) ne journalise que les refus, c'est suffisant.

Persistance :

```bash
sudo reboot
# après reconnexion :
sudo ufw status verbose | head -4
sysctl kernel.kptr_restrict kernel.dmesg_restrict
systemctl is-enabled ufw
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Si `ufw status` rend `inactive` après le redémarrage,
`ufw enable` n'a pas été lancé (il active `ufw.service`) ou `/etc/ufw/ufw.conf` contient `ENABLED=no`.

Pourquoi `deny` vaut `DROP` : lis `/etc/default/ufw`, `DEFAULT_INPUT_POLICY="DROP"`. Pour un réseau interne où tu veux
des échecs rapides, `ufw reject <port>` répond `ICMP port unreachable` ; sur un hôte exposé, `DROP` est préférable.

## Section 4 — Exercice autonome

### Indices

1. Lance `systemd-analyze security lecteur.service` sans `tail` : chaque ligne `✗` dit la directive manquante et son poids.
   Commence par les plus lourdes (`CapabilityBoundingSet=`, `PrivateNetwork=`, `RestrictAddressFamilies=`,
   `SystemCallFilter=~@privileged`).
2. Après chaque ajout : `daemon-reload`, `restart`, `status`. Si le service tombe, `journalctl -u lecteur -n 20` dit quel
   accès a été refusé ; `ProtectSystem=strict` sans `ReadOnlyPaths=/var/lib/lecteur` ne casse rien ici, mais
   `ProtectHome=yes` casserait un service dont les données sont sous `/home`.
3. Pour le profil AppArmor minimal, pars du profil fourni, change le nom du binaire et la ligne des `.txt`, retire ce que
   `journalctl -k` ne montre pas comme nécessaire. `apparmor_parser -p <fichier>` vérifie la syntaxe sans charger.

### Correction commentée

**Point 1.** Le drop-in complet est `etc/systemd/lecteur.service.d/hardening.conf`. Scores mesurés hors ligne sur le
conteneur de rédaction (exécuté, `systemd-analyze security --offline=true`, systemd de `ubuntu_lts`) :

| Drop-in | Score |
|---|---|
| aucun (unité livrée) | 9,0 UNSAFE |
| six directives de la démo | 7,0 MEDIUM |
| `hardening.conf` complet | 0,6 SAFE |
| `hardening.conf` remplacé par `User=root` (panne) | 9,4 UNSAFE |

```bash
sudo install -m 0644 etc/systemd/lecteur.service.d/hardening.conf /etc/systemd/system/lecteur.service.d/hardening.conf
sudo systemctl daemon-reload && sudo systemctl restart lecteur.service
systemctl status lecteur.service --no-pager | head -3
systemd-analyze security --no-pager lecteur.service | tail -1
sudo systemctl show -p NoNewPrivileges,ProtectSystem,SystemCallFilter lecteur.service
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]` pour le redémarrage. Les directives qui pèsent le plus,
et ce qu'elles ferment : `CapabilityBoundingSet=` vide (aucune capacité, même si le binaire était `setuid`),
`PrivateNetwork=yes` + `RestrictAddressFamilies=AF_UNIX` (pas de réseau du tout, le service n'en a pas besoin),
`SystemCallFilter=~@privileged @resources @mount @reboot @swap @obsolete` (listes noires en plus de la liste blanche
`@system-service`), `ProtectKernelTunables/Modules/Logs`, `ProtectControlGroups` (plus d'écriture dans `/proc/sys`,
`/sys`, cgroups), `MemoryDenyWriteExecute` (pas de page mémoire à la fois écrivable et exécutable),
`RestrictNamespaces`, `RestrictSUIDSGID`, `LockPersonality`. Avec `User=root`, presque tout cela devient inutile aux
yeux de l'analyseur : un service root non confiné est noté 9,4 quels que soient ses autres réglages.

**Point 2.** Profil minimal pour `/usr/local/bin/lecteur-journal` :

```bash
sudo cp /usr/local/bin/lecteur /usr/local/bin/lecteur-journal
sudo tee /etc/apparmor.d/usr.local.bin.lecteur-journal <<'EOF'
abi <abi/4.0>,
include <tunables/global>

/usr/local/bin/lecteur-journal {
  include <abstractions/base>
  include <abstractions/bash>
  /usr/local/bin/lecteur-journal r,
  /{usr/,}bin/bash ix,
  /{usr/,}bin/wc ix,
  /{usr/,}bin/cat ix,
  /{usr/,}bin/basename ix,
  /var/lib/lecteur/ r,
  /var/lib/lecteur/journal.txt r,
}
EOF
sudo apparmor_parser -p /etc/apparmor.d/usr.local.bin.lecteur-journal >/dev/null && echo "syntaxe OK"
sudo apparmor_parser -r -C /etc/apparmor.d/usr.local.bin.lecteur-journal     # complain
sudo lecteur-journal
sudo journalctl -k --since -1min | grep -E 'apparmor="ALLOWED".*lecteur-journal' | grep -oE 'name="[^"]+"' | sort -u
sudo aa-enforce /etc/apparmor.d/usr.local.bin.lecteur-journal
sudo lecteur-journal                 # inventaire.txt : « illisible » (refusé), journal.txt : 2 ligne(s)
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]` pour le chargement ; le profil fourni, dont celui-ci est
dérivé, compile avec `apparmor_parser` (exécuté). Ce que `complain` t'apprend : la ligne `name="/var/lib/lecteur/inventaire.txt"`
apparaît en `ALLOWED` parce que le script boucle sur `*.txt` ; c'est exactement ce que le profil doit refuser, donc on ne
l'ajoute pas. En `enforce`, le script affiche `lecteur: /var/lib/lecteur/inventaire.txt illisible` (son test `[ -r ]`)
et continue sur `journal.txt`. Un profil AppArmor se construit toujours ainsi : complain, exercer le programme, lire,
n'autoriser que le légitime, enforce.

## Section 5 — Variante Enterprise Linux

### Indices

1. `firewall-cmd` sans `--permanent` ne survit pas à `--reload` ; avec `--permanent` il ne s'applique qu'au `--reload`.
   Fais toujours les deux.
2. `getenforce` / `setenforce` changent le mode courant ; seul `/etc/selinux/config` survit au redémarrage.
3. `ausearch -m AVC -ts recent` puis `audit2why` lisent les refus SELinux ; `restorecon` répare 90 % des cas (fichier créé
   au mauvais endroit, puis déplacé).

### Correction commentée

```bash
sudo dnf remove -y httpd vsftpd
sudo systemctl disable --now rpcbind.socket rpcbind.service avahi-daemon.socket avahi-daemon.service
sudo systemctl mask rpcbind.socket rpcbind.service avahi-daemon.socket avahi-daemon.service
sudo dnf install -y dnf-automatic && sudo sed -i 's/^apply_updates = no/apply_updates = yes/' /etc/dnf/automatic.conf
sudo systemctl enable --now dnf-automatic.timer
sudo firewall-cmd --permanent --remove-service=http --remove-service=ftp
sudo firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=10.10.10.0/24 port port=8080 protocol=tcp accept'
sudo firewall-cmd --reload && sudo firewall-cmd --list-all
sudo setenforce 1 && sudo sed -i 's/^SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config
ls -Z /var/lib/demo-app && sudo restorecon -Rv /var/lib/demo-app
sudo ausearch -m AVC -ts recent | tail -5
sudo scripts/check.sh --el
```

`[non testé : pas de VM EL dans la session de rédaction]`. Si `demo-app` ne sert plus rien après `setenforce 1` : le service
lancé par systemd sans politique dédiée tourne en `unconfined_service_t` et n'est pas gêné ; en revanche un `httpd` confiné
le serait, et c'est là que `semanage port -a -t http_port_t -p tcp 8080` devient nécessaire. Le drop-in `hardening.conf`
de `lecteur` est le même fichier qu'en section 4 : seccomp et espaces de noms ne connaissent pas la distribution.
