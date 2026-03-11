# Feature Workflow

Implement a feature from understanding to pull request.

## Arguments

- `$ARGUMENTS` - Task description (e.g., "add user export functionality")

## Instructions

1. Read the `git-workflow` and `orchestrate` skills
2. Follow the orchestration protocol:
   - Spawn Analyst with task: `$ARGUMENTS`
   - Present plan for approval (wait for explicit user approval)
   - Execute per-PR loop (implement → local review → local CI → create PR → PR review + PR CI)
3. Report final PR URL(s) to user
