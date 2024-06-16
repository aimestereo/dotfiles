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

    # build tools - they are not added to shell env, so no need to specify them
    # pkgs.openssl
    # pkgs.cmake
    # pkgs.gcc
    # pkgs.gettext
    # pkgs.readline
    # pkgs.xz

    # terminal: environment
    pkgs.tmux
    pkgs.starship
    pkgs.stow
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
    pkgs.kubectl
    pkgs.minikube
    pkgs.poetry

    pkgs.terragrunt
    pkgs.awscli

    pkgs.shfmt
    pkgs.hadolint
    pkgs.pre-commit

    (pkgs.python311.withPackages (ppkgs: [
      ppkgs.ipdb
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

  programs.direnv.enable = true;

  programs.go = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    # plugins = [ zsh-256color ];
    initExtra = ''
      if [ -e $HOME/.profile ]; then
        . $HOME/.profile
      fi
      '';

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "joshskidmore/zsh-fzf-history-search"; }
      ];
    };
  };

  programs.lazygit = {
    enable = true;
  };

  programs.rtx = {
    enable = true;
    package = pkgs.unstable.mise;
    enableZshIntegration = true;
    settings = {
      tools = {
        node = ["lts"];
        python = ["3.10" "3.11"];
      };
    };
  };

  programs.neovim = {
    enable = true;
   #  plugins = [
   #   pkgs.vimPlugins.nvim-treesitter
   # ];
  };
}
