---
name: bugfix
description:
  Investigate and reproduce a bug, identify its root cause, implement and
  independently review a fix, validate it, and open a PR.
disable-model-invocation: true
---

# Bugfix

1. Gather relevant information from logs, database, and metrics.
2. Validate that this is a real bug, reproduce it locally, and save the output.
   - If you cannot reproduce the bug, do not guess at a possible fix. Instead,
     try what you reasonably can do to reproduce and if it doesn't work, report
     back that you couldn't reproduce and include a concise summary of what you
     tried to reproduce the bug.
3. Find the root cause. Add temporary local logging or metrics when needed. When
   the cause is unclear, name the plausible causes and run the quickest probe
   that distinguishes them. Confirm the cause before editing.
4. Implement a fix for the bug. When the bug has a cheap local test path, add
   the regression test first. Stage the commits so the failing repro lands
   before the fix in git history.
5. Rerun the same repro after the fix. Include the before and after output in
   the review brief and PR.
6. Have a fresh subagent independently review the changes against the original
   prompt, logs/analytics, agreed goals, and any later requirements. Give it
   access to the diff, relevant code, tests, and repository instructions,
   without the main agent's implementation rationale. Start it without inherited
   implementation discussion. Apply justified fixes and rerun the repro if they
   change behavior.
7. Open a PR with your fix.

If the bug is tracked in Notion or a similar tool, update the ticket status as
you work. When done, add a brief explanation of what caused the bug and how you
fixed it, if you have the required access to that tool.
