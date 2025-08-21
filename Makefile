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
nix-update-lockfile:
	(MAKE) -C $(NIX_CONFIG_DIR) update-lockfile

nix-darwin:
	(MAKE) -C $(NIX_CONFIG_DIR) darwin
nix-darwin-run:
	(MAKE) -C $(NIX_CONFIG_DIR) darwin-run

nix-arch:
	(MAKE) -C $(NIX_CONFIG_DIR) arch

nix-clean:
	(MAKE) -C $(NIX_CONFIG_DIR) clean

