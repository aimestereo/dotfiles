{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # To properly link installed applications to the Applications folder
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
      system = "aarch64-darwin";
      user = import ./user.nix;

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          cowsay
          neovim
        ];
      };

      darwinConfigurations = {
        ${user.hostname} = darwin.lib.darwinSystem {
          system = system;
          specialArgs = {
            inherit pkgs;
            inherit user;
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
                inherit pkgs;
                inherit user;
              };

            }
          ];
        };
      };
    };
}
