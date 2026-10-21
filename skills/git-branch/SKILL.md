---
name: git-branch
description: Manage git branches. Create a well-named branch (feat/..., fix/...) from an up-to-date main branch, switch branches without losing work, update a branch with main (rebase or merge, conflicts included) and clean up merged branches. Use whenever the user starts a new task on a branch or wants to create, switch, sync or delete branches.
argument-hint: "[task description | sync | clean | branch name]"
allowed-tools:
   - Bash(git status *)
   - Bash(git branch --show-current)
   - Bash(git branch -vv)
   - Bash(git branch --merged *)
   - Bash(git log *)
   - Bash(git fetch *)
   - Bash(git switch -c *)
   - Bash(git symbolic-ref --short refs/remotes/origin/HEAD)
---

# Git branch

## Context

- Current branch: !`git branch --show-current 2>&1 || true`
- Status: !`git status --short --branch 2>&1 || true`
- Local branches: !`git branch -vv 2>&1 || true`
- Default remote branch: !`git symbolic-ref --short refs/remotes/origin/HEAD 2>&1 || true`

User request (may be empty): $ARGUMENTS

Pick the action from the request: a task description means create, "sync" means update with the main branch, "clean" means clean up, an existing branch name means switch.

The main branch is the default remote branch shown above. If that line is empty or an error, use main or master, wichever exists.

## Create a branch

1. Name it `<type>/<short-description>`: lowercase, words joined by hyphens, no accents or spaces, 50 characters max. Types: feat, fix, docs, refactor, test, chore. Follow the repository's existing convention if it has one.
2. Start from an up-to-date main branch, to avoid conflicts later:
   - Clean working tree with a remote: run `git fetch origin`, then `git switch -c <name> --no-track origin/<main>`. Without `--no-track`, the new branch would track main and `git push` would try to push to it.
   - No remote: `git switch -c <name> <main>`.
   - Uncommited changes: `git switch -c <name>` from the current position takes them along, which is usually what the user wants ("I started on main by mistake"). Say so.
3. Report the branch name, its starting point, and the next steps (/git-commit, /git-push, /git-pr).

## Switch branch

Run `git switch <name>`. If git refuses because of uncommitted changes, offer to commit them or to stash them (`git stash push -m "<reason>"`, restored with `git stash pop`). Never use `--discard-changes` or `-f` without the user's OK: they delete work.

## Sync with the main branch

1. The working tree must be clean (commit or stash first).
2. Run `git fetch origin`.
3. Choose the method and explain the choice in one sentence:
   - rebase if the branch was never pushed or only the user work on it, for a linear history: `git rebase origin/<main>`
   - merge if the branch is already pushed and shared, so other people's history isn't rewritten: `git merge --no-edit origin/<main>`
4. On conflicts, list the files, read both sides and keep the intent of each; ask the user when it's ambiguous. Then run `git add <files>` and `GIT_EDITOR=true git rebase --continue` (the variable stops git from opening an editor, which would hang). `git rebase --abort` or `git merge --abort` restore everything: tell the user.
5. After rebasing a branch that was already pushed, the next push must be forced: warn the user and let the git-push skill handle it.

## Clean up

1. Run `git fetch --prune`
2. Candidates: `git branch --merged origin/<main>` and the branches marked `[gone]` in `git branch -vv`.
3. Show the list and ask for confirmation before deleting anything.
4. Delete merged branches with `git branch -d`. Use `-D` only for `[gone]` branches after explicit confirmation, since it also deletes unmerged work.
5. Never delete the main branch or the current branch, nor any remote branch unless asked.
