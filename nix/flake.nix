# nix profile install .
# nix profile upgrade 0

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = { self, nixpkgs, unstable, devenv }: {
    packages."aarch64-darwin".default = let
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      unstablePkgs = unstable.legacyPackages."aarch64-darwin";

    in pkgs.buildEnv {
      name = "home-packages";
      paths = with pkgs; [

        # general tools
        stow
        antigen
        
        tmux
        git
        gnupg
        curl
        wget
        jq
        rsync
        ripgrep
        fzf
        diff-so-fancy

        eza
        bat
        mprocs
        procs
        starship
        coreutils
        rtx

        # dev tools
        nix-direnv
        devenv.packages.aarch64-darwin.devenv
        kubectl
        minikube
        terragrunt
        awscli

        shfmt
        hadolint
        pre-commit

        # architecture mismatch
        # neovim
        
        # have licence issue
        # terraform
      ];
    };
  };

}
