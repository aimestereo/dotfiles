.PHONY: home-manager

install: nix-install brew symlinks home-manager
nix-install:
	cd nix && ./nix-install.sh
nix-upgrade:
	cd nix && ./nix-upgrade.sh
brew:
	./brew.sh
symlinks:
	./symlinks.sh
	# enable Keyboard remapping on system load
	launchctl unload -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2&> /dev/null || true
	launchctl load   -w ~/Library/LaunchAgents/com.local.KeyRemapping.plist

home-manager:
	# it's a separate target, cause it's rerun much more often
	stow --restow -t ${HOME} -v home-manager
	# update NIX home-manager environment
	home-manager switch
