#!/bin/bash
set -euo pipefail

# ------------------------------
# Configurable variables
# ------------------------------

# 1Password configuration
OP_DOMAIN="${1PASSWORD_DOMAIN:-my.1password.eu}"
echo "Using 1Password domain: $OP_DOMAIN"
read -rp "Enter your 1Password email address: " OP_EMAIL

# 1Password item identifiers
OP_GITHUB_TOKEN_ITEM="Dotfiles/GitHub Token/token"
OP_SSH_KEY_ITEM="Dotfiles/SSH Key/private key"

# Script URL to install dotfiles
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/infratron-io/dotfiles/refs/heads/master/scripts/install_dotfiles.sh"

# ------------------------------
# Helper functions
# ------------------------------

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_op_cli() {
  echo "Installing 1Password CLI..."
  if command_exists brew; then
    brew install 1password-cli
  elif command_exists apt; then
    sudo apt update && sudo apt install -y 1password-cli
  elif command_exists yum; then
    sudo yum install -y 1password-cli
  else
    echo "Unsupported package manager. Please install 1Password CLI manually."
    exit 1
  fi
}

# ------------------------------
# Main setup
# ------------------------------

# Install 1Password CLI if needed
if ! command_exists op; then
  install_op_cli
fi

# Sign in to 1Password
if ! op account list | grep -q "$OP_DOMAIN"; then
  echo "Signing in to 1Password..."
  eval "$(op signin $OP_DOMAIN $OP_EMAIL)"
fi

# Retrieve SSH private key and add to agent (needed to curl private GitHub content)
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  echo "Fetching SSH key from 1Password..."
  mkdir -p ~/.ssh
  op read "op://$OP_SSH_KEY_ITEM" > ~/.ssh/id_ed25519
  chmod 600 ~/.ssh/id_ed25519
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
fi

# Run dotfiles install script from remote private repo
echo "Downloading and executing dotfiles install script..."
curl -sSL -H "Authorization: Bearer $(op read \"op://$OP_GITHUB_TOKEN_ITEM\")" "$INSTALL_SCRIPT_URL" | bash
