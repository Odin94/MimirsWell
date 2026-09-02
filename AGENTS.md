# Repository instructions

This repository contains personal, self-written agent skills shared between Codex and Claude Code.

## Git workflow

- Always work directly on `main` in this repository.
- Never create or use another branch in this repository.

## Skill conventions

- Keep skills under `skills/<category>/<skill-name>/`.
- Use lowercase, hyphenated skill directory names and keep each skill self-contained.
- Every skill must include a `SKILL.md` with valid YAML frontmatter.
- Every skill must remain manually invoked. Set `disable-model-invocation: true` in `SKILL.md` for Claude Code and `policy.allow_implicit_invocation: false` in `agents/openai.yaml` for Codex.
- Do not add supporting files unless they directly help the skill do its work.
- Update `README.md` when adding, renaming, or removing a skill or setup script.

## Validation

- Check shell scripts with `bash -n scripts/*.sh`.
- Test link scripts against a temporary directory before changing them.
- Validate skill frontmatter and confirm that every skill has manual-invocation metadata for both supported agents.
