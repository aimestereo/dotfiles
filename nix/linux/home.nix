{
  config,
  pkgs,
  ...
}:

{
  # Import common configuration
  imports = [
    ../common.nix
  ];

  # Linux-specific packages
  home.packages = with pkgs; [
    # System Utilities
    wl-clipboard # Wayland clipboard utilities (wl-copy, wl-paste)
    impala # TUI for managing WiFi connections

    # Applications
    # Commented out to manage separately or via other package managers:
    # slack # Team communication
    # kitty # GPU-accelerated terminal emulator
    # zoom-us # Video conferencing
    # postman # API testing tool
    # telegram-desktop # Messaging app
    # obsidian # Note-taking app
    # zen-browser # Browser
  ];

  # ZSH configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      . ~/.config/zsh/zshrc-arch

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      source ~/.config/zsh/.p10k.zsh
    '';
  };

  # Enable XDG desktop integration
  targets.genericLinux.enable = true;
  xdg.enable = true;
  xdg.mime.enable = true;
}
