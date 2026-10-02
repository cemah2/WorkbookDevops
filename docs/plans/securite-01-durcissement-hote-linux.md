---
chapitre: "fiches/securite/01-durcissement-hote-linux.md"
domaine: "securite"
niveau: "débutant"
statut: "réalisé le 2026-10-02 — chapitre en brouillon, relecture critique à faire (prompts/04)"
duree_estimee: "5 h (4 h sans la variante Rocky / SELinux)"
profil_lab: "linux-base (deux VM : lx01 Ubuntu cible, lx02 Rocky comme poste d'attaque et variante EL)"
versions: "ubuntu_lts, rocky_linux, compliance_as_code (optionnel)"
certifications:
  - "CKS-03-01"
  - "CKS-03-02"
  - "CKS-03-03"
  - "CKS-03-04"
  - "KCSA-02-04"
  - "KCSA-02-05"
  - "LFCS-01-02"
  - "LFCS-02-04"
  - "LFCS-02-05"
  - "RHCSA-09-04"
  - "RHCSA-10-01"
  - "RHCSA-10-03"
---

# Plan — 01 Durcir un hôte Linux : surface d'attaque, comptes, réseau, AppArmor et seccomp

Première fiche de la série `securite` (cartographie `certifs/CKS/objectifs.md` §4, F1). Elle ouvre le domaine au niveau
débutant, sans cluster : tout se passe sur une VM Ubuntu du profil `linux-base`, comme sur un nœud d'examen CKS (hôtes
Ubuntu, AppArmor). Les quatre compétences CKS-03 sont traitées côté **hôte** ; leur application aux pods
(`securityContext.appArmorProfile`, `seccompProfile`) est la fiche 08.

Arbitrages hérités : Ubuntu 24.04 LTS image de référence (DECISIONS.md 2026-10-02), fiches numérotées, scripts de panne
`break/securite/01-*.sh` avec `--undo` et `--reveal`. Arbitrages validés le 2026-10-02 : section « Arbitrages validés ».

## Objectifs mesurables

- Inventorier les services, ports en écoute, paquets et modules noyau d'un hôte, et le réduire à SSH seul en écoute
  (plus les ports que je décide), en moins de 10 min.
- Créer un compte de service sans shell, lui donner un droit `sudo` limité à une commande, et le prouver avec `sudo -l`,
  en moins de 5 min.
- Durcir `sshd` (clé seule, root interdit, groupe autorisé), le vérifier avec `sshd -T` sans perdre ma session, en moins de 8 min.
- Mettre en place un pare-feu « tout refuser en entrée sauf SSH et un port choisi », persistant au redémarrage, vérifié
  depuis une seconde VM, en moins de 8 min.
- Passer un profil AppArmor fourni en `enforce`, lire le refus dans le journal, et expliquer la différence
  `enforce` / `complain` / `unconfined` en trois phrases sans notes.
- Confiner un service systemd avec `SystemCallFilter`, `ProtectSystem` et `NoNewPrivileges`, et faire baisser son score
  `systemd-analyze security` sous 5, en moins de 10 min.
- Défi final : partir d'un hôte « livré par un intégrateur » et le ramener à l'état attendu par `scripts/check.sh`
  (tous les contrôles verts) en moins de 15 min.

## Niveau et prérequis

- Débutant, nœud `securite_deb` (`docs/prerequis.md` §6.2, premier nœud de la série).
- Prérequis : nœud `linux_deb` (systemd, paquets apt, utilisateurs et groupes, SSH par clé, `journalctl`) ;
  nœud `reseau_deb` recommandé (ports, TCP/UDP, notion de pare-feu). Aucun chapitre n'existe pour ces nœuds au
  2026-10-02 : le front matter cite les nœuds, pas des fichiers, comme la fiche `gitops/01`.
- Pas de prérequis Kubernetes : la fiche est volontairement faisable avant le bloc CKA, et sert aussi LFCS et RHCSA.
- Suite : fiche 08 (AppArmor et seccomp pour les pods), fiche 06 (CIS benchmark, mêmes réflexes appliqués aux composants Kubernetes).

