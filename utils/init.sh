#!/usr/bin/env bash

set -euo pipefail

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Xcode and command line tool
sudo xcode-select --switch /Applications/Xcode.app

# Install shell utils

# Tmux Plugin Manager (TPM)
# todo: marry with nix
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Autolaunch
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Hammerspoon.app", hidden:true}' >/dev/null

echo "Please install Karabiner-DriverKit-VirtualHIDDevice"
open https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/tag/v4.3.0
/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate

echo "Please install Kanata"
open https://github.com/jtroo/kanata/releases/tag/v1.6.1
