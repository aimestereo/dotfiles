# Multi-Agent Team Workflow

Coordinate specialized agents to implement complex tasks with built-in quality controls.

## Arguments

- `$ARGUMENTS` - Task description

## Architecture

Four specialized roles with strict separation of concerns:

1. **Leader** (you, main conversation) - Orchestrates agents, makes meta-decisions, stays context-clean
2. **Planner/Researcher** - Analyzes codebase, researches solutions, creates implementation plan, identifies tests
3. **Coder** - Writes code only, no self-review
4. **Reviewer** - Reviews diff objectively without seeing original task
5. **Tester** - Runs local pre-flight checks, monitors CI, interprets failures

Communication happens through Git (branches, commits, diffs) - not direct agent-to-agent.

## Instructions

### You Are The Leader

Your job is to orchestrate, not to get lost in details. Stay rational:
- Spawn agents for research and implementation
- Make meta-decisions: retry, escalate, change strategy
- Don't dig into code yourself - delegate to agents
- Keep your context clean for decision-making

### Phase 1: Research & Planning (Spawn Planner Agent)

**Create branch BEFORE any work:**
```bash
git checkout -b feat/<short-description>
```

Launch a Task agent for research and planning:

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
   - Follow project testing philosophy (see below)

5. CREATE IMPLEMENTATION PLAN
   - List files to create/modify with specific changes
   - Note patterns to follow
   - Identify risks and edge cases
   - Include test plan: which tests to add/modify

Task: <task description>

Output a structured plan ready for Coder agent, including test recommendations.
```

**Review the plan. Ask clarifying questions if needed. Approve before proceeding.**

### Phase 2: Implementation (Spawn Coder Agent)

Launch a Task agent with strict constraints:

```
You are Coder. Your rules:
- Code only. No explanations. No apologies. No preamble.
- Never hardcode secrets - use environment variables
- Follow existing patterns from the codebase
- One logical change per commit
- If stuck after 3 attempts on same issue, STOP and report failure

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

### Phase 3: Review (Spawn Reviewer Agent)

Launch a Task agent that reviews WITHOUT seeing original task:

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

EXCLUDE from review (auto-generated files):
- Lock files: *.lock, *-lock.json, *-lock.yaml
- Generated code: *.generated.*, *.gen.*, *_generated.go
- Protobuf: *.pb.go, *_pb2.py, *_grpc.py
- Database: sqlc/, generated/, migrations/*.sql (auto-generated parts)
- GraphQL: *.graphql.ts, *.gql.ts (generated types)
- Schema files when marked with generation comments
- Helm chart generated files

Review command: `git diff main...HEAD -- . ':!*.lock' ':!*-lock.json' ':!*-lock.yaml'`
```

**Decision matrix:**
- No CRITICAL issues → proceed to Phase 4
- CRITICAL issues → return to Phase 2 with specific fixes (max 3 cycles)
- After 3 failed cycles → escalate to human

### Phase 4: Testing (Spawn Tester Agent)

Hybrid approach: local pre-flight + CI monitoring.

```
You are Tester. Two responsibilities:

1. LOCAL PRE-FLIGHT (quick checks before push)
   Run format and lint checks based on changed files.

2. CI MONITORING (after push)
   Monitor CI results and interpret failures.

See language-specific commands below.
```

#### Local Pre-flight Commands by Language

**JavaScript/TypeScript:**
```bash
pnpm lint
pnpm format:check
pnpm typecheck
pnpm test              # unit tests only
```

**Python:**
```bash
ruff check <files>
ruff format --check <files>
pyright <directories>
pytest <test_dir>      # unit tests only
```

**Golang:**
```bash
make tidy              # or: go mod tidy && gofmt -w .
make lint              # or: golangci-lint run
make test              # or: go test ./...
```

**Terraform/Tofu:**
```bash
tofu fmt -check -recursive
tofu validate
tflint
```

**Helm:**
```bash
helm lint <chart-path>
helm template <chart-path> | kubectl apply --dry-run=client -f -
```

**Nushell:**
```bash
# No standard linter, but check syntax
nu --commands "source <file>"
```

#### CI Monitoring

After push, monitor CI:
```bash
# Check PR status
gh pr checks

# Watch specific run
gh run watch

# Get failure details
gh run view <run-id> --log-failed
```

**Interpret CI failures:**
- Self-mutation happened → pull changes: `git pull`
- Lint/format failed → fix locally and push
- Tests failed → analyze logs, report to Leader
- DB migration check failed → schema issue, needs attention

### Phase 5: Pull Request

Create PR with:
- Summary of changes
- Test coverage notes
- Any warnings from review that were accepted

## Testing Philosophy

**Mock external dependencies:**
- Database calls → mock or in-memory
- Redis → mock
- External APIs → use VCR pattern (record once, replay in tests)
- HTTP requests → fixtures

**CI DB is only for:**
- Schema validation
- Migration generation and verification
- NOT for running tests

**Good tests:**
- Test behavior, not implementation
- Fast and isolated
- Don't require network or real services
- Use fixtures for external data

**VCR Pattern:**
- First run records actual HTTP responses to fixtures
- Subsequent runs replay from fixtures
- Deterministic and fast
- Update fixtures explicitly when API contracts change

## Leader Decision Points

At each phase transition, assess:

| Signal | Action |
|--------|--------|
| Plan unclear | Ask Planner for clarification |
| Coder stuck 3x | Adjust plan or escalate |
| CRITICAL in review | Send back to Coder with fixes |
| 3 review cycles failed | Escalate to human |
| Pre-flight failing | Fix before push |
| CI failing | Analyze and decide: fix or escalate |
| Self-mutation pushed | Pull and continue |

## When to Escalate

- Architectural decisions beyond task scope
- Implicit business requirements discovered
- Security-sensitive changes need human review
- Repeated failures (3+ cycles)
- Merge conflicts on complex code
- CI failures that aren't obvious to fix

## File Exclusion Patterns for Reviewer

```gitignore
# Lock files
*.lock
*-lock.json
*-lock.yaml
package-lock.json
pnpm-lock.yaml
yarn.lock
Cargo.lock
poetry.lock
devenv.lock
flake.lock

# Generated code markers
*.generated.*
*.gen.*
*_generated.*
*.pb.go
*_pb2.py
*_grpc.py
*.sqlc.go

# Build artifacts
dist/
build/
.next/
```
