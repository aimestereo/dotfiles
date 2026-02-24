# Jira Ticket Workflow

Work on a Jira ticket from understanding to pull request.

## Arguments

- `$ARGUMENTS` - Jira ticket ID (e.g., PROJ-123) or Jira browse URL

## Jira MCP Reference

- **cloudId**: Call `getAccessibleAtlassianResources` first to get the cloudId — all subsequent Jira/Confluence calls need it
- **Description format**: `editJiraIssue` accepts markdown strings for the `description` field — do NOT pass ADF objects, they will fail with "Failed to convert markdown to adf"
- **Linking PR to ticket**: Add a Jira comment with the PR link (not a remote link)

## Instructions

### 0. Assess Current State

Before starting, check what's already done:
- Run `git log main..HEAD --oneline` and `git diff main...HEAD --stat` to see if code is already on the branch
- If code is done: skip to step 5 (Fill Jira Description) and step 6 (Create PR)
- If no code yet: follow the full workflow from step 1

Parallelize independent calls — fetch Jira ticket details and git state in the same step.

### 1. Understand the Task

Use Jira MCP to gather context:
- Fetch the ticket details (summary, description, acceptance criteria)
- Check parent epic or linked issues for broader context
- Read comments for clarifications or updates
- Identify the ticket type (feature, bug, task, subtask)

Ask clarifying questions if:
- Requirements are ambiguous
- Acceptance criteria is missing or unclear
- Technical approach isn't specified

### 2. Analyze Codebase Impact

This is a monorepo. Determine scope:
- Which applications/services are affected?
- Are database changes needed? (Keystone/Prisma schema)
- Are API changes required?
- What existing patterns should be followed?

Ask for clarification if:
- Change spans multiple services and priority is unclear
- Breaking changes are required
- Migration strategy is needed

### 3. Create Implementation Plan

Before any code changes, present a plan for user approval:
- List files to be created/modified
- Describe the approach for each change
- Note any risks or alternatives considered
- Outline testing strategy

**Wait for explicit user approval before proceeding.**

### 4. Implement Changes

Create branch if needed: `<type>/<ticket-id>-<short-description>`
- Types: `feat`, `fix`, `chore`, `refactor`
- Example: `feat/PROJ-123-add-user-export`

Follow project conventions. Commit atomically (one logical change per commit).

### 5. Fill Jira Description

If the ticket description is empty or just a link, update it based on the actual work done:
- **Problem**: What was wrong and root causes
- **Fix**: What was changed and why
- **Affected Services**: Which services/files were touched

Use `editJiraIssue` with a markdown string for the `description` field.

### 6. Create Pull Request

Push branch and create PR with:
- Title: conventional commit style, under 70 chars
- Body structure:
  - `## Summary` — ticket link + bullet points explaining the change
  - `## Changed files` — list of files with one-line description each
  - `## Test plan` — checklist of verification steps

### 7. Link PR to Jira

Add a comment on the Jira ticket with the PR link:
```
PR: [#NUMBER TITLE](URL)
```
