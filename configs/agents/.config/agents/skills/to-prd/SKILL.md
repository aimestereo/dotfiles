---
name: to-prd
description: "Synthesize the current conversation into a PRD file inside the project repo, cross-linked to the task you are working on. Use when the commander asks to capture feature requirements as a PRD."
---

# /to-prd — Conversation → project PRD file

This skill captures the current conversation as a PRD file inside the project repo, then cross-links it to the task. Synthesize what you already know — do not interview the commander. The only pauses are the two checkpoints below.

If you already know what the PRD body should say and just need to land it, use `/prd-write` instead — it's the mechanism-only version of this skill.

## Storage layout

PRDs live as files **inside the project they describe** — never in the PKA wiki. See [[conventions]] § PRD Conventions for the full convention.

- **Filename:** `prd-<feature-kebab>.md` (e.g. `prd-chat-ui.md`, `prd-public-hosting.md`).
- **Location:** absolute path is `<project.path>/<relative_path>`, where `<relative_path>` is anywhere in the project tree that fits the feature. Default to the project root unless the feature is clearly subsystem-scoped.
- **Discovery convention:** other tools glob `prd-*.md` from the project root, so keep the filename prefix.

## Cross-linking

- **Task → PRD:** prepend one line to the task description: `**PRD:** [[prd:<project_slug>:<relative_path>]]` (preserve all existing description content below). This line is also the marker used to detect existing PRDs on re-invocation.
- **PRD → tracking tasks:** the PRD body has a `## Tracking` section near the top listing every linked task (`**[PKA-NN]** title — purpose`). Append bug-fix and follow-up tasks here over time.

## When to write a PRD at all

PRDs are required only for features that **span multiple sessions or split into multiple tasks**. Single-session bounded work doesn't warrant a contract document — task description and comments are enough.

If this session is producing a one-shot fix or a single-task feature, push back on the commander and confirm before continuing.

## Process

### 1. Locate the task

The PRD is always for an existing task you are already working on. Find the `display_id`:
- If the session is clearly about one task, use it.
- Otherwise ask the commander once: "Which task is this PRD for?" (display_id like PKA-NN).

Call `task_get` for title and description. Detect mode by scanning the description:
- **Update mode:** description contains a `[[prd:<slug>:<path>]]` wikilink for this feature. Resolve the file path, propose edits as a diff. On commander confirm, write the updated body to the same path — never duplicate, never create a second PRD file. A task may reference multiple PRDs; match the wikilink that corresponds to the feature being updated.
- **Create mode:** no matching PRD wikilink. Continue below to compose a new PRD.

### 2. Explore

Read the codebase and wiki pages that ground the PRD in the project's domain vocabulary. At minimum skim:
- The project overview wiki page (e.g. `pka-project-overview`)
- The roadmap if one exists (e.g. `pka-roadmap`) — flag any conflict between the PRD and a documented phase
- `wiki/conventions.md` and topic-specific pages the feature touches (db, mcp, skills, etc.)
- Existing code in the modules the PRD will affect

Use the project's terminology. If the PRD would contradict a documented decision, surface it to the commander instead of silently overriding.

### 3. Sketch modules

List the major modules to build or modify. Prefer **deep modules** (Ousterhout) — units that encapsulate a lot of functionality behind a simple, testable, stable interface — over shallow pass-throughs.

**Checkpoint 1:** present the module sketch to the commander. Confirm it matches expectations before continuing.

### 4. Compose the PRD body

Use this template verbatim. The `## Tracking` section is PKA-specific; everything below it is Matt Pocock's original template.

<prd-template>
# <feature title>

## Tracking

- **[<DISPLAY_ID>] <task title>** — implementation

_(Append later tasks here: follow-up features, bug fixes, refactors.)_

## Problem Statement

The problem the commander is facing, from the commander's perspective.

## Solution

The solution to the problem, from the commander's perspective.

## User Stories

A long, numbered list of user stories. Each in the format:

1. As an <actor>, I want a <feature>, so that <benefit>

Be extensive — cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions. Can include:

- Modules to build or modify
- Interfaces of those modules
- Technical clarifications from the commander
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do **not** include specific file paths or code snippets.

## Testing Decisions

- What makes a good test here (external behavior, not implementation details)
- Which modules will be tested
- Prior art in the codebase for these tests

## Out of Scope

What this PRD explicitly does not cover.

## Further Notes

Anything else worth recording.
</prd-template>

### 5. Tests checkpoint

**Checkpoint 2:** with the PRD composed, ask the commander which modules deserve tests. Fill in the Testing Decisions section with the answer.

### 6. Preview → confirm → publish

Show the full PRD to the commander. Wait for: **go**, **edit** (apply changes, re-preview), or **cancel** (abort without writing).

On **go**, invoke `/prd-write` with the composed body to land the file and insert the wikilink. Then report back: PRD path, task display_id, and confirmation that the description is updated.

## Rules

- The PRD is the durable source of truth for *requirements*. Implementation conversation lives in task comments. Bug fixes live in new tasks, appended to the PRD's `## Tracking` section.
- Edit PRDs in place when requirements evolve. Never duplicate, never mark outdated, never version via filename suffix. If a requirement is dropped, edit the PRD to reflect the new shape.
- Do not interview the commander to gather PRD content — synthesize from the session. Only pause for the two named checkpoints.
- Keep file paths and code out of the PRD. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose (state machine, reducer, schema, type shape), inline the decision-rich parts and note briefly that it came from a prototype.
- One PRD per feature, one feature per PRD.

---

*Adapted from Matt Pocock's [`to-prd` skill](https://github.com/mattpocock/skills/blob/main/skills/engineering/to-prd/SKILL.md). PKA-specific changes: output is a project-local file (not an issue ticket or wiki page), cross-linked to an existing task via the `[[prd:<slug>:<path>]]` wikilink and a `**PRD:**` line prepended to the task description; in-place updates; mechanism delegated to `/prd-write`.*
