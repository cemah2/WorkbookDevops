#!/usr/bin/env bash
# break/gitops/01-argocd-repo-credentials.sh — fiche 01 Argo CD.
# Remplace la clé SSH privée du secret de dépôt du lab par une clé fraîche et inconnue du serveur Git.
# Usage : ./01-argocd-repo-credentials.sh [--undo|--reveal]
# Variables : ARGOCD_NS (défaut argocd), REPO_MATCH (sous-chaîne de l'URL du dépôt, défaut gitops-demo).
set -euo pipefail
ARGOCD_NS="${ARGOCD_NS:-argocd}"
REPO_MATCH="${REPO_MATCH:-gitops-demo}"
BACKUP="break-01-repo-credentials-backup"

reveal() {
  cat <<'TXT'
Panne : la clé privée SSH stockée dans le secret de dépôt (label argocd.argoproj.io/secret-type=repository) a été
remplacée par une clé que le serveur Git ne connaît pas. Le dépôt public (guestbook) n'est pas concerné.
Symptôme : l'Application qui utilise ce dépôt passe en Unknown avec une condition ComparisonError qui parle
d'authentification ou de permission refusée ; `argocd repo list` montre le dépôt en échec de connexion.
Diagnostic : `argocd app get lab-demo --refresh`, `argocd repo list`, logs de argocd-repo-server.
Correction : réenregistrer le dépôt (`argocd repo add … --ssh-private-key-path … --upsert`) ou `--undo`,
qui restaure la clé d'origine depuis le secret de sauvegarde break-01-repo-credentials-backup.
TXT
}

find_secret() {
  kubectl -n "$ARGOCD_NS" get secret -l argocd.argoproj.io/secret-type=repository -o json \
    | jq -r --arg m "$REPO_MATCH" '.items[] | select((.data.url // "" | @base64d) | contains($m)) | .metadata.name' \
    | head -1
}

case "${1:-}" in
  --reveal) reveal ;;
  --undo)
    if ! kubectl -n "$ARGOCD_NS" get secret "$BACKUP" >/dev/null 2>&1; then
      echo "undo: aucune sauvegarde $BACKUP, rien à faire"; exit 0
    fi
    name=$(kubectl -n "$ARGOCD_NS" get secret "$BACKUP" -o jsonpath='{.data.secretName}' | base64 -d)
    key=$(kubectl -n "$ARGOCD_NS" get secret "$BACKUP" -o jsonpath='{.data.sshPrivateKey}')
    kubectl -n "$ARGOCD_NS" patch secret "$name" --type merge -p "{\"data\":{\"sshPrivateKey\":\"$key\"}}"
    kubectl -n "$ARGOCD_NS" delete secret "$BACKUP"
    echo "undo: clé SSH d'origine restaurée dans $name"
    ;;
  "")
    if kubectl -n "$ARGOCD_NS" get secret "$BACKUP" >/dev/null 2>&1; then
      echo "panne déjà injectée (sauvegarde $BACKUP présente)"; exit 0
    fi
    name=$(find_secret)
    if [ -z "$name" ]; then
      echo "aucun secret de dépôt dont l'URL contient '$REPO_MATCH' (variable REPO_MATCH)" >&2; exit 1
    fi
    key=$(kubectl -n "$ARGOCD_NS" get secret "$name" -o jsonpath='{.data.sshPrivateKey}')
    if [ -z "$key" ]; then
      echo "le secret $name n'a pas de sshPrivateKey : dépôt non SSH ?" >&2; exit 1
    fi
    kubectl -n "$ARGOCD_NS" create secret generic "$BACKUP" \
      --from-literal=secretName="$name" --from-literal=sshPrivateKey="$(printf '%s' "$key" | base64 -d)"
    tmp=$(mktemp -d); ssh-keygen -q -t ed25519 -N '' -f "$tmp/bogus"
    bogus=$(base64 -w0 < "$tmp/bogus"); rm -rf "$tmp"
    kubectl -n "$ARGOCD_NS" patch secret "$name" --type merge -p "{\"data\":{\"sshPrivateKey\":\"$bogus\"}}"
    echo "panne injectée : clé SSH remplacée dans $name (--reveal pour l'explication, --undo pour réparer)"
    ;;
  *) echo "usage: $0 [--undo|--reveal]" >&2; exit 2 ;;
esac
