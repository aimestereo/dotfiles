{
  pkgs,
  lib,
  config,
  ...
}:

let
  # Turn the sessionPath list into a colon-separated string once, in Nix.
  extraSessionPath = lib.concatStringsSep ":" config.home.sessionPath;
in
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
    nushellPlugins.polars

    # Core CLI Utilities
    bat # cat with syntax highlighting and git integration
    eza # Modern replacement for ls with colors and icons
    fd # Modern replacement for find, faster and easier
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
    inetutils # Network utilities (ftp, telnet, hostname, etc.)
    wget # Download files from web
    curl # Transfer data with URLs
    rsync # Fast incremental file transfer
    gnupg # Encryption and signing tool

    # Development - Version Control
    git # Version control system
    delta # Better git diff (current)
    diff-so-fancy # Better git diff output with colors (not used currently)
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
    libiconv # Character encoding conversion library (required for Rust linking on macOS)
    pkg-config # Helps find libraries during build

    # Development - Code Quality & Formatters
    shfmt # Shell script formatter
    shellharden # Shell script linter and hardener
    hadolint # Dockerfile linter
    pgformatter # PostgreSQL SQL formatter
    nufmt # Nushell code formatter

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
    # calibre - broken
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "zen-browser";
      PAGER = "less -R";
      LANG = "en_US.UTF-8";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.cache/npm/global/bin"
    ];
    shellAliases = {
      # Home Manager
      hm = "home-manager switch --flake ~/Work/my/dotfiles/nix#main";

      # ls replacements
      l = "eza --icons=auto";
      ls = "eza --icons=auto";
      ll = "eza -la --icons=auto";
      la = "eza -la --icons=auto";
      lt = "eza --tree --icons=auto";

      # Modern replacements
      c = "bat -p";
      cat = "bat";
      grep = "rg";
      find = "fd";

      # Git shortcuts
      g = "git";
      wt = "git worktree";

      gst = "git status";
      gco = "git checkout";
      gcm = "git commit -m";
      gcam = "git commit -am";

      v = "nvim";
      lazyvim = "NVIM_APPNAME=lazyvim nvim";

      cl = "clear";
      # md = "mkdir -p";
      rd = "rmdir";

      tf = "terraform";
      tg = "terragrunt";
      k = "kubectl";

      # It will automatically copy over the terminfo files and also magically enable shell integration on the remote machine.
      s = "kitten ssh";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };

  # Common program configurations
  programs = {
    bash = {
      enable = true;
      historyControl = [ "ignoreboth" ]; # ignoredups and ignorespace
      initExtra = ''
        #
        # Common bash config
        #

        # Re-apply sessionPath on top of Home Manager's PATH
        export PATH="$PATH:${extraSessionPath}"

        # All the default Omarchy aliases and functions
        # (don't mess with these directly, just overwrite them here!)
        if [ -f $HOME/.local/share/omarchy/default/bash/rc ]; then
        	source $HOME/.local/share/omarchy/default/bash/rc
        fi

        source ${pkgs.bash-preexec}/share/bash/bash-preexec.sh
        source $HOME/.config/shell/rc

        # use vi keybindings in the shell
        set -o vi
      '';
    };

    nushell = {
      enable = true;
      extraConfig = ''
        # Re-apply sessionPath on top of Home Manager's PATH
        $env.PATH ++= ("${extraSessionPath}" | split row ":")
      '';

      plugins = [
        pkgs.nushellPlugins.polars
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        extended = true; # Write the history file in the ":start:elapsed;command" format.
        size = 1000000; # Number of history entries kept in memory during a session.
        save = 1000000; # Number of history entries saved to the history file.

        # if false, then to keep global history set one of:
        # * append_history (Append history when the shell exits, instead of overwriting the history file.)
        # * inc_append_history (Write to the history file immediately, not when the shell exits.)
        # https://zsh.sourceforge.io/Doc/Release/Options.html#index-APPEND_005fHISTORY
        # P.S. I also have atuin for presize history management
        share = true; # Write the history file in the ":start:elapsed;command" format.

        ignoreSpace = true; # Don't record an entry starting with a space.
        saveNoDups = true; # Don't write duplicate entries in the history file.
        findNoDups = true; # Do not display a line previously found.
        ignoreDups = true; # Don't record an entry that was just recorded again.
        ignoreAllDups = true; # Delete old recorded entry if new entry is a duplicate.
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];

      initContent = ''
        #
        # Common zsh config
        #

        # Re-apply some variables that Home Manager misses: https://github.com/nix-community/home-manager/issues/2991
        export PATH="$PATH:${extraSessionPath}"

        source "$HOME/.config/shell/rc"
        source "$HOME/.config/zsh/zshrc-common"

        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        source ~/.config/zsh/.p10k.zsh

        # for some reason fzf integration doesn't apply or get overwritten later
        export FZF_DEFAULT_OPTS='--height 20% --layout=reverse --border --preview="if [ -d {} ]; then eza --tree --level 2 --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi" --bind="ctrl-y:accept"'
      '';
    };

    zoxide.enable = true;
    direnv.enable = true;
    carapace.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      # TODO: if I see that height is 30%, that means it works and I can remove the workaround in zsh initContent
      defaultOptions = [
        "--height=30%"
        "--layout=reverse"
        "--border"
        "--preview='if [ -d {} ]; then eza --tree --level 2 --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"
        "--bind 'ctrl-y:accept'"
      ];
    };

    atuin = {
      enable = true;
      flags = [
        # "--disable-up-arrow" - configured for session search
        # "--disable-ctrl-r" - configured for global search
      ];
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
