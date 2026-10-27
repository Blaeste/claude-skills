---
name: debug-code
description: Find and fix a bug methodically. Reproduce it, isolate it, find the root cause with evidence, and only then fix it and prove the fix works. Covers crashes, segfaults, memory leaks, wrong output and failing tests, with valgrind, gdb and sanitizers for C. Use whenever the user reports a bug, a crash, a segfault, a leak, a failing test or a behavior they don't understand.
argument-hint: "<what goes wrong, and how to trigger it>"
---

# Debug code

User report (may be empty): $ARGUMENTS

The rule of this skill: no fix before the root cause is found and proven. A fix based on a guess often hides the bug instead of removing it, and the next one is harder to find.

## 1. Reproduce

Get a command or a sequence of steps that triggers the bug every time, and run it. If the report doesn't give one, ask the user. Write down the exact error, output or exit code.

If you can't reproduce it, say so and gather more facts (input, environment, recent changes) before going further.

## 2. Isolate

Shrink the problem until it's small:
- Find the smallest input that still triggers the bug.
- Check the recent changes with `git log --oneline -10` and `git diff`. If the bug is new, `git bisect` finds the commit that introduced it.
- Add temporary prints, or use a debugger, to see where the actual behavior leaves the expected one.

## 3. Find the root cause

State a hypothesis, then test it with evidence: a print, a value in the debugger, a minimal test. Keep a hypothesis only if the evidence confirms it. Explain the cause in one or two sentences before touching the code.

For C programs (42 projects):
- Segfault: rebuild with `-g -fsanitize=address` and run again, or run `gdb ./<program>`, then `run <args>` and `bt` to see the call stack at the crash.
- Memory leak or invalid read or write: `valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./<program> <args>`.
- Undefined behavior: add `-fsanitize=undefined`.
- Don't use AddressSanitizer and valgrind at the same time: they don't work together.
- Put the Makefile flags back after debugging, so the debug flags are never committed.

## 4. Fix

Fix the root cause, with the smallest change that does it. Don't fix other things on the way: mention them in the report instead.

## 5. Prove it

Run the reproduction from step 1 again: the bug must be gone. If the project has tests, add one that fails without the fix and passes with it, then run the check skill to make sure nothing else broke. Remove the temporary prints.

## 6. Report

The bug, its root cause and the evidence that proves it, the fix, and how it was verified.
