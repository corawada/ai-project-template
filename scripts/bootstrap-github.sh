#!/usr/bin/env bash
set -euo pipefail

command -v gh >/dev/null || { echo "GitHub CLI (gh) is required." >&2; exit 1; }
gh auth status >/dev/null
repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"

create_label() {
  gh label create "$1" --repo "$repo" --color "$2" --description "$3" --force
}
create_label "type: feature" "1D76DB" "New functionality"
create_label "type: bug" "D73A4A" "Something is not working"
create_label "type: maintenance" "6F42C1" "Maintenance and refactoring"
create_label "status: triage" "FBCA04" "Needs prioritization"
create_label "ai-assisted" "BFDADC" "AI contributed to this change"
create_label "ai-review-required" "D4C5F9" "Human review of generated changes required"
create_label "breaking-change" "B60205" "Requires migration or breaks compatibility"
create_label "dependencies" "0366D6" "Dependency update"

echo "Setting default GitHub Actions permissions to read-only..."
gh api --method PUT "repos/$repo/actions/permissions/workflow" \
  -f default_workflow_permissions=read \
  -F can_approve_pull_request_reviews=false

ruleset_file="$(mktemp)"
trap 'rm -f "$ruleset_file"' EXIT
cat > "$ruleset_file" <<'JSON'
{
  "name": "Protect main from direct and destructive changes",
  "target": "branch",
  "enforcement": "active",
  "conditions": {"ref_name": {"include": ["refs/heads/main"], "exclude": []}},
  "rules": [
    {"type": "deletion"},
    {"type": "non_fast_forward"},
    {"type": "pull_request", "parameters": {
      "dismiss_stale_reviews_on_push": true,
      "require_code_owner_review": false,
      "require_last_push_approval": true,
      "required_approving_review_count": 1,
      "required_review_thread_resolution": true,
      "allowed_merge_methods": ["squash"]
    }},
    {"type": "required_status_checks", "parameters": {
      "strict_required_status_checks_policy": true,
      "do_not_enforce_on_create": true,
      "required_status_checks": [{"context": "repository checks"}]
    }}
  ],
  "bypass_actors": []
}
JSON

if gh api "repos/$repo/rulesets" --jq '.[].name' | grep -Fxq "Protect main from direct and destructive changes"; then
  echo "Ruleset already exists; leaving it unchanged. Review it in repository settings."
else
  gh api --method POST "repos/$repo/rulesets" --input "$ruleset_file" >/dev/null
  echo "Created active main branch ruleset."
fi

echo "GitHub bootstrap complete for $repo."
echo "Next: replace @YOUR_GITHUB_ID in .github/CODEOWNERS and review Settings > Rules > Rulesets."
