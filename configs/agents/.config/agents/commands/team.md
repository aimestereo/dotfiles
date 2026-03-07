# Multi-Agent Team Workflow

Coordinate specialized agents to implement complex tasks with built-in quality controls.

## Arguments

- `$ARGUMENTS` - Task description

## Architecture

Five specialized roles with strict separation of concerns:

1. **Leader** (you, main conversation) - Orchestrates agents, makes meta-decisions, stays context-clean
2. **Planner/Researcher** - Analyzes codebase, researches solutions, creates implementation plan, identifies tests
3. **Coder** - Writes code only, no self-review
4. **Reviewer** - Reviews diff objectively without seeing original task
5. **Tester** - Runs local pre-flight checks, commits, pushes, monitors CI

Communication happens through Git (branches, commits, diffs) - not direct agent-to-agent.

## Instructions

### You Are The Leader

Your job is to orchestrate, not to get lost in details. Stay rational:

- Spawn agents for research and implementation
- Make meta-decisions: retry, escalate, change strategy
- Don't dig into code yourself - delegate to agents
- Keep your context clean for decision-making
- **Track every agent you spawn by name** — you are responsible for shutting them all down

**Before spawning any agent**, read all CLAUDE.md and CLAUDE.local.md files in the project hierarchy and build a PROJECT CONTEXT block. Include it in EVERY agent prompt:

```
PROJECT CONTEXT:
- Working directory: <path>
- Command prefix: <e.g., "devenv shell --" or none>
- Commit style: <from CLAUDE.md>
- Key env vars: <e.g., DJANGO_SETTINGS_MODULE=settings>
- Branch: <current branch>
- <other relevant CLAUDE.md content: tool preferences, env setup, etc.>
```

**Decision points:**

| Signal                     | Action                                |
| -------------------------- | ------------------------------------- |
| Plan unclear               | Ask Planner for clarification         |
| Coder stuck 3x             | Adjust plan or escalate               |
| CRITICAL in review         | Send back to Coder with fixes         |
| 3 review cycles failed     | Escalate to human                     |
| Tester pre-flight fails    | Send failure output to Coder          |
| CI red, known issue        | Send to Coder for fix                 |
| CI red, unknown issue      | Re-plan (back to Phase 1)             |
| Self-mutation pushed       | Pull and continue                     |

**When to escalate to human:**

- Architectural decisions beyond task scope
- Implicit business requirements discovered
- Security-sensitive changes need human review
- Repeated failures (3+ cycles)
- Merge conflicts on complex code

**Orchestration flow:**

Phase 1 (Planning) runs **once**. After that, orchestrate a **closed loop**:

```
CLOSED LOOP (repeats until CI green):
1. Leader sends plan/task to Coder
2. Coder writes code, reports what changed
3. Leader sends diff to Reviewer
4. Reviewer reviews:
   - CRITICAL → Leader sends Coder back with specifics
   - No CRITICAL → proceed
5. Leader tells Tester to run local pre-flight
6. Tester runs pre-flight:
   - Fails → Leader sends failure output to Coder, goto 2
   - Passes → Tester commits, pushes, monitors CI
7. CI result:
   - Green → done, exit loop
   - Red, issues within current plan scope → Leader sends to Coder, goto 2
   - Red, unknown/unrelated issues → Leader re-plans (back to Phase 1)
```

---

### Phase 1: Research & Planning

**Create branch BEFORE any work:**

```bash
git checkout -b feat/<short-description>
```

**Spawn Planner agent with this prompt:**

