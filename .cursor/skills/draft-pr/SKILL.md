---
name: draft-pr
description: Prepare a clean branch, commit changes, push, and create a draft PR targeting the base branch. Use when the user asks to draft a PR, create a draft pull request, prepare a branch for review, or invokes /draft-pr.
---
# Draft PR

## Quick start

Prepare a clean branch, create the necessary commits, push the branch, and open a draft PR against the base branch.

Use this flow from the repo root. Confirm the base branch, verify the change, commit with a conventional message, push the branch, generate the PR description, and create a draft PR.

## Workflows

### 1. Review Changes

Run `git status` from the repo root. Inspect staged and unstaged changes before deciding what to commit. Do not include unrelated changes or likely secrets.

### 2. Verify Before Committing

Run the applicable verification checks before proceeding. Before the first commit for a change, run a full verification pass from the repo root. Targeted checks are fine while iterating, but they do not replace the full pre-commit verification pass. If verification cannot be run, explain why and ask whether to continue.

### 3. Ensure A Feature Branch

Identify the base branch, usually `main` or `master` unless the repo indicates otherwise. If the current branch is the base branch, confirm or create a feature branch before committing. Use an existing non-base branch when it already matches the work.

### 4. Commit Cleanly

Gather commit details from the diff. Stage only relevant files. Use a conventional commit message. Do not add auto-generated `Co-authored-by:` trailers from tooling.

### 5. Push The Branch

Push the current branch to the remote. Use `git push -u origin HEAD` when the branch does not already track a remote.

### 6. Prepare The PR Body

Analyze the branch diff with `git diff <base-branch>...HEAD`. Read recent branch commits with `git log <base-branch>...HEAD --oneline`. If there are no branch changes relative to the base branch, stop and report that clearly.

Read `./pr-description-template.md`. Fill the template with a concise title, summary, change list, testing notes, and related specs or briefs when present. Output the final description inside a single fenced markdown block for easy copy-paste. Include the verification performed and any checks that could not be run.

### 7. Create The Draft PR

Create a draft PR targeting the base branch. If the branch name contains a recognizable ticket key, include it in the PR title. If there is no recognizable key and the user did not supply one, omit the ticket key.

### 8. Finish With Handoff Details

Report the commit hash, branch name, PR URL or exact creation instructions if the PR could not be created, and the recommended next step: `/code-review`.

### 9. Commit Messages

Use conventional commits:

```text
type: subject
```

The scope is optional. Valid types:

- `feat`
- `fix`
- `refactor`
- `perf`
- `docs`
- `test`
- `build`
- `ci`
- `chore`
- `revert`

Rules:

- Write the subject in the imperative mood.
- Keep the subject concise.
- Use lowercase except for proper nouns and acronyms.
- Choose the type that reflects the user-facing or maintenance purpose of the change.

### 10. PR Title

When possible, derive the title from the conventional commit subject or branch purpose. If a ticket key is present in the branch name, prefix or include it naturally:

```text
fix: refresh expired sessions ABC-123
```

If there is no ticket key, do not invent one.