## Compétences couvertes

| Section | CKS | KCSA (à confirmer par la cartographie KCSA) | LFCS / RHCSA (à confirmer par leurs cartographies) |
|---|---|---|---|
| 1 Réduire la surface d'attaque | CKS-03-01 | KCSA-02-05 | LFCS-01-01, LFCS-01-02, LFCS-01-04 |
| 2 Comptes et accès à moindre privilège | CKS-03-02 | — | LFCS-02-04, LFCS-05-01, RHCSA-09-04, RHCSA-10-03 |
| 3 Réseau : réduire l'accès externe | CKS-03-03 | KCSA-02-04 (ports du kubelet, lecture) | LFCS-02-03, LFCS-02-05, RHCSA-08-04, RHCSA-10-01 |
| 4 AppArmor et seccomp sur l'hôte | CKS-03-04 (partie hôte) | KCSA-02-05 | LFCS-01-08 (variante SELinux), RHCSA-10-04 à 10-08 (variante) |

Le front matter de la fiche ne cite que les IDs CKS et KCSA tant que les cartographies LFCS et RHCSA n'existent pas ;
les IDs LFCS/RHCSA sont listés ici pour que ces cartographies retrouvent la fiche.

## Structure et exercices

Chaque section suit le cycle concept → démo guidée → exercice autonome → break-fix → défi chronométré.
Lecture totale visée : 45 min sur 4 h (la variante EL ajoute 1 h, presque entièrement en manipulation).

