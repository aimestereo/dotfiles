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

## Agent Commands

The `agents` package contains AI agent commands for Claude Code and Cursor:

```
configs/agents/
├── .config/agents/commands/    # Source commands
│   └── jira.md
├── .claude/commands/           # Symlinks for Claude Code
│   └── jira.md -> ../../.config/agents/commands/jira.md
└── .cursor/commands/           # Symlinks for Cursor
    └── jira.md -> ../../.config/agents/commands/jira.md
```

Commands are markdown files invoked via `/command-name` (e.g., `/jira PROJ-123`).

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
