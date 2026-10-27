---
name: git-commit
description: Create clean, atomic git commits in the Conventional Commit format from the current changes. Use whenever the user asks to commit or to save their work in git, or when committing is a step of the current task.
argument-hint: "[message hint]"
allowed-tools:
   - Bash(git status *)
   - Bash(git diff *)
   - Bash(git log *)
   - Bash(git add *)
   - Bash(git commit *)
---

# Commit

## Context

- Status: !`git status --short --branch 2>&1 || true`
- Staged: !`git diff --cached --stat 2>&1 || true`
- Unstaged: !`git diff --stat 2>&1 || true`
- Recent: !`git log --oneline -10 2>&1 || true`

User hint (may be empty): $ARGUMENTS

## Steps

1. Not a git repository: say so and offer `git init`. Nothing to commit: say so and stop.
2. Read the diffs and the new files before writing anything: the message describes the intent, and file names alone don't reveal it.
3. Never stage secrets (.env, private keys, tokens): once pushed, a secret stays compromised even after you delete it. Skip build artifacts too (*.o, a.out, node_modules/). Point them out and suggest adding them to .gitignore.
4. One commit per intent: if the changes mix unrelated work, split them by staging files by path. If the user already staged a selection, commit only that.
5. Write each message as `<type>(<scope>): <summary>`:
   - types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
   - summary in English, imperative mood, 72 characters max, no trailing period
   - add a body only when the why isn't obvious
   - the user hint above takes priority
6. Commit with `git commit -m "<summary>"` (add `-m "<body>"` for a body). If a pre-commit hook fails, fix the cause and commit again. Don't use --amend or --no-verify unless the user asks.
7. Show the new commits with `git log --oneline -<n>`.
8. Don't push on your own: ask the user whether to push the new commits. If they agree, run the git-push skill. Skip this question when the commit was a step of the git-push or ship skill, since they push right after.