| # | Section | Type | Énoncé court | Critère |
|---|---|---|---|---|
| 0 | — | guidé | `scripts/host-livre.sh` : transformer `lx01` en hôte « livré » (services inutiles, compte `deploy` avec mot de passe et `sudo ALL`, root SSH autorisé, pas de pare-feu, profil AppArmor en `complain`, module `usb-storage` chargé) ; `scripts/check.sh` montre tout en rouge | `check.sh` : 0 contrôle vert |
| 1.1 | 1 | guidé | Inventaire : `systemctl list-units --type=service --state=running`, `list-unit-files --state=enabled`, `ss -lntup`, `apt list --installed`, `lsmod`, `find / -perm -4000` ; lire chaque ligne et décider garder / arrêter / supprimer | tableau rempli |
| 1.2 | 1 | autonome | Supprimer deux paquets, `disable --now` puis `mask` deux services, interdire un module (`/etc/modprobe.d/`, `install usb-storage /bin/false`), activer `unattended-upgrades` sécurité ; re-lire `ss` | seuls `sshd` et `systemd-resolved` en écoute |
| 1.3 | 1 | break-fix | `break/securite/01-hote-service-fantome.sh` | port disparu, unité retirée |
| 1.4 | 1 | chronométré | Hôte fourni → SSH seul en écoute | 10 min |
| 2.1 | 2 | guidé | Compte de service `app` (`nologin`, sans mot de passe), groupe `ops`, drop-in `/etc/sudoers.d/` avec `Cmnd_Alias`, `visudo -cf`, `sudo -l -U app` ; `sshd_config.d/` : `PermitRootLogin no`, `PasswordAuthentication no`, `KbdInteractiveAuthentication no`, `AllowGroups ops`, `MaxAuthTries 3`, test `sshd -t` puis `sshd -T` filtré par `grep -i` ; **règle d'or : garder une session ouverte** | `sshd -T` conforme, seconde session OK |
| 2.2 | 2 | autonome | Verrouiller `deploy` (`passwd -l`, shell `nologin`), retirer son `sudo ALL`, ne lui laisser que `systemctl restart app` ; vérifier qu'un `ssh deploy@lx01` par mot de passe échoue depuis `lx02` | refus par mot de passe, `sudo -l` limité |
| 2.3 | 2 | break-fix | `break/securite/01-hote-sudo-ouvert.sh` | `sudo -l` limité, root SSH refusé |
| 2.4 | 2 | chronométré | Compte de service + règle sudo + SSH clé seule | 8 min |
| 3.1 | 3 | guidé | Un service d'exemple écoute sur `0.0.0.0` : le lier à `127.0.0.1` ; `ufw default deny incoming`, `allow 22/tcp`, `allow from 10.10.10.0/24 to any port 8080`, `ufw enable`, lire `nft list ruleset` pour voir ce qu'ufw génère ; `sysctl` persistants (`kernel.dmesg_restrict`, `kernel.kptr_restrict`, `net.ipv4.conf.all.rp_filter`, `fs.protected_regular`), avec la note « `net.ipv4.ip_forward=1` reste nécessaire à un nœud Kubernetes » | `nc -zv` depuis `lx02` : 22 ouvert, 8080 selon source, reste fermé |
| 3.2 | 3 | autonome | Ajouter une règle de limitation (`ufw limit 22/tcp`), journaliser les refus, retrouver un refus dans `journalctl -k` ; redémarrer et prouver la persistance | règles présentes après reboot |
| 3.3 | 3 | break-fix | `break/securite/01-hote-pare-feu-ouvert.sh` | service de nouveau joignable uniquement depuis le réseau autorisé |
| 3.4 | 3 | chronométré | Deny par défaut + deux autorisations ciblées, persistant | 8 min |
| 4.1 | 4 | guidé | `aa-status`, profils de `/etc/apparmor.d/`, `aa-complain` / `aa-enforce` / `aa-disable`, `apparmor_parser -r` ; profil fourni pour `scripts/lecteur.sh` qui tente de lire `/etc/shadow` ; refus dans `journalctl -k` (`apparmor="DENIED"`) ; puis service systemd `lecteur.service` : `systemd-analyze security lecteur` avant, ajout de `NoNewPrivileges=yes`, `ProtectSystem=strict`, `ProtectHome=yes`, `PrivateTmp=yes`, `SystemCallFilter=@system-service`, `SystemCallErrorNumber=EPERM`, score après | refus lu, score < 5 |
| 4.2 | 4 | autonome | Écrire un profil AppArmor minimal pour un second script (lecture d'un seul répertoire), le tester en `complain` avec `aa-logprof` facultatif, le passer en `enforce` ; ajouter `CapabilityBoundingSet=` et `RestrictAddressFamilies=` au service et observer ce qui casse | profil `enforce` sans refus légitime |
| 4.3 | 4 | break-fix | `break/securite/01-hote-apparmor-complain.sh` | profil de nouveau `enforce`, score du service revenu |
| 4.4 | 4 | chronométré | Profil fourni → `enforce` + service confiné | 10 min |
| 5 | final | chronométré | Relancer `host-livre.sh` sur une VM propre, tout remettre d'équerre | `check.sh` tout vert en 15 min |
| V | variante | autonome (optionnel) | Même parcours sur `lx02` Rocky : `dnf`, `firewalld` (`firewall-cmd --permanent`), SELinux (`getenforce`, `semanage port`, `restorecon`, booléens) à la place d'AppArmor | `check.sh --el` vert |

## Scénarios de panne (`break/securite/`)

| Script | Injection | Symptôme montré à l'apprenant |
|---|---|---|
| `01-hote-service-fantome.sh` | unité systemd `maintenance-http.service` lancée en root (`python3 -m http.server` sur `0.0.0.0:8000`, racine `/`), activée au démarrage | un port inconnu sert l'arborescence du disque à tout le réseau |
| `01-hote-sudo-ouvert.sh` | `/etc/sudoers.d/90-deploy` (`NOPASSWD: ALL`), drop-in `sshd_config.d/99-break.conf` (`PermitRootLogin yes`, `PasswordAuthentication yes`), mot de passe posé sur `deploy` | `sudo -l -U deploy` rend `ALL`, connexion root par mot de passe possible depuis `lx02` |
| `01-hote-pare-feu-ouvert.sh` | `ufw disable` + service d'exemple relié à `0.0.0.0` | `nc -zv lx01 8080` réussit depuis n'importe quelle source |
| `01-hote-apparmor-complain.sh` | profil du lecteur en `complain`, drop-in `lecteur.service.d/override.conf` qui vide `SystemCallFilter` et `ProtectSystem` | `aa-status` montre le profil en complain, `/etc/shadow` lisible, score `systemd-analyze security` remonté |
| `01-hote-module-noyau.sh` (optionnel) | suppression du blacklist, `modprobe usb-storage` | `lsmod` montre le module, règle `modprobe.d` absente |

Conventions : exécutés en root sur l'hôte (`sudo ./break/securite/01-….sh`), idempotents (marqueur sous
`/var/lib/break-securite/`), `--undo`, `--reveal`, shellcheck. Les trois premiers servent au défi final (injection
aveugle par `break.sh random` quand ce wrapper existera).

