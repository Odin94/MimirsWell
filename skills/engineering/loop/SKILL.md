---
name: loop
description: Iterate implementation and subagent review until no actionable feedback remains. Use only when explicitly invoked.
disable-model-invocation: true
---

# Loop

For implementation, run this loop:

1. Implement the requested changes against the original prompt, agreed goals, and any later requirements.
2. Spin up a fresh review subagent to inspect the current changes. Give it the requirements, diff, relevant code, tests, and repository instructions. Ask for actionable findings with concrete evidence.
3. In the main thread, validate the findings and implement justified suggestions. Run the checks appropriate to the fixes. If a suggestion is unjustified, record why instead of applying it blindly.
4. Repeat the review and implementation cycle on the updated changes until the review subagent provides no more actionable feedback. Resolve disputed findings with evidence; do not count dismissing feedback as a clean review.

If review or a required fix is blocked, report the blocker and remaining findings rather than claiming the loop is complete.
