#!/usr/bin/env bash
# Link every skill of this repository into ~/.claude/skills so Claude Code finds it.
set -euo pipefail

skills_dir="$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")"
target_dir="$HOME/.claude/skills"
mkdir -p "$target_dir"

# Remove links to skills that were renamed or deleted in this repository.
for link in "$target_dir"/*; do
  if [ -L "$link" ] && [ ! -e "$link" ]; then
    case "$(readlink "$link")" in
      "$skills_dir"/*)
        rm "$link"
        echo "removed  $(basename "$link") (no longer in the repo)"
        ;;
    esac
  fi
done

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
