#!/usr/bin/env bash

set -euo pipefail

# Autolaunch
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Hammerspoon.app", hidden:true}' >/dev/null

# enable Keyboard remapping on system load
launchctl unload -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2 &>/dev/null || true
launchctl load -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist

/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
