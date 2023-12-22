install: interactive brew symlinks configs
interactive:
	./interactive.sh
brew:
	./brew.sh
symlinks:
	./symlinks.sh
	# enable Keyboard remapping on system load
	launchctl unload ~/Library/LaunchAgents/com.local.KeyRemapping.plist 2&> /dev/null || true
	launchctl load ~/Library/LaunchAgents/com.local.KeyRemapping.plist
