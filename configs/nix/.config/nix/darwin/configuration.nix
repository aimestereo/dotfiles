{ user, ... }:
{
  users.users = {
    ${user.name} = {
      home = user.homeDir;
    };
  };

  # Use Touch ID for sudo authentication.
  security.pam.services.sudo_local.touchIdAuth = true;

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
    ];

    casks = [
      "hammerspoon"
      "force-paste"
      "alfred"
      "docker"
      "1password"
      "karabiner-elements"

      "yandex" # browser, nix version is x86 only
      "transmission" # torrent client
    ];
  };

}
