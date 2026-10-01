---
name: bugfix
description: Investigate and reproduce a bug, identify its root cause, implement and independently review a fix, validate it, and open a PR. Use only when explicitly invoked.
disable-model-invocation: true
---

# Bugfix

1. Gather relevant information from logs, database, and metrics.
2. Validate that this is a real bug and reproduce it locally.
3. When you can cleanly reproduce it, find the root cause; add temporary local logging and metrics to help if needed.
4. Implement a fix for the bug.
5. Have a fresh subagent independently review the changes against the original prompt, logs/analytics, agreed goals, and any later requirements. Give it access to the diff, relevant code, tests, and repository instructions, without the main agent's implementation rationale. Start it without inherited implementation discussion.
6. Run the steps that reproduced the bug earlier to validate that it is fixed.
7. Open a PR with your fix.

If the bug is tracked in Notion or a similar tool, update the ticket status as you work. When done, add a brief explanation of what caused the bug and how you fixed it, if you have the required access to that tool.
