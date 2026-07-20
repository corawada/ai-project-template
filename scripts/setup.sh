#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
cd "$root"
git config --local core.hooksPath .githooks
git config --local pull.ff only
chmod +x scripts/*.sh .githooks/*
printf '%s\n' \
  "Local safety hooks enabled." \
  "Protected branches: main, master, develop, release/*" \
  "Create a work branch before committing."
