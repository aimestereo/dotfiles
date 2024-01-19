{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aimestereo";
  home.homeDirectory = "/Users/aimestereo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # pkgs.hello

    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # internet
    pkgs.git
    pkgs.curl
    pkgs.wget
    pkgs.gnupg
    pkgs.rsync

    # build tools
    pkgs.openssl
    pkgs.cmake
    pkgs.gcc

    # terminal: environment
    pkgs.tmux
    pkgs.starship
    # pkgs.stow -- install by NIX, because it's needed prior to this
    pkgs.antigen

    # terminal: essentials
    pkgs.eza
    pkgs.bat
    pkgs.coreutils
    pkgs.jq
    pkgs.ripgrep
    pkgs.fzf
    pkgs.diff-so-fancy

    # processes
    pkgs.mprocs
    pkgs.procs

    # dev tools
    # pkgs.mise
    pkgs.kubectl
    pkgs.minikube

    pkgs.terragrunt
    pkgs.awscli

    pkgs.shfmt
    pkgs.hadolint
    pkgs.pre-commit

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/aimestereo/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    FOO = "bar";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.go = {
    enable = true;
  };
}
