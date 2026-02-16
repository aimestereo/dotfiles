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
      "felixkratz/formulae" # For borders (jankyborders alternative)

      "netbirdio/tap" # For netbird VPN
    ];

    brews = [
      "ical-buddy" # for tmux calendar plugin
      "kanata"
      "borders" # Window borders for macOS (replaces jankyborders)

      "netbirdio/tap/netbird" # netbird VPN CLI
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

      "balenaetcher" # for creating bootable USB drives

      "calibre" # ebook management

      # dev tools
      "zed" # code editor
      "kitty" # GPU-accelerated terminal emulator
      "claude"
      "claude-code"

      "netbirdio/tap/netbird-ui" # GUI for netbird VPN
      # "aws-vpn-client" # AWS VPN client
      "tailscale-app" # Tailscale VPN client

      # GUI apps moved from nix (previously required mac-app-util)
      "slack" # Team communication
      "postman" # API testing tool
      "telegram" # Messaging app
      "obsidian" # Note-taking app
      "iina" # Modern media player for macOS

      # macOS utilities moved from nix (to avoid Swift build dependency)
      "mos" # Mouse, keyboard, and touchpad customization
      "monitorcontrol" # External monitor brightness and volume control
    ];
  };

}
