{ pkgs, ... }:

{
  # To search by name, run: $ nix-env -qaP | grep wget
  home.packages = with pkgs; [
    hello
    nixfmt-rfc-style

    nerd-fonts.jetbrains-mono
    nerd-fonts.hack

    # internet
    git
    curl
    wget
    gnupg
    rsync
    wttrbar # wheather
    gh # github cli

    # cli tools
    blueutil

    # internet apps
    slack
    # zoom-us  # contant reinstalls mess with MacOS permissions
    # arc-browser  # updates ofthen, lets use brew version to avoid overrides
    postman
    telegram-desktop

    # terminal: environment
    kitty
    tmux
    stow
    _1password-cli
    zoxide
    nushell

    # neovim
    neovim
    go
    nodejs_22
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

    # Mouse, keyboard, and touchpad
    mos

    # Monitor, Windows
    jankyborders
    monitorcontrol

    # terminal: essentials
    eza
    bat
    coreutils
    jq
    ripgrep
    fzf
    fd
    diff-so-fancy
    tldr
    atuin # command history manager
    carapace # shell completion framework
    jujutsu # git cli alternative

    # processes
    mprocs
    procs
    htop
    btop

    # dev: languages

    # dev: tools
    lazygit
    lazydocker
    pre-commit
    awscli2
    # redli # redis-cli alternative
    devenv
    k9s

    cloc # count lines of code

    # dev: build tools
    readline

    # others
    obsidian
    iina

    (python312.withPackages (ppkgs: [
      ppkgs.pip
      ppkgs.ipdb
      # ppkgs.neovim
    ]))

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
