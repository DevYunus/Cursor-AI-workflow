#!/usr/bin/env bash
# Cursor hook: afterShellExecution (matcher: "git commit")
# No-op placeholder — extend if you sync memory to external tools.

HOOK_NAME="afterShellExecution.git-commit"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

payload="$(cat || true)"
exit_code=$(printf '%s' "$payload" | json_get '.exit_code' || true)

if [[ "$exit_code" != "0" && -n "$exit_code" ]]; then
  log_info "commit exit=$exit_code — skip"
fi

printf '{}\n'
