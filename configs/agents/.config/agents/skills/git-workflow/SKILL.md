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

Applies to projects with `git_strategy: git-workflow` (PR-based development). Projects that push to main (`git_strategy: direct-to-main`) are excluded.

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

## PR size

Target at most 300 lines of hand-written feature code per PR. Exclude tests, docs, ordinary config, and generated files. Security-relevant config (auth, permissions, access-control flags) counts. Trivial fixes below the target need no split. Larger features split into stacked PRs below.

Never split so part 1 alone is insecure or broken (for example part 1 removes an auth check that part 2 would restore). If a regen exposes a reachable surface, ship the auth check in the same PR or first.

## Stacked PRs

When a plan decomposes into 2+ independently reviewable units, use stacked PRs. All PRs in the stack share the **same Jira ticket** — do not create a Jira issue or Sub-task per PR.

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

`--base` only chains git. GitHub also has a separate **stack object** (the UI "Preview stack" / stack `#NNNN`). `gh pr create` does **not** join it. After every stacked `gh pr create`, join the stack via REST — do not wait for the commander to click **Add to stack**.

**Join GitHub stack (mandatory after stacked `gh pr create`)**

Need `Accept: application/vnd.github+json` and `X-GitHub-Api-Version: 2026-03-10`. Docs: [REST API — stacks](https://docs.github.com/en/rest/pulls/stacks).

```bash
OWNER_REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
NEW_PR=$(gh pr view --json number -q .number)
PARENT_BRANCH=$(gh pr view --json baseRefName -q .baseRefName)

# Skip GitHub stack for a PR that targets the default branch.
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
if [ "$PARENT_BRANCH" = "$DEFAULT_BRANCH" ]; then
  echo "PR #${NEW_PR} targets ${DEFAULT_BRANCH}; GitHub stack starts when PR2 is created"
  exit 0
fi

PARENT_PR=$(gh pr list --head "$PARENT_BRANCH" --state open --json number -q '.[0].number')
if [ -z "$PARENT_PR" ]; then
  echo "error: no open PR for base branch ${PARENT_BRANCH}" >&2
  exit 1
fi

STACK=$(gh api "repos/${OWNER_REPO}/pulls/${PARENT_PR}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  --jq '.stack.number // empty')

HDR=(-H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2026-03-10")
if [ -n "$STACK" ]; then
  # Append only the new PRs, current top of stack upward.
  gh api --method POST "repos/${OWNER_REPO}/stacks/${STACK}/add" "${HDR[@]}" \
    --input - <<< "{\"pull_requests\": [${NEW_PR}]}"
else
  # Parent not in a stack yet — create one, bottom (parent) to top (new).
  gh api --method POST "repos/${OWNER_REPO}/stacks" "${HDR[@]}" \
    --input - <<< "{\"pull_requests\": [${PARENT_PR}, ${NEW_PR}]}"
fi
```

When creating several stacked PRs in one session, one `/add` with all new numbers in order is enough (e.g. `[3129, 3131, 3134]`). First new PR's base ref must equal the current stack top's head ref.

Do not rely on `gh stack` unless `gh stack --help` works in this environment (extension, not core `gh`). Prefer the REST calls above.

**Branch naming for stacked PRs with Jira** — one ticket, distinct kebab suffixes:

```
feat/PROJ-123-add-schema    (PR1)
feat/PROJ-123-add-api       (PR2)
feat/PROJ-123-add-ui        (PR3)
```

Each PR title/commit uses the same `(PROJ-123)` scope. Comment every PR URL onto that one Jira issue.

Create the full stack in one pass. Do not wait for CodeRabbit or remote CI on a parent before opening the next PR. Join the GitHub stack as each PR is created. Address CodeRabbit when it posts; that is not a gate on creating the rest of the stack.

**Updating stacked PRs** — never cascade-update the whole stack. A PR is only updated in two cases:

1. **Own CI/review failure**: the PR's own checks or review found issues — fix on its branch, push
2. **Direct parent merged**: the immediately preceding PR was merged into main — rebase onto updated main and verify the PR base was retargeted to `main` (GitHub usually does this automatically)

If an early PR gets fixes, do NOT force-update or rebase the following PRs. They will naturally pick up the changes when their direct parent merges. This minimizes unnecessary rebases and avoids overburdening CI with redundant runs across the stack.

## Worktrees

Feature/fix work on `git-workflow` projects runs in an **isolated git worktree** — a separate checkout directory with its own branch — not the shared main checkout. Applies to orchestrated sessions (Sky, `/from-handoff`, multi-agent workflows) and solo work when parallel sessions are possible. `direct-to-main` projects are excluded.

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

Whoever created the worktree removes it — **do not ask** "should I remove it?". Remove only after the PR is `MERGED`.

- **Positive-attribution:** if you cannot confirm you created this worktree in the current session, skip it and note the path — do not guess.
- **Wait for delegates:** only after every agent dispatched to that worktree has returned.
- **Preserve while open:** uncommitted work, unpushed commits, or an open PR (pushed but not merged) — leave the worktree; do not ask. Set `blocked` only for real unsaved work that was never pushed.
- **After `MERGED`:** switch cwd to the main checkout → `git worktree remove <path>` → verify absent from `git worktree list` → delete the local feature branch (`git branch -d`, or `-D` after squash). Squash-merge SHAs differing from main is not unsaved work.
- **Surface failures:** if `git worktree remove` returns non-zero, log the error; do not silently swallow.
