---
name: link-skill
description: Install the skills of the user's skills repository by linking them into ~/.claude/skills, so Claude Code finds them in every project. Use whenever the user has created a new skill and wants to install, activate or link it, or when a new skill doesn't show up in the / menu.
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/scripts/link.sh)
---

# Link skill

1. Run `${CLAUDE_SKILL_DIR}/scripts/link.sh`. It links every folder of the repository's `skills/` directory that contains a SKILL.md, including skills grouped in category folders, and leaves the ones already linked alone.
2. Show the user the result, one line per skill.
3. Claude Code watches ~/.claude/skills and picks up new skills by itself. If a newly linked skill still doesn't appear in the / menu, tell the user to type /reload-skills (only the user can run it).
4. If a skill was skipped because something else already has its name in ~/.claude/skills, explain the conflict and don't delete anything without the user's OK.
