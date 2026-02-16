# Feature Workflow

Implement a feature from understanding to pull request.

## Arguments

- `$ARGUMENTS` - Task description (e.g., "add user export functionality")

## Instructions

### 1. Understand the Task

Parse the task description and clarify scope:
- What is the expected behavior?
- What are the acceptance criteria?
- Are there edge cases to consider?

Ask clarifying questions if:
- Requirements are ambiguous
- Technical approach isn't clear
- Scope needs boundaries

### 2. Analyze Codebase Impact

Determine scope:
- Which files/modules are affected?
- Are database changes needed?
- Are API changes required?
- What existing patterns should be followed?

Ask for clarification if:
- Change spans multiple areas and priority is unclear
- Breaking changes are required
- Migration strategy is needed

### 3. Create Implementation Plan

Before any code changes, present a plan for user approval:
- List files to be created/modified
- Describe the approach for each change
- Note any risks or alternatives considered
- Outline testing strategy

**Wait for explicit user approval before proceeding.**

### 4. Create Branch (Before Any Changes)

**Create the branch BEFORE making any code changes. Never commit to main.**

Branch naming: `feat/<short-description>`
- Use kebab-case for description
- Example: `feat/add-user-export`

```bash
git checkout -b feat/<short-description>
```

### 5. Implement Changes

Follow project conventions. Commit atomically as you code (one logical change per commit).

### 6. Create Pull Request

Push branch and create PR with:
- Summary of changes
- Test plan or verification steps
