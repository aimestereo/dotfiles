# TODO: think about [brewfile](https://github.com/Homebrew/homebrew-bundle#usage)

- Install Xcode and command line tool
  sudo xcode-select --switch /Applications/Xcode.app

- Install [Homebrew](https://brew.sh)

- Install apps

```shell
brew install --cask \
  karabiner-elements hammerspoon `# Keyboard customizer & Automation` \
  fluor `# Change the behavior of the fn keys depending on the active application` \
  mos `# Smooths scrolling and set mouse scroll directions independently` \
  force-paste gitup sourcetree visual-studio-code iterm2 teamviewer telegram slack \
  hadolint `# Dockerfile linting` \
  shfmt `# for VSCod shell-format` \
  android-file-transfer \
  raycast 1password/tap/1password-cli `# Spotlight replacement + plugin fro 1password` \
  arc `# browser` \
  postman \
  vlc \
  amethyst  `# window manager` \
  diff-so-fancy

```

Amethyst
disable MacOS settings Mission Control: "Automatically rearrange Spaces based on most recent use"

- Install shell env

```shell
brew install \
 gcc openssl \
 python psql wget git cookiecutter \
 awscli \
 aws/tap/aws-sam-cli `# PyCharm Extention - AWS Serverless Application Model Command Line Interface (AWS SAM CLI)` \
 neovim \
 ripgrep `# dependency of telescope (nvim plug)` \
 tmux fzf \
 jq \
 hatch `# like poetry` \
 ngrok \
 rsync \
 pnpm yarn \
 vercel-cli \
 minikube kubectl `# Kubernetes` \
 pre-commit \
 pantsbuild/tap/pants  `# Monorepo manager`


# Copy
* .zshenv, .zshrc .zprofile
* ~/.config/zellij/config.kdl
* $nu.config-path

# PostgresQL
brew install libpq
brew link --force libpq

# Java
brew install openjdk

# Redis-cli
brew tap ringohub/redis-cli
brew install redis-cli

brew tap heroku/brew && brew install heroku


# Rust

curl https://sh.rustup.rs -sSf | sh
cargo install sccache
RUSTC_WRAPPER=sccache cargo install --locked \
 cargo-cache cargo-update \
 exa bat mprocs ripgrep irust procs \
 nu zellij warp starship rtx-cli

RUSTC_WRAPPER=sccache cargo install \
 coreutils --locked --features macos

RUSTC_WRAPPER=sccache cargo install \
 cargo install taplo-cli --locked --features lsp

# RUSTC_WRAPPER=sccache cargo install-update -a


# Python
rtx use --global python@3.10
curl -sSL https://install.python-poetry.org | python3 -

```

# terraform/terragrunt

```shell
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -help  # to verify installation

brew install terragrunt
```

# Warp teminal

- Bigger font (16)
- set Left Alt as Meta key
- install themes from https://github.com/catppuccin/warp

# iTerm2

brew tap homebrew/cask-fonts && brew install --cask font-JetBrains-Mono-nerd-font

Only changes in Profiles Tab:

- Terminal -> Scrollback lines: increas at least to 10_000
- Window -> Style: Full-Width Top of Screen
- Kyes -> Window -> uncheck "Force this profile to always open in a new window, never in tab"
- Kyes -> Hotkey Window -> Configure Hotkey Window -> Hotkey: Shift + Control + Option + Command + F (Floating Window)
- Preferences -> Profiles -> Keyboard and checking "Use Option as +Esc" - Meta key

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

- Add such apps as Messages, Telergram, Hammerspoon, (not Karabiner, it's run as background job), Flour, Mos, iTerm, Spectacle, OpenVPN Connect
- Check background jobs and disable useless staff, i.e. Google Updater, TeamViewer

# Chrome

in User-Agent Switcher set Custom Mode:

```json
{
  "statusmoney.com": "statusmoney-team-aimestereo"
}
```

# SSH

- [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

- add new ssh .pub key to Github, DigitalOcean (VPN)

# VPN

```shell
ssh do-vpn
# add new user/pass
# download and add vpn profile to MacOS
```

# Keyboard

brew install --cask qmk-toolbox
brew install qmk/qmk/qmk
brew install avr-gcc
brew install armmbed/formulae/arm-none-eabi-gcc
