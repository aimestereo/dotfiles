{
  description = "Home Manager configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake-utils
    flake-utils.url = "github:numtide/flake-utils";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs @ { self
  , nixpkgs
  , home-manager
  , flake-utils
  , mac-app-util
  , nixpkgs-unstable
  , ...
  }:
    let
      utils = flake-utils;
      user = import ./user.nix;
    in
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        unstable = import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
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
              mac-app-util.homeManagerModules.default
            ];

            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
            extraSpecialArgs = {
              inherit user;
              inherit unstable;
            };
          };
        };

        # Homebrew needs to be installed on its own!
        homebrew = {
          enable = true;

          taps = [
            "beeftornado/rmtree"
            "ringohub/redis-cli"
          ];

          brews = [
            "ical-buddy"  # for tmux calendar plugin

            # devs
            "libpq"
            # "redis-cli"

            # nvim fzf and its dependencies:
            "fzf"
            "bat"
            "ripgrep"
            "the_silver_searcher"
            "perl"
            "universal-ctags"
          ];

          casks = [
            "hammerspoon"
            "1password/tap/1password-cli"
            "arc"
            "force-paste"
            "gitup"
            "zoom"
            "1password/tap/1password-cli"
            "postman"
            "open-video-downloader"
            "alfred"
          ];
        };

      });
}
