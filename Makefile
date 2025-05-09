.PHONY: home-manager

CONFIG_DIR := $(HOME)/.config

# NIX doesn't support symlinks, so we need to point to the actual directory
current_dir := $(shell pwd)
NIX_CONFIG_DIR := $(current_dir)/configs/nix/.config/nix


install:
	utils/install.sh
	@echo "Restart shell and run 'make after-install'"
after-install: symlinks
	utils/after-install.sh

update: nix-rebuild symlinks after-install
upgrade: nix-upgrade symlinks after-install

symlinks:
	utils/symlinks.sh

#
# Nix
#

nix: nix-rebuild
nix-rebuild:
	darwin-rebuild switch --flake $(NIX_CONFIG_DIR) 

nix-upgrade: nix-update-lockfile nix-update
nix-update-lockfile:
	nix flake update --flake $(NIX_CONFIG_DIR)
nix-update:
	nix run nix-darwin \
		--extra-experimental-features 'nix-command flakes' \
		-- switch --flake $(NIX_CONFIG_DIR)

nix-clean:
	nix-store --gc
	sudo nix-collect-garbage -d

