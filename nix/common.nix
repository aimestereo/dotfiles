{ pkgs, ... }:

{
  # Common packages across all platforms
  home.packages = with pkgs; [
    # Nix Tools
    nixfmt-rfc-style # Nix code formatter

    # Fonts
    nerd-fonts.jetbrains-mono # Programming font with icons
    nerd-fonts.hack # Hack font with icons
    nerd-fonts.caskaydia-mono # Cascadia Code with Nerd Font patches

    # Shell & Terminal Environment
    direnv # Auto-load environment variables per directory
    bash-preexec # Bash hooks for command execution (required by atuin)
    starship # Modern, fast shell prompt
    tmux # Terminal multiplexer for persistent sessions
    zoxide # Smart cd command that learns your habits
    stow # Symlink manager for dotfiles
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

    # System Monitoring & Process Management
    htop # Interactive process viewer
    btop # Modern resource monitor with better UI
    bottom # System monitor
    procs # Modern replacement for ps with colors
    mprocs # Run multiple processes in parallel with TUI
    dust # Disk usage analyzer

    # System Utilities
    fastfetch # System information tool (neofetch alternative)
    man # Manual pages
    tldr # Simplified community-driven man pages
    gum # Shell scripting with styled UI components
    plocate # Fast file locator (updatedb/locate)
    unzip # Extract zip archives
    inetutils # Network utilities (ftp, telnet, hostname, etc.)
    wget # Download files from web
    curl # Transfer data with URLs
    rsync # Fast incremental file transfer
    gnupg # Encryption and signing tool

    # Development - Version Control
    git # Version control system
    delta # Better git diff
    lazygit # TUI for git with keyboard shortcuts

    # Development - Languages & Runtimes
    go # Go programming language (LSP and tools)
    nodejs_22 # Node.js runtime (provides npm, npx, corepack for LSPs)
    rustc # Rust compiler (for Rust development and tools)
    cargo # Rust package manager and build tool
    luarocks # Lua package manager (for neovim plugins)
    perl # Perl interpreter (required by fzf for some features)

    # Development - Build Tools & Compilers
    readline # Library for line editing (dependency for many CLI tools)
    clang # C/C++ compiler (LLVM frontend)
    llvm # Compiler infrastructure (required by some LSPs)
    cmake # Cross-platform build system generator

    # Development - Code Quality & Formatters
    shfmt # Shell script formatter
    shellharden # Shell script linter and hardener
    hadolint # Dockerfile linter
    pgformatter # PostgreSQL SQL formatter

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
  ];

  # Common program configurations
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        . ~/.config/shell/bashrc
        . ${pkgs.bash-preexec}/share/bash/bash-preexec.sh
      '';
    };

    fzf.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
