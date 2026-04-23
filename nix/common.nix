{
  pkgs,
  ...
}:

{
  # Common packages across all platforms
  home.packages = with pkgs; [
    # Nix Tools
    nixfmt # Nix code formatter

    # Fonts
    nerd-fonts.jetbrains-mono # Programming font with icons
    nerd-fonts.hack # Hack font with icons
    nerd-fonts.caskaydia-mono # Cascadia Code with Nerd Font patches

    # Shell & Terminal Environment
    direnv # Auto-load environment variables per directory
    starship # Modern, fast shell prompt
    tmux # Terminal multiplexer for persistent sessions
    zoxide # Smart cd command that learns your habits
    stow # Symlink manager for dotfiles
    atuin # Command history manager with sync
    carapace # Multi-shell completion framework
    nushell
    nushellPlugins.polars

    # Core CLI Utilities
    bat # cat with syntax highlighting and git integration
    eza # Modern replacement for ls with colors and icons
    fd # Modern replacement for find, faster and easier
    sd # Streamlined alternative to sed for simple replacements
    fzf # Fuzzy finder for files, history, commands (used by neovim)
    ripgrep # Fast grep alternative, respects .gitignore
    jq # JSON processor for CLI

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
    unzip # Extract zip archives
    wget # Download files from web
    curl # Transfer data with URLs
    rsync # Fast incremental file transfer
    gnupg # Encryption and signing tool

    # Development - Version Control
    git # Version control system
    delta # Better git diff (current)
    diff-so-fancy # Better git diff output with colors (not used currently)
    lazygit # TUI for git with keyboard shortcuts
    # claude-code  # brew has newer version

    # Development - Languages & Runtimes
    go # Go programming language (LSP and tools)
    nodejs_22 # Node.js runtime (provides npm, npx, corepack for LSPs)

    # Development - Build Tools & Compilers
    readline # Library for line editing (dependency for many CLI tools)
    libiconv # Character encoding conversion library (required for Rust linking on macOS)
    pkg-config # Helps find libraries during build

    # Development - Code Quality & Formatters
    shfmt # Shell script formatter
    shellharden # Shell script linter and hardener
    pgformatter # PostgreSQL SQL formatter
    nufmt # Nushell code formatter
    yamlfmt # YAML formatter
    mdformat # Markdown formatter

    # Development - Editor & LSP Support
    neovim # Modern vim-based text editor
    universal-ctags # Code indexing tool (used by neovim plugins)
    silver-searcher # Fast code search (ag command, used by neovim plugins)
    tree-sitter
    git-spice # Manage stacked Git branches

    # Development - Environment Management
    devenv # Fast, declarative development environments

    # DevOps & Cloud
    lazydocker # TUI for managing Docker containers
    k9s # TUI for managing Kubernetes clusters

    # Data & File Processing
    cloc # Count lines of code by language
    tokei # Code statistics

    # Applications
    # calibre - broken
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
