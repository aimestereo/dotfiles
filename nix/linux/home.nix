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

  # Enable XDG desktop integration
  targets.genericLinux.enable = true;
  xdg.enable = true;
  xdg.mime.enable = true;
}
