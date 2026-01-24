{ username, homeDirectory, ... }:
{
  users.users = {
    ${username} = {
      home = homeDirectory;
    };
  };

  # Use Touch ID for sudo authentication.
  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = username;
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false; # don't rearrange spaces
      expose-group-apps = true; # to fix missioncontrol after aerospace
    };
    finder.ShowPathbar = true;
    NSGlobalDomain."com.apple.keyboard.fnState" = true;
    NSGlobalDomain._HIHideMenuBar = true;
  };

  homebrew = {
    enable = true;

    taps = [
      "beeftornado/rmtree"
    ];

    brews = [
      "ical-buddy" # for tmux calendar plugin
      "kanata"
    ];

    casks = [
      "hammerspoon"
      "force-paste"
      "alfred"
      "1password"
      "karabiner-elements"

      "arc" # arc-browser updates often, use brew version to avoid overrides
      "yandex" # browser, nix version is x86 only
      "transmission" # torrent client
      "zoom"
      "zed" # code editor

      "balenaetcher" # for creating bootable USB drives

      "calibre" # ebook management

      # GUI apps moved from nix (previously required mac-app-util)
      "kitty" # GPU-accelerated terminal emulator
      "slack" # Team communication
      "postman" # API testing tool
      "telegram" # Messaging app
      "obsidian" # Note-taking app
      "iina" # Modern media player for macOS
    ];
  };

}
