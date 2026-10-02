---
titre: "Durcir un hôte Linux — surface d'attaque, comptes, réseau, AppArmor et seccomp"
domaine: "securite"
niveau: "débutant"
prerequis:
  - "docs/prerequis.md#linux_deb (systemd, paquets, utilisateurs et groupes, SSH par clé, journalctl ; aucun chapitre rédigé au 2026-10-02)"
  - "docs/prerequis.md#reseau_deb (ports, TCP/UDP, notion de pare-feu ; recommandé, aucun chapitre rédigé au 2026-10-02)"
duree_estimee: "5 h (4 h sans la section 5, variante Enterprise Linux)"
lecture_max: "20 %"
profil_lab: "linux-base"
budget_lab: "2 VM : 4 vCPU / 8 Go RAM / 80 Go (sur les 8 vCPU / 16 Go / 180 Go de labs/profiles/linux-base.yaml) : lx01 Ubuntu (cible), lx02 Rocky (poste d'attaque, variante EL)"
versions: "ubuntu_lts, rocky_linux"
certifications:
  - "CKS-03-01"
  - "CKS-03-02"
  - "CKS-03-03"
  - "CKS-03-04"
  - "KCSA-02-04"
  - "KCSA-02-05"
praticable_sur_le_lab: "oui"
solutions: "solutions/fiches/securite/01-durcissement-hote-linux.md"
break_fix: "break/securite/01-hote-*.sh"
flashcards: "revision/flashcards/securite-01-durcissement-hote-linux.csv"
etat_initial: "fiches/securite/01-durcissement-hote-linux/scripts/host-livre.sh"
verification: "fiches/securite/01-durcissement-hote-linux/scripts/check.sh"
statut: "brouillon"
---

# Durcir un hôte Linux — surface d'attaque, comptes, réseau, AppArmor et seccomp

> Niveau **débutant** · durée **5 h** (4 h sans la section 5) · profil de lab **linux-base** · couvre **CKS-03-01, CKS-03-02,
> CKS-03-03, CKS-03-04** (partie hôte ; la partie pods est la fiche 08) et **KCSA-02-04, KCSA-02-05** (à confirmer par la
> cartographie KCSA). Les IDs LFCS et RHCSA touchés sont listés dans `docs/plans/securite-01-durcissement-hote-linux.md`.

Statut d'exécution de cette version : la session de rédaction tournait sur un conteneur de la même LTS que `ubuntu_lts`,
sans systemd en PID 1, sans AppArmor dans le noyau et sans réseau de lab. Ont été exécutés pour de vrai : `sshd -t` et
`sshd -T` sur le drop-in fourni, `visudo -cf`, `apparmor_parser` sur le profil, `systemd-analyze verify` et
`systemd-analyze security --offline` sur les unités, le script `lecteur`, `check.sh`, shellcheck et les `--reveal` des pannes.
Tout ce qui touche un système vivant (services, pare-feu, SSH depuis `lx02`, journal noyau) est marqué
`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Le statut passera à `validé en conditions réelles`
après une exécution complète sur le lab.

Plan validé : `docs/plans/securite-01-durcissement-hote-linux.md`. Arbitrages : ufw en chemin principal, variante Rocky en
section optionnelle, état initial scripté, OpenSCAP reporté à la fiche 06.

## Objectifs mesurables

À la fin de cette fiche tu sais :

- inventorier services, ports en écoute, paquets et modules d'un hôte et le ramener à SSH plus les ports que tu décides,
  en moins de 10 min ;
- créer un compte de service sans shell, lui donner un droit `sudo` limité à une commande, et le prouver avec `sudo -l`,
  en moins de 5 min ;
- durcir `sshd` (clé seule, root interdit, groupe autorisé), le vérifier avec `sshd -T` sans perdre ta session,
  en moins de 8 min ;
- poser un pare-feu « tout refuser en entrée sauf SSH et un port choisi », persistant, vérifié depuis une seconde VM,
  en moins de 8 min ;
- passer un profil AppArmor en `enforce`, lire le refus dans le journal, et expliquer `enforce` / `complain` / `unconfined`
  en trois phrases sans notes ;
- confiner un service systemd (`SystemCallFilter`, `ProtectSystem`, `NoNewPrivileges`) et faire tomber son score
  `systemd-analyze security` sous 5, en moins de 10 min ;
- partir d'un hôte « livré par un intégrateur » et le ramener à un `check.sh` tout vert en moins de 15 min.

## Section 0 — Mise en place : l'hôte « livré »

Une VM fraîche du lab est déjà presque propre. Pour apprendre à durcir, il faut d'abord un hôte qui ne l'est pas.
Le script `scripts/host-livre.sh` joue l'intégrateur pressé ; `scripts/check.sh` est ton juge de paix, tu le relanceras
après chaque section.

```bash
# sur lx01 (10.10.10.11), depuis un clone du dépôt
cd ~/WorkbookDevops/fiches/securite/01-durcissement-hote-linux
sudo scripts/host-livre.sh
sudo scripts/check.sh
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Sur le conteneur de rédaction, `check.sh` s'exécute de bout
en bout et rend 23 contrôles en échec sur 33 (exécuté) : c'est à peu près ce que tu verras. Lis la liste des `[KO]` : c'est
le programme des quatre sections. Garde une console Proxmox ouverte sur `lx01` pendant toute la fiche. Tu vas toucher
à SSH et au pare-feu ; la console est ton filet.