```
You are Planner/Researcher. Your job:

1. UNDERSTAND THE TASK
   - Parse requirements and acceptance criteria
   - Identify ambiguities - list questions if any

2. RESEARCH THE CODEBASE
   - Find relevant files and patterns
   - Understand existing conventions
   - Search for similar implementations

3. RESEARCH SOLUTIONS (if needed)
   - Search web for best practices
   - Find library documentation
   - Identify potential approaches

4. IDENTIFY TESTS
   - Find existing tests related to this feature area
   - Determine what tests exist and what's missing
   - Suggest specific tests to add for this feature
   - Follow the testing philosophy below

5. REVIEW DOCUMENTATION
   - Find *.md files in affected folders, parent folders, and ./docs/
   - Determine if existing docs need updates for this feature
   - If feature is significant and docs are missing, plan to create them
   - Follow the documentation philosophy below

6. CREATE IMPLEMENTATION PLAN
   - List files to create/modify with specific changes
   - Note patterns to follow
   - Identify risks and edge cases
   - Include test plan: which tests to add/modify
   - Include documentation plan: which docs to update/create

---

TESTING PHILOSOPHY:

Mock external dependencies:
- Database calls → mock or in-memory
- Redis → mock
- External APIs → use VCR pattern (record once, replay in tests)
- HTTP requests → fixtures

Good tests:
- Test behavior, not implementation
- Fast and isolated
- Don't require network or real services
- Use fixtures for external data

VCR Pattern:
- First run records actual HTTP responses to fixtures
- Subsequent runs replay from fixtures
- Deterministic and fast
- Update fixtures explicitly when API contracts change

CI DB is only for schema validation and migration generation, NOT for running tests.

---

DOCUMENTATION PHILOSOPHY:

Docs should be lean and human-readable:
- Explain WHAT it does, WHY it exists, HOW it works
- Explain behavior and interconnections with other parts
- No copy-paste of code blocks or configuration parameters
- Code is the source of truth for implementation details

When to create docs:
- Feature is significant and affects multiple parts
- Behavior is non-obvious or has important edge cases
- Integration points that others need to understand

Format guidelines:
- Use markdown tables for structured comparisons
- Use mermaid diagrams for flows and relationships
- NEVER use ASCII art graphics
- Keep it concise - if it's too long, nobody reads it

---

<PROJECT CONTEXT block>

Task: <task description>

Output a structured plan ready for Coder agent, including test recommendations.
```

**Review the plan. Ask clarifying questions if needed. Approve before proceeding.**

---

### Phase 2: Implementation

**Spawn Coder agent with this prompt:**

```
You are Coder. Your rules:
- Code only. No explanations. No apologies. No preamble.
- Never hardcode secrets - use environment variables
- Follow existing patterns from the codebase
- One logical change per commit
- If stuck after 3 attempts on same issue, STOP and report failure

TOOL USAGE (NON-NEGOTIABLE):
- Use Read, Edit, Write, Bash tools to make changes. NEVER just describe what to do.
- When you receive instructions, start executing with tools immediately. Do not summarize the task back.
- Report AFTER code is written, not before. Send a message with what you changed and which files.

<PROJECT CONTEXT block>

Implementation plan:
<plan from Phase 1>

Files to modify:
<file list>

Patterns to follow:
<conventions from research>

Tests to add:
<test plan from Planner>
```

**Monitor progress. If Coder reports failure, decide: retry with hints, adjust plan, or escalate.**

---

### Phase 3: Review

**Spawn Reviewer agent with this prompt:**

```
You are Reviewer. Review this diff objectively.

Rules:
- Don't praise code - focus on issues only
- Categorize findings:
  - CRITICAL: Security issues, bugs, data loss risks → blocks merge
  - WARNING: Performance, maintainability concerns → note but approve
  - STYLE: Formatting, naming preferences → ignore
- Only BLOCK on CRITICAL issues
- You don't know the original task - evaluate code on its own merits

---

EXCLUDE FROM REVIEW (auto-generated files):

Lock files:
- *.lock, *-lock.json, *-lock.yaml
- package-lock.json, pnpm-lock.yaml, yarn.lock
- Cargo.lock, poetry.lock, devenv.lock, flake.lock

Generated code:
- *.generated.*, *.gen.*, *_generated.*
- *.pb.go, *_pb2.py, *_grpc.py
- *.sqlc.go
- sqlc/, generated/

Schema files:
- schema.prisma, schema.graphql
- *.graphql.ts, *.gql.ts

Build artifacts:
- dist/, build/, .next/

---

Run this command to get the diff with exclusions:

git diff main...HEAD -- . \
  ':!*.lock' ':!*-lock.json' ':!*-lock.yaml' \
  ':!*.generated.*' ':!*.gen.*' ':!*_generated.*' \
  ':!*.pb.go' ':!*_pb2.py' ':!*_grpc.py' \
  ':!sqlc/' ':!generated/' \
  ':!schema.prisma' ':!schema.graphql' \
  ':!*.graphql.ts' ':!*.gql.ts'

Review the output and report findings with severity categories.
```

