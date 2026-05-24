#!/usr/bin/env bash
# Shared utilities for Cursor hooks.
# Source: source "$SCRIPT_DIR/lib/common.sh" at the top of each hook script.

set -uo pipefail

# Workflow root — the central repo in symlink mode, or the app's .cursor
# directory in direct-copy mode.
if [[ -z "${WORKFLOW_ROOT:-}" ]]; then
  WORKFLOW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi
export WORKFLOW_ROOT

HOOK_LOG_DIR="$HOME/.cursor/logs"
export HOOK_LOG_DIR

_log() {
  local level="$1"
  shift
  local msg="$*"
  local ts
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  mkdir -p "$HOOK_LOG_DIR" 2>/dev/null || true
  printf '[%s] [%s] [%s] %s\n' "$ts" "$level" "${HOOK_NAME:-unknown}" "$msg" >> "$HOOK_LOG_DIR/hooks-$(date +%Y-%m-%d).log" 2>/dev/null || true
}

log_info() { _log INFO "$@"; }
log_warn() { _log WARN "$@"; }
log_error() { _log ERROR "$@"; }

json_get() {
  local path="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -r "$path // empty" 2>/dev/null || true
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c '
import json, re, sys
expr = sys.argv[1]
try:
    data = json.load(sys.stdin)
    tokens = re.findall(r"\.([A-Za-z0-9_-]+)|\[(\d+)\]", expr)
    for key, index in tokens:
        data = data[int(index)] if index else data[key]
    if data is not None:
        print(data)
except (json.JSONDecodeError, KeyError, IndexError, TypeError, ValueError):
    pass
' "$path"
  fi
}

default_project_dir() {
  if [[ -n "${PROJECT_DIR:-}" ]]; then
    printf '%s\n' "$PROJECT_DIR"
  elif [[ -n "${PROJECT:-}" && -d "$WORKFLOW_ROOT/projects/$PROJECT" ]]; then
    printf '%s\n' "$WORKFLOW_ROOT/projects/$PROJECT"
  elif [[ -d "$WORKFLOW_ROOT/projects/example" ]]; then
    printf '%s\n' "$WORKFLOW_ROOT/projects/example"
  elif [[ -d "$WORKFLOW_ROOT/skills" || -d "$WORKFLOW_ROOT/rules" ]]; then
    printf '%s\n' "$WORKFLOW_ROOT"
  else
    printf '%s\n' "$WORKFLOW_ROOT/projects/example"
  fi
}

# Active project harness directory. In symlink mode this resolves
# <app>/.cursor to cursor-workflow/projects/<project>; in direct-copy mode it
# resolves to the app repo's real .cursor directory.
PROJECT_DIR="$(default_project_dir)"
export PROJECT_DIR

payload_cwd() {
  local payload="$1"
  local candidate
  for candidate in \
    "$(printf '%s' "$payload" | json_get '.cwd' || true)" \
    "$(printf '%s' "$payload" | json_get '.working_directory' || true)" \
    "$(printf '%s' "$payload" | json_get '.workspace_roots[0]' || true)" \
    "${PWD:-}"; do
    [[ -n "$candidate" && -d "$candidate" ]] || continue
    printf '%s\n' "$candidate"
    return 0
  done
  printf '%s\n' "${PWD:-/}"
}

resolve_project_dir() {
  local payload="$1"
  local root
  root="$(payload_cwd "$payload")"

  if [[ -d "$root/.cursor" ]]; then
    PROJECT_DIR="$(cd "$root/.cursor" && pwd -P)"
  else
    PROJECT_DIR="$(default_project_dir)"
  fi
  export PROJECT_DIR
}

emit_allow() {
  printf '{"permission": "allow"}\n'
}

emit_deny() {
  local reason="$1"
  local escaped
  escaped=$(printf '%s' "$reason" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read())[1:-1])' 2>/dev/null || printf '%s' "$reason" | sed 's/"/\\"/g')
  printf '{"permission": "deny", "user_message": "%s", "agent_message": "%s"}\n' "$escaped" "$escaped"
}

emit_context() {
  local ctx="$1"
  local escaped
  escaped=$(printf '%s' "$ctx" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read())[1:-1])' 2>/dev/null || printf '%s' "$ctx" | sed 's/"/\\"/g')
  printf '{"additional_context": "%s"}\n' "$escaped"
}

emit_followup() {
  local msg="$1"
  local escaped
  escaped=$(printf '%s' "$msg" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read())[1:-1])' 2>/dev/null || printf '%s' "$msg" | sed 's/"/\\"/g')
  printf '{"followup_message": "%s"}\n' "$escaped"
}
