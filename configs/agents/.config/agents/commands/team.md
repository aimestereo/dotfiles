# Multi-Agent Team Workflow

Coordinate specialized agents to implement a task with built-in quality controls.

## Arguments

- `$ARGUMENTS` - Task description

## Architecture

Three specialized roles prevent "polite feedback loops":

1. **Planner** - Analyzes task, identifies files, creates implementation plan
2. **Coder** - Writes code only, no self-review
3. **Reviewer** - Reviews diff objectively without seeing original task

Communication happens through Git (branches, commits, diffs) - not direct agent-to-agent.

## Instructions

### Phase 1: Planning (You act as Planner)

**Understand the task:**
- Parse task description, identify acceptance criteria
- Ask clarifying questions if requirements are ambiguous

**Identify context (two-step approach):**
1. First pass: identify which files are relevant to the task
2. Second pass: read those files to understand patterns and conventions

**Create implementation plan:**
- List files to create/modify with specific changes
- Note existing patterns to follow
- Identify risks or edge cases
- Define verification criteria

**Create branch BEFORE any changes:**
```bash
git checkout -b feat/<short-description>
```

**Wait for user approval before proceeding.**

### Phase 2: Implementation (Spawn Coder Agent)

Launch a Task agent with these strict constraints:

```
You are Coder. Your rules:
- Code only. No explanations. No apologies. No preamble.
- Never hardcode secrets - use environment variables
- Follow existing patterns from the codebase
- One logical change per commit
- If stuck after 3 attempts on same issue, STOP and report

Task: <implementation plan from Phase 1>
Files to modify: <file list>
Patterns to follow: <conventions identified>
```

The Coder agent should:
- Make changes file by file
- Commit atomically after each logical change
- Stop immediately if hitting repeated failures

### Phase 3: Review (Spawn Reviewer Agent)

Launch a separate Task agent that reviews WITHOUT seeing original task:

```
You are Reviewer. Review this diff objectively.

Rules:
- Don't praise code - focus on issues only
- Categorize findings:
  - CRITICAL: Security issues, bugs, data loss risks → blocks merge
  - WARNING: Performance, maintainability concerns → note but approve
  - STYLE: Formatting, naming preferences → ignore
- Only BLOCK on CRITICAL issues
- You don't know the original task - evaluate the code on its own merits

Review: `git diff main...HEAD`
```

**Decision matrix:**
- No CRITICAL issues → proceed to Phase 4
- CRITICAL issues found → return to Phase 2 with specific fixes (max 3 cycles)
- After 3 failed fix attempts → escalate to user

### Phase 4: Verification

Run project tests if available:
```bash
# Run tests with resource limits if possible
npm test / pytest / go test / make test
```

**Verification checklist:**
- [ ] Tests pass (or no tests affected)
- [ ] No new lint errors
- [ ] Files written successfully (not empty commits)
- [ ] No path traversal (files stay within repo)

### Phase 5: Pull Request

Create PR with:
- Summary of changes (what, not why - the diff shows what)
- Verification steps performed
- Any warnings from review that were accepted

## Safety Controls

**Retry limits:** Max 3 fix attempts per issue. Escalate after.

**Path validation:** All file operations must stay within repository root.

**Empty commit prevention:** Verify files were actually written before committing.

## When to Escalate to Human

- Architectural decisions required
- Implicit business requirements discovered
- Security-sensitive changes
- After 3 failed fix cycles
- Merge conflicts on non-trivial code
