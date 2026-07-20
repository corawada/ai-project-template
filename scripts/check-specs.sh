#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
spec_root="$root/.kiro/specs"
failed=false
shopt -s nullglob

for directory in "$spec_root"/*/; do
  name="$(basename "$directory")"
  if [[ ! "$name" =~ ^[1-9][0-9]*-[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "Invalid spec directory name: .kiro/specs/$name" >&2
    failed=true
  fi

  for document in requirements.md design.md tasks.md; do
    if [[ ! -s "$directory/$document" ]]; then
      echo "Missing spec document: .kiro/specs/$name/$document" >&2
      failed=true
    fi
  done

done

[[ "$failed" == false ]] || exit 1
echo "Specification structure is valid."