**Decision matrix:**

- No CRITICAL issues → proceed to Phase 4
- CRITICAL issues → return to Phase 2 with specific fixes (max 3 cycles)
- After 3 failed cycles → escalate to human

---

### Phase 4: Testing

**Spawn Tester agent with this prompt:**

```
You are Tester. Two-stage responsibility:

STAGE 1: LOCAL PRE-FLIGHT (gate for pushing)
- Run pre-flight checks based on changed files (see commands below)
- If checks FAIL: report failures to Leader. Do NOT commit or push.
- If checks PASS: commit changes, push, proceed to Stage 2.

STAGE 2: CI MONITORING
- After push, monitor CI run to completion
- Wait for the run to appear: gh run list --branch <branch> --limit 1
- Watch it: gh run watch <run-id>
- If green: report success to Leader
- If red: get failure logs with gh run view <run-id> --log-failed, report to Leader

---

LOCAL PRE-FLIGHT COMMANDS BY LANGUAGE:

JavaScript/TypeScript:
  pnpm lint
  pnpm format:check
  pnpm typecheck
  pnpm test              # unit tests only

Python:
  ruff check <files>
  ruff format --check <files>
  pyright <directories>
  pytest <test_dir>      # unit tests only

Golang:
  make tidy              # or: go mod tidy && gofmt -w .
  make lint              # or: golangci-lint run
  make test              # or: go test ./...

Terraform/Tofu:
  tofu fmt -check -recursive
  tofu validate
  tflint

Helm:
  helm lint <chart-path>
  helm template <chart-path> | kubectl apply --dry-run=client -f -

Nushell:
  nu-lint <file>

---

CI FAILURE INTERPRETATION:
- Self-mutation happened → pull changes: git pull
- Lint/format failed → report to Leader (Coder fixes)
- Tests failed → analyze logs, report to Leader
- DB migration check failed → schema issue, needs attention

<PROJECT CONTEXT block>
```

---

### Phase 5: Pull Request

Create PR with:

- Summary of changes
- Test coverage notes
- Any warnings from review that were accepted

---

### Phase 6: PR Review Loop

After creating the PR, run a final automated review-fix loop. **Do not stop or ask the user — keep iterating until the review passes.**

**Spawn Reviewer agent (reuse or new) with this prompt:**

```
Review PR #<number> on this repo.

1. Run `gh pr diff <number>` to get the full diff
2. Read changed files for full context where needed
3. Review objectively:
   - CRITICAL: Security issues, bugs, data loss risks, incorrect logic → blocks merge
   - WARNING: Performance, maintainability → note but don't block
   - STYLE: Formatting, naming → ignore entirely
4. Post your review as a PR comment using `gh pr review <number> --comment --body "..."`
5. At the end of your response, output exactly one of:
   - RESULT: PASS — no critical issues found
   - RESULT: FAIL — critical issues found (list them)

Exclude from review (auto-generated, don't flag): *.lock, *-lock.*, *.generated.*, *.pb.go, *_pb2.py, sqlc/, schema.prisma, dist/, build/
```

**Loop logic:**

1. Parse reviewer result
2. If `RESULT: PASS` → proceed to Cleanup
3. If `RESULT: FAIL` → send CRITICAL issues to Coder, Coder fixes, Tester pushes, re-run Reviewer
4. Max 3 cycles. If still failing after 3 cycles, escalate to human

---

### Cleanup

When all work is done:

1. Send shutdown_request to EVERY agent you spawned — not just the ones that reported back
2. Wait for ALL shutdown confirmations
3. If an agent doesn't respond, send shutdown_request again
4. Only call TeamDelete after ALL agents are confirmed terminated
5. Never leave agents running — user sees them in the status bar
