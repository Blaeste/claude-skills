# claude-skills

My personal [Claude Code](https://code.claude.com) skills for everyday development.

| Skill | What it does |
|---|---|
| `/git-commit` | Atomic commits in the Conventional Commits format |
| `/git-push` | Safe push that offers to commit first |
| `/git-branch` | Create, switch, sync and clean up branches |
| `/git-pr` | Open a GitHub pull request with a structured description |
| `/link-skill` | Link the skills of this repo into `~/.claude/skills` |

## Install

```bash
git clone https://github.com/Blaeste/claude-skills.git
cd claude-skills
mkdir -p ~/.claude/skills
ln -s "$PWD/skills/link-skill" ~/.claude/skills/link-skill
```

Then type `/link-skill` in Claude Code to link all the other skills.
