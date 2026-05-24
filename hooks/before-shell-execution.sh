#!/usr/bin/env bash
# Cursor hook: beforeShellExecution (matcher: "git commit")
# Requires a Context: section in commit messages inside the workflow repo.

HOOK_NAME="beforeShellExecution.git-commit"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

is_enforced_repo() {
  local repo="$1"
  [[ "$repo" == "$WORKFLOW_ROOT" ]]
}

commit_msg_has_context() {
  check_has_context "$1"
}

check_has_context() {
  local msg="$1"
  if ! printf '%s' "$msg" | grep -qiE '(^|[^[:alnum:]_-])Context:[[:space:]]*$'; then
    return 1
  fi
  printf '%s' "$msg" | python3 -c '
import re, sys
text = sys.stdin.read()
m = re.search(r"(^|[^A-Za-z0-9_\-])Context:[ \t]*$", text, re.IGNORECASE | re.MULTILINE)
if not m:
    sys.exit(1)
for line in text[m.end():].splitlines():
    s = line.strip()
    if not s:
        continue
    if re.match(r"^[-*]\s+\S", s):
        sys.exit(0)
    break
sys.exit(1)
' 2>/dev/null
}

payload="$(cat || true)"
command_str=$(printf '%s' "$payload" | json_get '.command' || true)
log_info "command: ${command_str:0:200}"

if ! printf '%s' "$command_str" | grep -qE '(^|[[:space:]])git[[:space:]]+commit([[:space:]]|$)'; then
  emit_allow
  exit 0
fi

if printf '%s' "$command_str" | grep -qE 'git[[:space:]]+commit[[:space:]]+(--help|-h|--version)'; then
  emit_allow
  exit 0
fi

repo_root=""
if command -v git >/dev/null 2>&1; then
  repo_root=$(git -C "$(payload_cwd "$payload")" rev-parse --show-toplevel 2>/dev/null || true)
fi

if [[ -z "$repo_root" ]] || ! is_enforced_repo "$repo_root"; then
  emit_allow
  exit 0
fi

staged_files=$(git -C "$repo_root" diff --cached --name-only 2>/dev/null || true)
if [[ -z "$staged_files" ]]; then
  emit_allow
  exit 0
fi

if check_has_context "$command_str"; then
  emit_allow
  exit 0
fi

file_arg=$(printf '%s' "$command_str" | grep -oE -- '-F[[:space:]]+\S+|--file=\S+' | head -1 || true)
if [[ -n "$file_arg" ]]; then
  fpath=$(printf '%s' "$file_arg" | sed -E 's/^-F[[:space:]]+//; s/^--file=//')
  if [[ -f "$fpath" ]] && check_has_context "$(cat "$fpath" 2>/dev/null || true)"; then
    emit_allow
    exit 0
  fi
fi

if printf '%s' "$command_str" | grep -q -- '--amend' \
   && ! printf '%s' "$command_str" | grep -qE -- '-m[[:space:]]|-F[[:space:]]|--file='; then
  head_msg=$(git -C "$repo_root" log -1 --format=%B 2>/dev/null || true)
  if check_has_context "$head_msg"; then
    emit_allow
    exit 0
  fi
fi

if ! printf '%s' "$command_str" | grep -qE -- '-m[[:space:]]|-F[[:space:]]|--file=|--amend'; then
  emit_allow
  exit 0
fi

reason=$(cat <<EOF
Commit denied in cursor-workflow: staged files need a Context: section with at least one bullet.

  chore: short subject

  Context:
  - projects/example/skills/grill/SKILL.md: clarified exit criteria

Other repos are unaffected — this hook only runs in the workflow repo itself.
EOF
)

emit_deny "$reason"
exit 0
