{ pkgs, ... }:

{
  # Import common configuration
  imports = [
    ../common.nix
  ];

  # Darwin-specific packages
  home.packages = with pkgs; [
    # Shell & Terminal Environment
    kitty # GPU-accelerated terminal emulator
    nushell # Modern shell with structured data
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

    # Applications
    slack # Team communication
    postman # API testing tool
    telegram-desktop # Messaging app
    obsidian # Note-taking app
    iina # Modern media player for macOS

    # Applications (Disabled)
    # Commented out to manage separately or via other package managers:
    # zoom-us # Video conferencing (constant reinstalls mess with MacOS permissions)
    # arc-browser # Browser (managed via brew for faster updates)

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
    FOO = "bar";
  };

  programs = {
    zsh = {
      enable = true;
      initContent = ''
        . "$HOME/.config/zsh/zshrc-darwin"
      '';
    };

    bash = {
      enable = true;
      initExtra = ''
        . ~/.config/shell/bashrc
        . ${pkgs.bash-preexec}/share/bash/bash-preexec.sh
      '';
    };
  };
}
