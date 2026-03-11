---
name: orchestrate
description: Coordinator pattern for multi-agent workflows. The agent you talk to orchestrates sub-agents for research, coding, review, and CI. Used by /feat, /jira, /team commands.
triggers:
  - implement feature
  - multi-agent
  - orchestrate
  - coordinator
role: orchestrator
scope: workflow
output-format: instructions
---

# Orchestrate

## Coordinator Role

You are the **Coordinator**. You do NOT do research, write code, or run tests yourself. You spawn sub-agents (via Agent tool, subagent_type: general-purpose) for all implementation and research work. Stay context-clean for decision-making.

**What the Coordinator does directly:**

- Spawn and manage sub-agents
- Create branches (`git checkout -b`)
- Create PRs (`gh pr create`)
- Link PRs to external trackers (e.g., Jira MCP calls to add comments, update descriptions)
- Make meta-decisions: retry, escalate, change strategy

**What the Coordinator delegates to sub-agents:**

- All research (codebase exploration, ticket fetching, reading files)
- All code changes
- All reviews (local and PR)
- All test execution, linting, committing, pushing

**Sub-agent lifecycle:**

- Every Agent call returns an `agentId`. **Track all agent IDs.**
- To continue a previous agent's work, use `resume: <agentId>` instead of spawning a new agent. The resumed agent keeps its full previous context (research, reasoning, file reads).
- Resume when: user requests plan changes, follow-up investigation is needed, or a fix attempt needs the same context.
- Spawn fresh when: the task is unrelated to the previous agent's work, or the agent's context is no longer relevant.

**Before spawning any agent**, read all CLAUDE.md files in the project hierarchy and build a PROJECT CONTEXT block. Include it in every agent prompt:

```
PROJECT CONTEXT:
- Working directory: <path>
- Branch: <current branch>
- Commit style: <from CLAUDE.md>
- Key conventions: <tool preferences, env setup, etc.>
```

## Sub-Agent Roles

| Role | Responsibility | Commits? | Pushes? |
|------|---------------|----------|---------|
| Analyst | Research codebase, design plan, identify PR boundaries | No | No |
| Coder | Implement changes per plan (no commits) | No | No |
| Local Reviewer | Review uncommitted changes (`git diff`) | No | No |
| Local CI | Run tests/linters, commit, pre-commit hooks, push | Yes | Yes |
| PR Reviewer | Review PR diff, post review comment | No | No |
| PR CI | Monitor GitHub Actions, report status | No | No |

## Orchestration Flow

### Phase 1: Planning

1. Create feature branch (follow `git-workflow` skill conventions)
2. Spawn Analyst sub-agent with task + project context
3. Analyst: research codebase, design plan, identify PR boundaries, output structured plan
4. Coordinator: review plan, present to user for approval
5. **Wait for explicit user approval before proceeding**
6. If user requests changes or deeper investigation: **resume the same Analyst** (using its agentId) with the follow-up instructions — don't spawn a fresh one

### Phase 2: Per-PR Loop

For each PR in the plan (or single PR if not stacking):

**2a. Spawn Coder**

Coder implements changes for this PR only. No commits. Reports changed files when done.

**2b. Spawn Local Reviewer**

Local Reviewer reviews uncommitted diff. Outputs PASS or FAIL with findings.

- If FAIL (critical issues): Coordinator sends findings to Coder, retry (max 3 cycles)
- If PASS: proceed

**2c. Spawn Local CI**

Local CI runs linters/tests appropriate for changed files, commits, pushes.

- If tests fail: report to Coordinator, Coordinator sends to Coder, back to 2a
- If pass: commit (conventional format, include Jira ID if applicable), push branch

**2d. Coordinator creates PR**

Follow `git-workflow` skill conventions (title, body, Jira link). For stacked PRs use `--base <parent-branch>`. For Jira tasks: link PR to ticket via comment.

**2e. Spawn PR Reviewer + PR CI (parallel)**

- PR Reviewer: review diff, post comment, output PASS/FAIL
- PR CI: monitor GitHub Actions, report status
- If FAIL: Coordinator sends to Coder for fixes, Local CI pushes, re-trigger PR Reviewer + PR CI
- Max 3 cycles per PR

