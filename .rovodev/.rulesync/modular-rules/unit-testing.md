# Unit Testing Rules

## Discover project tooling first

Before writing or running tests:
- Identify the test runner and assertion library from `package.json` scripts and config files (e.g., `jest.config.*`, `vitest.config.*`, `.mocharc.*`).
- Identify the component/hook testing utilities already in use (React Testing Library, Vue Test Utils, etc.).
- Identify any shared test helpers, fixtures, or setup files already in the project.
- Use whatever the project defines. Do not introduce a new test framework.

---

## Core principles

- **Test behavior, not implementation.** Tests should describe what the code does from the caller's perspective, not how it does it internally.
- **Arrange-Act-Assert (AAA).** Structure every test with a clear setup phase, a single action, and verification of the outcome.
- **One behavior per test.** Keep each test focused. Multiple assertions are fine when they all verify the same behavior.
- **Descriptive names.** Test names should read as specifications. Do not start test descriptions with "should" — use the present tense ("it returns...", "it throws when...", "it calls X with...").
- **Test edge cases.** Empty inputs, null/undefined values, boundary conditions, permission errors, and network failures are all worth covering.
- **Fast and independent.** Each test must be runnable in isolation, in any order. Shared mutable state between tests is a bug.

---

## File organization

- Name test files `<name-of-file-under-test>.test.ts(x)` and place them in the **same directory** as the file being tested.
- Never use a `__tests__` directory or any equivalent centralized test folder.
- Every test file should have a root `describe` block named after the file or module under test.
- Look for an existing test file before creating a new one.

---

## Integration over mocks

- Prefer integration tests (real dependencies, real DB, real module graph) over unit tests with mocks wherever practical.
- Only mock when: (a) the dependency has unacceptable side-effects in tests (external network, email, billing), (b) the test needs to simulate specific failure modes that are hard to reproduce otherwise, or (c) the test would become unreasonably slow.
- Place shareable mocks in the project's global test setup file, not scattered across individual test files.
- Never manually clear, restore, or reset mocks inside individual tests — handle this globally in the setup/teardown lifecycle.

---

## Assertions

- **Falsy assertions require a preceding truthy anchor.** Before asserting that something does not exist or is null, first assert that the surrounding state is correct. This prevents false passes from setup failures.

  ```
  // ✅ correct
  expect(await findElement('button')).toBeVisible()
  expect(queryElement('error-message')).toBeNull()

  // ❌ wrong — passes even if the page never loaded
  expect(queryElement('error-message')).toBeNull()
  ```

---

## UI / component testing

- Use the project's established interaction simulation utility (e.g., `userEvent` or equivalent). Avoid low-level synthetic events unless no alternative exists.
- Avoid render-only tests that assert only that a component renders without error. Test meaningful behavior: user interactions, state changes, conditional rendering driven by props or responses.

---

## Coverage

- Coverage is a byproduct, not a goal. Do not write tests just to hit a percentage.
- Focus coverage on business-critical paths: data mutations, authorization checks, error branches, and edge cases.
- A passing test suite with meaningful assertions is worth more than 100% coverage with trivial assertions.
