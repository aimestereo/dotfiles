{ pkgs, ... }:

{
  # To search by name, run: $ nix-env -qaP | grep wget
  home.packages = with pkgs; [
    # Nix Tools
    nixfmt-rfc-style # Nix code formatter

    # Fonts
    nerd-fonts.jetbrains-mono # Programming font with icons
    nerd-fonts.hack # Hack font with icons

    # Shell & Terminal Environment
    kitty # GPU-accelerated terminal emulator
    tmux # Terminal multiplexer for persistent sessions
    zoxide # Smart cd command that learns your habits
    stow # Symlink manager for dotfiles
    nushell # Modern shell with structured data
    atuin # Command history manager with sync
    carapace # Multi-shell completion framework

    # Core CLI Utilities
    bat # cat with syntax highlighting and git integration
    eza # Modern replacement for ls with colors and icons
    fd # Modern replacement for find, faster and easier
    fzf # Fuzzy finder for files, history, commands (used by neovim)
    ripgrep # Fast grep alternative, respects .gitignore
    jq # JSON processor for CLI
    diff-so-fancy # Better git diff output with colors
    coreutils # GNU coreutils for macOS (provides gls, gcat, etc.)

    # System Monitoring & Process Management
    htop # Interactive process viewer
    btop # Modern resource monitor with better UI
    bottom # System monitor
    procs # Modern replacement for ps with colors
    mprocs # Run multiple processes in parallel with TUI
    dust # Disk usage analyzer

    # System Utilities
    tldr # Simplified community-driven man pages
    wget # Download files from web
    curl # Transfer data with URLs
    rsync # Fast incremental file transfer
    gnupg # Encryption and signing tool
    wttrbar # Weather information for status bar

    # macOS-Specific Utilities
    blueutil # CLI for Bluetooth management on macOS
    _1password-cli # 1Password command line interface
    mos # Mouse, keyboard, and touchpad customization for macOS
    jankyborders # Window borders for macOS window managers
    monitorcontrol # Control external monitor brightness and volume

    # Development - Version Control
    git # Version control system
    delta # Better git diff
    lazygit # TUI for git with keyboard shortcuts
    gh # GitHub CLI for repository management
    jujutsu # Git CLI alternative (jj command)

    # Development - Languages & Runtimes
    go # Go programming language (LSP and tools)
    nodejs_22 # Node.js runtime (provides npm, npx, corepack for LSPs)
    rustc # Rust compiler (for Rust development and tools)
    cargo # Rust package manager and build tool
    luarocks # Lua package manager (for neovim plugins)
    perl # Perl interpreter (required by fzf for some features)

    (python312.withPackages (ppkgs: [
      ppkgs.pip # Python package installer
      ppkgs.ipdb # IPython debugger
      # ppkgs.neovim
    ]))

    # Development - Build Tools & Compilers
    readline # Library for line editing (dependency for many CLI tools)

    # Development - Code Quality & Formatters
    shfmt # Shell script formatter
    shellharden # Shell script linter and hardener
    hadolint # Dockerfile linter
    pgformatter # PostgreSQL SQL formatter
    pre-commit # Git hooks framework for code quality checks

    # Development - Editor & LSP Support
    neovim # Modern vim-based text editor
    universal-ctags # Code indexing tool (used by neovim plugins)
    silver-searcher # Fast code search (ag command, used by neovim plugins)

    # Development - Environment Management
    devenv # Fast, declarative development environments

    # DevOps & Cloud
    awscli2 # AWS command line interface
    lazydocker # TUI for managing Docker containers
    k9s # TUI for managing Kubernetes clusters

    # Data & File Processing
    cloc # Count lines of code by language
    tokei # Code statistics

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

    direnv.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
