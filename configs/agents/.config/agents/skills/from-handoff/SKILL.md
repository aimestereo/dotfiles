---
name: from-handoff
description: >-
  Pick up a handoff document and continue the work. Read every referenced file
  in full (no summarization), run init/context loading, and isolate feature
  work in a git worktree. Use when the commander points at a handoff file or
  says "continue from handoff", "pick up where we left off", or invokes
  /from-handoff.
---

# /from-handoff — Resume from a handoff document

You are continuing work a prior session handed off. **Do not re-derive context from memory or skim.** Load the artifacts, then execute.

## 1. Open the handoff

- If the commander gave a path, **Read that file in full**.
- If they pasted a path in chat, Read it.
- If unclear, ask once for the handoff path.

## 2. Read everything it references — in full, no summarization

For every artifact the handoff cites (PRDs, plans, ADRs, task IDs, wiki slugs, file paths, PR URLs, commits):

- **Read the complete file or fetch the complete record** — do not paraphrase, truncate, or "summarize for yourself" instead of loading it.
- Follow links recursively until you hit primary sources (code, schema, protocol docs).
- If the handoff names a PKA task (`display_id`), call `init` (cwd) then `task_get` with `include_active_comments: true` and read the full description + comments.
- Run **CLAUDE.md discovery** on the anchor paths you will touch (walk up; Read every `CLAUDE.md` + `CLAUDE.local.md` on the path).

Stop and ask the commander only when a referenced artifact is missing or ambiguous — not to re-confirm things already in the handoff.

## 3. Honor the handoff's routing

- Use the **skills** the handoff recommends (e.g. `/sky-only`, `/to-prd`, `/git-workflow`).
- Respect **constraints** it states (out of scope, blocked decisions, branch naming, env assumptions).
- Treat the handoff as a index — durable truth stays in the linked artifacts.

## 4. Work in a git worktree

Feature/fix work runs in an **isolated worktree**, not the shared checkout:

1. Create or enter a dedicated worktree + feature branch for this handoff's task.
2. Do all edits and local verification **inside that worktree** (absolute paths under the worktree root).
3. Scope build/test commands to the worktree (`-C`, `--dir`, or equivalent).
4. If you delegate to subagents, pass the **absolute worktree path** and forbid git — see `/git-workflow` § Worktrees.
5. Clean up session-created worktrees at close-out per `/git-workflow` § Worktrees.

## 5. Confirm briefly, then work

Post a **short** pickup note (task id, worktree path, branch, next step from the handoff) — not a re-summary of the artifacts. Proceed.

## Anti-patterns

- Skimming a PRD/plan and proceeding on a mental model.
- Editing in the main repo checkout while another branch is checked out elsewhere.
- Re-interviewing the commander for decisions already captured in linked docs.
- Starting implementation before init + referenced files are fully loaded.
