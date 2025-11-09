{ pkgs, username, ... }:
{
  nix = {
    settings = {
      # Enable Nix flakes
      experimental-features = "nix-command flakes";
      trusted-users = [
        username
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
  system.stateVersion = 5;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
  ];

  # Update the system environment.
  programs.zsh.enable = true;
}
