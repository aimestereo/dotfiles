{ user, ... }:
{
  users.users = {
    ${user.name} = {
      home = user.homeDir;
    };
  };

  # Use Touch ID for sudo authentication.
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false; # don't rearrange spaces
      expose-group-by-app = true; # to fix missioncontrol after aerospace
    };
    finder.ShowPathbar = true;
    NSGlobalDomain."com.apple.keyboard.fnState" = true;
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
      "1password"

      "docker"
    ];
  };

}
