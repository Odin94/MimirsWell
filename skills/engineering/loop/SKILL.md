---
name: loop
description:
  Implement, verify, and iterate through a bounded subagent review. Use only
  when explicitly invoked.
disable-model-invocation: true
---

# Loop

## 1. Build and verify

Pin the diff base. State the requested behavior and what would prove it works.
Implement the smallest change that meets the request and run that check through
the affected interface. For bugs, run the same repro before and after the fix
when practical. Record missing checks and pre-existing failures.

## 2. Review

Start one fresh, read-only subagent per round. Give it the requirements, the
scoped patch including uncommitted files, repo rules, and check results. Leave
out the builder's rationale. Keep the patch stable during review and note which
patch the verdict covers.

- **Spec.** Look for missing, wrong, or unrequested behavior.
- **Standards.** Look for repo rule violations and maintainability problems with
  a concrete consequence.

Ask for a verdict and findings with severity, file and line, and impact. Prefer
a runnable repro with expected and actual results. A code trace or cited
requirement can establish a finding too. Label unverified concerns.

## 3. Fix and stop

Validate findings in the main thread. Make the smallest justified fixes and
rerun the relevant checks. Keep a short ledger of what was fixed, disputed, or
deferred and why.

Use up to three rounds by default. Review the whole scoped patch first, then
check changed behavior and open findings. Nits alone need no further round. When
a material finding stays disputed, use a reviewer from another provider for the
next round if available.

Finish when required checks pass on the current patch and review covers its
behavior with no material findings open. If review or verification is blocked,
or the budget runs out with work open, report what remains and the evidence.
