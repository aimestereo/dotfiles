.PHONY: home-manager

current_dir := $(shell pwd)

install: nix-install brew symlinks keyboard-remapping nix
brew:
	./brew.sh
symlinks:
	./symlinks.sh
keyboard-remapping:
	# enable Keyboard remapping on system load
	launchctl unload -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2&> /dev/null || true
	launchctl load   -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist

nix-install:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	echo "Restart shell to enable Nix"

nix: symlinks
	# update NIX home-manager environment
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
		export XDG_CONFIG_HOME=$(current_dir)/nix/.config \
		&& nix/.config/bin/render-user-nix \
		&& nix/.config/bin/hms