## Section 1 — Réduire la surface d'attaque

Chaque section suit le cycle ci-dessous, dans cet ordre, sans en sauter.

### Concept (court)

La surface d'attaque d'un hôte, c'est tout ce qui peut recevoir une entrée hostile : un processus qui écoute sur le réseau,
un paquet installé avec ses bibliothèques, un module noyau chargé, un binaire `setuid`. Chaque élément en moins est une
vulnérabilité future en moins à corriger. La méthode tient en trois verbes : **lister**, **justifier**, **retirer**.
Ce qu'on ne sait pas justifier, on le retire ; ce qu'on garde, on le met à jour automatiquement. Manipulation.

### Démo guidée

Inventaire. Quatre commandes, quatre listes à lire ligne par ligne.

```bash
systemctl list-units --type=service --state=running --no-pager
systemctl list-unit-files --state=enabled --no-pager | grep -vE '@|target'
sudo ss -lntup
apt list --installed 2>/dev/null | wc -l
lsmod | grep -E '^(usb_storage|firewire)'
sudo find / -xdev -perm -4000 -type f 2>/dev/null
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Sur l'hôte livré tu dois voir `apache2`, `vsftpd`,
`rpcbind`, `avahi-daemon` en service ; `ss` montre `:80`, `:21`, `:111`, `:5353` (UDP) en plus de `:22` et `:8080` ;
`lsmod` rend `usb_storage` ; `find` rend `/usr/local/bin/bash-suid` à côté des `setuid` légitimes (`sudo`, `passwd`,
`mount`…).

Retirer. Un paquet qu'on supprime n'a plus à être mis à jour ; un service qu'on masque ne peut plus être démarré par erreur.

```bash
sudo apt-get purge -y apache2 vsftpd
sudo apt-get autoremove -y
sudo systemctl disable --now rpcbind.socket rpcbind.service avahi-daemon.socket avahi-daemon.service
sudo systemctl mask rpcbind.socket rpcbind.service avahi-daemon.socket avahi-daemon.service
sudo install -m 0644 etc/modprobe.d/blacklist-lab.conf /etc/modprobe.d/blacklist-lab.conf
sudo rmmod usb-storage
modprobe -n -v usb-storage        # attendu : install /bin/false
sudo rm /usr/local/bin/bash-suid
sudo ss -lntup
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Le fichier `blacklist-lab.conf` combine `blacklist`
(pas de chargement automatique) et `install <module> /bin/false` (pas de `modprobe` explicite non plus) : seul le second
arrête un administrateur, ou un attaquant, qui tape la commande.

Mettre à jour ce qui reste, sans y penser.

