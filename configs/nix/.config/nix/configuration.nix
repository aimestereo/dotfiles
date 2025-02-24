{ pkgs, user, ... }:
{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        user.name
      ];
    };
  };
  system.stateVersion = 5;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
    ];

  # Update the system environment.
  programs.zsh.enable = true;
}
