{ pkgs, ... }:

{
  # Import common configuration
  imports = [
    ../common.nix
  ];

  # Darwin-specific packages
  home.packages = with pkgs; [
    coreutils # GNU coreutils for macOS (provides gls, gcat, etc.)
    _1password-cli # 1Password command line interface
    gh # GitHub CLI for repository management

    # GUI Applications moved to homebrew (nix/darwin/configuration.nix)
    # to avoid Swift build dependency and re-builds on updates
  ];
}
