---
name: create-docs
description: Write a new documentation file (guide, architecture, how-to, setup, API notes) from the information the user gives after the command, completed and checked against the project's files. Use whenever the user asks to create, write or add a new doc, guide or documentation page about something in the project. To change a doc that already exists, use the update-docs skill instead.
argument-hint: "<topic> [information to include]"
allowed-tools:
  - Bash(git ls-files *)
  - Bash(git log *)
  - Write
  - Edit
---

# Create docs

## Context

- Existing docs: !`git ls-files --cached --others --exclude-standard '*.md' 2>&1 | head -40 || true`
- Project files: !`git ls-files --cached --others --exclude-standard 2>&1 | head -150 || true`

User request and information: $ARGUMENTS

## 1. Understand what to write

Find the topic, the reader (a developer of the project, a user, a 42 evaluator) and what the doc must let them do. If the request is too vague to know that, ask one or two short questions first.

If a doc about this topic already exists, don't create a second one: tell the user and use the update-docs skill instead.

## 2. Choose where it goes

Follow the project's convention: if there is a `docs/` folder, put it there, otherwise create `docs/`. Name the file after the topic in kebab-case (`docs/local-setup.md`). If the project has no README at all, write the README first.

## 3. Gather the content

- The user's information is the core of the doc: keep all of it.
- Complete it with what the project shows about the topic: read the relevant files (code, Makefile, package.json, Docker files, configs).
- Check every command, path, port and option against the project. If the user's information contradicts the project, say so and ask before writing it.
- For environment variables, read `.env.example`, never `.env` or `secrets/`, and never copy a secret value.

## 4. Write it

- Language: the one of the project's other docs, otherwise English.
- Start with a title and one or two sentences: what the doc covers and for whom.
- Then short sections in the order the reader needs them, with copyable commands in code blocks.
- For an architecture or a flow, add a Mermaid diagram (GitHub renders it) that shows only real parts of the project.
- No filler: no section without content, no invented feature.

## 5. Make it findable

If the README has a docs section or a list of docs, add a link to the new file there.

## 6. Report

The file created and its outline, the sources used (the user's information, and each project file you relied on), and the points you couldn't verify. Suggest committing with the git-commit skill (type `docs`).
