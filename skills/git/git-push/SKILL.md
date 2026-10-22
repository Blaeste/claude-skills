---
name: git-push
description: Push the current git branch to its remote safely (GitHub, GitLab, vogsphere). Sets the upstream on the first push, handles a branch that is behind, and never overwrites other people's work. Use whenever the user asks to push, to send their commits to GitHub, or to publish their branch.
argument-hint: "[remote] [--force]"
allowed-tools:
   - Bash(git status *)
   - Bash(git branch --show-current)
   - Bash(git remote -v)
   - Bash(git log *)
   - Bash(git fetch *)
   - Bash(git push)
   - Bash(git push -u origin HEAD)
---

# Push

## Context

- Branch: !`git branch --show-current 2>&1 || true`
- Status: !`git status --short --branch 2>&1 || true`
- Remotes: !`git remote -v 2>&1 || true`
- Unpushed commits: !`git log --oneline HEAD --not --remotes 2>&1 || true`

User request (may be empty): $ARGUMENTS

## Steps

1. Check before pushing:
   - No remote: offer to create the GitHub repository with `gh repo create <name> --private --source=. --remote=origin`. Ask for the name and visibility first, and don't create it without the user's OK.
   - Detached HEAD: stop and explain that a branch is needed first.
   - Uncommitted changes: point them out, since they won't be pushed, and ask whether to commit them first. If the user agrees, run the git-commit skill, then continue from step 2 with the new commits.
   - Nothing to push and nothing left to commit: say so and stop.

2. Run `git fetch` and compare with the remote. If the branch is behind or has diverged, offer `git pull --rebase`. Never force a push to get past a rejection: it would erase the commits someone else pushed.
3. Push with `git push -u origin HEAD` the first time (no upstream yet), and `git push` after that.
4. Force push only when the user asks for it, always with `git push --force-with-lease` (it refuses if someone else pushed in the meantime), and never on main or master.
5. If a pre-push hook fails, show the error and fix the cause. Don't use --no-verify unless the user asks.
6. Report what was pushed (commits, branch, remote). If the remote is GitHub and the branch isn't the default one, suggest opening a pull request with /git-pr.

