#!/usr/bin/env bash

set -euo pipefail

# Install homebrew
git config --global http.version HTTP/1.1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install shell utils

# Tmux Plugin Manager (TPM)
# todo: marry with nix
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# echo "Please install Kanata"
# open https://github.com/jtroo/kanata/releases/tag/v1.8.1
# downloaded and copied to configs/kanata/.local/bin/kanata_macos_arm64

# Nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
echo "Restart shell to enable Nix"
exit 0

# Nix: add Home Manager [darwin]
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
