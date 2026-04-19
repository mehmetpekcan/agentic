---
targets:
  - "*"
description: Implement a feature or fix a bug as a coordinated workflow.
---

# Implementation (orchestrator)

This command is an **orchestrator**. It never does the work of a persona inline — it spawns personas and commands, waits for their output, and uses that output to drive the next step.

## Objective

Land the smallest set of changes that are still sufficient in quality. Smallest does not mean sacrificing readability, testability, or correctness — it means no unnecessary scope creep.

## Workflow

### Step 1 — Classify the input

Determine whether the user's ask is a **bug** (error trace, broken behaviour, regression) or a **feature** (new capability, change to existing behaviour, direct ask).

If ambiguous, ask the user once, then proceed.

### Step 2 — Spawn the appropriate persona or command

- **Bug** → spawn `root-cause-analyst`. Pass the error trace, reproduction steps, and any affected files. Wait for its output (root cause + concrete fix proposal) before continuing.
- **Feature** → spawn `/explain`. Pass the feature description and the area of the codebase it touches. Wait for its output (architectural understanding of the affected area) before continuing.

Do not proceed to planning until the output has returned. Do not attempt to do its work inline.

### Step 3 — Spawn `solution-architect`

Pass the problem statement and the full output from Step 2 to `solution-architect`. Wait for the approach document it produces.

Present the approach document to the user. **Wait for explicit approval of the chosen approach before writing any code.** If the user pushes back, re-invoke `solution-architect` with the new constraints.

### Step 4 — Spawn `principal-engineer`

Pass the approved approach document and the Step 2 output. `principal-engineer` implements the change — defaulting to TDD, overridable only if the user explicitly says to skip it.

### Step 5 — Spawn `code-quality-engineer`

Pass the diff of your changes. Wait for its output. Apply its suggestions before moving to review.

### Step 6 — Spawn `/review`

Pass the diff of your changes. Surface its findings to the user as a clear list of improvements and concerns.

**Do not auto-apply review findings.** The user decides what to act on.

## Hard rules

- Never commit.
- Never open or draft a PR.
- Never push.
- Keep all changes local.

## Anti-patterns

- Skipping a persona or command spawn and doing its work inline.
- Writing code before the approach is approved.
- Applying `/review` findings without user decision.
- Expanding scope beyond the approved approach.
