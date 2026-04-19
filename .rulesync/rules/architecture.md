---
targets:
  - '*'
root: false
description: Architecture best practices and patterns
globs:
  - '**/*'
cursor:
  description: Architecture best practices and patterns
  globs:
    - '**/*'
---

# Architecture Rules

## Discover project conventions first

Before creating any new files, routes, modules, or layers:
1. Read the existing folder structure and understand what convention is already in use.
2. Identify the project's router/framework (inspect `package.json`, entry points, and existing route files).
3. Match the naming, colocation, and export patterns already established.

Do not invent a new structure. If the project has no clear convention for something, pick the simplest approach and document the assumption.

---

## Principles

### Colocate related code

Keep code that changes together physically close together. Group by feature/domain, not by technical layer, unless the project already uses a layer-based structure.

### Match existing boundaries

Identify where the project draws its architectural boundaries (e.g., client vs server, public API vs internal, UI vs data layer) and respect them. Do not blur a boundary that is already established.

### Share types across boundaries

When types are needed on both sides of a boundary (e.g., request/response shapes), define them once and import from both sides. Avoid duplicating type definitions.

### Composition over coupling

Prefer passing dependencies explicitly (props, parameters, constructor injection) over reaching for global state or tight cross-module imports. This keeps units testable and boundaries clear.

### Consistent error handling

Use the project's established error model consistently — whatever shape, type, or exception strategy it already employs. Do not introduce a parallel error-handling convention.

### Minimal surface area

Expose only what callers need. Keep internals private. Prefer explicit exports over barrel files that re-export everything.

---

## When adding new code

- **New file?** Check if a similar file already exists. If yes, follow its naming and structure.
- **New folder?** Only if there are at least two files that belong together; otherwise colocate.
- **New dependency?** Confirm it is not already available from an existing package in the project.
- **New abstraction?** Only extract when there are at least two concrete use cases that justify it.
