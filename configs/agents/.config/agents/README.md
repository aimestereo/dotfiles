# Agent Configuration

AI agent commands and skills for Claude Code and Cursor, managed with GNU Stow.

## Structure

```
.config/agents/          # canonical source (always edit here)
├── commands/
│   └── feat.md
├── skills/
│   ├── git-workflow/SKILL.md
│   ├── grill-me/SKILL.md
│   ├── grill-with-docs/SKILL.md
│   ├── handoff/SKILL.md
│   ├── from-handoff/SKILL.md
│   ├── jira-b2b/SKILL.md
│   └── to-prd/SKILL.md
└── README.md

.claude/skills/<name>    → ../../.config/agents/skills/<name>
.cursor/skills/<name>    → ../../.config/agents/skills/<name>
```

## How It Works

**Commands** are markdown files invoked via `/command-name` (e.g., `/feat add user export`).

**Skills** are reusable protocols. Each skill is a directory with a `SKILL.md` file (YAML frontmatter: name, description). Skills can be auto-triggered by matching keywords or explicitly invoked via `/skill-name`.

## Canonical source vs client symlinks

**All skills live in `.config/agents/skills/`** — that is the only place to add or edit skill content.

Client directories (`.claude/skills/`, `.cursor/skills/`) are **symlink indexes**, not second copies. Stow projects the canonical tree to `~/.config/agents/`; each client gets a symlink for every skill.

| Skill | `.claude/skills/` | `.cursor/skills/` |
|-------|:-----------------:|:-----------------:|
| `git-workflow` | ✓ | ✓ |
| `grill-me` | ✓ | ✓ |
| `grill-with-docs` | ✓ | ✓ |
| `handoff` | ✓ | ✓ | Write handoff doc for next session |
| `from-handoff` | ✓ | ✓ | Pick up handoff — full reads, init, worktree isolation |
| `jira-b2b` | ✓ | ✓ |
| `to-prd` | ✓ | ✓ |

**Rule:** create the skill under `.config/agents/skills/<name>/`, then add symlinks in **both** `.claude/skills/<name>` and `.cursor/skills/<name>` pointing to `../../.config/agents/skills/<name>`.

PKA team skills (`sky*`, `prd-write`, …) live in the **PKA repo stow** (`pka/stow/pka-team/`), not here. Exception: `/to-prd` is personal and lives in dotfiles; `/prd-write` is PKA MCP mechanism and stays in PKA stow.

## Symlink Setup

Stow symlinks the whole `agents` package to `$HOME` with `--no-folding`. Relative symlinks inside the package resolve to `~/.config/agents/...` after stow:

```
.claude/commands/<cmd>.md   → ../../.config/agents/commands/<cmd>.md
.claude/skills/<skill>      → ../../.config/agents/skills/<skill>
.cursor/commands/<cmd>.md   → ../../.config/agents/commands/<cmd>.md
.cursor/skills/<skill>      → ../../.config/agents/skills/<skill>
```

## Adding a New Command

1. Create `.config/agents/commands/<name>.md`
2. Symlink in `.claude/commands/` and `.cursor/commands/`
3. Re-stow: `utils/stow-packages` from dotfiles root (or `make symlinks-mac` / `make symlinks-fedora`)

## Adding a New Skill

1. Create `.config/agents/skills/<name>/SKILL.md` with YAML frontmatter
2. Symlink in `.claude/skills/<name>` → `../../.config/agents/skills/<name>`
3. Symlink in `.cursor/skills/<name>` → `../../.config/agents/skills/<name>`
4. Re-stow the `agents` package
