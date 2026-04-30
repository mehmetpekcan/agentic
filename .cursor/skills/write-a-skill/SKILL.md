---
name: write-a-skill
description: Guides creation of agent skills with frontmatter, progressive disclosure, optional scripts, and split reference files. Use when writing or authoring skills, creating SKILL.md, scaffolding .rulesync/skills, or defining skill descriptions and trigger phrases.
---
# Writing Skills

Rulesync and Cursor load skills from `SKILL.md` files: a short frontmatter plus instructions the model follows when the skill is selected. This skill describes how to author those files.

## Quick Start

```bash
# From repo root (example: rulesync-managed skills)
mkdir -p .rulesync/skills/my-skill
```

Create `SKILL.md` with frontmatter and a clear title:

```md
---
name: my-skill
description: >-
  One-line what it does. Use when user asks for X, mentions Y, or works on Z.
---

# My Skill

## Quick Start
[Minimal example or first action]

## Core Workflow
[Numbered steps if the skill encodes a process]
```

## Core Workflow

1. **Gather requirements** — Confirm task/domain, use cases, whether scripts or only prose are needed, and any reference material to bundle.
2. **Draft the skill** — Write concise `SKILL.md`; add `REFERENCE.md` / `EXAMPLES.md` / `scripts/` only when they reduce noise or token use in the main file.
3. **Review** — Check description triggers, length limits, terminology, and that examples are concrete.

## Key Conventions

| Topic | Purpose |
| ----- | ------- |
| Frontmatter `description` | Only signal the agent uses to choose this skill; must say *what* and *when* (see below). |
| `SKILL.md` length | Keep short; split when over ~100 lines or when topics are independent. |
| Scripts under `scripts/` | Prefer for deterministic steps (validation, formatting) instead of repeating generated code in chat. |
| Extra markdown files | Use for depth (`REFERENCE.md`), examples (`EXAMPLES.md`), not for repeating the entire skill in prose. |

## Repository Layout

```
skill-name/
├── SKILL.md           # Main instructions (required)
├── REFERENCE.md       # Optional deep detail
├── EXAMPLES.md        # Optional usage samples
└── scripts/           # Optional helpers
    └── helper.js
```

## Description (frontmatter)

The description is the main routing hint: agents match user intent against it alongside other skills.

**Requirements**

- Prefer under 1024 characters.
- Third person.
- First part: capability in plain language.
- Include **Use when …** with concrete triggers (keywords, file types, tasks).

**Good**

```
Extract text and tables from PDFs, merge documents, fill forms. Use when working with PDFs, forms, or document extraction.
```

**Bad**

```
Helps with documents.
```

Too vague to distinguish from other skills.

## Scripts vs. Inline Instructions

Add scripts when the operation is repeatable and deterministic, the same logic would otherwise be inlined many times, or failures must be handled explicitly. Otherwise keep guidance in markdown.

## Splitting Content

Move content out of `SKILL.md` when:

- The file grows past ~100 lines without a natural cut.
- Sections serve different domains (e.g., schema vs policy).
- Advanced material is rarely needed on first load.

Link one level deep: `See [REFERENCE.md](REFERENCE.md)` from `SKILL.md`.

## Verify Before Shipping

- [ ] `description` includes **Use when** triggers.
- [ ] `SKILL.md` stays within the preferred length or is split cleanly.
- [ ] No brittle time-bound facts (URLs, dates) unless maintained.
- [ ] Terminology is consistent across files.
- [ ] Examples are copy-paste or action-ready where applicable.

## Detailed Reference

- [Repository layout](#repository-layout): optional files beside `SKILL.md`.
- [Description (frontmatter)](#description-frontmatter): routing and format.
- [Scripts vs. inline](#scripts-vs-inline-instructions): when to add `scripts/`.
- [Splitting content](#splitting-content): progressive disclosure.
