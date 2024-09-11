#!/usr/bin/env bash

set -euo pipefail

# Autolaunch
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Hammerspoon.app", hidden:true}' >/dev/null

# enable Keyboard remapping on system load
launchctl unload -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2 &>/dev/null || true
launchctl load -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist

/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate

# Nix
nix run nix-darwin -- switch --flake "$PWD/configs/nix/.config/nix"

npm config set prefix "${HOME}/.cache/npm/global" &&
	mkdir -p "${HOME}/.cache/npm/global" &&
	npm install -g -U pnpm neovim
