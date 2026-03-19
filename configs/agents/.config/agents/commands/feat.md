# Feature Workflow

Implement a feature from understanding to pull request.

## Arguments

- `$ARGUMENTS` - Task description, optionally with a Jira ticket ID or URL (e.g., "PROJ-123 add user export" or "add user export")

## Jira MCP Reference

Only relevant when `$ARGUMENTS` contains a Jira ticket ID or browse URL.

- **cloudId**: Call `getAccessibleAtlassianResources` first to get the cloudId
- **Description format**: `editJiraIssue` accepts markdown strings for `description` — do NOT pass ADF objects
- **Linking PR to ticket**: Add a Jira comment with the PR link (not a remote link)

## Instructions

### 1. Setup

Read the `git-workflow` skill. Create a feature branch per its conventions.

If `$ARGUMENTS` contains a Jira ticket ID or URL, fetch ticket details (summary, description, acceptance criteria, comments) via Jira MCP and incorporate them into the task context for step 2.

### 2. Implement

Run `/feature-dev:feature-dev` with the task description (and Jira context if applicable).

### 3. Local CI

After implementation, run pre-flight checks appropriate for changed files:

- JavaScript/TypeScript: `pnpm lint`, `pnpm test`
- Python: `ruff check`, `ruff format --check`, `pytest`
- Go: `make lint`, `make test` (or `golangci-lint run`, `go test ./...`)
- Terraform: `tofu fmt -check`, `tofu validate`

If checks fail, fix and re-run. When green: `git add`, commit (conventional format per `git-workflow`), push.

### 4. Create PR

Create PR following `git-workflow` conventions (`gh pr create`). For stacked PRs use `--base <parent-branch>`.

If Jira ticket: link PR to ticket via Jira MCP comment. If Jira description is empty, fill it using `editJiraIssue` with markdown (Problem / Fix / Affected Services).

### 5. PR Review

Run `/pr-review-toolkit:review-pr` on the created PR.

If critical issues found: fix → re-run local CI → push → re-review. Max 3 cycles.

### 6. PR CI

Monitor GitHub Actions: `gh run list --branch <branch> --limit 1`, then `gh run watch <run-id>`.

If red: get failure logs with `gh run view <run-id> --log-failed`, fix, push, re-monitor. Max 3 cycles.

### 7. Report

Report final PR URL(s) to user.
