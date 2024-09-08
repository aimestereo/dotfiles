{ config, pkgs, user, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user.name;
  home.homeDirectory = user.homeDir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # pkgs.hello

    # is not available in pkgs
    # pkgs.ical-buddy  
    # pkgs.arc-browser
    # pkgs.zoom
    # pkgs.postman
    # pkgs.open-video-downloader
    # pkgs.alfres
    # pkgs.hammerspoon
    # pkgs.libpq
    # pkgs.redis-cli
    # pkgs.gitup

    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # internet
    pkgs.git
    pkgs.curl
    pkgs.wget
    pkgs.gnupg
    pkgs.rsync

    # internet apps
    pkgs.slack

    # terminal: environment
    pkgs.kitty
    pkgs.tmux
    pkgs.stow

    # terminal: neovim
    pkgs.neovim
    pkgs.go
    pkgs.nodejs_22
    pkgs.luarocks
    pkgs.rustc
    pkgs.cargo
    pkgs.shfmt
    pkgs.shellharden
    pkgs.hadolint
    pkgs.pgformatter

    # Mouse, keyboard, and touchpad
    pkgs.mos
    pkgs.monitorcontrol

    # terminal: essentials
    pkgs.eza
    pkgs.bat
    pkgs.coreutils
    pkgs.jq
    pkgs.ripgrep
    pkgs.fzf
    pkgs.fd
    pkgs.diff-so-fancy
    pkgs.tldr
    pkgs.atuin

    # processes
    pkgs.mprocs
    pkgs.procs
    pkgs.htop
    pkgs.btop

    # dev tools
    pkgs.lazygit
    pkgs.lazydocker
    pkgs.pre-commit
    pkgs.awscli

    # others
    pkgs.obsidian
    pkgs.iina

    (pkgs.python312.withPackages (ppkgs: [
      ppkgs.pip
      ppkgs.ipdb
      # ppkgs.neovim
    ]))


    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
