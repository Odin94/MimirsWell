# Mimir's Well

A personal collection of self-written skills for Codex and Claude Code.

## Layout

```text
.
├── docs/                  Repository documentation
├── scripts/               Skill-linking helpers
└── skills/
    └── engineering/
        ├── be-stack/
        ├── design/
        └── fe-stack/
```

All skills are manual-only. Invoke them explicitly as `$fe-stack`, `$be-stack`, or `$design` in Codex, and `/fe-stack`, `/be-stack`, or `/design` in Claude Code.

## Link the skills

The scripts create symbolic links and are safe to run repeatedly. They refuse to replace an existing file or a link to a different source.

```bash
./scripts/link-codex.sh
./scripts/link-claude.sh
```

By default, Codex skills are linked into `${CODEX_HOME:-$HOME/.codex}/skills` and Claude Code skills into `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills`. Pass a directory as the first argument to either script to use a custom destination:

```bash
./scripts/link-codex.sh /path/to/codex/skills
./scripts/link-claude.sh /path/to/claude/skills
```

See [Adding a skill](docs/adding-a-skill.md) for the repository conventions.

