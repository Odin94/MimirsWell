---
name: review
description: Independently review completed changes with a fresh subagent, validate findings, fix issues, address PR comments, and merge when CI is green. Use only when explicitly invoked.
disable-model-invocation: true
---

# Review

When implementation is done, have a fresh Sol 6.2 High (or later equivalent) subagent independently review the changes against the original prompt, agreed goals, and any later requirements.

Give it access to the diff, relevant code, tests, and repository instructions. Start it without inherited implementation discussion, and do not provide the main agent's implementation rationale or prior conclusions. Ask for actionable findings with concrete evidence and file locations.

In the main thread, validate each finding against the requirements and code. Implement justified fixes, and explain any rejected findings with evidence. Run the checks appropriate to the changes and have the reviewer inspect fixes where needed.

Address PR comments by validating them and implementing justified fixes. Follow the repository's PR and merge workflow and the user's existing authorization (if this is a repo where usually changes are pushed to main rather than going through branches & CI, just validate locally and push to main). 
If there is a repository, merge when required CI is green and required approvals are satisfied. If CI fails, fix the failure and rerun the relevant checks before merging. Report any unresolved findings or merge blockers. If there is no repository or no CI pipeline, just run tests and validation locally.

Follow the deployment triggered by pushing/merging if there is one, and if it breaks in a way that has a straightforward fix, fix it and rerun the deployment with the fix.

Open the PR after review/fixup is done checks pass locally
