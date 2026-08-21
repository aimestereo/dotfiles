---
name: jira-b2b
description: Generic Jira MCP workflow — self-assign at creation, In-Progress transition when work starts, Testing transition when work is merged, and Story→Sub-task hierarchy when a feature is split into multiple issues. Project-specific constants (cloudId, project key, custom fields, issue-type table, post-merge transition) live in the PKA wiki page `jira-b2b-constants`.
triggers:
  - jira
  - mcp__jira
  - create Jira issue
  - split into subtasks
  - story
role: protocol
scope: workflow
output-format: instructions
---

# Jira workflow — generic rules

Applies whenever an agent uses `mcp__jira__*` tools. Read once at session start; re-consult before every `createJiraIssue` and before any decision to split work into multiple issues.

## Where the constants live

Project-specific values — Jira cloudId, project key, custom-field IDs, mandatory-vs-optional field policy, canonical issue-type names — are **not** in this skill. Fetch them from the PKA wiki at session init and keep the values in in-context memory:

```
mcp__pka__wiki_page_get(slug: "jira-b2b-constants")
```

`mcp__pka__init` returns only the project overview, not linked pages — the constants page will not arrive automatically. The overview names the slug; you fetch it. If the page does not exist for the project you're in, ask the commander before creating any issue.

## Rule 1 — Always self-assign at creation

- Call `mcp__jira__atlassianUserInfo` once per session and cache the returned `accountId` — that IS the commander. In-context cache only; a new session must re-fetch.
- Pass it as `assignee_account_id` on **every** `mcp__jira__createJiraIssue` call. No exceptions unless the commander explicitly says "assign to <name>", in which case use `mcp__jira__lookupJiraAccountId` first.
- Never leave an issue unassigned. Unassigned issues sit dead on the board.

## Rule 2 — Transition to In Progress when work starts

