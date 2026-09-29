---
name: review
description: Independently review completed changes with a fresh subagent, validate findings, fix issues, address PR comments, and merge when CI is green. Use only when explicitly invoked.
disable-model-invocation: true
---

# Review

When implementation is done, have a fresh subagent independently review the changes against the original prompt, agreed goals, and any later requirements.

Give it access to the diff, relevant code, tests, and repository instructions. Start it without inherited implementation discussion, and do not provide the main agent's implementation rationale or prior conclusions. Ask for actionable findings with concrete evidence and file locations.

In the main thread, validate each finding against the requirements and code. Implement justified fixes, and explain any rejected findings with evidence. Run the checks appropriate to the changes and have the reviewer inspect fixes where needed.

Address PR comments by validating them and implementing justified fixes. Follow the repository's PR and merge workflow and the user's existing authorization. Merge when required CI is green and required approvals are satisfied. If CI fails, fix the failure and rerun the relevant checks before merging. Report any unresolved findings or merge blockers.
