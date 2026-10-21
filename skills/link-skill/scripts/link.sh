#!/usr/bin/env bash
# Link every skill of this repository into ~/.claude/skills so Claude Code finds it.
set -euo pipefail

skills_dir="$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")"
target_dir="$HOME/.claude/skills"
mkdir -p "$target_dir"

for skill in "$skills_dir"/*/; do
  skill="${skill%/}"
  name="$(basename "$skill")"
  link="$target_dir/$name"
  if [ ! -f "$skill/SKILL.md" ]; then
    echo "skipped  $name (no SKILL.md)"
  elif [ -L "$link" ] && [ "$(readlink "$link")" = "$skill" ]; then
    echo "ok       $name (already linked)"
  elif [ -e "$link" ] || [ -L "$link" ]; then
    echo "skipped  $name ($link already exists)"
  else
    ln -s "$skill" "$link"
    echo "linked   $name"
  fi
done
