# Dotfiles

MacOS/Linux environment configuration managed with GNU Stow.

## Structure

```
dotfiles/
├── configs/           # Stow packages (each subdirectory is a package)
│   ├── agents/        # AI agent commands (Claude, Cursor)
│   ├── aws/           # AWS CLI helpers (stow package; currently a placeholder)
│   ├── brightness/    # `brightness-control` (ddcutil-based DDC/CI control; Linux)
│   ├── btop/          # btop process monitor (`color_theme = "current"`; theme palette via `theme-bootstrap` symlink).
│   ├── direnv/        # Direnv global config (`direnv.toml` whitelist + settings)
│   ├── ghostty/       # Ghostty terminal (includes ~/.config/theme/current/ghostty.conf)
│   ├── git/           # Git configuration
│   ├── hammerspoon/   # macOS automation (Hyper key, window mgmt, draw on screen)
│   ├── keyd/          # CapsLock → Hyper remap (Fedora; sudo-installed to /etc/keyd)
│   ├── kitty/         # Kitty terminal (includes ~/.config/theme/current/kitty.conf)
│   ├── mise/          # mise tool versions (host + bind-mounted into DevPod containers)
│   ├── nix/           # Nix/Home Manager
│   ├── nushell/       # Nushell shell
│   ├── nvim/          # Neovim (theme-aware: `lua/plugins/colorscheme.lua` eager-installs all theme colorscheme plugins and tracks `theme-set` live via an fs_event watcher on `~/.config/theme/current`)
│   ├── shell/         # Cross-platform shell configs (zsh, atuin, generic rc)
│   ├── shell-fedora/  # Fedora-only `.bashrc` (kept separate from Mac for divergence)
│   ├── shell-mac/     # macOS-only `.bashrc`
│   ├── starship/      # Starship cross-shell prompt config
│   ├── theme/         # Vendored omarchy theme sources + templates; `theme-render` / `theme-set` / `theme-update` scripts
│   ├── tmux/          # Tmux
│   ├── toolbox/       # Stowed host↔toolbox wrappers: toolbox-run, devpod, devpod-up, devpod-allocate-loopback-ip, xdg-open, swaymsg. Fedora-only (excluded from Mac stow).
│   ├── waybar/        # Waybar styling (style.css only; imports theme palette). Fedora-only (excluded from Mac stow).
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

Run `make symlinks-mac` to apply all packages on macOS (`make symlinks-fedora` for Fedora). Both targets are two-line recipes that invoke `utils/stow-packages` (with the per-platform exclude regex) followed by `utils/theme-bootstrap`.

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
make mac                   # Full macOS setup
make fedora-bootstrap      # Host shell only. Sync host (rpm-ostree layer + repos + Flathub remote); idempotent, requires reboot
make fedora                # Host shell only. Full Fedora post-install (Pattern B: toolbox-as-outer — see workstation-bootstrap/dev-containers.md)
make fedora-recreate-tools # Host shell only. Stop + remove + re-provision the `tools` toolbox from scratch (then re-runs `make fedora`).
make symlinks-mac          # Just symlink configs (Mac; skips shell-fedora, toolbox, waybar)
make symlinks-fedora       # Symlink configs (Fedora; skips hammerspoon, nix, shell-mac). Runs from host OR toolbox — $HOME is shared.
make nix-mac               # Nix/Home Manager (macOS)
make nix-linux             # Home Manager only (Linux/Fedora)
```

> Fedora targets that talk to host-only state (flatpak, podman containers, systemd, rpm-ostree) **must** run from the host shell. `make fedora` enforces this with a `/run/.toolboxenv` guard; the others fail naturally when their CLI isn't on the toolbox PATH.

## Fedora Workstation

The end-to-end spec for the Fedora Atomic Sway workstation — USB Tier-1 bootstrap, host package layer, terminals + theme, keyd Hyper-key remap, Pattern B toolbox-as-outer topology, xonsh interactive ergonomics (Mac zsh parity), per-project devpod containers, direnv/mise/devenv translation, Tailscale + AmneziaVPN networking, Flatpak GUI apps — lives in **[workstation-bootstrap/prd-fedora-workstation.md](workstation-bootstrap/prd-fedora-workstation.md)**. Read it before making non-trivial Fedora-side changes. Mac, Nix, devenv, and zsh are referenced only as baseline sources for replicated configs; they are not modified by the PRD.

## Shells

- **zsh** (Mac default) — `configs/shell/` with p10k via zinit, atuin, zoxide, fzf, mise, direnv, carapace.
- **xonsh** (opt-in via `xonsh -i`, planned Fedora default) — `configs/xonsh/`. Mirrors zsh's tool integrations; uses starship as the cross-shell prompt. Two xontribs (`xonsh-direnv`, `xontrib-fzf-widgets`) are required and installed by `utils/mac-after-install` via xonsh's bundled pip (`xpip`); versions are pinned in `utils/xontrib-requirements.txt`.

