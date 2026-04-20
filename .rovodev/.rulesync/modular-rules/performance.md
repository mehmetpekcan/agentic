# Performance Rules

Apply these principles through whatever data layer, framework, and runtime the repo uses. The patterns are universal; the implementation details vary.

---

## Data fetching

### Avoid N+1 queries

Never fetch a list of records and then issue a separate query per record in a loop. Instead, batch the related data in a single query with joins, includes, or a bulk-fetch call — whatever the project's data layer supports.

### Project only needed fields

Request only the columns/fields you will actually use. Avoid selecting `*` or fetching entire documents when only a few properties are needed. This reduces payload size and memory pressure.

### Paginate large result sets

Never load an unbounded collection. Always apply a limit. For user-facing lists, use cursor-based or offset pagination with a sensible default page size.

### Index hot query paths

Identify the fields used in filters, sorts, and joins that are queried frequently. Ensure the database has appropriate indexes for those access patterns. Review the query plan when something is slow.

### Avoid redundant reads

When the same data is needed in multiple places in a single request/render cycle, fetch it once and pass it down or cache it. Do not re-fetch the same resource independently in sibling components or functions.

---

## Bundle and module size (front-end)

### Lazy-load heavy modules

Defer loading large dependencies until they are needed. Use the framework's dynamic import mechanism (`import()`, `React.lazy`, `dynamic()`, etc.) for components and libraries that are not required on the critical path.

### Tree-shake

Prefer named imports over default namespace imports when consuming large libraries. Verify that the bundler can statically eliminate unused exports.

### Minimize payload

Return only the data a client needs. Do not send entire records when a subset would suffice. This applies to API responses, server-rendered HTML props, and event payloads alike.

---

## General

- **Measure before optimizing.** Identify the actual bottleneck with profiling or query-plan analysis before rewriting anything.
- **Async where appropriate.** Parallelize independent I/O operations (e.g., `Promise.all`) rather than awaiting them sequentially.
- **Connection and resource cleanup.** Ensure subscriptions, event listeners, and open connections are released when no longer needed.
