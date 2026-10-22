---
name: proofread
description: Fix spelling, grammar and typing mistakes in the project's text (docs, Markdown, code comments, user-facing strings, skill files) by itself, without changing the meaning or the code, then report every fix. Use whenever the user asks to proofread, to fix typos, spelling or grammar, or to clean up the wording of docs or comments.
argument-hint: "[file or folder | all]"
allowed-tools:
  - Bash(git status *)
  - Bash(git diff *)
  - Bash(git ls-files *)
  - Bash(git grep *)
  - Edit
---

# Proofread

## Context

- Changed files: !`git status --short 2>&1 || true`

User request (may be empty): $ARGUMENTS

## 1. Pick the files

- A file or folder given: proofread that.
- `all`: every text file of the project, including new ones not committed yet (`git ls-files --cached --others --exclude-standard`).
- Nothing given: the changed and new files above, since that's where new mistakes are. If there are none, ask what to proofread.

Skip generated and third-party files (lockfiles, `dist/`, `build/`, minified files, vendored libraries) and binary files.

## 2. Fix only real mistakes

Fix spelling, grammar, typos, doubled words and wrong punctuation, in the file's own language (French stays French, English stays English) and with its spelling variant (keep British or American, as the file does).

Don't change:
- code: identifiers, keywords, file paths, commands, URLs, config keys, anything inside backticks or code blocks. Renaming something in the code can break the program.
- the meaning, the tone or the style: proofreading is not rewriting.
- technical terms and intentional spellings, such as tool names or messages quoted from a tool.

In code files, fix only comments and user-facing strings. Before changing a user-facing string, search for it with `git grep`: if a test checks that exact text, fix the test too, or leave both and mention it. In 42 C files, keep every line within 80 columns and never touch the 42 header.

When you're not sure something is a mistake, leave it and list it in the report.

## 3. Fix

Edit the files directly, without asking: every fix shows up in `git diff`.

## 4. Report

A table with one line per fix: file:line, before, after, kind (spelling, grammar, typo, punctuation). Then the doubtful cases you left alone. End with how to review: `git diff` shows every change, and the user can ask you to revert any single fix.
