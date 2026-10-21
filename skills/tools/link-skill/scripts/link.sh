#!/usr/bin/env bash
# Link every skill of this repository into ~/.claude/skills so Claude Code finds it.
# Skills can be grouped in category folders (skills/git/git-commit/...). Claude Code
# only looks one level deep in ~/.claude/skills, so the links stay flat.
set -euo pipefail

repo_dir="$(git -C "$(dirname "$(readlink -f "$0")")" rev-parse --show-toplevel)"
skills_dir="$repo_dir/skills"
target_dir="$HOME/.claude/skills"
mkdir -p "$target_dir"

# Remove links to skills that were moved, renamed or deleted in this repository.
for link in "$target_dir"/*; do
  if [ -L "$link" ] && [ ! -e "$link" ]; then
    case "$(readlink "$link")" in
      "$skills_dir"/*)
        rm "$link"
        echo "removed  $(basename "$link") (no longer at this path)"
        ;;
    esac
  fi
done

# Link every folder that contains a SKILL.md, at any depth.
find "$skills_dir" -name SKILL.md -print0 | sort -z | while IFS= read -r -d '' file; do
  skill="$(dirname "$file")"
  name="$(basename "$skill")"
  link="$target_dir/$name"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$skill" ]; then
    echo "ok       $name (already linked)"
  elif [ -e "$link" ] || [ -L "$link" ]; then
    echo "skipped  $name ($link already exists)"
  else
    ln -s "$skill" "$link"
    echo "linked   $name"
  fi
done
