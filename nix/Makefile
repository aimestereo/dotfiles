.PHONY: mac
mac:
	sudo darwin-rebuild switch --flake .#macOS

.PHONY: mac-initial
mac-initial:
	sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#macOS

.PHONY: arch
arch:
	home-manager switch --flake .#main

#
# Common commands
#

.PHONY: help
	home-manager --help

.PHONY: update
update:
	nix flake update

.PHONY: generations
	home-manager generations

.PHONY: rollback
	home-manager rollback
	# home-manager switch-generation <number>

.PHONY: clean
clean:
	nix-store --gc
	sudo nix-collect-garbage -d
