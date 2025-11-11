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

    # Development
    # git
    tmux
    # kitty
    stow
    # lazygit
    # lazydocker
    # pre-commit
    awscli2
    # redli # redis-cli alternative
    devenv
    k9s
    cloc # count lines of code
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
    # neovim: fzf
    perl
    silver-searcher
    universal-ctags

    # # Build tools
    readline
    cargo
    clang
    llvm
    cmake

    # Terminal utilities
    # eza # Modern replacement for exa, ls
    # bat
    # gum
    # coreutils
    # jq
    # ripgrep
    # fzf
    # fd
    diff-so-fancy
    # man
    # tldr
    # less
    # whois
    # plocate
    bash-preexec # atuin dependency
    atuin # command history manager
    carapace # shell completion framework
    # jujutsu # git cli alternative

    # System tools
    # mprocs
    # procs
    # htop
    # btop

    # Other utilities
    # unzip
    # wget
    # curl
    # inetutils
    # gnupg
    # rsync
    # impala # TUI for managing wifi
    # zoxide
    # xmlstarlet  # XML command line toolkit
    # wl-clipboard
    # fastfetch
    # ddcutil # monitor control - requires /dev/i2c devices

    # Apps
    # slack
    # zoom-us
    # # zen-browser  # updates ofthen, lets use brew version to avoid overrides
    # postman
    # telegram-desktop
    # obsidian

  ];

  # Git configuration
  # programs.git = {
  #   enable = true;
  #   userName = "Valentin Kuznetsov";
  #   userEmail = "aimestereo@gmail.com";
  #   extraConfig = {
  #     init.defaultBranch = "main";
  #   };
  # };

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
