#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

echo "==> Checking whitespace errors"
git diff --check

echo "==> Validating shell syntax"
while IFS= read -r -d '' file; do
  bash -n "$file"
done < <(find scripts .githooks -type f -name '*.sh' -print0)

echo "==> Checking required governance files"
required=(
  AGENTS.md CLAUDE.md .github/CODEOWNERS
  .github/pull_request_template.md .github/workflows/quality.yml
)
for file in "${required[@]}"; do
  [[ -s "$file" ]] || { echo "Missing required file: $file" >&2; exit 1; }
done

if command -v ruby >/dev/null 2>&1; then
  echo "==> Validating YAML syntax"
  while IFS= read -r -d '' file; do
    ruby -e 'require "yaml"; YAML.load_file(ARGV.fetch(0), aliases: true)' "$file"
  done < <(find .github -type f \( -name '*.yml' -o -name '*.yaml' \) -print0)
else
  echo "WARN: Ruby not found; YAML syntax validation skipped" >&2
fi

# Add project-specific formatter, lint, typecheck, unit tests, and build below.
echo "All checks passed."
