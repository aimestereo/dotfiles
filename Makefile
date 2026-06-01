NIX_DIR := nix

.PHONY: mac
mac: mac-install mac-after-install nix-mac

.PHONY: mac-install
mac-install:
	utils/mac-install
	@echo "Restart shell and run 'make after-install'"

.PHONY: mac-after-install
mac-after-install: symlinks-mac
	utils/mac-after-install

.PHONY: symlinks-mac
symlinks-mac:
	utils/stow-packages '^(shell-fedora|toolbox|waybar|swayosd|mako|rofi)$$'
	utils/theme-bootstrap

.PHONY: symlinks-fedora
symlinks-fedora:
	utils/stow-packages '^(hammerspoon|nix|shell-mac)$$'
	utils/theme-bootstrap

.PHONY: fedora
fedora: fedora-after-install

.PHONY: fedora-bootstrap
fedora-bootstrap:
	workstation-bootstrap/fedora-bootstrap.sh

.PHONY: fedora-after-install
fedora-after-install: symlinks-fedora
	utils/fedora-after-install

# `podman rm --force` is preferred over `toolbox rm`: toolbox metadata desync
# is the exact failure mode this target exists to recover from. The `-` prefix
# tolerates non-zero exit (container absent) but does NOT swallow stderr, so a
# podman-daemon failure surfaces instead of silently letting `$(MAKE) fedora`
# run against a broken environment.
.PHONY: fedora-recreate-tools
fedora-recreate-tools:
	@if [ -f /run/.toolboxenv ]; then echo "fedora-recreate-tools: must run from host shell, not toolbox" >&2; exit 1; fi
	-podman rm --force tools
	$(MAKE) fedora

#
# Nix
#
.PHONY: nix-mac
nix-mac:
	$(MAKE) -C $(NIX_DIR) mac

.PHONY: nix-linux
nix-linux:
	$(MAKE) -C $(NIX_DIR) linux

