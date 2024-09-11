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

echo "Please install Karabiner-DriverKit-VirtualHIDDevice"
open https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/tag/v4.3.0

# echo "Please install Kanata"
# open https://github.com/jtroo/kanata/releases/tag/v1.6.1

# Nix
sh <(curl -L https://nixos.org/nix/install)
echo "Restart shell to enable Nix"
exit 0
