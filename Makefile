NIX_DIR := nix

.PHONY: mac
mac: mac-install mac-after-install nix-mac

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

.PHONY: symlinks-fedora
symlinks-fedora:
	utils/symlinks-fedora

.PHONY: fedora
fedora: fedora-after-install

.PHONY: fedora-bootstrap
fedora-bootstrap:
	workstation-bootstrap/fedora-bootstrap.sh

.PHONY: fedora-after-install
fedora-after-install: symlinks-fedora
	utils/fedora-after-install

#
# Nix
#
.PHONY: nix-mac
nix-mac:
	$(MAKE) -C $(NIX_DIR) mac

.PHONY: nix-linux
nix-linux:
	$(MAKE) -C $(NIX_DIR) linux

