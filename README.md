# claude-skills

My personal [Claude Code](https://code.claude.com) skills for everyday development.

| Skill | What it does |
|---|---|
| `/git-commit` | Atomic commits in the Conventional Commits format |
| `/git-push` | Safe push that offers to commit first |
| `/git-branch` | Create, switch, sync and clean up branches |
| `/git-pr` | Open a GitHub pull request with a structured description |
| `/check` | Run the project's checks (lint, types, tests, build, norminette) and fix them on request |
| `/proofread` | Fix spelling, grammar and typos in docs and comments, then report each fix |
| `/debug-code` | Find a bug's root cause with evidence before fixing it (valgrind, gdb, sanitizers for C) |
| `/tdd` | Build a feature test first: failing test, minimal code, then refactor |
| `/update-docs` | Update the README and docs from their content, the project files and your notes |
| `/create-docs` | Write a new doc (guide, architecture, how-to) from your notes, checked against the project |
| `/explain-code` | Explain a file, a function or the selected code step by step, to learn from it |
| `/plan-feature` | Turn a feature idea into an agreed design and a step-by-step plan, before any code |
| `/ship` | Check, commit, push and open a pull request with a single confirmation (manual only) |
| `/create-skill` | Create a new skill in this repo from your instructions, following its conventions |
| `/link-skill` | Link the skills of this repo into `~/.claude/skills` |

Skills are grouped by category in `skills/<category>/<name>/`: `git`, `quality`, `docs`, `study`, `workflow` and `tools`.

## Install

```bash
git clone https://github.com/Blaeste/claude-skills.git
cd claude-skills
mkdir -p ~/.claude/skills
ln -s "$PWD/skills/tools/link-skill" ~/.claude/skills/link-skill
```

Then type `/link-skill` in Claude Code to link all the other skills.


## Docs

- [Adding a skill](docs/adding-a-skill.md)

