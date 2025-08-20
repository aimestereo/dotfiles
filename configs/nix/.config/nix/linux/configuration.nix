{ config, pkgs, user, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking = {
    hostName = user.hostname;
    networkmanager.enable = true;
  };
  
  # Time zone and locale
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  
  # User account
  users.users.${user.name} = {
    isNormalUser = true;
    extraGroups = [];
    shell = pkgs.zsh;
  };

  # Enable sound
  services.pulseaudio.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
  ];
}

