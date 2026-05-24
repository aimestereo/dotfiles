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
    ];

    brews = [
      "ical-buddy" # for tmux calendar plugin
      "borders" # Window borders for macOS (replaces jankyborders)
      "mactop" # top-like activity monitor for macOS

      "worktrunk" # CLI for Worktrunk, a tool for managing workspaces and projects

      # moved from nix due to closure size
      "hadolint" # Dockerfile linter
      "mermaid-cli" # Generate diagrams and flowcharts from text (used by neovim plugins)
      "mise" # Manage development environments for multiple languages
      "awscli" # AWS command line interface
      "tectonic" # Modern LaTeX engine
      "yarn" # Yarn package manager (for JS/TS projects)
      "imagemagick" # Image processing tools (used by neovim plugins)
      "cmake" # Cross-platform build system generator
      "perl" # Perl interpreter (required by fzf for some features)
      "luarocks" # Lua package manager (for neovim plugins)
      "rust" # Rust compiler and package manager
      "xonsh" # Python-powered shell (cross-shell config for Fedora; opt-in on Mac via `xonsh -i`)
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
      "ghostty"
      "kitty" # GPU-accelerated terminal emulator
      "claude"
      "claude-code"

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
