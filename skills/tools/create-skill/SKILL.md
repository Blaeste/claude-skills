---
name: create-skill
description: Create a new Claude Code skill in the user's skills repository from their instructions, following the repository's conventions (category folders, English, minimal permissions), then install it with link-skill. Use whenever the user asks to create, write or add a new skill or slash command, or to turn a workflow into a skill.
argument-hint: "<what the skill should do>"
allowed-tools:
  - Bash(readlink -f *)
  - Bash(ls *)
  - Write
---

# Create skill

## Context

- This skill's real folder: !`readlink -f ${CLAUDE_SKILL_DIR} 2>&1 || true`
- Installed skills: !`ls ~/.claude/skills 2>&1 || true`

User instructions: $ARGUMENTS

The skills repository is the folder three levels above this skill's real folder (`<repository>/skills/tools/create-skill`). New skills go in `<repository>/skills/<category>/<name>/SKILL.md`, whatever project the user is in right now.

## 1. Understand the skill

From the instructions, find: what the skill does, when it should trigger (the words the user would say), what it receives after the command, what it changes, and what it reports at the end. If any of this is unclear or missing, ask the user before writing anything, with choices when possible. Don't guess: a skill built on a wrong guess does the wrong thing every time it runs.

## 2. Name and place it

- Name in English kebab-case, starting with the category prefix when the category uses one (`git-` for git skills).
- Category: pick the existing folder of `<repository>/skills/` that fits. If none fits, propose a name for a new category folder, with one or two alternatives, and wait for the user's choice before creating it.
- The name must not be one of the installed skills above, nor a built-in command such as `/branch`, `/commit`, `/pr`, `/review`, `/init`, `/doctor`, `/help`, `/clear` or `/config`: a skill with the same name would replace it. When unsure, ask the user to type `/<name>` in the menu to check.
- Before writing, state the full path the skill will be created at.

## 3. Write SKILL.md

Write it in English, following the other skills of the repository:
- **Frontmatter**: `name`; `description` with what the skill does, then when to use it, with the user's own words; `argument-hint` in quotes; `allowed-tools` with only what the skill needs. Use exact rules (no `*`) for anything risky (`Bash(git push)`, never `Bash(git push *)`), never pre-allow a command that can delete data, and allow `Edit` or `Write` only if the skill must change files by itself. Add `disable-model-invocation: true` when the skill chains actions other people will see (push, pull request, deploy).
- **Context**: `!` commands that give the skill what it needs to start, each ending with `2>&1 || true` so a failure doesn't cancel the skill, and without `@{...}` syntax, which isn't run ahead.
- **User request**: a line with `\$ARGUMENTS`.
- **Steps**: numbered, short, in the imperative. Give the reason of each rule, ask before anything destructive or visible to others, and reuse the other skills by name ("run the git-commit skill") instead of copying their steps.
- **Report**: what the skill shows at the end.

Keep it under about 100 lines. Put long reference material in a `references/` file, and deterministic work in a script in `scripts/`, made executable and called through `\${CLAUDE_SKILL_DIR}`.

## 4. Install it

Run the link-skill skill and check that its output shows `linked <name>`. If it shows `skipped` instead, explain the conflict to the user. The new skill shows up a few seconds later, or right away after `/reload-skills`, which only the user can run.

## 5. Report

The path of the new skill, its name and description, the permissions it got and why. Then a realistic command to test it, what the user should check in the result, and a suggestion to commit with the git-commit skill.
