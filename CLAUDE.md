# Dotfiles

MacOS/Linux environment configuration managed with GNU Stow.

## Structure

```
dotfiles/
├── configs/           # Stow packages (each subdirectory is a package)
│   ├── agents/        # AI agent commands (Claude, Cursor)
│   ├── git/           # Git configuration
│   ├── hammerspoon/   # macOS automation
│   ├── kanata/        # Keyboard remapping
│   ├── nix/           # Nix/Home Manager
│   ├── nushell/       # Nushell shell
│   ├── nvim/          # Neovim
│   ├── omarchy/       # Omarchy Linux customization
│   ├── shell/         # Shell configs (zsh/bash)
│   └── tmux/          # Tmux
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
make nix-mac       # Nix/Home Manager only
```

## Key Utilities

- `utils/symlinks` - Stow all config packages to $HOME
- `utils/mac-install` - Install Homebrew and packages
- `utils/mac-after-install` - Post-install configuration
