---
name: check
description: Run the project's quality checks (type check, lint, tests, build, and norminette for 42 C projects), summarize the errors, and fix them when asked. Use whenever the user asks to check, lint, type-check, test or validate their code, or asks whether it compiles or passes the norm. Also use it on your own before a commit or a pull request, after significant changes.
argument-hint: "[fix] [lint|types|test|build|norm]"
allowed-tools:
  - Bash(git ls-files *)
---

# Check

## Context

- Project files: !`git ls-files '*package.json' '*tsconfig.json' '*Makefile' '*.mk' '*pyproject.toml' 2>&1 | head -40 || true`
- CI workflows: !`git ls-files '.github/workflows/*' 2>&1 || true`
- C sources: !`git ls-files '*.c' '*.h' 2>&1 | head -5 || true`

User request (may be empty): $ARGUMENTS

## 1. Find the checks

Use what the project itself runs, in this order:
1. The CI workflows above: they define what "checked" means for this project. Read them and reuse their commands.
2. The Makefile targets (`lint`, `test`, `check`, `norm`...).
3. The `scripts` of each package.json (`lint`, `typecheck`, `test`) and the config files: a tsconfig.json means `npx --no-install tsc --noEmit` in that folder.

If nothing is found, look in the README for how the project is built and tested, and propose a command.

Never run a target that deletes or resets something (`clean`, `fclean`, `re`, `prune`, `down`, `reset`...), even if it looks like a check: in some projects `fclean` wipes the database.

If the user named a category (lint, types, test, build, norm), run only that one.

## 2. Install what's missing, with the user's OK

Checks often need dependencies (`node_modules`, a virtualenv, a generated Prisma client). If something is missing, say what and which command installs it, preferring the project's own targets (`make install`, `make generate`). Then ask before running it: it downloads packages and writes to the project.

## 3. Run each check

Run them one by one from the right folder, keeping only the end of the output so the conversation stays readable:

    { <command> 2>&1; echo "exit: $?"; } | tail -n 60

If the end isn't enough to understand an error, run the command again on the failing package only.

## 4. Fix, if asked

- If the user asked to fix (`fix`), or if you introduced these errors yourself in the current task, fix the cause, then run the failing checks again until they pass, or until you're blocked and can explain why.
- Otherwise, show the errors and a fix plan, and ask before changing code.
- Fix the cause, don't hide the symptom: no `eslint-disable`, `@ts-ignore`, `any`, skipped test or removed `-Werror` without the user's OK, because that hides the problem instead of solving it.

## 42 C projects

- Build with `make` and read the warnings: 42 projects compile with `-Wall -Wextra -Werror`.
- Run `norminette` on the project's own `.c` and `.h` files only, not on provided libraries such as the minilibx.
- When splitting a function to respect the norm (25 lines, 4 parameters, 5 variables, 5 functions per file), cut it into pieces that make sense.
- Never edit the 42 header at the top of the files.
- For memory leaks, offer `valgrind --leak-check=full --show-leak-kinds=all ./<program> <args>` with realistic arguments.

## 5. Report

A short table: check, folder, result. Then the errors grouped by cause (one root cause often produces dozens of errors), what you fixed, and what is left.
