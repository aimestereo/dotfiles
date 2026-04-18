---
name: git-workflow
description: Git workflow conventions for branching, commits, PRs, Jira linking, and stacked PRs. Referenced by /feat, /jira, /team commands.
triggers:
  - branch naming
  - commit convention
  - pull request
  - stacked PR
  - Jira linking
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
