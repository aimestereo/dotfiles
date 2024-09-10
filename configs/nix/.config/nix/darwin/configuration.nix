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
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.ShowPathbar = true;
  };

  homebrew = {
    enable = true;

    taps = [
      "beeftornado/rmtree"
    ];

    brews = [
      "ical-buddy" # for tmux calendar plugin

      # devs
      "libpq" # postgres client
    ];

    casks = [
      "hammerspoon"
      "force-paste"
      "gitup"
      "open-video-downloader"
      "alfred"
      "1password"
    ];
  };

}
