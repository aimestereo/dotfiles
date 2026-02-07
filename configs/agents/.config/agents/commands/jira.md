# Jira Ticket Workflow

Work on a Jira ticket from understanding to pull request.

## Arguments

- `$ARGUMENTS` - Jira ticket ID (e.g., PROJ-123)

## Instructions

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

### 3. Create Branch

Branch naming: `<type>/<ticket-id>-<short-description>`
- Types: `feat`, `fix`, `chore`, `refactor`
- Example: `feat/PROJ-123-add-user-export`

### 4. Implement Changes

Follow project conventions. For database changes:
- Update Prisma schema in keystone
- Generate and review migrations
- Consider data migration if needed

Commit atomically as you code (one logical change per commit).

### 5. Create Pull Request

Push branch and create PR with:
- Reference to Jira ticket
- Summary of changes
- Test plan or verification steps