## Fichiers livrés avec la fiche

- `fiches/securite/01-durcissement-hote-linux/scripts/host-livre.sh` : prépare l'hôte « livré » (idempotent, `--undo`).
- `fiches/securite/01-durcissement-hote-linux/scripts/check.sh` : vérifie l'état attendu (ports, `sshd -T`, sudoers,
  `ufw status`, `aa-status`, score du service) ; sortie verte/rouge par contrôle, code de retour non nul si un contrôle échoue.
- `fiches/securite/01-durcissement-hote-linux/apparmor/usr.local.bin.lecteur` : profil AppArmor fourni.
- `fiches/securite/01-durcissement-hote-linux/systemd/lecteur.service` : unité d'exemple avant durcissement.
- Variante EL : `check.sh --el` et `host-livre.sh --el` (firewalld, SELinux) ; notes dans la fiche, pas de scripts séparés.

## Profil de lab et budget

- `linux-base` (8 vCPU / 16 Go / 180 Go, `labs/profiles/linux-base.yaml`) : deux VM utilisées, `linux-base-lx01`
  (Ubuntu 24.04, cible, `10.10.10.11`) et `linux-base-lx02` (Rocky 10.2, poste d'attaque pour `nc` et `ssh`, variante EL,
  `10.10.10.12`). Budget réel : 4 vCPU / 8 Go / 80 Go. Accès console Proxmox indispensable comme filet en cas de
  verrouillage SSH.
- Sans `lab up linux-base` : toute VM Ubuntu 24.04 fraîche (cloud-init) et une seconde machine sur le même réseau ; un
  conteneur ne suffit pas (systemd, AppArmor et nftables exigent une VM).
- Session de rédaction Claude : pas de VM, pas de systemd. Les commandes seront vérifiées sur la syntaxe (`sshd -T`,
  `visudo -cf`, `apparmor_parser -p`, `nft -c`, shellcheck) et marquées `[non testé : pas de VM dans la session de rédaction]`
  ailleurs ; validation en conditions réelles à ton retour de pratique (`prompts/08`).

## Points de vigilance `versions.yaml`

- `ubuntu_lts` 24.04 : `ssh` est **activé par socket** (`ssh.socket`) depuis 22.10 : `ListenAddress`/`Port` dans `sshd_config`
  sont ignorés tant que le socket est actif ; `systemctl restart ssh` ne suffit pas pour un changement de port
  (`systemctl daemon-reload` + `restart ssh.socket`). Un piège d'examen, à montrer en démo.
- 24.04 : `sshd_config` commence par `Include /etc/ssh/sshd_config.d/*.conf` et **la première valeur rencontrée gagne** :
  un drop-in `50-cloud-init.conf` posé par cloud-init peut forcer `PasswordAuthentication yes` ; nommer le nôtre `00-hardening.conf`.
- 24.04 : AppArmor 4.0 et `kernel.apparmor_restrict_unprivileged_userns=1` par défaut : explique des refus d'outils en
  espace de noms utilisateur (lien avec les conteneurs rootless, fiche 08). Mentionné, pas enseigné.
