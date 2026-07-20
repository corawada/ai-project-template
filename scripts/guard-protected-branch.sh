#!/usr/bin/env bash
set -euo pipefail

branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
protected=false
case "$branch" in
  main|master|develop|release/*) protected=true ;;
esac

if [[ "$protected" == true ]]; then
  cat >&2 <<MESSAGE
ERROR: '$branch' is a protected branch for AI-assisted work.
Create a task branch first, for example:
  git switch -c feat/<issue>-<short-description>
No commit or push was performed.
MESSAGE
  exit 1
fi
