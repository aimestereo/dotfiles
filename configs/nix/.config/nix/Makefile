update-lockfile:
	sudo nix flake update --flake .

darwin:
	darwin-rebuild switch --flake .#aimestereo-Air
darwin-run:
	sudo nix run nix-darwin -- switch --flake .#aimestereo-Air

arch:
	nix build .#nixosConfigurations.aimestereo-arch.config.system.build.toplevel
arch-home:
	home-manager switch --flake .#aimestereo-arch

clean:
	nix-store --gc
	sudo nix-collect-garbage -d

