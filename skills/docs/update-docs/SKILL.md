---
name: update-docs
description: Update the project's README and documentation files so they match the current project. Starts from their existing content, checks every claim against the files actually in the project, and adds the information the user gives after the command. Use whenever the user asks to update, refresh or complete the README or the docs, or after changes that leave the docs out of date (new feature, renamed command, new install step).
argument-hint: "[file] [information to add]"
allowed-tools:
  - Bash(git ls-files *)
  - Bash(git log *)
  - Bash(git diff *)
  - Edit
---

# Update docs

## Context

- Docs in the project: !`git ls-files --cached --others --exclude-standard '*.md' 2>&1 | head -40 || true`
- Recent commits: !`git log --oneline -15 2>&1 || true`
- Project files: !`git ls-files --cached --others --exclude-standard 2>&1 | head -150 || true`

User information (may be empty): $ARGUMENTS

## 1. Pick the docs

The file the user named. Otherwise the README, plus the docs that the recent commits make out of date. If many docs could be concerned, ask which ones. If the README doesn't exist yet, offer to create it.

## 2. Start from the current content

Read each doc entirely before changing it. Keep its structure, tone, language and every part that is still right: this is an update, not a rewrite.

## 3. Check every claim against the project

- Commands (install, build, run, test): they must exist in the Makefile, the package.json scripts or the project's scripts.
- Files, folders, paths, ports, environment variables and options: they must exist in the project.
- Lists (features, services, skills, endpoints): compare them with what the project contains. Add what is missing, remove what no longer exists.

Read the files you need for that. For environment variables, read `.env.example`, never `.env` or `secrets/`, and never copy a secret value into a doc.

## 4. Add the user's information

Put the information given after the command in the section where it belongs, in the doc's language and style. If it contradicts the project, say so and ask before writing it.

## 5. Write only what you checked

Edit the docs directly. If something can't be verified (an external URL, a behavior the code doesn't show), keep the existing text and list it in the report. Don't invent features, badges or sections.

## 6. Report

For each doc: what was added, changed and removed, each time with the project file that proves it. Then the points you couldn't verify. Suggest committing with the git-commit skill (type `docs`).
