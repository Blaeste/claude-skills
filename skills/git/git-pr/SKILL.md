---
name: git-pr
description: Create or update a GitHub pull request for the current branch with gh. Pushes the branch if needed, then writes a clear title and a structured description (summary, changes, how to test) from all the commits of the branch. Use whenever the user wants to open, prepare or update a pull request (PR), or get their branch reviewed on GitHub.
argument-hint: "[--draft] [base branch] [notes]"
allowed-tools:
  - Bash(git status *)
  - Bash(git branch --show-current)
  - Bash(git log *)
  - Bash(git diff *)
  - Bash(git fetch *)
  - Bash(git push)
  - Bash(git push -u origin HEAD)
  - Bash(gh repo view *)
  - Bash(gh pr view *)
  - Bash(gh pr create *)
  - Bash(gh pr checks *)
---

# Pull request

## Context

- Current branch: !`git branch --show-current 2>&1 || true`
- Default branch on GitHub: !`gh repo view --json defaultBranchRef --jq .defaultBranchRef.name 2>&1 || true`
- Status: !`git status --short --branch 2>&1 || true`
- Existing pull request: !`gh pr view --json number,title,state,url 2>&1 || true`

User request (may be empty): $ARGUMENTS

## Steps

1. Check first:
   - Not a GitHub repository, or gh not logged in: explain (`gh auth login`) and stop.
   - On the default branch: a pull request from main to main is impossible. Offer to create a branch from the current state with the git-branch skill; the commits follow.
   - A pull request already exists: give its link. Pushing new commits updates it. Change its title or description with `gh pr edit` only if the user asks.
   - Uncommitted changes: ask whether they belong in the pull request. If so, run the git-commit skill first.
2. The base branch is the one the user gave, otherwise the default branch above. Read all the commits of the branch, not just the last one: run `git fetch origin`, `git log --oneline origin/<base>..HEAD` and `git diff --stat origin/<base>...HEAD`, then read the important parts of the diff. If there are no commits ahead of the base, there is nothing to propose: say so.
3. Push if needed: `git push -u origin HEAD` when there is no upstream, `git push` when commits aren't pushed yet.
4. Write the title: under 70 characters, in the Conventional Commits style if the repository uses it.
5. Write the description in English, keeping only the useful sections:

   ```
   ## Summary
   1 to 3 sentences: what the pull request does and why.

   ## Changes
   - the important changes, from the reviewer's point of view

   ## How to test
   - [ ] concrete verification steps

   ## Notes
   risks, breaking changes, open questions
   ```

   Add `Closes #<n>` only if an issue is referenced in the branch name, the commits or the request.
6. Create it, passing the description in a heredoc to keep its formatting:

   ```
   gh pr create --base <base> --title "<title>" --body "$(cat <<'EOF'
   <description>
   EOF
   )"
   ```

   Add `--draft` if the user asks for a draft or if the work is clearly unfinished.
7. Report the pull request link, its base branch and whether it's a draft. If the repository has CI, offer to follow it with `gh pr checks`.
