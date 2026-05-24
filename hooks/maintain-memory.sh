#!/usr/bin/env bash
# Cursor hook: stop
# Queues session transcripts for /maintain-memory to process into AGENTS.md.

HOOK_NAME="stop.maintain-memory"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

log_info "starting"
payload="$(cat || true)"
resolve_project_dir "$payload"

conversation_id=$(printf '%s' "$payload" | json_get '.conversation_id' || true)
transcript_path=$(printf '%s' "$payload" | json_get '.transcript_path' || true)
workspace_roots=$(printf '%s' "$payload" | json_get '.workspace_roots[0]' || true)

state_dir="$PROJECT_DIR/hooks/state"
mkdir -p "$state_dir" 2>/dev/null || true
pending_file="$state_dir/maintain-memory-pending.jsonl"

if [[ -n "$transcript_path" && -f "$transcript_path" && -n "$conversation_id" ]]; then
  CONV_ID="$conversation_id" \
  TRANSCRIPT="$transcript_path" \
  WORKSPACE="${workspace_roots:-}" \
  PENDING_FILE="$pending_file" \
  python3 - <<'PY' 2>/dev/null || log_warn "could not queue transcript"
import json, os
from datetime import datetime, timezone

entry = {
    "conversation_id": os.environ["CONV_ID"],
    "transcript_path": os.environ["TRANSCRIPT"],
    "workspace": os.environ.get("WORKSPACE", ""),
    "queued_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
}
with open(os.environ["PENDING_FILE"], "a") as f:
    f.write(json.dumps(entry) + "\n")
PY
  log_info "queued transcript for maintain-memory: $conversation_id"
else
  log_info "no transcript — skipping queue"
fi

if [[ -f "$pending_file" ]] && [[ $(wc -l < "$pending_file" | tr -d ' ') -gt 0 ]]; then
  count=$(wc -l < "$pending_file" | tr -d ' ')
  emit_followup "Maintain-memory: $count session(s) queued. Run /maintain-memory to update AGENTS.md."
else
  printf '{}\n'
fi

log_info "done"
