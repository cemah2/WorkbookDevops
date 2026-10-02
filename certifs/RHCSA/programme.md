---
code: RHCSA
title: "Red Hat Certified System Administrator (EX200)"
issuer: "Red Hat"
version: "Red Hat Enterprise Linux 10"
exam_format: "pratique, sur machine, ~3 h, en centre ou à distance"
weighted_domains: false
golden_kubestronaut: false
source_url: "https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam"
source_file: "programmes-certifications/autres/RHCSA_EX200.md (retranscription)"
license: "Objectifs d'examen publics, retranscrits depuis la page officielle ; texte © éditeur, usage de référence"
retrieved: 2026-09-28
converted: 2026-10-02
status: "à revérifier lors de la veille (voir LISEZMOI)"
---

# RHCSA — Red Hat Certified System Administrator (EX200)

Programme officiel retranscrit tel quel (en anglais). Les identifiants `RHCSA-DD-CC` sont stables et servent au mapping objectifs → chapitres (`objectifs.md`).

## Notes

- Version : « This exam is based on Red Hat Enterprise Linux 10 » → lab sur Rocky Linux 10 / AlmaLinux 10.

## Domaines

| ID | Domaine |
|---|---|
| RHCSA-01 | [Understand and use essential tools](#rhcsa-01--understand-and-use-essential-tools) |
| RHCSA-02 | [Manage software](#rhcsa-02--manage-software) |
| RHCSA-03 | [Create simple shell scripts](#rhcsa-03--create-simple-shell-scripts) |
| RHCSA-04 | [Operate running systems](#rhcsa-04--operate-running-systems) |
| RHCSA-05 | [Configure local storage](#rhcsa-05--configure-local-storage) |
| RHCSA-06 | [Create and configure file systems](#rhcsa-06--create-and-configure-file-systems) |
| RHCSA-07 | [Deploy, configure, and maintain systems](#rhcsa-07--deploy-configure-and-maintain-systems) |
| RHCSA-08 | [Manage basic networking](#rhcsa-08--manage-basic-networking) |
| RHCSA-09 | [Manage users and groups](#rhcsa-09--manage-users-and-groups) |
| RHCSA-10 | [Manage security](#rhcsa-10--manage-security) |

## Compétences

### RHCSA-01 — Understand and use essential tools

- **RHCSA-01-01** Access a shell prompt and issue commands with correct syntax
- **RHCSA-01-02** Use input-output redirection (>, >>, |, 2>, etc.)
- **RHCSA-01-03** Use grep and regular expressions to analyze text
- **RHCSA-01-04** Access remote systems using SSH
- **RHCSA-01-05** Log in and switch users in multi-user targets
- **RHCSA-01-06** Archive, compress, unpack, and uncompress files using tar, gzip, and bzip2
- **RHCSA-01-07** Create and edit text files
- **RHCSA-01-08** Create, delete, copy, and move files and directories
- **RHCSA-01-09** Create hard and soft links
- **RHCSA-01-10** List, set, and change standard ugo/rwx permissions
- **RHCSA-01-11** Locate, read, and use system documentation including man, info, and files in /usr/share/doc

### RHCSA-02 — Manage software

- **RHCSA-02-01** Configure access to RPM repositories
- **RHCSA-02-02** Install and remove RPM software packages
- **RHCSA-02-03** Configure access to Flatpak repositories
- **RHCSA-02-04** Install and remove Flatpak software packages

### RHCSA-03 — Create simple shell scripts

- **RHCSA-03-01** Conditionally execute code (use of: if, test, [], etc.)
- **RHCSA-03-02** Use Looping constructs (for, etc.) to process file, command line input
- **RHCSA-03-03** Process script inputs ($1, $2, etc.)
- **RHCSA-03-04** Processing output of shell commands within a script

### RHCSA-04 — Operate running systems

- **RHCSA-04-01** Boot, reboot, and shut down a system normally
- **RHCSA-04-02** Boot systems into different targets manually
- **RHCSA-04-03** Interrupt the boot process in order to gain access to a system
- **RHCSA-04-04** Identify CPU/memory intensive processes and kill processes
- **RHCSA-04-05** Adjust process scheduling
- **RHCSA-04-06** Manage tuning profiles
- **RHCSA-04-07** Locate and interpret system log files and journals
- **RHCSA-04-08** Preserve system journals
- **RHCSA-04-09** Start, stop, and check the status of network services
- **RHCSA-04-10** Securely transfer files between systems

### RHCSA-05 — Configure local storage

- **RHCSA-05-01** List, create, and delete partitions on GPT disks
- **RHCSA-05-02** Create and remove physical volumes
- **RHCSA-05-03** Assign physical volumes to volume groups
- **RHCSA-05-04** Create and delete logical volumes
- **RHCSA-05-05** Configure systems to mount file systems at boot by universally unique ID (UUID) or label
- **RHCSA-05-06** Add new partitions and logical volumes, and swap to a system non-destructively

### RHCSA-06 — Create and configure file systems

- **RHCSA-06-01** Create, mount, unmount, and use VFAT, ext4, and XFS file systems
- **RHCSA-06-02** Mount and unmount network file systems using NFS
- **RHCSA-06-03** Configure autofs
- **RHCSA-06-04** Extend existing logical volumes
- **RHCSA-06-05** Diagnose and correct file permission problems

### RHCSA-07 — Deploy, configure, and maintain systems

- **RHCSA-07-01** Schedule tasks using at, cron and systemd timer units
- **RHCSA-07-02** Start and stop services and configure services to start automatically at boot
- **RHCSA-07-03** Configure systems to boot into a specific target automatically
- **RHCSA-07-04** Configure time service clients
- **RHCSA-07-05** Install and update software packages from Red Hat Content Delivery Network, a remote repository, or from the local file system
- **RHCSA-07-06** Modify the system bootloader

### RHCSA-08 — Manage basic networking

- **RHCSA-08-01** Configure IPv4 and IPv6 addresses
- **RHCSA-08-02** Configure hostname resolution
- **RHCSA-08-03** Configure network services to start automatically at boot
- **RHCSA-08-04** Restrict network access using firewalld and firewall-cmd

### RHCSA-09 — Manage users and groups

- **RHCSA-09-01** Create, delete, and modify local user accounts
- **RHCSA-09-02** Change passwords and adjust password aging for local user accounts
- **RHCSA-09-03** Create, delete, and modify local groups and group memberships
- **RHCSA-09-04** Configure privileged access

### RHCSA-10 — Manage security

- **RHCSA-10-01** Configure firewall settings using firewall-cmd/firewalld
- **RHCSA-10-02** Manage default file permissions
- **RHCSA-10-03** Configure key-based authentication for SSH
- **RHCSA-10-04** Set enforcing and permissive modes for SELinux
- **RHCSA-10-05** List and identify SELinux file and process context
- **RHCSA-10-06** Restore default file contexts
- **RHCSA-10-07** Manage SELinux port labels
- **RHCSA-10-08** Use Boolean settings to modify system SELinux settings
