---
name: explain-code
description: Explain a piece of code step by step so the user understands how it works and learns from it. Takes a file, a function or a range of lines given after the command, or the code selected in the editor. Use whenever the user asks to explain code, to walk them through a file or a function, or says they don't understand how some code works.
argument-hint: "[file | function | file:lines]"
---

# Explain code

User request (may be empty): $ARGUMENTS

## 1. Find the code

- A file, a function name or a range of lines (`src/parser.c:40-80`) given above: read it. For a function name, search for its definition in the project.
- Nothing given: use the code selected in the editor.
- Neither: ask the user which code to explain.

Also read the code around it (its callers, the types and functions it uses), so the explanation matches what the code really does in this project.

## 2. Explain it step by step

Explain in the language the user is writing in.

1. Start with one or two sentences: what this code is for and where it fits in the project.
2. Then go through it in order, one step per logical block rather than one per line: quote the few lines of the step, then explain what they do and why they are written this way.
3. Explain each concept the first time it appears (a pointer, a recursion, a callback, a promise...), with a concrete example taken from this code rather than a general definition.
4. Point out the tricky parts: edge cases, memory handling, error paths, and anything that looks surprising.
5. End with a short summary of the whole flow.

Don't change the code: this skill is for understanding, not for fixing. If you notice a bug, mention it at the end and let the user decide what to do.
