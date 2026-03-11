# Jira Ticket Workflow

Work on a Jira ticket from understanding to pull request.

## Arguments

- `$ARGUMENTS` - Jira ticket ID (e.g., PROJ-123) or Jira browse URL

## Jira MCP Reference

- **cloudId**: Call `getAccessibleAtlassianResources` first to get the cloudId
- **Description format**: `editJiraIssue` accepts markdown strings for `description` — do NOT pass ADF objects
- **Linking PR to ticket**: Add a Jira comment with the PR link (not a remote link)

## Instructions

### 0. Assess Current State

Before starting, check what's already done:

- Run `git log main..HEAD --oneline` and `git diff main...HEAD --stat` to see if code is already on the branch
- If code is done: skip to PR creation
- If no code yet: follow the full workflow from step 1

Parallelize independent calls — fetch Jira ticket details and git state in the same step.

### 1. Read Skills

Read the `git-workflow` and `orchestrate` skills.

### 2. Follow Orchestration Protocol with Jira Context

- Analyst fetches Jira ticket details (summary, description, acceptance criteria, comments) as part of research
- Branch/commit/PR naming includes ticket ID (per `git-workflow` skill)
- After each PR creation: link PR to Jira ticket via comment
- After all PRs complete: fill Jira description if empty using `editJiraIssue` with markdown (Problem / Fix / Affected Services)

### 3. Report Final PR URL(s) to User
