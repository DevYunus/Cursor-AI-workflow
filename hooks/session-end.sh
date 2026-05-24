#!/usr/bin/env bash
# Cursor hook: sessionEnd
# Appends session metadata to memory/sessions/YYYY-MM-DD.md

HOOK_NAME="sessionEnd"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

log_info "starting"
payload="$(cat || true)"
resolve_project_dir "$payload"

conversation_id=$(printf '%s' "$payload" | json_get '.conversation_id' || true)
workspace_roots=$(printf '%s' "$payload" | json_get '.workspace_roots[0]' || true)
duration_ms=$(printf '%s' "$payload" | json_get '.duration_ms' || true)
transcript_path=$(printf '%s' "$payload" | json_get '.transcript_path' || true)

sessions_dir="$PROJECT_DIR/memory/sessions"
mkdir -p "$sessions_dir" 2>/dev/null || true

today="$(date +%Y-%m-%d)"
session_file="$sessions_dir/$today.md"

if [[ ! -f "$session_file" ]]; then
  {
    printf '# Sessions — %s\n\n' "$today"
    printf '_Auto-appended by sessionEnd hook._\n\n'
  } > "$session_file"
fi

{
  printf '## %s — %s\n' "$(date +%H:%M)" "${conversation_id:-unknown}"
  [[ -n "$workspace_roots" ]] && printf -- '- **Workspace:** %s\n' "$workspace_roots"
  [[ -n "$duration_ms" ]] && printf -- '- **Duration:** %s ms\n' "$duration_ms"
  [[ -n "$transcript_path" ]] && printf -- '- **Transcript:** `%s`\n' "$transcript_path"
  printf '\n'
} >> "$session_file" 2>/dev/null || log_warn "could not write to $session_file"

log_info "appended to $session_file"
printf '{}\n'
