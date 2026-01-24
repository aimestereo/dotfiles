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

    # System Utilities
    wttrbar # Weather information for status bar

    # macOS-Specific Utilities
    blueutil # CLI for Bluetooth management on macOS
    _1password-cli # 1Password command line interface
    mos # Mouse, keyboard, and touchpad customization for macOS
    jankyborders # Window borders for macOS window managers
    monitorcontrol # Control external monitor brightness and volume

    # Development - Version Control
    gh # GitHub CLI for repository management
    jujutsu # Git CLI alternative (jj command)

    # Development - Languages & Runtimes
    (python312.withPackages (ppkgs: [
      ppkgs.pip # Python package installer
      ppkgs.ipdb # IPython debugger
      # ppkgs.neovim
    ]))

    # Development - Code Quality & Formatters
    pre-commit # Git hooks framework for code quality checks

    # GUI Applications moved to homebrew (nix/darwin/configuration.nix)
    # No longer using mac-app-util - these are now managed via homebrew casks
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
