## `/zoom-out`

### Use

Use this when you are inside unfamiliar code and need a higher-level understanding before changing anything. It helps you understand:

- important modules
- data flow
- ownership boundaries
- public interfaces
- related files
- domain concepts
- how the current area fits into the whole system

### When

Use it when:

- you are lost in a feature area
- you need to modify code you did not write
- an AI assistant is about to make changes but lacks context
- you want a map before implementation
- you want to understand callers and dependencies

### Example

```text
/zoom-out

Help me understand the service graph layout area.
I need to know how data flows from API response to xyflow nodes.
```

---

## `/grill-me`

### Use

Use this when you have an idea, but the requirements are still unclear. It asks clarifying questions, challenges vague terms, checks domain language, and helps turn a fuzzy idea into something concrete. It is especially useful before writing a PRD or implementation plan.

### When

- the feature idea is not fully defined
- behavior is ambiguous
- terminology is unclear
- product decisions are still needed
- you want the AI to challenge assumptions

### Example

```text
/grill-me

I want to add saved layouts to the service graph UI.
Users should be able to move nodes and persist their positions.
Grill me before we build it.
```

---

## `/to-prd`

### Use

Use this when the feature is already discussed enough and you want a formal PRD. It turns the current conversation and repo context into a structured product/technical requirements document. It should synthesize what is already known rather than interviewing you from scratch.

### When

- the idea is clear enough to document
- you need a durable spec
- you want to hand work off to another engineer or AI agent
- you want to capture decisions, scope, and non-goals
- you want a source of truth before creating issues

### Example

```text
/to-prd

Turn everything we discussed about saved graph layouts into a PRD.
Include user stories, implementation decisions, testing decisions, and out-of-scope items.
```

---

## `/to-issues`

### Use

Use this when you already have a PRD, spec, or plan and want implementation tasks. It breaks work into thin vertical slices instead of horizontal technical layers. A good issue should be independently useful, testable, and reviewable.

### When

- you have a PRD and need GitHub/Linear issues
- the feature is too large to implement in one pass
- you want agent-friendly implementation tasks
- you want to separate human-decision work from implementation work
- you want each task to produce visible or verifiable behavior

### Example

```text
/to-issues

Break the saved graph layouts PRD into vertical implementation slices.
Separate agent-ready tasks from tasks that need human judgment.
```

### Bad Issue Breakdown

```text
1. Create database table
2. Add backend API
3. Build frontend UI
4. Add tests
```

### Better Issue Breakdown

```text
1. Save and load one user’s layout for one graph
2. Reset a saved layout back to auto-layout
3. Handle newly discovered services in an existing saved layout
4. Add loading, empty, and error states for layout sync
```

---

## `/tdd`

### Use

Use this when you are ready to implement or fix something using a test-first workflow. It follows a loop like:

```text
write failing test → minimal implementation → refactor → next test
```

The goal is to test behavior through public interfaces, not implementation details.

### When

- you are implementing a feature slice
- you are fixing a bug
- you want safer refactoring
- you want regression coverage
- you want the AI to avoid overbuilding
- you want one small verified step at a time

### Example

```text
/tdd

Implement the first saved-layout slice:
when a user moves a graph node and refreshes the page,
the node should appear in the same position.
```

### Good Test Style

```text
User moves a node, refreshes the page, and sees the node in the same position.
```

### Weak Test Style

```text
layoutStore.setNodePosition was called with { x, y }.
```
