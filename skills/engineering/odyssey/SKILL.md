---
name: odyssey
description: Create multiple plan files that track progress for large changes towards a shared goal when explicitly requested.
disable-model-invocation: true
---

# Odyssey

Invoke manually with `$odyssey` in Codex or `/odyssey` in Claude Code.

Create a new folder for the user's planned changes, following the repository's documentation conventions. Give it a descriptive name and keep all planning context there so fresh implementation threads can work without the planning conversation.

The folder contains:

- `goal.md`: The overall goal and north star. Every thread working on a task must read it and orient its work towards that goal. Define it at the beginning, refine it during planning, and rarely update it during implementation, only when new insights justify a change.
- `glossary.md`: Shared vocabulary with precise meanings across threads. Evolve it continuously during planning and implementation.
- Numbered Markdown task files: The work needed to reach the goal, with progress recorded in each file.
- `AGENTS.md`: Instructions for implementation threads, added when defining the task order.

## Step 1 — Fill `goal.md`

Use the overall goal in the prompt that invoked this skill. If it is missing, ask the user to describe it before planning tasks.

Capture the product area being changed, the intended end state, and the core value of the change. Include stakeholders and how they should be affected when provided. Keep the goal concise and distinguish confirmed decisions from open questions.

## Step 2 — Make the goal concrete and create task files

Inspect the existing code, features, routes, permissions, domain concepts, and relevant repository documentation. Use what you find to inform questions and recommendations; record relevant code paths and existing behavior in the task files.

Ask questions in sets of three, with a concrete recommendation for each. Wait for the user's answers before the next set and update the files as decisions are made. Cover details such as who can access a feature, how a page is reached, expected behavior, and surrounding constraints. Include critical questions that challenge assumptions and clarify scope. Ask the user to differentiate similar domain terms rather than treating them as synonyms.

As understanding develops:

- Refine `goal.md` with decisions that matter to the north star. Put task-specific details in task files.
- Update `glossary.md` with domain concepts, distinctions, and agreed meanings.
- Create task files for coherent subtasks. Together, they must cover everything needed to reach the goal.
- Persist decisions, rationale, constraints, unresolved questions, and relevant context in the files, including information supplied in answers. Fresh threads must not need the planning conversation.

Each task should cover at least the detail of a user story, even if it is not yet an implementation-ready plan. Include:

- The task's purpose and contribution to the overall goal.
- The affected user or stakeholder and their intended outcome.
- Scope, expected behavior, entry points, access rules, and relevant edge cases.
- Existing code and features that inform the work, and any constraints.
- Acceptance criteria and how completion can be verified.
- Dependencies, open questions, and a progress/status section.
- A place to link relevant pull requests.

Move to step 3 once you have a strong understanding of the concrete goal, the tasks needed to reach it, and the surrounding constraints and context, or when the user explicitly asks. Carry any unresolved questions into the files rather than treating them as settled.

## Step 3 — Define the order and hand off

Discuss the order with the user and recommend which tasks should run sequentially and which can run in parallel. Consider dependencies and overlapping changes in the existing code. Record the agreed dependencies in the task files as well as their filenames.

Use the leading number as an execution stage. Tasks with the same number can run in parallel; later stages wait for the earlier stages to finish. For example, `1_add_dashboard.md` and `1_add_new_role.md` can run in parallel, while `2_add_dashboard_api.md` follows both. Use enough zero padding to keep filenames sorted when there are many stages.

Add an `AGENTS.md` in the planning folder that instructs implementation threads to:

- Read `goal.md`, `glossary.md`, and the selected task before starting. Orient work towards the goal and keep shared terminology consistent.
- Follow the execution stages in task filenames and the documented dependencies. Check completed work in `done/` before starting a dependent task.
- Pick up only one task at a time. Mark it in progress in its task file so other threads can see it is being handled, and keep progress and blockers current.
- Update `glossary.md` as domain understanding evolves. Change `goal.md` only when a new insight warrants revising the north star, and record the reason.
- Record relevant PR links and completion evidence in each task file. Move completed tasks into a `done/` subfolder, preserving their filenames and history.
- Create new task files for follow-up work discovered during implementation that falls outside the current task. Record why the work is needed and its dependencies, assign an appropriate stage, and keep the current thread focused on its selected task.

When every task has an agreed order, tell the user planning is complete. Link the planning folder and the first available tasks, and explain that they can start implementation in a fresh thread by pointing it at one task file. For example: “Implement the task in `<planning-folder>/1_add_dashboard.md`; read the folder's `AGENTS.md`, `goal.md`, and `glossary.md` first.”