- After creation, the issue is in whatever the workflow's initial status is (Open / To Do). Do **not** transition at create time.
- **Right before you start implementation on that specific issue**, transition it:
  1. `mcp__jira__getTransitionsForJiraIssue` — find the transition whose target status has `statusCategory.key == "indeterminate"` (Jira's stable key for the In-Progress category).
  2. `mcp__jira__transitionJiraIssue` with that transition ID.
- If no such transition is available in one hop (workflow requires an intermediate step like `Open → In Review → In Progress`), report the transition list to the commander and ask which step to take. Do not guess.
- Applies per-issue. On a Story with Sub-tasks: transition the Sub-task you're actively coding on. Transition the parent Story when the first Sub-task starts and leave it there until the last Sub-task closes.
- Do **not** leave an issue in the initial status while pushing code against it.

## Rule 3 — Story hierarchy when splitting work

Trigger: you and the commander are deciding to break a feature into **2+ Jira issues** (not 2+ PRs — stacked PRs stay on one issue per the `git-workflow` skill). The moment a real Jira split is on the table, this rule fires.

Protocol:

1. **Propose the split to the commander with reasoning** (which axes: services, phases, independent deliverables). Wait for approval. Do not run the JQL search or create anything yet.
2. **Commander approves** → search for an existing open Story that fits. Strip JQL metacharacters (`"`, `\`, leading `+`/`-`) from the keyword before substituting; a malformed query silently returns zero results and pushes the flow to step 4 (create new Story) — a data-quality regression, not a security bug.
   ```
   mcp__jira__searchJiraIssuesUsingJql(
     cloudId: <from wiki>,
     jql: "project = <KEY> AND issuetype = Story AND statusCategory != Done AND (summary ~ \"<keyword>\" OR description ~ \"<keyword>\")",
     maxResults: 5
   )
   ```
   Present all returned candidates to the commander with `key`, `summary`, `status`.
3. **Commander picks an existing Story** → create each Sub-task with `parent: "<STORY-KEY>"`, self-assigned, all mandatory fields set per the constants page.
4. **No match** → create the Story first (self-assigned, all mandatory fields set), then create the Sub-tasks with `parent: "<NEW-STORY-KEY>"`.
5. **Never create sibling Tasks for a split feature.** The hierarchy is the whole point — Story parents Sub-tasks. Only use standalone Task when the work has no siblings and no natural Story home.

Skip this rule when: the work is one issue with multiple PRs (see `git-workflow` stacked PRs); or the commander explicitly says "just create N Tasks, no parent" (rare — confirm).

## Rule 4 — Transition to Testing (not Done) when work is merged

- **When the PR merges upstream (or the direct-to-main commit lands),** transition the issue to the workflow's "under verification" state — Testing / QA / Verify. Never jump straight to Done from In Progress. The verification stage exists so QA / manual smoke-tests can catch regressions CI missed, and its absence in the audit trail is visible to teammates.
- The specific transition ID and target status name are project-specific. Look them up in the constants page's "Post-merge workflow" section (or equivalent) and pass that transition ID to `mcp__jira__transitionJiraIssue`.
- **If the constants page names no post-merge state**, ask the commander which transition to use before falling back to Done. Do not silently skip the verification stage.
- **Downstream transitions** (Testing → Ready to Deploy → Deployed → Done, or whatever the project uses) are typically driven by QA, deploy pipelines, or manual verification. The Jira MCP caller does NOT auto-advance beyond the post-merge state unless the constants page explicitly authorises it.
- Applies per-issue. On a Story with Sub-tasks: transition each Sub-task as its PR merges. The parent Story advances when its last Sub-task lands.

## Common gotchas

- Every Jira project has mandatory custom fields — the constants page lists them. Omitting a mandatory field fails or defaults badly.
- Sub-tasks require `parent`. Passing it as a bare string (`"<KEY>"`) is accepted by the MCP layer; the MCP normalises to the Jira REST `{"key": "..."}` shape internally.
- Issue-type names — the API accepts English canonical forms (`Story`, `Sub-task`, `Task`, `Bug`, `Epic`) even when the board displays localised labels. Verify against the constants page for the project.

## Complete example — Story + 2 Sub-tasks, self-assigned, both moved to In Progress when work starts

Step 0 — fetch the constants page and read `cloudId`, `projectKey`, and the mandatory-fields JSON block from its markdown body:

```
constants_page = mcp__pka__wiki_page_get(slug: "jira-b2b-constants")
# Extract from constants_page.body (markdown):
#   CLOUD_ID          — from the "Connection" section
#   PROJECT_KEY       — from the "Connection" section
#   MANDATORY_FIELDS  — the JSON block under "Mandatory custom field"
```

The rest of the flow substitutes those extracted values. Placeholders below (`<CLOUD_ID>` etc.) are what you pass to the MCP after reading them from the page body.

```
caller = mcp__jira__atlassianUserInfo()   # in-context cache of caller.accountId

story = mcp__jira__createJiraIssue(
  cloudId: <CLOUD_ID>,
  projectKey: <PROJECT_KEY>,
  issueTypeName: "Story",
  summary: "<feature title>",
  description: "<one-paragraph scope>",
  contentFormat: "markdown",
  assignee_account_id: caller.accountId,
  additional_fields: <MANDATORY_FIELDS>
)

sub_be = mcp__jira__createJiraIssue(
  cloudId: <CLOUD_ID>,
  projectKey: <PROJECT_KEY>,
  issueTypeName: "Sub-task",
  parent: story.key,
  summary: "Backend: <slice>",
  contentFormat: "markdown",
  assignee_account_id: caller.accountId,
  additional_fields: <MANDATORY_FIELDS>
)

sub_fe = mcp__jira__createJiraIssue(
  cloudId: <CLOUD_ID>,
  projectKey: <PROJECT_KEY>,
  issueTypeName: "Sub-task",
  parent: story.key,
  summary: "Frontend: <slice>",
  contentFormat: "markdown",
  assignee_account_id: caller.accountId,
  additional_fields: <MANDATORY_FIELDS>
)

for issue_key in [sub_be.key, story.key]:
  transitions = mcp__jira__getTransitionsForJiraIssue(
    cloudId: <CLOUD_ID>, issueIdOrKey: issue_key
  )
  in_progress = next(t for t in transitions if t.to.statusCategory.key == "indeterminate")
  mcp__jira__transitionJiraIssue(
    cloudId: <CLOUD_ID>, issueIdOrKey: issue_key,
    transition: {"id": in_progress.id}
  )
```

## Cheat sheet

- Before any Jira MCP call in a session → fetch `jira-b2b-constants` via `mcp__pka__wiki_page_get` and keep `cloudId`, `projectKey`, mandatory-fields JSON, and the post-merge transition in in-context memory.
- Creating an issue? → `assignee_account_id = commander` + all mandatory fields from the constants page. Always.
- Starting to code on an issue? → `getTransitionsForJiraIssue` + `transitionJiraIssue` to In Progress. Always.
- Merging the PR / commit? → `transitionJiraIssue` to Testing (per the constants page). Never straight to Done from In Progress.
- Splitting into 2+ Jira issues? → always Story + Sub-tasks, never sibling Tasks. See Rule 3. Multiple PRs on one issue → `git-workflow` skill, not this rule.
