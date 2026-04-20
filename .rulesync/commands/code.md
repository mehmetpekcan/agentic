---
targets:
  - "*"
description: Implement a feature or fix a bug as a coordinated workflow.
---

# Implementation (orchestrator)

This command is a **strict orchestrator**. It never does the work of a persona inline — it spawns personas and commands, waits for their output, surfaces that output to the user, and only proceeds after **explicit user approval at every gate**.

## Objective

Land the smallest set of changes that are still sufficient in quality. Smallest does not mean sacrificing readability, testability, or correctness — it means no unnecessary scope creep.

## Non-negotiable rules

These override any other instinct, optimization, or shortcut:

1. **Never skip a step.** Every step below runs, in order, every time. No "this one is simple, I'll just do it."
2. **Never act without approval.** After every step that produces output, present it to the user and wait for an **explicit "approved" / "go" / "yes, proceed"** message. Silence is not approval. A thumbs-up emoji is not approval if the user has not actually read the output. If unsure, ask.
3. **Never do a persona's work inline.** Personas are spawned via the agent tools. Their output is what you act on. You do not summarize their work and pretend it ran.
4. **Never write code before Step 4.** Steps 1–3 are read-only / planning. No edits to source files. No scaffolding. No "let me just stub this out."
5. **The plan lives on disk.** The approach document is written to a file (see Step 3). It is not just a chat message that scrolls away.

## Workflow

### Step 1 — Classify the input

Determine whether the user's ask is a **bug** (error trace, broken behaviour, regression) or a **feature** (new capability, change to existing behaviour, direct ask).

If ambiguous, ask the user once, then proceed.

**Gate:** State your classification to the user in one line (e.g. "Classified as: bug") before moving on. No approval needed for classification itself, but the classification must be visible.

### Step 2 — Spawn the appropriate persona or command

- **Bug** → spawn `root-cause-analyst` via the agent tools. Pass the error trace, reproduction steps, and any affected files. Wait for its output (root cause + concrete fix proposal) before continuing.
- **Feature** → spawn `/explain` (or the `explore` subagent if `/explain` is not available as a spawnable command in this environment). Pass the feature description and the area of the codebase it touches. Wait for its output (architectural understanding of the affected area) before continuing.

Surface the persona's output to the user. **Wait for explicit approval that the diagnosis / understanding is correct before continuing.** If the user disagrees, re-spawn with the corrected framing.

Do not proceed to planning until the user has approved the Step 2 output. Do not attempt to do its work inline.

### Step 3 — Plan in `plan` mode and write the approach to disk

Before spawning the architect, **switch to `plan` mode**. Briefly explain why ("entering plan mode to design the approach without making changes"). Wait for the user to accept the mode switch.

Once in plan mode:

1. Resolve the **repo name** — the basename of the workspace root directory.
2. Ensure the plans directory exists. **Run `mkdir -p` on every command invocation**, even if the directory already exists — this step is mandatory, not conditional:

   ```
   ~/.rulesync/references/{repo-name}/plans/
   ```

   Expand `~` to the user's home directory.

3. Spawn `solution-architect` via the agent tools. Pass the problem statement and the full output from Step 2.
4. The architect must produce its approach document **strictly following the template at `~/.rulesync/templates/approach-plan-template.md`** — same headings, same sections, in the same order.
5. Save the architect's output as a Markdown file at:

   ```
   ~/.rulesync/references/{repo-name}/plans/{YYYY-MM-DD-HHmm}-{kebab-case-short-title}.md
   ```

   Use the actual current date and time (24h) so multiple runs on the same day do not collide. Never overwrite an existing plan — if the path somehow already exists, append a numeric suffix (`-2`, `-3`, …).

6. Read the saved file back and present it to the user. Reference the **absolute file path** explicitly so they can open it directly.

**Gate — go / no-go on the plan file:** Wait for an **explicit go or no-go** from the user on the saved plan file. Acceptable go signals: "go", "approved", "go with A", "proceed". Acceptable no-go signals: "no-go", "rework", "change X". Silence, a bare thumbs-up, or a short "ok" is **not** a go — ask directly: "Go or no-go on the plan?" On no-go, edit the plan file (or re-spawn `solution-architect` if the change is large) and re-present for another go/no-go round. **Do not switch out of plan mode and do not write any code until you have received an explicit go.**

### Step 4 — Spawn `principal-engineer`

Once the plan is approved:

1. Switch the IDE back to `agent` mode and wait for the user to accept the mode switch if necessary.
2. Spawn `principal-engineer` via the agent tools. Pass the path to the approved plan file and the Step 2 output.
3. `principal-engineer` implements the change — defaulting to TDD, overridable only if the user has explicitly said to skip it earlier in this conversation.

**Gate:** When `principal-engineer` returns, summarize what changed (files touched, tests added) and **wait for the user to confirm before moving to Step 5.** If the user wants changes, re-spawn `principal-engineer` with the correction.

### Step 5 — Spawn `code-quality-engineer`

Spawn `code-quality-engineer` via the agent tools and wait for its output.

Surface its suggestions to the user as a clear list. **Do not auto-apply.** Wait for the user to say which suggestions to apply. Then spawn `principal-engineer` again (or apply directly if the user explicitly authorizes inline edits) to apply the chosen suggestions.

**Gate:** Confirm with the user that the applied changes look right before moving to Step 6.

### Step 6 — Spawn `/review`

Pass the diff of your changes to `/review`. Surface its findings to the user as a clear list of improvements and concerns.

**Do not auto-apply review findings.** The user decides what to act on. If they want fixes applied, route them back through Step 4 (spawn `principal-engineer`).

## Hard rules

- Never commit.
- Never open or draft a PR.
- Never push.
- Keep all changes local.
- Never delete the plan file under `~/.rulesync/references/{repo-name}/plans/` — it is a record of the decision.

## Anti-patterns (these are violations, not suggestions)

- Skipping a persona or command spawn and doing its work inline.
- Writing code before the plan file exists and is approved.
- Treating the plan as a chat message instead of a file on disk.
- Skipping the `plan` mode switch in Step 3.
- Skipping the `agent` mode switch in Step 4.
- Inferring approval from silence, a brief reply, or a non-committal "ok".
- Applying `code-quality-engineer` or `/review` findings without user decision.
- Expanding scope beyond the approved approach.
- Combining multiple steps into a single turn to "save time".

## Self-check before every action

Before any tool call other than reading files, presenting output, or asking a question, ask yourself:

1. Am I on the step the workflow says I should be on?
2. Has the user explicitly approved the previous step's output in this conversation?
3. If I am about to edit a file, does a plan file exist under `~/.rulesync/references/{repo-name}/plans/` and has the user given an explicit **go** on it in this conversation?

If the answer to any of these is "no", **stop and return to the correct step.**
