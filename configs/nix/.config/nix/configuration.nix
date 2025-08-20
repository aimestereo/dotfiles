{ pkgs, user, ... }:
{
  nix = {
    settings = {
      # Enable Nix flakes
      experimental-features = "nix-command flakes";
      trusted-users = [
        user.name
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.05"; # Did you read the comment?

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
    ];

  # Update the system environment.
  programs.zsh.enable = true;
}
