{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, home-manager, nixpkgs-unstable, ... }:
    let
      utils = flake-utils;
      user = import ./user.nix;
    in
    utils.lib.eachDefaultSystem (system:
      let
        stable-pkgs = nixpkgs.legacyPackages.${system};
        unstable-pkgs = nixpkgs-unstable.legacyPackages.${system};
        pkgs = stable-pkgs // {
          # provides alias for all ustable pkgs
          unstable = unstable-pkgs;

          starship = unstable-pkgs.starship;
          git = unstable-pkgs.git;
        };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages = {
          homeConfigurations.${user.name} = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            # Specify your home configuration modules here, for example,
            # the path to your home.nix.
            modules = [
              ./home.nix
            ];

            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
            extraSpecialArgs = {
              inherit pkgs;
            };
          };
        };
      });
}
