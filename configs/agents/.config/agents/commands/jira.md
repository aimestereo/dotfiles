# Jira Ticket Workflow

Work on a Jira ticket from understanding to pull request.

## Arguments

- `$ARGUMENTS` - Jira ticket ID (e.g., PROJ-123) or Jira browse URL

## Jira MCP Reference

- **cloudId**: Call `getAccessibleAtlassianResources` first to get the cloudId
- **Description format**: `editJiraIssue` accepts markdown strings for `description` — do NOT pass ADF objects
- **Linking PR to ticket**: Add a Jira comment with the PR link (not a remote link)

## Instructions

### 1. Read Skills

Read the `git-workflow` and `orchestrate` skills.

### 2. Become Coordinator

You are the Coordinator. **Do NOT fetch Jira tickets yourself** — delegate everything to the Analyst sub-agent. Pass the ticket IDs/URLs and the Jira MCP Reference section above into the Analyst prompt so it can fetch ticket details.

### 3. Follow Orchestration Protocol with Jira Context

Spawn Analyst with these Jira-specific additions to its prompt:

- Jira ticket IDs/URLs: `$ARGUMENTS`
- Include the Jira MCP Reference section from this command
- Analyst must: fetch ticket details (summary, description, acceptance criteria, comments), check git state (`git log main..HEAD`, `git diff main...HEAD --stat`), assess if code already exists on branch
- Analyst includes ticket context in the plan output

Additional Jira steps during orchestration:

- Branch/commit/PR naming includes ticket ID (per `git-workflow` skill)
- After each PR creation: Coordinator links PR to Jira ticket via comment (this is the one Jira MCP call the Coordinator makes)
- After all PRs complete: Coordinator fills Jira description if empty using `editJiraIssue` with markdown (Problem / Fix / Affected Services)

### 4. Report Final PR URL(s) to User
