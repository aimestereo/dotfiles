.PHONY: home-manager

CONFIG_DIR := $(HOME)/.config

current_dir := $(shell pwd)
NIX_CONFIG_DIR := $(current_dir)/configs/nix/.config/nix

.PHONY: mac
mac: mac-install mac-after-install nix-darwin

.PHONY: mac-install
mac-install:
	utils/mac-install
	@echo "Restart shell and run 'make after-install'"

.PHONY: mac-after-install
mac-after-install: symlinks 
	utils/mac-after-install

.PHONY: symlinks
symlinks:
	utils/symlinks

#
# Nix
#
.PHONY: nix-update-lockfile
nix-update-lockfile:
	$(MAKE) -C $(NIX_CONFIG_DIR) update-lockfile

.PHONY: nix-darwin
nix-darwin:
	$(MAKE) -C $(NIX_CONFIG_DIR) darwin

.PHONY: nix-arch
nix-arch:
	$(MAKE) -C $(NIX_CONFIG_DIR) arch

.PHONY: nix-clean
nix-clean:
	$(MAKE) -C $(NIX_CONFIG_DIR) clean

