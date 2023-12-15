# Setup MY environment

Scripts and configuration to initialize new MacOS.

## Prerequisites

- Install [Homebrew](https://brew.sh)

## Install

### Homebrew apps

Run `./setup.sh`

## Post Install

### Environment

Copy

- .zshenv, .zshrc .zprofile
- ~/.config/zellij/config.kdl
- $nu.config-path

### Amethyst

disable MacOS settings Mission Control: "Automatically rearrange Spaces based on most recent use"

# Neovim

```shell
git clone git@github.com:aimestereo/kickstart.nvim.git ~/.config/nvim
```

## Alternatives:

Manual
Package manager packer (maybe lazy): https://github.com/wbthomason/packer.nvim
https://github.com/ThePrimeagen/init.lua/tree/master

Packed with batteries: NvChad, AstroNvim

# MOS

it's installed previously with brew

- Smooth and Reverse scroolling should be on
- iTerm2 should be added to exclusion for smooth scrolling https://github.com/Caldis/Mos/issues/82

# Configure Keyboard automations

- In "Karabiner-Elements" -> "Simple Modification" -> "For all devices" set "caps_lock" -> "f18"
- Check result in "Karabiner-Viewer"
- Copy Hammerspoon config to `.hammerspoon/` (.lua scripts including `.init.lua`).
- Reload Hammerspoon config.
- Test it by twice clicking `Control` to show Help and `CapsLock + S` to open "Slack".

Disable useless keyboard shortcuts:

- Search/open man Page in terminal
- Chinese conversions and so on
- Spotlight (Raycast will do the job)

Disable/change the key binding for the Search man Page Index in Terminal feature:
Open Apple menu | System Preferences | Keyboard | Shortcuts | Services
Disable Search man Page Index in Terminal (or change the shortcut)
Use Search Everywhere (Shift+Shift) shortcut instead of Find Action (Cmd+Shift+A).

# Configure Login items:

- Add such apps as Messages, Hammerspoon, (not Karabiner, it's run as background job), Flour, Mos, iTerm, Spectacle, OpenVPN Connect
- Check background jobs and disable useless staff, i.e. Google Updater, TeamViewer

# SSH

- [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

- add new ssh .pub key to Github, DigitalOcean (VPN)

# VPN

```shell
ssh do-vpn
# add new user/pass
# download and add vpn profile to MacOS
```

# Keyboard layout build/flash

brew install --cask qmk-toolbox
brew install qmk/qmk/qmk
brew install avr-gcc
brew install armmbed/formulae/arm-none-eabi-gcc
