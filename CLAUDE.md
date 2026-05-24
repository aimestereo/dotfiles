# Dotfiles

MacOS/Linux environment configuration managed with GNU Stow.

## Structure

```
dotfiles/
├── configs/           # Stow packages (each subdirectory is a package)
│   ├── agents/        # AI agent commands (Claude, Cursor)
│   ├── brightness/    # `brightness-control` (ddcutil-based DDC/CI control; Linux)
│   ├── ghostty/       # Ghostty terminal (includes ~/.config/theme/current/ghostty.conf)
│   ├── git/           # Git configuration
│   ├── hammerspoon/   # macOS automation (Hyper key, window mgmt, draw on screen)
│   ├── keyd/          # CapsLock → Hyper remap (Fedora; sudo-installed to /etc/keyd)
│   ├── kitty/         # Kitty terminal (includes ~/.config/theme/current/kitty.conf)
│   ├── mise/          # mise tool versions (host + bind-mounted into DevPod containers)
│   ├── nix/           # Nix/Home Manager
│   ├── nushell/       # Nushell shell
│   ├── nvim/          # Neovim
│   ├── shell/         # Cross-platform shell configs (zsh, atuin, generic rc)
│   ├── shell-fedora/  # Fedora-only `.bashrc` (kept separate from Mac for divergence)
│   ├── shell-mac/     # macOS-only `.bashrc`
│   ├── starship/      # Starship cross-shell prompt config
│   ├── theme/         # `theme-update` / `theme-set-templates` / `theme-set` (palettes pulled from basecamp/omarchy)
│   ├── tmux/          # Tmux
│   └── xonsh/         # Xonsh shell — opt-in on Mac (`xonsh -i`), planned default on Fedora
├── nix/                    # Nix configuration (separate Makefile)
├── utils/                  # Installation scripts
└── workstation-bootstrap/  # USB-distributable Fedora Tier-1 bootstrap + day-to-day dev container docs
```

## How Stow Works

Each directory under `configs/` is a stow package. The internal structure mirrors `$HOME`:

```
configs/git/.config/git/config  →  ~/.config/git/config
configs/git/.local/bin/gclean   →  ~/.local/bin/gclean
```

Run `make symlinks-mac` or `utils/symlinks-mac` to apply all packages on macOS (`make symlinks-fedora` / `utils/symlinks-fedora` for Fedora).

## Agent Commands & Skills

The `agents` package contains AI agent commands and reusable skills for Claude Code and Cursor. See `configs/agents/.config/agents/README.md` for full setup details.

```
configs/agents/.config/agents/
├── commands/       # User-invocable (/feat)
└── skills/         # Shared protocols (git-workflow)
```

Commands and skills are symlinked to `.claude/` and `.cursor/` directories within the stow package. The `/feat` command leverages `feature-dev` and `pr-review-toolkit` plugins for implementation and PR review.

## Installation

```bash
make mac              # Full macOS setup
make fedora-bootstrap # Sync host (rpm-ostree layer + repos + Flathub remote); idempotent, requires reboot
make fedora           # Full Fedora post-install (Pattern B: toolbox-as-outer — see workstation-bootstrap/dev-containers.md)
make symlinks-mac     # Just symlink configs (Mac; skips shell-fedora)
make symlinks-fedora  # Symlink configs (Fedora; skips hammerspoon, nix, shell-mac)
make nix-mac          # Nix/Home Manager (macOS)
make nix-linux        # Home Manager only (Linux/Fedora)
```

## Shells

- **zsh** (Mac default) — `configs/shell/` with p10k via zinit, atuin, zoxide, fzf, mise, direnv, carapace.
- **xonsh** (opt-in via `xonsh -i`, planned Fedora default) — `configs/xonsh/`. Mirrors zsh's tool integrations; uses starship as the cross-shell prompt. Two xontribs (`xonsh-direnv`, `xontrib-fzf-widgets`) are required and installed by `utils/mac-after-install` via xonsh's bundled pip (`xpip`); versions are pinned in `utils/xontrib-requirements.txt`.

## Hyper Key

CapsLock acts as a Hyper key for global shortcuts (app switching, window management, etc.).

Two modes available (set `HYPER_MODE` in `configs/hammerspoon/.hammerspoon/init.lua`):

- **`quad`** (default) — Karabiner-Elements maps CapsLock → Cmd+Ctrl+Alt+Shift. Bindings in `quad-mapping.lua` are plain `hs.hotkey.bind` calls. No modal, survives sleep.
- **`f18`** (legacy) — hidutil maps CapsLock → F18. Uses `hs.hotkey.modal` via `hyper/` module. Can break after macOS sleep cycles.

## Terminal Theme

Kitty and Ghostty include their palette from `~/.config/theme/current/`, a symlink managed by three scripts in the `theme` stow package:

- `theme-update` — clones (or `git pull`s) `basecamp/omarchy@dev` into `$OMARCHY_PATH` (default `~/.local/share/omarchy`), then renders every theme's templates into `~/.config/theme/<theme>/`. First run defaults `current → catppuccin`.
- `theme-set-templates [theme-dir]` — vendored from omarchy. Renders `$OMARCHY_PATH/default/themed/*.tpl` against the theme dir's `colors.toml` (palette via `{{ key }}` / `{{ key_strip }}` / `{{ key_rgb }}` placeholders). User overrides in `~/.config/theme/themed/*.tpl` take precedence over built-in templates.
- `theme-set <name>` (or no arg for interactive picker via fzf / numbered menu) — retargets the `current` symlink.

Theme content is runtime state under `~/.config/theme/`; it is not tracked in the repo. Switching themes does not require re-stowing.

## Key Utilities

- `utils/symlinks-mac` - Stow Mac config packages to $HOME (excludes shell-fedora)
- `utils/symlinks-fedora` - Stow Fedora config packages to $HOME (excludes hammerspoon, nix, shell-mac)
- `utils/mac-install` - Install Homebrew and packages
- `utils/mac-after-install` - Post-install configuration