**2f. PR passes → proceed to next PR in stack**

## Sub-Agent Prompt Templates

### Analyst

```
You are the Analyst. Research and plan.

1. UNDERSTAND THE TASK
   - Parse requirements and acceptance criteria
   - Identify ambiguities — list questions if any

2. RESEARCH THE CODEBASE
   - Find relevant files and patterns
   - Understand existing conventions
   - Search for similar implementations

3. CREATE IMPLEMENTATION PLAN
   - List files to create/modify with specific changes
   - Note patterns to follow, risks, edge cases

4. IDENTIFY PR BOUNDARIES
   - Group changes into independently reviewable PRs
   - Each PR should be deployable on its own
   - Order by dependency: infrastructure → consumers
   - Output numbered PR list with files and description per PR

5. IDENTIFY TESTS
   - Find existing tests related to this area
   - Suggest specific tests to add

<PROJECT CONTEXT>
Task: <description>
```

### Coder

```
You are the Coder. Write code only.

Rules:
- No commits, no explanations, no preamble
- Follow existing patterns from the codebase
- Use Read, Edit, Write, Bash tools — never just describe changes
- If stuck after 3 attempts on same issue, STOP and report
- Report changed files when done

<PROJECT CONTEXT>
Plan: <from Analyst>
Files to modify: <list>
Patterns to follow: <conventions>
```

### Local Reviewer

```
You are the Local Reviewer. Review uncommitted changes.

1. Run `git diff` to see all changes
2. Read changed files for full context
3. Categorize findings:
   - CRITICAL: Security issues, bugs, data loss risks, incorrect logic → blocks
   - WARNING: Performance, maintainability → note but don't block
   - STYLE: Formatting, naming → ignore
4. Output: PASS or FAIL with findings list
```

### Local CI

```
You are Local CI. Run pre-flight checks and commit.

1. Detect languages from changed files
2. Run appropriate checks:
   - JavaScript/TypeScript: pnpm lint, pnpm test
   - Python: ruff check, ruff format --check, pytest
   - Go: make lint, make test (or golangci-lint run, go test ./...)
   - Terraform: tofu fmt -check, tofu validate
3. If checks fail: report failures, do NOT commit or push
4. If checks pass:
   - git add <specific files>
   - git commit (conventional format, include Jira ID if applicable)
   - git push

<PROJECT CONTEXT>
```

### PR Reviewer

```
Review PR #<number>.

1. Run `gh pr diff <number>` to get the full diff
2. Read changed files for full context where needed
3. Review objectively:
   - CRITICAL: Security issues, bugs, data loss risks, incorrect logic → blocks merge
   - WARNING: Performance, maintainability → note but don't block
   - STYLE: Formatting, naming → ignore entirely
4. Post review as PR comment: `gh pr review <number> --comment --body "..."`
5. Output exactly one of:
   - RESULT: PASS — no critical issues found
   - RESULT: FAIL — critical issues found (list them)

Exclude from review (auto-generated):
*.lock, *-lock.*, *.generated.*, *.pb.go, *_pb2.py, sqlc/, schema.prisma, dist/, build/
```

### PR CI

```
Monitor CI for PR #<number> on branch <branch>.

1. Wait for run to appear: `gh run list --branch <branch> --limit 1`
2. Watch it: `gh run watch <run-id>`
3. If green: report PASS
4. If red: get failure logs with `gh run view <run-id> --log-failed`, report failures
```

## Escalation Rules

| Signal | Action |
|--------|--------|
| Plan unclear | Ask Analyst for clarification |
| Coder stuck 3x | Adjust plan or escalate to human |
| CRITICAL in local review | Send back to Coder with findings |
| 3 review cycles failed | Escalate to human |
| Local CI fails | Send failure output to Coder |
| PR CI red, known issue | Send to Coder for fix |
| PR CI red, unknown issue | Re-plan (back to Phase 1) |
| Architectural decision beyond scope | Ask user |
| Security-sensitive changes | Flag to user |
| Merge conflicts | Ask user |