## Hyper Key

CapsLock acts as a Hyper key for global shortcuts (app switching, window management, etc.).

Two modes available (set `HYPER_MODE` in `configs/hammerspoon/.hammerspoon/init.lua`):

- **`quad`** (default) — Karabiner-Elements maps CapsLock → Cmd+Ctrl+Alt+Shift. Bindings in `quad-mapping.lua` are plain `hs.hotkey.bind` calls. No modal, survives sleep.
- **`f18`** (legacy) — hidutil maps CapsLock → F18. Uses `hs.hotkey.modal` via `hyper/` module. Can break after macOS sleep cycles.

## Terminal Theme

Kitty and Ghostty include their palette from `~/.config/theme/current/`, a symlink at one of the rendered themes under `~/.config/theme/rendered/`. The theme catalog is vendored in the repo — palettes (`colors.toml`) and upstream per-theme overrides under `configs/theme/.config/theme/themes/<name>/`, omarchy renderer templates under `configs/theme/.config/theme/themed/*.tpl`. Backgrounds are not vendored.

Stow uses `--no-folding` for the `theme/` package (and `agents/`, `btop/` — see Key Utilities below) so `~/.config/theme/` stays a real directory (`themes/` and `themed/` are per-file symlinks; `rendered/` and `current` are runtime-only and never touch the repo).

- `theme-render [<name>]` — renders runtime themes under `~/.config/theme/rendered/<name>/` (all themes by default) by copying sources from `~/.config/theme/themes/<name>/` then applying `theme-set-templates`. Per-theme upstream override files win over template renders (skip-if-exists guard).
- `theme-set-templates [theme-dir]` — vendored from omarchy. Renders `~/.config/theme/themed/*.tpl` against the theme dir's `colors.toml` (palette via `{{ key }}` / `{{ key_strip }}` / `{{ key_rgb }}` placeholders).
- `theme-set <name>` (or no arg for interactive picker via fzf / numbered menu) — retargets `~/.config/theme/current → rendered/<name>` and live-reloads running terminals (`SIGUSR1` kitty, `SIGUSR2` ghostty), waybar (`SIGUSR2`), and btop (`SIGUSR2`). Renders on demand if missing. Defaults to `catppuccin` on a host with no `current` symlink yet.
- `theme-bg-set <name|path>` (or no arg for interactive picker with fzf + chafa image preview) — retargets the `~/.config/theme/current-background-image` symlink at an image under `~/backgrounds/` (or any absolute/relative path). Sway's `output * bg` and swaylock's `-i` flag both reference this symlink, so wallpaper rotation needs no config edit. Pushes `swaymsg "output * bg …"` when sway is running; swaylock picks up the change at the next lock. `theme-bootstrap` seeds the symlink to `car-with-full-moon-background.jpg` on first stow. The script is context-agnostic: the sway bindsym wraps the call in `toolbox-run` (see `configs/toolbox/.local/bin/toolbox-run`) so the picker has `fd` / `fzf` / `chafa` on PATH; sibling `~/.local/bin/swaymsg` toolbox-wrapper bridges the swaymsg push back to host sway via `flatpak-spawn`.
- `theme-update` — refreshes the in-repo sources from `basecamp/omarchy@dev` (clones/pulls into `$OMARCHY_PATH`, default `~/.local/share/omarchy`), `rsync --delete`s upstream `themes/*/` (excluding `backgrounds/`) into the repo's `configs/theme/.config/theme/themes/`, copies `default/themed/*.tpl` into `configs/theme/.config/theme/themed/`, then re-runs `theme-render`. Review with `git status` / `git diff` and commit the refreshed sources.

`make symlinks-mac` / `make symlinks-fedora` run `theme-render` and seed the default `current` symlink at the end, so a fresh stow produces a working theme system with no extra steps. Switching themes does not require re-stowing.

## Key Utilities

- `utils/stow-packages <exclude-regex>` - Stow all packages under `configs/` except those whose name matches the regex. Special-cases the `theme`, `agents`, and `btop` packages with `--no-folding` (their target dirs — `~/.config/theme/`, `~/.claude/`, `~/.cursor/`, `~/.config/btop/` — receive runtime writes and/or contributions from another stow package, so they must stay real directories rather than folded symlinks into the repo). Used by `make symlinks-mac` (excludes `shell-fedora|toolbox|waybar`) and `make symlinks-fedora` (excludes `hammerspoon|nix|shell-mac`). Run from the repo root.
- `utils/theme-bootstrap` - Renders all themes (`theme-render`), seeds `~/.config/theme/current → rendered/catppuccin` if missing, seeds the wallpaper symlink, and (when `~/.config/btop/` exists) symlinks `~/.config/btop/themes/current.theme → ~/.config/theme/current/btop.theme`. Invoked by both `make symlinks-*` targets.
- `utils/mac-install` - Install Homebrew and packages
- `utils/mac-after-install` - Post-install configuration
