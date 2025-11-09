.PHONY: darwin
darwin:
	sudo darwin-rebuild switch --flake .#macOS

.PHONY: darwin-run
darwin-run:
	sudo nix run nix-darwin -- switch --flake .#macOS

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

.PHONY: clean
clean:
	nix-store --gc
	sudo nix-collect-garbage -d