```bash
sudo tee /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
apt-config dump | grep Unattended-Upgrade
systemctl list-timers apt-daily-upgrade.timer --no-pager
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Le paquet `unattended-upgrades` est présent sur l'image
cloud de `ubuntu_lts` ; `20auto-upgrades` est le fichier que `host-livre.sh` avait mis à zéro.

### Exercice autonome

1. Il reste des services que la démo n'a pas touchés. Relis `systemctl list-units --type=service --state=running`
   et décide, pour chacun, « garde » ou « retire », avec une raison d'une ligne. Indice : `snapd`, `multipathd`,
   `ModemManager`, `udisks2` ne servent à rien sur une VM de lab.
2. Objectif : `sudo ss -lntup` ne montre plus que `sshd` sur `:22`, `demo-app` (python3) sur `:8080` et le résolveur
   local `systemd-resolved` sur `127.0.0.53:53` et `127.0.0.54:53`.
3. Relance `sudo scripts/check.sh` : les contrôles de la section 1 doivent passer.

Compétences couvertes : `CKS-03-01`, `KCSA-02-05`.

### Break-fix

Script : `break/securite/01-hote-service-fantome.sh` — injecte la panne, `--undo` la retire, `--reveal` l'explique.

Depuis `lx02`, `curl -s http://10.10.10.11:8000/etc/hostname` répond le nom de la machine. Un port que tu n'as pas
ouvert sert quelque chose qu'il ne devrait pas. Trouve le processus, l'unité qui le lance, et fais en sorte qu'il ne
revienne pas au prochain redémarrage.

### Défi chronométré

Sur un hôte sorti de `host-livre.sh` : ramener la liste `ss -lntup` à `sshd`, `demo-app` et le résolveur local, modules et
`setuid` compris, mises à jour automatiques actives. **10 min.** Critère : les huit contrôles de la section 1 de `check.sh`
passent.

## Section 2 — Comptes et accès à moindre privilège

### Concept (court)

Un compte ne doit pouvoir faire que ce pour quoi il existe : un service n'a pas besoin de shell, un déployeur n'a pas
besoin de `root`, un humain n'a pas besoin de mot de passe s'il a une clé. Trois mécanismes suffisent : le shell du
compte (`/usr/sbin/nologin`), une règle `sudo` précise (chemin absolu, arguments exacts), et un `sshd` qui n'accepte que
des clés, pour un groupe nommé. Règle d'or avant de toucher à `sshd` : **une seconde session reste ouverte** jusqu'à ce
que la nouvelle configuration soit prouvée. Manipulation.

### Démo guidée

Le groupe des humains autorisés, et ton compte dedans **avant** tout le reste.

```bash
sudo groupadd -f ops
sudo usermod -aG ops "$USER"
id "$USER"                        # ops doit apparaître
ls ~/.ssh/authorized_keys         # ta clé est là (cloud-init l'a déposée)
```

Le drop-in `sshd` fourni, lu avant de l'appliquer.

```bash
cat etc/ssh/sshd_config.d/00-hardening.conf
sudo rm -f /etc/ssh/sshd_config.d/99-livre.conf
sudo install -m 0644 etc/ssh/sshd_config.d/00-hardening.conf /etc/ssh/sshd_config.d/00-hardening.conf
sudo sshd -t && echo "syntaxe OK"
sudo sshd -T | grep -iE '^(permitrootlogin|passwordauthentication|kbdinteractiveauthentication|allowgroups|maxauthtries)'
```

Sortie obtenue (exécuté sur le drop-in seul, avec `sshd -T -f`, la configuration du conteneur ne comptant pas) :

```text
maxauthtries 3
permitrootlogin no
passwordauthentication no
kbdinteractiveauthentication no
allowgroups ops
```

