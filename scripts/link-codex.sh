#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
default_config_root=${CODEX_HOME:-"${HOME}/.codex"}
destination_root=${1:-"$default_config_root/skills"}

exec "$script_dir/link-skills.sh" "$destination_root" "Codex"
