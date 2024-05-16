#!/usr/bin/env bash

set -euo pipefail

mkdir -p ~/.zfunc/

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Xcode and command line tool
sudo xcode-select --switch /Applications/Xcode.app


# Install apps
brew install --cask \
  hammerspoon `# Keyboard customizer & Automation` \
  fluor `# Change the behavior of the fn keys depending on the active application` \
  mos `# Smooths scrolling and set mouse scroll directions independently` \
  raycast 1password/tap/1password-cli `# Spotlight replacement + plugin fro 1password` \
  arc `# browser` \
  force-paste gitup slack \
  raycast 1password/tap/1password-cli \
  postman \
  amethyst  `# window manager` \
  kitty \
  obsidian \

# Install shell utils

brew tap beeftornado/rmtree
brew install \
 openssl gettext xz readline cmake gcc cffi \

# NIX home-manager
brew install \
  mise poetry cookiecutter ruff \
  go \
  git curl wget gnupg rsync lazygit pre-commit \
  tmux ical-buddy \
  starship stow antigen \
  neovim fzf ripgrep shfmt hadolint \
  jq coreutils bat eza diff-so-fancy \
  kubectl minikube hashicorp/tap/terraform terragrunt awscli \
  btop tldr \
  sqlc \
  ariga/tap/atlas \

# Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

git clone git@github.com:ohmyzsh/ohmyzsh.git ~/.config/oh-my-zsh

# Copy all config files
mkdir ~/.config
stow --target ~/.config .


# PostgresQL
brew install libpq
brew link --force libpq

# Redis-cli
brew tap ringohub/redis-cli
brew install redis-cli

brew tap heroku/brew && brew install heroku

# Tmux Plugin Manager (TPM)
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Python
# TODO: revise, maybe completely switch to home-manager
mise use --global python@3.11
curl -sSL https://install.python-poetry.org | python3 -

curl -sSf https://rye-up.com/get | bash
rye self completion -s zsh > ~/.zfunc/_rye

# GO
go install github.com/a-h/templ/cmd/templ@latest
go install github.com/melkeydev/go-blueprint@latest

# Ollama
brew install ollama
brew services start ollama
ollama pull deepseek-coder

# SSH
ssh-keygen

# Fix .zshrc
if ! grep -qxF ". \$HOME/.config/zsh/profile" ~/.zshrc; then
  echo ". \$HOME/.config/zsh/profile" >> ~/.zshrc
fi
