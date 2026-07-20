#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <issue-number> <kebab-case-name>" >&2
  exit 2
}

[[ $# -eq 2 ]] || usage
issue="$1"
name="$2"
[[ "$issue" =~ ^[1-9][0-9]*$ ]] || { echo "Issue number must be a positive integer." >&2; exit 2; }
[[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Name must be lowercase kebab-case." >&2; exit 2; }

root="$(git rev-parse --show-toplevel)"
templates="$root/.kiro/settings/templates/specs"
destination="$root/.kiro/specs/$issue-$name"
[[ ! -e "$destination" ]] || { echo "Spec already exists: $destination" >&2; exit 1; }

mkdir "$destination"
for document in requirements.md design.md tasks.md; do
  cp "$templates/$document" "$destination/$document"
done

printf 'Created %s\nReview and approve requirements.md before writing the design.\n' "$destination"
