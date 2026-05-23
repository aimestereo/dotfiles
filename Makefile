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

#
# Nix
#
.PHONY: nix-mac
nix-mac:
	$(MAKE) -C $(NIX_DIR) mac

.PHONY: nix-linux
nix-linux:
	$(MAKE) -C $(NIX_DIR) linux

