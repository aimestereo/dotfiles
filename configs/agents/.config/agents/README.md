# Agent Configuration

AI agent commands and skills for Claude Code and Cursor, managed with GNU Stow.

## Structure

```
.config/agents/
├── commands/          # User-invocable commands (/feat)
│   └── feat.md
├── skills/            # Reusable skills referenced by commands
│   └── git-workflow/
│       └── SKILL.md
└── README.md
```

## How It Works

**Commands** are markdown files invoked via `/command-name` (e.g., `/feat add user export`).

**Skills** are reusable protocols that commands reference. Each skill is a directory with a `SKILL.md` file containing YAML frontmatter (name, description, triggers). Skills can be auto-triggered by matching keywords or explicitly referenced by commands.

**Plugins** provide specialized agents used by commands:

- `feature-dev` — guided feature development (exploration, architecture, implementation, review)
- `pr-review-toolkit` — comprehensive PR review (code, tests, errors, types, comments, simplification)

## Symlink Setup

Stow symlinks `.config/agents/` to `~/.config/agents/`. Each tool also needs its own symlinks so it can discover commands and skills:

```
.claude/commands/<cmd>.md   → ../../.config/agents/commands/<cmd>.md
.claude/skills/<skill>      → ../../.config/agents/skills/<skill>
.cursor/commands/<cmd>.md   → ../../.config/agents/commands/<cmd>.md
.cursor/skills/<skill>      → ../../.config/agents/skills/<skill>
```

These are relative symlinks inside the stow package. When stowed to `$HOME`, they resolve to `~/.config/agents/...`.

## Adding a New Command

1. Create `commands/<name>.md`
2. Add symlinks in `.claude/commands/` and `.cursor/commands/` pointing to `../../.config/agents/commands/<name>.md`
3. Run `make symlinks`

## Adding a New Skill

1. Create `skills/<name>/SKILL.md` with YAML frontmatter
2. Optionally add `skills/<name>/references/` for supporting docs
3. Add symlinks in `.claude/skills/` and `.cursor/skills/` pointing to `../../.config/agents/skills/<name>`
4. Run `make symlinks`
