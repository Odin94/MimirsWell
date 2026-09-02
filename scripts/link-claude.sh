#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
default_config_root=${CLAUDE_CONFIG_DIR:-"${HOME}/.claude"}
destination_root=${1:-"$default_config_root/skills"}

exec "$script_dir/link-skills.sh" "$destination_root" "Claude Code"
