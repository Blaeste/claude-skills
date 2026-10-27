---
name: tdd
description: Build a feature or fix a bug test first. Write a failing test that describes the expected behavior, write the minimal code that makes it pass, then clean up while the tests stay green. Use whenever the user asks for TDD or test-first, asks to add tests along with a change, or wants a behavior to be guaranteed by a test.
argument-hint: "<behavior to implement or bug to fix>"
---

# Test-driven development

User request (may be empty): $ARGUMENTS

Work in short cycles of red, green, refactor. The test comes first because a test written after the code tends to check what the code does, not what it should do.

## 1. Find how the project tests

Look for the existing tests and how they run: the `test` script of package.json (`tsx --test`, vitest, jest), pytest, a Makefile target. Use the same framework, folder and naming. If the project has no tests yet:
- TypeScript or JavaScript: use Node's built-in test runner (`node:test` with `assert`), so nothing needs to be installed.
- C (42 projects): write a small test program in a `tests/` folder, with its own `main` and `assert`, built by a separate Makefile rule, so the project's files stay unchanged. If the subject forbids extra files in the repository, keep the tests outside it and tell the user.
If the tested file has its own `main`, compile it alone with `-Dmain=<file>_main -c` into an object, then link that object with the test program, so the two `main` functions don't clash.

Ask before installing a test framework.

## 2. Red: write one failing test

Write the smallest test for the next piece of behavior: one case, with a name that says what is expected. Run it and check that it fails for the right reason (the behavior is missing), not because of a typo or a missing import. A test that has never failed proves nothing.

## 3. Green: make it pass

Write the minimal code that makes this test pass, and nothing more. Run all the tests: the new one passes and the old ones still pass.

## 4. Refactor

Clean up the code and the tests (names, duplication, structure) without changing the behavior. Run the tests after each change: they must stay green.

## 5. Repeat

Go back to step 2 with the next case. Edge cases (empty input, limits, errors) come after the normal case. Stop when the request is covered.

## 6. Check and report

Run the check skill to make sure nothing else broke. Then report the tests written (each with the behavior it guarantees), the code changed, and the command that runs the tests.
