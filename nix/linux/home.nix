{
  config,
  pkgs,
  ...
}:

{
  # Packages to install
  home.packages = with pkgs; [
    hello
    nixfmt-rfc-style

    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.hack

    # Development tools
    bat
    devenv
    direnv
    eza # Modern replacement for exa, ls
    fd
    git
    jq
    ripgrep
    stow
    starship
    tmux
    zoxide

    # neovim: fzf
    fzf
    perl
    silver-searcher
    universal-ctags

    # Devops tools
    awscli2
    coreutils
    lazydocker
    lazygit
    k9s

    # redli # redis-cli alternative
    # imagemagick

    # neovim
    go
    nodejs_22 # provides: corepack node npm npx
    luarocks
    rustc
    cargo
    shfmt
    shellharden
    hadolint
    pgformatter

    # Build tools
    readline
    cargo
    clang
    llvm
    cmake

    # Terminal utilities
    gum
    man
    tldr
    less
    whois
    cloc # count lines of code
    plocate
    bash-preexec # atuin dependency
    atuin # command history manager
    carapace # shell completion framework
    diff-so-fancy
    # jujutsu # git cli alternative

    # System tools
    mprocs # Process manager
    procs # Better top
    htop
    btop

    # Other utilities
    unzip
    wget
    curl
    inetutils # provides: ftp telnet rsh rlogin hostname
    gnupg
    rsync
    impala # TUI for managing wifi
    xmlstarlet # XML command line toolkit
    wl-clipboard
    fastfetch

    # Apps
    # slack
    # kitty
    # zoom-us
    # # zen-browser  # updates ofthen, lets use brew version to avoid overrides
    # postman
    # telegram-desktop
    # obsidian

  ];

  # ZSH configuration
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    initContent = ''
      . ~/.config/zsh/zshrc-arch
    '';
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      . ~/.config/shell/bashrc
      . ${pkgs.bash-preexec}/share/bash/bash-preexec.sh
    '';
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG desktop integration
  targets.genericLinux.enable = true;
  xdg.enable = true;
  xdg.mime.enable = true;
}
