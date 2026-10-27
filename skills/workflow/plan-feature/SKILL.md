---
name: plan-feature
description: Turn a feature idea into an agreed design and a step-by-step implementation plan before any code is written. Asks about the real goal, explores the code, proposes approaches with their trade-offs, then writes small verifiable steps. Use whenever the user wants to add or design a feature bigger than a quick fix, says "I want to add" or "how should I build", or asks for a plan before coding.
argument-hint: "<feature idea>"
---

# Plan a feature

Feature idea (may be empty): $ARGUMENTS

Don't write code in this skill. A plan is cheap to change, while code built on a misunderstood goal has to be thrown away.

## 1. Understand the goal

Ask questions until you know what the feature is for, who uses it, what "done" looks like and what is out of scope. Ask one question at a time, with choices when possible, starting with the most important unknown. Stop asking when the answers stop changing the design.

## 2. Explore the project

Read the parts of the code the feature touches: where it plugs in, the existing patterns to follow (structure, naming, error handling, tests), and what could break. For a 42 project, also check the subject's constraints: allowed functions, the norm, the files to hand in.

## 3. Propose approaches

Present two or three approaches, each with its trade-offs (effort, risk, what it makes easy or hard later), and recommend one with the reason. Wait for the user's choice.

## 4. Write the plan

Write steps small enough to be done and verified in a few minutes each, in order. For each step:
- what to do, and the files to create or change;
- how to verify it: a test to write first, a command to run, or a behavior to check.

Then add the risks, the open questions, and what is out of scope.

Save the plan as `docs/plans/<feature>.md` if the project has a `docs/` folder or the user agrees. For a 42 project, ask first, because the subject may forbid extra files. Otherwise, show it in the conversation only.

## 5. Hand over

Show the plan and ask for approval or changes. Once it's approved, offer to create a branch with the git-branch skill, then to start step 1, test first, with the tdd skill.
