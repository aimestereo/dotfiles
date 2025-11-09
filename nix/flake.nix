{
  description = "NixOS and Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Darwin (macOS) specific inputs
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";

    # Common inputs
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      darwin,
      mac-app-util,
      ...
    }:
    let
      # Import user configuration
      user = import ./user.nix { };

      # Function to create a package set for a specific system
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

      # Systems supported
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
    in
    {
      # Darwin configurations (for macOS)
      darwinConfigurations = {
        "aimestereo-Air" =
          let
            system = "aarch64-darwin";
          in
          darwin.lib.darwinSystem {
            inherit system;
            specialArgs = {
              pkgs = pkgsFor system;
              user = import ./user.nix { hostname = "aimestereo-Air"; };
            };
            modules = [
              ./configuration.nix
              ./darwin/configuration.nix
              mac-app-util.darwinModules.default

              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.users.aimestereo = import ./darwin/home.nix;

                # To enable it for all users:
                home-manager.sharedModules = [
                  mac-app-util.homeManagerModules.default
                ];

                home-manager.extraSpecialArgs = {
                  pkgs = pkgsFor system;
                  user = import ./user.nix { hostname = "aimestereo-Air"; };
                };
              }
            ];
          };
      };

      # Home Manager configurations (for standalone use on Linux)
      homeConfigurations = {
        "aimestereo-arch" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          extraSpecialArgs = {
            user = import ./user.nix { hostname = "aimestereo-arch"; };
          };
          modules = [
            ./linux/home.nix
          ];
        };
      };
    };
}
