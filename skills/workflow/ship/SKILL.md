---
name: ship
description: Ship a finished change in one command. Runs the checks, then commits, pushes and opens a pull request by chaining the check, git-branch, git-commit, git-push and git-pr skills, with a single confirmation. Started only by the user with /ship.
disable-model-invocation: true
argument-hint: "[--draft] [notes]"
---

# Ship

User request (may be empty): $ARGUMENTS

Run each step with the skill named in it, so that all its rules apply. Stop as soon as a step fails or is refused, and say why: stopping is better than shipping half of a change.

## 1. Check

Run the check skill. Apply only safe automatic fixes (formatting, auto-fixable lint). If errors remain, stop here and show them: broken code isn't shipped. If the project has no checks, say so and go on.

## 2. Branch

If the current branch is the main one (main or master), ask the user to choose:
- create a branch with the git-branch skill, then push it and open a pull request;
- push directly to the main branch, without a pull request.

## 3. Recap

Show one recap and ask for a single OK before going on:
- the planned commits, one line each, since the git-commit rules can split the work into several commits;
- the branch, and where it will be pushed;
- the pull request and its draft title, or "no pull request".

## 4. Commit, push, pull request

Without asking again, since the user approved the recap:
1. Run the git-commit skill.
2. Run the git-push skill.
3. Run the git-pr skill when the branch isn't the main one, passing `--draft` if the user asked for it.

The safety questions of these skills still apply, for example a secret found in the changes or a missing remote: ask them when they come up.

## 5. Report

- Checks: the result, and what was fixed.
- The commits created.
- The branch pushed, and the remote.
- The pull request link, or why there is none.
