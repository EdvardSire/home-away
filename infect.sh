#!/usr/bin/env bash
set -euo pipefail



REMOTE="${1:?set '$1' to remote e.g. \`bash infect.sh forge\`}"
REPO_URL="https://github.com/EdvardSire/home-away.git"
DEST_DIR="repos"

read -r -p "Continue? The script is rough [y/N] " a && [[ $a =~ ^[Yy]([Ee][Ss])?$ ]] || exit 1

ssh -o BatchMode=yes \
    -o StrictHostKeyChecking=accept-new \
    "$REMOTE" bash -s -- \
    "$REPO_URL" "$DEST_DIR" <<'REMOTE_SCRIPT'
set -euo pipefail

REPO_URL="$1"
DEST_DIR="$2"
REPO_NAME="home-away"


echo "==> Checking Ubuntu"
source /etc/os-release
if [[ "${ID:-}" != "ubuntu" ]]; then
  echo "ERROR: Expected Ubuntu, got ID='${ID:-unknown}' (NAME='${NAME:-unknown}')."
  exit 3
fi


echo "==> Ensuring curl + git"
command -v curl >/dev/null 2>&1 || { echo "curl is not installed"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git is not installed"; exit 1; }


echo "==> single-user NIX setup"
USER_NIX="$HOME/.nix-profile/bin/nix"
SYSTEM_NIX="/nix/var/nix/profiles/default/bin/nix"

if [ -x "$USER_NIX" ] || [ -x "$SYSTEM_NIX" ]; then
  echo "Nix already installed."
else
  echo "Installing Nix (no-daemon)"
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
  # TODO: setup path
fi


echo "==> NIX config: nix-command and flakes"
mkdir -p "$HOME/.config/nix"
if [ ! -f "$HOME/.config/nix/nix.conf" ]; then
  echo "extra-experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
fi


echo "==> Cloning repo"
mkdir -p "$HOME/$DEST_DIR"
pushd "$HOME/$DEST_DIR"
[[ -d "$HOME/$DEST_DIR/$REPO_NAME/.git" ]] || git clone $REPO_URL $REPO_NAME
popd


echo "==> Install nix profile"
pushd "$HOME/$DEST_DIR/$REPO_NAME"
nix profile add .
popd


echo "==> Done"
REMOTE_SCRIPT
