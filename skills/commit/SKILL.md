---
name: commit
description: Create clean, atomic git commits in the Conventional Commit format from the current changes. Use whenever the user asks to commit or to save their work in git, or when committing is a step of the current task.
---

# Commit

1. Run `git status` and `git diff` to understand what changed and why.
2. Never stage secrets (.env, private keys, tokens) or build artifacts (*.o, a.out, node_modules/). Point them out and suggest adding them to .gitignore.
3. If the changes mix unrelated intents, makes one commit per intent.
4. Write each message as `<type>(<scope>): <summary>`:
  - types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
  - summary in the imperative mood, 72 characters max, no trailing period
5. Stage files by path, then commit. Don't use --amend or --no-verify unless user asks.
6. Show the new commits with `git log --oneline`. Don't push.
