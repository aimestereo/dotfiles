{ config, unstable, user, ... }:

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
    # unstable.hello

    (unstable.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # internet
    unstable.git
    unstable.curl
    unstable.wget
    unstable.gnupg
    unstable.rsync

    # internet apps
    # unstable.arc-browser
    unstable.slack
    # unstable.zoom  # zoom is not available in unstable
    # unstable.postman
    # unstable.open-video-downloader

    # build tools - they are not added to shell env, so no need to specify them
    # unstable.openssl
    # unstable.cmake
    # unstable.gcc
    # unstable.gettext
    # unstable.readline
    # unstable.xz
    # unstable.cffi

    # terminal: environment
    unstable.kitty
    unstable.tmux
    unstable.stow
    unstable.neovim
    # unstable.ical-buddy

    # Mouse, keyboard, and touchpad
    unstable.mos
    # unstable.force-paaste
    unstable.monitorcontrol
    # unstable.alfred  # alfred is not available in unstable

    # terminal: essentials
    # unstable.hammerspoon
    unstable.eza
    unstable.bat
    unstable.coreutils
    unstable.jq
    unstable.ripgrep
    unstable.fzf
    unstable.diff-so-fancy
    unstable.tldr
    unstable.atuin

    # processes
    unstable.mprocs
    unstable.procs
    unstable.htop
    unstable.btop

    # dev tools
    # unstable.gitup
    unstable.lazygit
    unstable.lazydocker
    unstable.pre-commit
    unstable.awscli
    # unstable.libpq
    # unstable.redis-cli

    # others
    unstable.obsidian
    unstable.iina


    # (unstable.python311.withPackages (ppkgs: [
    #   ppkgs.ipdb
    # ]))


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
