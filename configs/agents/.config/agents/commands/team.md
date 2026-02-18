# Multi-Agent Team Workflow

Coordinate specialized agents to implement complex tasks with built-in quality controls.

## Arguments

- `$ARGUMENTS` - Task description

## Architecture

Four specialized roles with strict separation of concerns:

1. **Leader** (you, main conversation) - Orchestrates agents, makes meta-decisions, stays context-clean
2. **Planner/Researcher** - Digs into codebase, searches for solutions, creates implementation plan
3. **Coder** - Writes code only, no self-review
4. **Reviewer** - Reviews diff objectively without seeing original task

Communication happens through Git (branches, commits, diffs) - not direct agent-to-agent.

## Instructions

### You Are The Leader

Your job is to orchestrate, not to get lost in details. Stay rational:
- Spawn agents for research and implementation
- Make meta-decisions: retry, escalate, change strategy
- Don't dig into code yourself - that's what Planner/Researcher is for
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

4. CREATE IMPLEMENTATION PLAN
   - List files to create/modify with specific changes
   - Note patterns to follow
   - Identify risks and edge cases
   - Define verification criteria

Task: <task description>

Output a structured plan ready for Coder agent.
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

Review command: `git diff main...HEAD -- . ':!*.lock' ':!*-lock.json'`
```

**Decision matrix:**
- No CRITICAL issues → proceed to Phase 4
- CRITICAL issues → return to Phase 2 with specific fixes (max 3 cycles)
- After 3 failed cycles → escalate to human

### Phase 4: Verification

Run project tests if available:
```bash
npm test / pytest / go test / make test
```

**Checklist:**
- [ ] Tests pass (or no tests affected)
- [ ] No new lint errors
- [ ] Files written successfully (not empty commits)

### Phase 5: Pull Request

Create PR with:
- Summary of changes
- Verification steps performed
- Any warnings from review that were accepted

## Leader Decision Points

At each phase transition, assess:

| Signal | Action |
|--------|--------|
| Plan unclear | Ask Planner for clarification |
| Coder stuck 3x | Adjust plan or escalate |
| CRITICAL in review | Send back to Coder with fixes |
| 3 review cycles failed | Escalate to human |
| Tests failing | Decide: fix attempt or rollback |

## When to Escalate

- Architectural decisions beyond task scope
- Implicit business requirements discovered
- Security-sensitive changes need human review
- Repeated failures (3+ cycles)
- Merge conflicts on complex code

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
