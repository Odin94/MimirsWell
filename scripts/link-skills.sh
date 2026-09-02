#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <destination> <agent-name>" >&2
  exit 2
fi

destination_root=$1
agent_name=$2
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
repository_root=$(cd "$script_dir/.." && pwd -P)
skills_root="$repository_root/skills"

mkdir -p "$destination_root"

linked_count=0
while IFS= read -r -d '' skill_file; do
  source_dir=$(dirname "$skill_file")
  skill_name=$(basename "$source_dir")
  destination="$destination_root/$skill_name"

  if [[ -L "$destination" ]] && [[ $(readlink "$destination") == "$source_dir" ]]; then
    echo "Already linked $skill_name"
    continue
  fi

  if [[ -e "$destination" || -L "$destination" ]]; then
    echo "Refusing to replace existing destination: $destination" >&2
    exit 1
  fi

  ln -s "$source_dir" "$destination"
  echo "Linked $skill_name for $agent_name"
  linked_count=$((linked_count + 1))
done < <(find "$skills_root" -mindepth 2 -type f -name SKILL.md -print0)

if [[ $linked_count -eq 0 ]]; then
  echo "No new skills linked for $agent_name"
fi
