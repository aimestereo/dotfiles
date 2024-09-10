# Setup MY environment

Scripts and configuration to initialize new MacOS.

```shell
make install
```

On interactive step:

- in open browser download and install PyCharm Nerd Font and install it
- verify, that it works (will require reboot kitty)
- open tmux and install plugins via TPM `Alt+a + I`

# Kitty + Nerd Font

Check that kitty know about specified font

```shell
kitty +list-fonts --psnames | grep Nerd
```

verify that desired font is used by kitty

```shell
kitty --debug-font-fallback
```

# MOS

it's installed previously with brew

- Smooth and Reverse scroolling should be on
- iTerm2 should be added to exclusion for smooth scrolling https://github.com/Caldis/Mos/issues/82

Disable useless keyboard shortcuts:

- Search/open man Page in terminal
- Chinese conversions and so on
- Spotlight (Raycast will do the job)

Disable/change the key binding for the Search man Page Index in Terminal feature:
Open Apple menu | System Preferences | Keyboard | Shortcuts | Services
Disable Search man Page Index in Terminal (or change the shortcut)
Use Search Everywhere (Shift+Shift) shortcut instead of Find Action (Cmd+Shift+A).

# Configure Login items:

- Add such apps as Hammerspoon, (not Karabiner, it's run as background job), Mos
- Check background jobs and disable useless staff, i.e. Google Updater, TeamViewer

# SSH

- [x] should be done by script: [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

- add new ssh .pub key to Github, DigitalOcean (VPN)

# Keyboard layout build/flash

brew install --cask qmk-toolbox
brew install qmk/qmk/qmk
brew install avr-gcc
brew install armmbed/formulae/arm-none-eabi-gcc