- 24.04 : `ufw` 0.36 génère des règles nftables (`nft list ruleset`) ; `iptables` n'est qu'une couche de compatibilité.
- 24.04 : systemd 255, `systemd-analyze security` disponible avec `--threshold` ; le score dépend de la version, la fiche donne
  un ordre de grandeur (« sous 5 ») pas une valeur exacte.
- Image cloud-init du lab : utilisateur `ubuntu` avec `sudo NOPASSWD: ALL` et clé SSH injectée ; la fiche ne doit pas le
  casser avant que l'apprenant ait sa propre clé et son groupe `ops`.
- `rocky_linux` 10.2 : SELinux, firewalld, `sshd` soumis aux politiques crypto système (`update-crypto-policies`) ;
  pas d'AppArmor. Variante seulement.
- `newer_lts` 26.04 : à la bascule, revérifier socket SSH, version d'AppArmor et de systemd ; rien d'autre ne devrait bouger.
- `compliance_as_code` 0.1.82 (optionnel) : vérifier que le contenu `ssg-ubuntu2404-ds.xml` et le profil CIS niveau 1
  serveur existent dans cette version avant de promettre un score OpenSCAP.

## `[lecture + simulation]`

- Rien pour cause de matériel.
- Lecture seule, avec renvoi : Secure Boot, TPM, `dm-verity` et OS immuables (Talos) comme réduction ultime de la surface
  d'attaque (`docs/roadmap.md` §4, fiche 10 et distribution Talos) ; `auditd` sur l'hôte (les audit logs Kubernetes sont la
  fiche 14) ; PAM `faillock` et politiques de mot de passe ; seccomp **par profil JSON** et AppArmor **par pod** (fiche 08).
- Encadré « à connaître pour l'examen » : les ports d'un nœud Kubernetes (6443, 2379-2380, 10250, 10257, 10259, 30000-32767)
  pour écrire les règles de pare-feu d'un control plane ou d'un worker ; les commandes `ufw` telles que les énoncés CKS les
  attendent.
- Trois à cinq flashcards couvrent ces points de lecture.

## Livrables attendus de la session de rédaction

- `fiches/securite/01-durcissement-hote-linux.md` (gabarit `templates/fiche.md`) et son dossier `scripts/`, `apparmor/`, `systemd/`
- `solutions/fiches/securite/01-durcissement-hote-linux.md` (3 indices puis correction)
- `break/securite/README.md` (une ligne) et `break/securite/01-*.sh` (4 scripts, 1 optionnel)
- `revision/flashcards/securite-01-durcissement-hote-linux.csv` (10 à 20 cartes)
- `templates/fiche.md` : deux lignes optionnelles de front matter (`etat_initial`, `verification`) et un paragraphe « état initial
  scripté » dans la section Liens, pour les fiches hors Kubernetes (arbitrage 3)
- mise à jour de `certifs/CKS/objectifs.md` §3 et §4, de `docs/prerequis.md` §6.2 (nœud `rédigé`), de `docs/plans/README.md`
  et de ce plan (`statut: réalisé`)

## Arbitrages validés (2026-10-02)

1. **Pare-feu** : `ufw` en chemin principal ; la démo fait lire le ruleset nftables généré (`nft list ruleset`) pour que
   LFCS-02-05 ne soit pas un saut dans le vide ; nftables natif en encadré de lecture.
2. **Variante Rocky 10** incluse en section optionnelle (firewalld, SELinux, `dnf`) : +1 h, `check.sh --el`,
   IDs RHCSA-10 et LFCS-01-08 cités dans le front matter de la fiche avec la mention « à confirmer ».
3. **Convention « état initial »** : `scripts/host-livre.sh` et `scripts/check.sh` dans le dossier de la fiche, généralisée
   dans `templates/fiche.md` par la PR du chapitre (lignes optionnelles de front matter).
4. **OpenSCAP / ComplianceAsCode** : reporté à la fiche 06 (CIS benchmark), qui réunira kube-bench côté cluster et
   OpenSCAP côté hôte ; cette fiche reste à 4 h hors variante.