Pourquoi `00-` ? `sshd_config` de `ubuntu_lts` commence par `Include /etc/ssh/sshd_config.d/*.conf` (ligne 12 sur
l'image de rédaction, exécuté) et, dans `sshd`, **la première valeur rencontrée gagne**. Test exécuté : un fichier qui dit
`PasswordAuthentication no` puis `PasswordAuthentication yes` donne `passwordauthentication no` dans `sshd -T`. Un drop-in
`50-cloud-init.conf` qui réactiverait les mots de passe perd donc contre `00-hardening.conf`. C'est aussi pourquoi
`host-livre.sh` avait nommé le sien `99-livre.conf` : il perdait, mais il n'y avait rien devant lui.

Recharger, puis prouver depuis `lx02` **sans fermer la session courante**.

```bash
sudo systemctl restart ssh
# depuis lx02 (10.10.10.12) :
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no deploy@10.10.10.11   # attendu : Permission denied
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no root@10.10.10.11     # attendu : Permission denied
ssh "$USER"@10.10.10.11 'echo ok'                                                        # attendu : ok (clé)
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Si `ssh` par clé échoue ici, **ne ferme pas ta session** :
`sudo journalctl -u ssh -n 20` dit pourquoi (en général `User … not allowed because not listed in AllowGroups`).

Sur `ubuntu_lts`, `ssh` est **activé par socket** (`ssh.socket`) : changer `Port` ou `ListenAddress` dans `sshd_config` ne
sert à rien tant que le socket écoute ; il faut `systemctl daemon-reload` puis `systemctl restart ssh.socket`. Cette fiche
ne change pas le port, mais c'est un piège d'examen : vérifie toujours avec `ss -lntp | grep sshd` ce qui écoute vraiment.

Et `root` ? Il avait reçu un mot de passe de l'intégrateur. On le lui reprend.

```bash
sudo passwd -l root
sudo passwd -S root               # attendu : root L …
```

### Exercice autonome

Le compte `deploy` a un mot de passe, un shell et `sudo ALL`. Il ne doit garder qu'un droit : redémarrer `demo-app`.

1. Verrouille son mot de passe et retire-lui le shell interactif.
2. Supprime `/etc/sudoers.d/90-deploy` et écris ta propre règle dans `/etc/sudoers.d/deploy` (mode `0440`) : chemin absolu
   de `systemctl`, argument exact. Valide-la avec `visudo -cf` avant de la laisser en place.
3. Prouve-le : `sudo -l -U deploy` ; puis `sudo -u deploy sudo -n systemctl restart demo-app.service` passe,
   `sudo -u deploy sudo -n systemctl restart ssh` est refusé.
4. Relance `check.sh` : les contrôles de la section 2 doivent passer.

Compétences couvertes : `CKS-03-02`.

### Break-fix

Script : `break/securite/01-hote-sudo-ouvert.sh` — injecte la panne, `--undo` la retire, `--reveal` l'explique.

Depuis `lx02`, `ssh deploy@10.10.10.11` demande un mot de passe et l'accepte. Pourtant ton `00-hardening.conf` est
toujours là. Trouve ce qui a changé, dans `sudoers.d` comme dans `sshd_config.d`, et pourquoi ton fichier a perdu.

### Défi chronométré

Hôte fourni avec un compte `deploy` ouvert : compte de service verrouillé et sans shell, règle `sudo` limitée à une commande,
`sshd` en clé seule pour le groupe `ops`, root verrouillé, session de secours jamais fermée. **8 min.**
Critère : les douze contrôles de la section 2 de `check.sh` passent, et `ssh` par clé fonctionne encore depuis `lx02`.

## Section 3 — Réseau : réduire l'accès externe

### Concept (court)

Ce qui écoute doit être joignable par ceux qui en ont besoin, et par personne d'autre. Après la section 1, deux
services écoutent : `sshd`, pour les humains d'`ops`, et `demo-app`, pour le VLAN de management. Le pare-feu de l'hôte
dit cela en trois règles. Sur `ubuntu_lts`, `ufw` écrit des règles nftables à ta place ; c'est l'outil que les énoncés
CKS citent, et `nft list ruleset` te montre ce qu'il a réellement écrit. Quelques `sysctl` ferment en plus des portes
noyau que personne n'utilise. Manipulation.

### Démo guidée

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'ssh ops'
sudo ufw allow from 10.10.10.0/24 to any port 8080 proto tcp comment 'demo-app mgmt'
sudo ufw logging on
sudo ufw enable
sudo ufw status verbose
sudo nft list ruleset | grep -A3 'chain ufw-user-input'
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]` : `ufw` a besoin des modules netfilter du noyau, absents
du conteneur de rédaction. `ufw status verbose` doit afficher `Default: deny (incoming), allow (outgoing)` puis les deux
règles, et `nft list ruleset` montre la table `ufw` avec une chaîne par étape (`ufw-user-input` contient tes deux règles
sous forme `tcp dport 22 accept` et `ip saddr 10.10.10.0/24 tcp dport 8080 accept`).

Prouver depuis `lx02` (dans `10.10.10.0/24`) puis depuis ton poste sur le LAN (hors du réseau autorisé, routé par
`core-rtr01`).

```bash
# depuis lx02 :
nc -zv 10.10.10.11 22        # attendu : succeeded
curl -s -m 3 http://10.10.10.11:8080/ | head -1   # attendu : <h1>demo-app</h1>
nc -zv -w 3 10.10.10.11 111  # attendu : timed out ou refused
# depuis le poste LAN (192.168.0.x), via le routeur virtuel :
curl -s -m 3 http://10.10.10.11:8080/ || echo "bloqué"            # attendu : bloqué
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. `ufw` utilise `DROP` par défaut pour `deny` : un port
fermé **ne répond pas** (`timed out`), il ne refuse pas (`refused`). C'est voulu, un scanner met plus de temps.

Les `sysctl`, persistants dès le premier redémarrage.

```bash
cat etc/sysctl.d/90-hardening.conf
sudo rm -f /etc/sysctl.d/90-livre.conf
sudo install -m 0644 etc/sysctl.d/90-hardening.conf /etc/sysctl.d/90-hardening.conf
sudo sysctl --system | grep -E 'dmesg_restrict|kptr_restrict|protected_regular'
sysctl kernel.dmesg_restrict kernel.kptr_restrict fs.protected_regular
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]` ; le fichier a été lu avec `sysctl -p` sur le conteneur
(exécuté, toutes les clés sont reconnues sauf `kernel.yama.ptrace_scope`, absent du noyau du conteneur mais présent sur
`ubuntu_lts`). Lis le dernier commentaire du fichier : `net.ipv4.ip_forward` n'y est pas, exprès. Un nœud Kubernetes en a
besoin à `1` et la fiche 06 te fera retrouver ce détail dans un rapport CIS.

### Exercice autonome

1. Remplace `allow 22/tcp` par `limit 22/tcp` et explique, en une ligne, ce que `limit` ajoute (lis `man ufw`).
2. Depuis `lx02`, tente une connexion sur `:111`. Retrouve le refus dans `sudo journalctl -k | grep '\[UFW BLOCK\]'`
   et lis `SRC`, `DST`, `DPT`.
3. Redémarre `lx01`. Prouve que les règles et les `sysctl` sont toujours là (`ufw status`, `sysctl kernel.kptr_restrict`).
4. Relance `check.sh` : les contrôles de la section 3 doivent passer.

Compétences couvertes : `CKS-03-03`, `KCSA-02-04` (ports d'un nœud, voir l'encadré de fin de fiche).

### Break-fix

Script : `break/securite/01-hote-pare-feu-ouvert.sh` — injecte la panne, `--undo` la retire, `--reveal` l'explique.

Depuis ton poste LAN, `curl http://10.10.10.11:8080/` répond. Hier il était bloqué. Tes règles sont-elles encore là ?
Sont-elles appliquées ? Deux commandes suffisent pour le dire, une troisième pour réparer.

