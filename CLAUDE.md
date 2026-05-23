# Dotfiles

MacOS/Linux environment configuration managed with GNU Stow.

## Structure

```
dotfiles/
├── configs/           # Stow packages (each subdirectory is a package)
│   ├── agents/        # AI agent commands (Claude, Cursor)
│   ├── git/           # Git configuration
│   ├── hammerspoon/   # macOS automation (Hyper key, window mgmt, draw on screen)
│   ├── nix/           # Nix/Home Manager
│   ├── nushell/       # Nushell shell
│   ├── nvim/          # Neovim
│   ├── shell/         # Shell configs (zsh/bash) — Mac default
│   ├── tmux/          # Tmux
│   └── xonsh/         # Xonsh shell — opt-in on Mac (`xonsh -i`), planned default on Fedora
├── nix/               # Nix configuration (separate Makefile)
└── utils/             # Installation scripts
```

## How Stow Works

Each directory under `configs/` is a stow package. The internal structure mirrors `$HOME`:

```
configs/git/.config/git/config  →  ~/.config/git/config
configs/git/.local/bin/gclean   →  ~/.local/bin/gclean
```

Run `make symlinks` or `utils/symlinks` to apply all packages.

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
make mac           # Full macOS setup
make symlinks      # Just symlink configs
make nix-mac       # Nix/Home Manager (macOS)
make nix-linux     # Home Manager only (Linux/Fedora)
```

## Shells

- **zsh** (Mac default) — `configs/shell/` with p10k via zinit, atuin, zoxide, fzf, mise, direnv, carapace.
- **xonsh** (opt-in via `xonsh -i`, planned Fedora default) — `configs/xonsh/`. Mirrors zsh's tool integrations; uses starship as the cross-shell prompt. Two xontribs (`xonsh-direnv`, `xontrib-fzf-widgets`) are required and installed by `utils/mac-after-install` via xonsh's bundled pip (`xpip`).

## Hyper Key

CapsLock acts as a Hyper key for global shortcuts (app switching, window management, etc.).

Two modes available (set `HYPER_MODE` in `configs/hammerspoon/.hammerspoon/init.lua`):

- **`quad`** (default) — Karabiner-Elements maps CapsLock → Cmd+Ctrl+Alt+Shift. Bindings in `quad-mapping.lua` are plain `hs.hotkey.bind` calls. No modal, survives sleep.
- **`f18`** (legacy) — hidutil maps CapsLock → F18. Uses `hs.hotkey.modal` via `hyper/` module. Can break after macOS sleep cycles.

## Key Utilities

- `utils/symlinks` - Stow all config packages to $HOME
- `utils/mac-install` - Install Homebrew and packages
- `utils/mac-after-install` - Post-install configuration
