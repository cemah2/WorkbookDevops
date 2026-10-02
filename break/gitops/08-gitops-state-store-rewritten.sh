#!/usr/bin/env bash
# break/gitops/08-gitops-state-store-rewritten.sh — fiche 08 OpenGitOps.
# À lancer SUR LE SERVEUR GIT (en tant que git, ou root avec sudo -u git). Désactive l'immutabilité du dépôt bare
# et réécrit l'historique de main en retirant le dernier commit, comme un `push --force` qui serait passé.
# Usage : BARE_REPO=/srv/git/gitops-principes.git ./08-gitops-state-store-rewritten.sh [--undo|--reveal]
# Variables : BARE_REPO (obligatoire, doit être sous /srv/git/), BRANCH (main).
set -euo pipefail
BARE_REPO="${BARE_REPO:-}"
BRANCH="${BRANCH:-main}"
SAVED="refs/break/08-saved"

reveal() {
  cat <<'TXT'
Panne : receive.denyNonFastForwards et receive.denyDeletes ont été passés à false sur le dépôt bare, puis la
branche main a été reculée d'un commit (git update-ref, l'équivalent côté serveur d'un push --force accepté).
Le commit retiré est gardé dans refs/break/08-saved et dans le reflog du serveur si core.logAllRefUpdates est actif.
Symptôme : au prochain pull, Argo CD déploie l'état d'avant (une version ou une fonctionnalité disparaît) sans
qu'aucun commit n'apparaisse dans `git log` ; `argocd app history` cite une révision que `git show` ne trouve plus
dans un clone frais ; `argocd app rollback` vers cette révision échoue.
Principe violé : « Versioned and Immutable » (le state store n'a plus d'historique complet) ; le terme en jeu
est State Store, pas Drift : le cluster est fidèle à Git, c'est Git qui a menti.
Diagnostic : `git fetch && git log --oneline origin/main` dans un clone, `git -C <bare> reflog show main` et
`git -C <bare> config --get receive.denyNonFastForwards` sur le serveur, `argocd app get demo-pull` (revision).
Correction : restaurer la référence depuis le reflog ou refs/break/08-saved (ou --undo), remettre les deux options
à true, puis faire un commit vide « audit : historique restauré » pour laisser une trace.
TXT
}

guard() {
  if [ -z "$BARE_REPO" ]; then echo "BARE_REPO est obligatoire (ex. /srv/git/gitops-principes.git)" >&2; exit 2; fi
  case "$BARE_REPO" in /srv/git/*) ;; *) echo "refus : BARE_REPO doit être sous /srv/git/ (garde-fou)" >&2; exit 2 ;; esac
  if [ "$(git -C "$BARE_REPO" rev-parse --is-bare-repository 2>/dev/null)" != "true" ]; then
    echo "$BARE_REPO n'est pas un dépôt bare" >&2; exit 2
  fi
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    guard
    if ! git -C "$BARE_REPO" show-ref --verify --quiet "$SAVED"; then
      echo "undo: aucune sauvegarde $SAVED, rien à faire"; exit 0
    fi
    git -C "$BARE_REPO" update-ref "refs/heads/$BRANCH" "$SAVED"
    git -C "$BARE_REPO" update-ref -d "$SAVED"
    git -C "$BARE_REPO" config receive.denyNonFastForwards true
    git -C "$BARE_REPO" config receive.denyDeletes true
    echo "undo: $BRANCH restaurée sur $(git -C "$BARE_REPO" rev-parse --short "$BRANCH"), immutabilité remise"
    ;;
  "")
    guard
    if git -C "$BARE_REPO" show-ref --verify --quiet "$SAVED"; then
      echo "panne déjà injectée (sauvegarde $SAVED présente)"; exit 0
    fi
    if [ "$(git -C "$BARE_REPO" rev-list --count "$BRANCH" 2>/dev/null || echo 0)" -lt 2 ]; then
      echo "il faut au moins deux commits sur $BRANCH" >&2; exit 1
    fi
    git -C "$BARE_REPO" update-ref "$SAVED" "$BRANCH"
    git -C "$BARE_REPO" config receive.denyNonFastForwards false
    git -C "$BARE_REPO" config receive.denyDeletes false
    git -C "$BARE_REPO" update-ref "refs/heads/$BRANCH" "$BRANCH~1"
    echo "panne injectée : $BRANCH reculée d'un commit, immutabilité coupée (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: BARE_REPO=<bare> $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
