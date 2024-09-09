{ pkgs, user, ... }:
{
  nix = {
    useDaemon = true;
    configureBuildUsers = true;
    settings.experimental-features = "nix-command flakes";
  };

  # Auto upgrade nix package and the daemon service (for non-root users).
  services.nix-daemon.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
  ];

  # Update the system environment.
  programs.zsh.enable = true;
}
