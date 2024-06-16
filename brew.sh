#!/usr/bin/env bash

set -euo pipefail

mkdir -p ~/.zfunc/

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Xcode and command line tool
sudo xcode-select --switch /Applications/Xcode.app

# Install apps
brew install --cask \
	hammerspoon \
	fluor \
	mos \
	raycast \
	1password/tap/1password-cli \
	arc \
	force-paste \
	gitup \
	slack \
	zoom \
	raycast \
	1password/tap/1password-cli \
	postman \
	amethyst \
	kitty \
	obsidian \
	open-video-downloader \
	iina \
	monitorcontrol \
	fantastical \
	alfred

# Install shell utils

brew tap beeftornado/rmtree
brew install \
	openssl gettext xz readline cmake gcc cffi

brew install \
	mise \
	poetry \
	cookiecutter \
	ruff \
	go \
	git \
	curl \
	wget \
	gnupg \
	rsync \
	lazygit \
	lazydocker \
	pre-commit \
	tmux \
	ical-buddy \
	stow \
	antigen \
	neovim \
	fzf \
	ripgrep \
	luarocks \
	shfmt \
	shellharden \
	hadolint \
	pgformatter \
	jq \
	coreutils \
	bat \
	eza \
	diff-so-fancy \
	kubectl \
	minikube \
	hashicorp/tap/terraform \
	terragrunt \
	awscli \
	btop \
	tldr \
	sqlc \
	ariga/tap/atlas \
	languagetool

# nvim fzf: Installing dependencies using Homebrew
brew install fzf bat ripgrep the_silver_searcher perl universal-ctags

# Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# Copy all config files
mkdir ~/.config
stow --target ~/.config .

# PostgresQL
brew install libpq
brew link --force libpq

# Redis-cli
brew tap ringohub/redis-cli
brew install redis-cli

# Tmux Plugin Manager (TPM)
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Python
# TODO: revise, maybe completely switch to home-manager
mise use --global python@3.11
curl -sSL https://install.python-poetry.org | python3 -

curl -sSf https://rye-up.com/get | bash
rye self completion -s zsh >~/.zfunc/_rye

# GO
go install github.com/a-h/templ/cmd/templ@latest
go install github.com/melkeydev/go-blueprint@latest

# Ollama
brew install ollama
brew services start ollama
ollama pull deepseek-coder

# SSH
ssh-keygen

# projen
npm i -g projen
projen completion >~/.zfunc/_projen

# Autolaunch
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Hammerspoon.app", hidden:true}' >/dev/null

echo "Please install Karabiner-DriverKit-VirtualHIDDevice"
open https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases
/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate

echo "Please install Kanata"
open https://github.com/jtroo/kanata/releases
