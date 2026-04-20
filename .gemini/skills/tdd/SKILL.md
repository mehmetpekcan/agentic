---
name: tdd
description: >-
  Implement code using Test-Driven Development — tests as a design tool, not a
  coverage exercise. Use when implementing any feature or bug fix that requires
  writing production code.
---
# TDD

Work in tight red/green/refactor cycles. Do not write all tests up front; do not write the implementation first.

## Cycle

For each small increment of behaviour:

1. **Red.** Write the smallest failing test that expresses the next behaviour required. The test should read as a statement of intent.
2. **Green.** Write the minimum implementation that makes the test pass. Resist generalising ahead of the tests.
3. **Refactor.** With tests green, clean up the code just written — naming, duplication, structure. Keep tests green throughout.
4. Repeat until the approved approach is fully implemented.

## Before starting

Read neighbouring code and tests to match the project's conventions (framework, assertion style, file layout, mocking approach). Conventions in the repo win over personal preference.

## Design signals

If a test is hard to write because the code is awkwardly shaped, that is a design signal — adjust the design, don't fight the test.

## Hard rules

- Tests are written **before** the code they cover. No "write tests after" disguised as TDD.
- Each cycle is small. Don't batch a dozen tests and a feature into one step.
- No refactoring with a red bar.

## Anti-patterns

- Writing the full test suite up front, then the implementation.
- Implementing beyond what the current failing test requires.
- Chasing coverage percentages — coverage is a byproduct, not a goal.
- Rewriting adjacent code not required by the current cycle.
