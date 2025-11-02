{
  config,
  pkgs,
  user,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = user.name;
  home.homeDirectory = user.homeDir;

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
    # neovim
    kitty
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

    # # Build tools
    # readline
    # cargo 
    # clang 
    # llvm

    # Terminal utilities
    # eza # Modern replacement for exa, ls
    # bat
    # gum
    # coreutils
    # jq
    # ripgrep
    # fzf
    # fd
    # diff-so-fancy
    # man
    # tldr
    # less
    # whois
    # plocate
    # atuin # command history manager
    # carapace # shell completion framework
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

    # Apps
    # slack
    # zoom-us # contant reinstalls mess with MacOS permissions
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

  programs.direnv.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
