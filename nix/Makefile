.PHONY: update-lockfile
update-lockfile:
	sudo nix flake update --flake .

.PHONY: darwin
darwin:
	sudo darwin-rebuild switch --flake .#aimestereo-Air

.PHONY: darwin-run
darwin-run:
	sudo nix run nix-darwin -- switch --flake .#aimestereo-Air

.PHONY: arch
arch:
	home-manager switch --flake .#main

.PHONY: clean
clean:
	nix-store --gc
	sudo nix-collect-garbage -d

