# Plan: the /ship skill

Ship a finished change in one manual command: run the checks, then commit, push and open a pull request, by chaining the existing skills.

## Decisions

| Question | Decision |
|---|---|
| The checks find errors | Stop and show them. Only safe automatic fixes (formatting, auto-fixable lint) are applied first. |
| `/ship` runs on the main branch | Ask: create a branch and open a pull request, or push directly without a pull request |
| Who can start it | Only the user, with `/ship` (`disable-model-invocation: true`), because it pushes and opens a pull request |
| Confirmations | One: a recap of the planned commits, branch, push and pull request, then everything runs |
| Approach | An orchestrator that runs the existing skills (check, git-branch, git-commit, git-push, git-pr) and only adds its own rules |

## Steps

### 1. Let git-commit skip its push question when ship runs it
In `skills/git/git-commit/SKILL.md`, step 8, extend the exception to the ship skill: "Skip this question when the commit was a step of the git-push or ship skill, since they push right after."
**Verify:** `grep -n "git-push or ship" skills/git/git-commit/SKILL.md` finds the line.

### 2. Create the skill and its frontmatter
Check that `/ship` is still free with the binary grep used for the other names. Create `skills/workflow/ship/SKILL.md` with `name: ship`, a description, `disable-model-invocation: true` and `argument-hint: "[--draft] [notes]"`.
**Verify:** `/link-skill` prints `linked ship`. `/ship` shows up in the `/` menu, but not in the list of skills Claude can start by itself.

### 3. Write the steps of the skill
In this order:
1. **Check**: run the check skill and apply only safe automatic fixes. If errors remain, stop and show them. If the project has no checks, say so and go on.
2. **Branch**: on the main branch, ask whether to create a branch and open a pull request (the git-branch skill), or to push directly without a pull request.
3. **Recap**: list the planned commits, the branch, where it will be pushed, and the pull request with its draft title. Ask for one OK.
4. **Commit**: run the git-commit skill.
5. **Push**: run the git-push skill.
6. **Pull request**: run the git-pr skill when the branch isn't the main one, passing `--draft` if it was asked for.
7. **Report**: the checks, the commits, the push, and the pull request link.

**Verify:** read the file back and check that each decision above appears in it.

### 4. Test it for real on this repository
Use a real pending change: the `## Docs` section of the README, linking `docs/adding-a-skill.md`, which is still missing. Make the change on `master`, then run `/ship`.
**Verify:**
- it asks the branch question;
- after "branch + pull request", a single recap appears;
- after the OK, the commit, the push and the pull request follow without other questions;
- the pull request link opens on GitHub.

### 5. Update the README
Run `/update-docs` to add `/plan-feature` and `/ship` to the table, and `workflow` to the categories.
**Verify:** the README table lists 15 skills.

## Risks

- The chained skills keep their own safety questions, for example a secret found by git-commit or a missing remote in git-push. They can still interrupt `/ship`, and that's intended.
- git-commit can split the changes into several commits, so the recap must list each planned commit, not only one.
- The "checks fail" path is hard to test in this repository, which has no checks. It should be tested later on trans or on a 42 project.

## Out of scope

- Merging the pull request and deleting the branch, which `/git-branch clean` already does.
- Waiting for the CI: `/ship` only offers `gh pr checks`, through git-pr.