### Défi chronométré

Hôte sans pare-feu : deny par défaut en entrée, SSH autorisé pour tous, `8080/tcp` pour `10.10.10.0/24` seulement,
journalisation active, `sysctl` durcis et persistants. **8 min.** Critère : les neuf contrôles de la section 3 de `check.sh`
passent et `curl` depuis `lx02` répond encore.

## Section 4 — AppArmor et seccomp sur l'hôte

### Concept (court)

Les permissions Unix (DAC) disent qui peut lire quoi. Elles ne disent rien de ce qu'un **programme** a le droit de
faire une fois lancé par root. Deux mécanismes du noyau complètent : **AppArmor** confine un programme à une liste de
chemins et de capacités (contrôle d'accès obligatoire, MAC), **seccomp** limite les appels système qu'il peut faire.
Sur un hôte, systemd est la porte d'entrée la plus simple vers les deux : une directive `SystemCallFilter=` dans une
unité, c'est un filtre seccomp ; `ProtectSystem=`, `ProtectHome=`, `PrivateTmp=` sont des espaces de noms. Et
`systemd-analyze security` note le résultat de 0 (sûr) à 10. Sur un nœud Kubernetes, ce sont exactement les mêmes
mécanismes qu'un pod déclare dans son `securityContext` (fiche 08). Manipulation.

### Démo guidée

AppArmor d'abord. Le service `lecteur` (`/usr/local/bin/lecteur`) compte les lignes des fichiers de `/var/lib/lecteur`.
Son profil est chargé en **complain** par `host-livre.sh` : il journalise, il n'interdit rien.

```bash
sudo aa-status | grep -B1 -A1 lecteur
sudo lecteur /etc/shadow | head -1          # root + complain : ça passe, et c'est journalisé
sudo journalctl -k --since -2min | grep -E 'apparmor="ALLOWED".*lecteur'
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]`. Note le sujet du test : **root**. Pour `lecteur`
(l'utilisateur), `/etc/shadow` est déjà illisible par DAC ; ce que le profil ajoute, c'est que même root, en lançant ce
programme, n'y accède pas. Lis le profil avant de le passer en `enforce`.

```bash
cat apparmor/usr.local.bin.lecteur
sudo aa-enforce /etc/apparmor.d/usr.local.bin.lecteur
sudo aa-status | grep -A1 'enforce mode' | head -2
sudo lecteur /etc/shadow                    # attendu : cat: /etc/shadow: Permission denied
sudo lecteur                                # attendu : les .txt comptés, comme avant
sudo journalctl -k --since -1min | grep -E 'apparmor="DENIED".*name="/etc/shadow"'
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]` ; le profil a été compilé avec `apparmor_parser -p` et
`-Q -d` sur le conteneur (exécuté, syntaxe OK, nom `/usr/local/bin/lecteur`). Sortie du script sans confinement,
exécutée sur le conteneur :

```text
inventaire.txt: 3 ligne(s)
journal.txt: 2 ligne(s)
total: 5 ligne(s)
```

Trois modes à connaître : `enforce` (bloque et journalise), `complain` (journalise seulement, pour écrire un profil),
`unconfined` (pas de profil). `aa-complain`, `aa-enforce`, `aa-disable` changent le mode ; `apparmor_parser -r` recharge
un profil modifié ; les profils vivent dans `/etc/apparmor.d/`, nommés d'après le chemin du binaire.

seccomp et espaces de noms ensuite, par systemd. L'unité livrée ne protège rien.

```bash
systemd-analyze security --no-pager lecteur.service | tail -1
```

Sortie obtenue (exécutée hors ligne sur l'unité livrée, `systemd-analyze security --offline=true`, systemd de `ubuntu_lts`) :

```text
→ Overall exposure level for lecteur.service: 9.0 UNSAFE :-{
```

Trois directives pour commencer, puis mesure.

```bash
sudo mkdir -p /etc/systemd/system/lecteur.service.d
sudo tee /etc/systemd/system/lecteur.service.d/hardening.conf <<'EOF'
[Service]
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
SystemCallFilter=@system-service
SystemCallErrorNumber=EPERM
EOF
sudo systemctl daemon-reload
sudo systemctl restart lecteur.service
systemctl status lecteur.service --no-pager | head -5
systemd-analyze security --no-pager lecteur.service | tail -1
```

`[non testé : pas de VM ni de systemd dans la session de rédaction]` pour le redémarrage ; score mesuré hors ligne avec ces six
lignes (exécuté) :

```text
→ Overall exposure level for lecteur.service: 7.0 MEDIUM :-|
```

`@system-service` est un groupe d'appels système « ce qu'un service ordinaire utilise » ; tout appel hors du groupe rend
`EPERM` au lieu de tuer le processus (`SystemCallErrorNumber`), ce qui se lit dans les logs sans crash. `ProtectSystem=strict`
monte tout le système en lecture seule sauf ce que `ReadWritePaths=` liste. Le reste du chemin vers un score bas est
l'exercice autonome.

### Exercice autonome

1. Complète le drop-in jusqu'à un score **sous 5**, sans casser le service (`systemctl status`, `journalctl -u lecteur`).
   Lis `systemd-analyze security lecteur.service` en entier : chaque ligne `✗` est une directive à ajouter. Le fichier
   `etc/systemd/lecteur.service.d/hardening.conf` du dossier de la fiche est la correction ; essaie d'abord sans.
2. Écris un profil AppArmor minimal pour une copie du script, `/usr/local/bin/lecteur-journal`, qui n'a le droit de lire
   que `/var/lib/lecteur/journal.txt`. Charge-le en `complain`, lance le script, lis les `ALLOWED` dans `journalctl -k`,
   ajuste, passe en `enforce`. Vérifie que `inventaire.txt` est refusé.
3. Relance `check.sh` : tout doit être vert.

Compétences couvertes : `CKS-03-04`, `KCSA-02-05`.

### Break-fix

Script : `break/securite/01-hote-apparmor-complain.sh` — injecte la panne, `--undo` la retire, `--reveal` l'explique.

`sudo lecteur /etc/shadow` affiche de nouveau le fichier, et `ps -o user= -C lecteur` rend `root`. Quelqu'un a « dépanné »
le service. Retrouve les deux choses qui ont changé, remets le confinement, et explique en une phrase pourquoi un drop-in
peut annuler un autre drop-in.

### Défi chronométré

Hôte fourni avec un profil en `complain` et un service nu : profil en `enforce`, service confiné sous 5, toujours actif.
**10 min.** Critère : les six contrôles de la section 4 de `check.sh` passent.

## Section 5 — Variante Enterprise Linux (optionnelle, 1 h)

Sur `lx02` (Rocky, `rocky_linux` de `versions.yaml`), les mêmes idées avec les outils de la famille Red Hat : `dnf`,
`firewalld`, SELinux à la place d'AppArmor. Même état initial, même juge de paix.

```bash
# sur lx02 (10.10.10.12)
sudo scripts/host-livre.sh          # détecte la famille EL ; --el pour forcer
sudo scripts/check.sh               # idem, --el pour forcer
```

Ce qui change, section par section. Tout est `[non testé : pas de VM EL dans la session de rédaction]`.

- **Section 1** : `dnf remove -y httpd vsftpd`, `systemctl mask` identique, blacklist de module identique,
  `dnf install -y dnf-automatic && systemctl enable --now dnf-automatic.timer` (avec `apply_updates = yes` dans
  `/etc/dnf/automatic.conf`).
- **Section 2** : identique (`sshd_config.d/` existe aussi, même règle « première valeur gagne ») ; `sudoers.d` identique.
  Attention aux politiques crypto système : `update-crypto-policies --show` ; `sshd` suit `DEFAULT`.
- **Section 3** : `firewall-cmd --permanent --remove-service=http --remove-service=ftp`,
  `firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=10.10.10.0/24 port port=8080 protocol=tcp accept'`,
  `firewall-cmd --reload`, `firewall-cmd --list-all`. `sysctl` identique.
- **Section 4** : `getenforce` rend `Permissive` sur l'hôte livré. `sudo setenforce 1` puis `SELINUX=enforcing` dans
  `/etc/selinux/config`. `demo-app` sert `/var/lib/demo-app` : vérifie les contextes avec `ls -Z`, répare avec
  `restorecon -Rv /var/lib/demo-app`, et lis les refus avec `ausearch -m AVC -ts recent`. Le port 8080 n'est pas un
  port HTTP connu de SELinux : `semanage port -l | grep http_port_t` puis, si un service confiné devait écouter dessus,
  `semanage port -a -t http_port_t -p tcp 8080`. Le drop-in systemd de `lecteur` est strictement identique : seccomp et
  espaces de noms sont des mécanismes noyau, pas des mécanismes de distribution.

Exercice autonome : amener `check.sh --el` au vert en moins de 20 min, et noter dans `journal/` les trois commandes qui
diffèrent le plus de l'Ubuntu. Compétences couvertes : `CKS-03-01` à `CKS-03-04` (même objectifs), et pour les
cartographies à venir LFCS-01-08, RHCSA-08-04, RHCSA-10-01, RHCSA-10-03 à 10-08.

## Défi final — l'hôte livré, de bout en bout

Sur une VM `lx01` remise à neuf (`lab down` / `lab up linux-base`, ou `host-livre.sh --undo` puis `host-livre.sh`),
tout ce qui précède, d'un trait, pendant qu'un camarade (ou `break.sh random`, quand il existera) injecte une des quatre
pannes au milieu. **15 min.** Critère : `sudo scripts/check.sh` rend `tout est vert`. Si tu dépasses, note où le temps est
parti : c'est la section à refaire à J+7.

## Checklist de maîtrise

À cocher honnêtement, en conditions réelles (terminal seul, documentation officielle, minuteur).

- [ ] Je sais inventorier et réduire les services, ports, paquets, modules et `setuid` d'un hôte en moins de 10 min
- [ ] Je sais créer un compte de service sans shell avec une règle `sudo` limitée, prouvée par `sudo -l`, en moins de 5 min
- [ ] Je sais durcir `sshd` par drop-in et le prouver avec `sshd -T` sans perdre ma session, en moins de 8 min
- [ ] Je sais poser un pare-feu deny par défaut avec deux autorisations ciblées, persistant, en moins de 8 min
- [ ] Je sais passer un profil AppArmor en `enforce` et retrouver le refus dans `journalctl -k` en moins de 3 min
- [ ] Je sais confiner un service systemd sous un score de 5 en moins de 10 min
- [ ] Je sais diagnostiquer un service fantôme, un `sudo` rouvert, un pare-feu coupé ou un confinement desserré en moins de 5 min chacun
- [ ] Je sais remettre un hôte livré au vert de `check.sh` en moins de 15 min
- [ ] Je sais expliquer en 3 phrases sans notes : DAC vs MAC, `enforce` vs `complain`, ce qu'est un filtre seccomp

## À connaître pour l'examen (lecture seule)

- Ports d'un nœud Kubernetes, à autoriser au pare-feu quand un énoncé le demande : control plane `6443` (API server),
  `2379-2380` (etcd), `10250` (kubelet), `10257` (controller manager), `10259` (scheduler) ; worker `10250` (kubelet),
  `30000-32767` (NodePort). Source : documentation officielle « Ports and Protocols », autorisée pendant l'épreuve.
- `ufw` tel que les énoncés CKS l'écrivent : `ufw allow from <cidr> to any port <port>`, `ufw deny <port>`, `ufw status numbered`,
  `ufw delete <n>`.
- Ce qui n'est pas dans cette fiche, et où le trouver : AppArmor et seccomp **appliqués aux pods** (fiche 08), auditd et audit
  logs de l'API server (fiche 14), Secure Boot / TPM / OS immuable (lecture, fiche 10 et distribution Talos), PAM `faillock`
  et politiques de mots de passe (hors programme CKS).
- `ubuntu_lts` : `kernel.apparmor_restrict_unprivileged_userns=1` par défaut explique des refus d'outils rootless ; on le
  retrouvera avec les conteneurs.

## Liens

- Solutions (3 indices puis correction commentée) : `solutions/fiches/securite/01-durcissement-hote-linux.md`
- Pannes scriptées : `break/securite/`
- État initial scripté et vérification : `fiches/securite/01-durcissement-hote-linux/scripts/host-livre.sh`,
  `fiches/securite/01-durcissement-hote-linux/scripts/check.sh`
- Fichiers fournis : `apparmor/`, `systemd/`, `etc/` dans le même dossier
- Flashcards (10 à 20, CSV `question;réponse;tags`) : `revision/flashcards/securite-01-durcissement-hote-linux.csv`
- Mapping certification : `certifs/CKS/objectifs.md`
- Rappel espacé : séances J+1, J+7, J+30 à noter dans `journal/`
