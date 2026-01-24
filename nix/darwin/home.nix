{ pkgs, ... }:

{
  # Import common configuration
  imports = [
    ../common.nix
  ];

  # Darwin-specific packages
  home.packages = with pkgs; [
    # Shell & Terminal Environment
    bash-preexec # Bash hooks for command execution (required by atuin)

    # Core CLI Utilities
    coreutils # GNU coreutils for macOS (provides gls, gcat, etc.)

    # macOS-Specific Utilities
    _1password-cli # 1Password command line interface

    # Development - Version Control
    gh # GitHub CLI for repository management

    # Development - Languages & Runtimes
    (python312.withPackages (ppkgs: [
      ppkgs.pip # Python package installer
      ppkgs.ipdb # IPython debugger
      # ppkgs.neovim
    ]))

    # GUI Applications moved to homebrew (nix/darwin/configuration.nix)
    # to avoid Swift build dependency and re-builds on updates
  ];

  programs = {
    zsh = {
      # override: platform-specific config
      initContent = ''
        #
        # Darwin-specific zsh config
        #

        source "$HOME/.config/zsh/zshrc-darwin"
      '';
    };
  };
}
