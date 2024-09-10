.PHONY: home-manager

CONFIG_DIR := $(HOME)/.config

# NIX doesn't support symlinks, so we need to point to the actual directory
current_dir := $(shell pwd)
NIX_CONFIG_DIR := $(current_dir)/configs/nix/.config/nix


install: init nix-install symlinks after-install
update: nix-rebuild symlinks after-install
upgrade: nix-upgrade symlinks after-install

init:
	utils/init.sh
symlinks:
	utils/symlinks.sh
after-install: 
	utils/after-install.sh

#
# Nix
#

nix: nix-rebuild
nix-rebuild:
	darwin-rebuild switch --flake $(NIX_CONFIG_DIR) 

nix-install:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	render-user-nix

	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
		&& nix run nix-darwin -- switch --flake $(NIX_CONFIG_DIR) 

	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
		&& npm config set prefix "${HOME}/.cache/npm/global" \
		&& mkdir -p "${HOME}/.cache/npm/global" \
		&& npm install -g -U pnpm neovim

	@echo "Restart shell to enable Nix"

nix-update:
	nix run nix-darwin -- switch --flake $(NIX_CONFIG_DIR)

nix-upgrade:
	nix flake update $(NIX_CONFIG_DIR)
	nix run nix-darwin -- switch --flake $(NIX_CONFIG_DIR)

