---
name: git-workflow
description: Git workflow conventions for branching, commits, PRs, Jira linking, and stacked PRs. Referenced by /feat, /jira, /team commands.
triggers:
  - branch naming
  - commit convention
  - pull request
  - stacked PR
  - Jira linking
  - worktree
  - git worktree
role: protocol
scope: workflow
output-format: instructions
---

# Git Workflow

## Branching

Never commit to main. Always work on feature branches.

- With Jira: `<type>/<TICKET-ID>-<description>` (e.g., `feat/PROJ-123-add-export`)
- Without Jira: `<type>/<description>` (e.g., `feat/add-export`)
- Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`
- Kebab-case for descriptions

Check current branch before any changes. If on main, create a feature branch first.

## Commits

Conventional format: `<type>(<scope>): <subject>`

- With Jira ticket, use ticket ID as scope: `feat(PROJ-123): add export endpoint`
- Without Jira: `feat: add export endpoint` or `feat(module): add export endpoint`
- Subject: 50 chars max, imperative mood ("add" not "added"), no period
- Atomic: one logical change per commit
- For complex changes: add body explaining what/why (72-char wrapped lines)
- Never include "Co-Authored-By"

## Pull Requests

Always push and create a PR after completing work. Do not ask — just do it.

**Title**: same format as commits.

- With Jira: `feat(PROJ-123): add export endpoint`
- Without Jira: `feat: add export endpoint`

**Body**:

```markdown
Jira: [PROJ-123](https://<org>.atlassian.net/browse/PROJ-123)

## Summary
- <what changed and why, bullet points>

## Test plan
- [ ] <verification steps>
```

Omit the Jira line when no ticket is involved.

**Jira linking**: after PR creation, add a comment on the Jira ticket:

```
PR: [#NUMBER TITLE](URL)
```

## Stacked PRs

When a plan decomposes into 2+ independently reviewable units, use stacked PRs.

Single logical unit = one PR to main (no stacking). If units are independent (no dependency between them), prefer multiple independent PRs targeting `main` over stacking.

**Planning phase** identifies PR boundaries by:

- Independent subsystems (schema, API, frontend)
- Dependency order (infrastructure first, then consumers)
- Risk isolation (risky changes in their own PR)

**Plan output**: numbered PR list with files, description, and base branch per PR.

**Branch chaining**:

- PR1 targets `main`
- PR2 targets PR1's branch
- PR3 targets PR2's branch
- Create with `gh pr create --base <parent-branch>`

**Branch naming for stacked PRs with Jira**:

```
feat/PROJ-123-add-schema    (PR1)
feat/PROJ-123-add-api       (PR2)
feat/PROJ-123-add-ui        (PR3)
```

Each PR goes through full review+CI loop before starting the next.

**Updating stacked PRs** — never cascade-update the whole stack. A PR is only updated in two cases:

1. **Own CI/review failure**: the PR's own checks or review found issues — fix on its branch, push
2. **Direct parent merged**: the immediately preceding PR was merged into main — rebase onto updated main and verify the PR base was retargeted to `main` (GitHub usually does this automatically)

If an early PR gets fixes, do NOT force-update or rebase the following PRs. They will naturally pick up the changes when their direct parent merges. This minimizes unnecessary rebases and avoids overburdening CI with redundant runs across the stack.

## Worktrees

Feature/fix work runs in an **isolated git worktree** — a separate checkout directory with its own branch — not the shared main checkout. Applies to orchestrated sessions (Sky, `/from-handoff`, multi-agent workflows) and solo work when parallel sessions are possible.

### Why

Subagents and shell tools often **default cwd to the main repo**, not the worktree. Relative paths and bare `git` commands then hit the wrong checkout. A subagent that silently fails to switch branch can commit onto another session's branch while the intended worktree stays empty.

### Discipline

**Orchestrator owns all git.** Subagents run **zero** git commands — no `checkout`, `add`, `commit`, `branch`, `stash`. The orchestrator (session cwd in the worktree) creates branches, stages, commits, and pushes.

**Subagents use absolute worktree paths only.** Hand every implementer/reviewer the full path under the worktree root. Never a relative path that resolves against the main checkout.

**Scope build/test to the worktree.** Pass an explicit directory flag, e.g. `go -C <worktree>/... test ./...`, `pnpm -C <worktree>/... test`.

**Verify topology before review.** After implementation returns, confirm `git -C <worktree> log --oneline <base>..HEAD` shows the expected commit(s) on the expected branch before dispatching review.

**Never reset another checkout.** If a commit lands on the wrong branch, cherry-pick into the correct worktree branch (additive) and leave the stray commit for the owning session to drop — do not `reset` without commander sign-off.

### Dispatch boilerplate (subagents)

> Your shell cwd may be the main repo. Operate ONLY on the worktree at `<abs path>`: edit via absolute worktree paths, scope build/test to that tree (`-C` / `--dir`), run NO git commands — the orchestrator owns git.

### Cleanup at close-out

Whoever created the worktree removes it — **do not ask** "should I remove it?".

- **Squash-merge artifact ≠ unsaved work.** After squash-merge, the local feature branch may still show commits "not in main" (pre-squash SHAs differ). Verify the PR merged (`gh pr view <n> --json state,mergeCommit` → `MERGED`) and content is on `main`, then remove the worktree with discard — no prompt needed.
- **Block only on real unsaved work:** unpushed commits that were never merged anywhere. Merged-then-squashed branches are safe to discard.
- **Push before remove.** Remote holds the work; confirm merged, then drop the local worktree freely.
