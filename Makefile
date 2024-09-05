.PHONY: home-manager

current_dir := $(shell pwd)

install: brew symlinks keyboard-remapping
brew:
	./brew.sh
symlinks:
	./symlinks.sh
keyboard-remapping:
	# enable Keyboard remapping on system load
	launchctl unload -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2&> /dev/null || true
	launchctl load   -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist

#
# WIP
#
nix: hms symlinks
nix-update: nix-update-lockfile nix

nix-install:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	@echo "Restart shell to enable Nix"

nix-update-lockfile:
	nix flake update --flake $(current_dir)/configs/nix/.config/home-manager

hms:
	# update NIX home-manager environment
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
		export XDG_CONFIG_HOME=$(current_dir)/configs/nix/.config \
		&& configs/nix/.config/bin/render-user-nix \
		&& configs/nix/.config/bin/hms

