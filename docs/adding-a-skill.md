# Adding a skill

1. Create `skills/<category>/<skill-name>/SKILL.md`. Use a lowercase, hyphenated name.
2. Add `disable-model-invocation: true` to the `SKILL.md` frontmatter so Claude Code cannot select the skill automatically.
3. Add `agents/openai.yaml` with `policy.allow_implicit_invocation: false` so Codex cannot select the skill automatically.
4. Keep the instructions focused. Add `scripts/`, `references/`, or `assets/` inside the skill only when they are needed.
5. Run the repository validation commands documented in `AGENTS.md`, then rerun the appropriate link script.

The link scripts discover skills by finding `SKILL.md` files below `skills/`, so no registry needs to be maintained. Skill names must be unique across categories because they share a flat installation directory.

