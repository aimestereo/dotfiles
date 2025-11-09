{
  description = "Home Manager configuration";

  inputs = {
    # Common inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # This ensures home-manager uses the same nixpkgs version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin (macOS) specific inputs
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
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
      userConfigs = import ./userConfigs.nix { };

      # Function to create a package set for a specific system
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

      mkHomeConfig =
        name: config:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor config.system;
          modules = [
            ./home.nix
            {
              home = {
                inherit (config) username homeDirectory;
                stateVersion = "24.11";
              };

              # Protect Omarchy-managed directories
              home.file.".config/omarchy".enable = false;
              home.file.".config/hypr".enable = false;
              home.file.".config/alacritty".enable = false;
              home.file.".config/btop/themes".enable = false;
            }
          ];
        };

    in
    {
      # Home Manager configurations (for standalone use on Linux)
      homeConfigurations = builtins.mapAttrs mkHomeConfig userConfigs;

      # Darwin configurations (for macOS)
      darwinConfigurations = {
        "aimestereo-Air" =
          let
            config = userConfigs.macOS;
            system = config.system;
          in
          darwin.lib.darwinSystem {
            inherit system;
            specialArgs = {
              pkgs = pkgsFor system;
              inherit (config) username homeDirectory;
            };
            modules = [
              ./configuration.nix
              ./darwin/configuration.nix
              mac-app-util.darwinModules.default

              home-manager.darwinModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  users.${config.username} = {
                    imports = [ ./darwin/home.nix ];
                    home = {
                      inherit (config) username homeDirectory;
                      stateVersion = "23.05";
                    };
                  };

                  # To enable it for all users:
                  sharedModules = [
                    mac-app-util.homeManagerModules.default
                  ];

                  extraSpecialArgs = {
                    pkgs = pkgsFor system;
                  };
                };
              }
            ];
          };
      };
    };
}
