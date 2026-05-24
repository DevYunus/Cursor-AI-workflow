#!/usr/bin/env bash
# Cursor hook: sessionStart
# Emits scout-doc index and broken @-ref warnings for the active project harness.

HOOK_NAME="sessionStart"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

log_info "starting"
payload="$(cat || true)"
log_info "payload bytes: ${#payload}"
resolve_project_dir "$payload"

build_context() {
  printf '# Cursor Workflow — session context\n\n'

  if [[ -d "$PROJECT_DIR/docs" ]]; then
    printf '## Reference docs (load via @.cursor/docs/<path>)\n'
    find "$PROJECT_DIR/docs" -type f -name '*.md' 2>/dev/null | sort | while read -r f; do
      rel="${f#$PROJECT_DIR/}"
      printf -- '- .cursor/%s\n' "$rel"
    done
    printf '\n'
  fi

  if [[ -f "$PROJECT_DIR/memory/_stale-flags.md" ]] && grep -q '^## ' "$PROJECT_DIR/memory/_stale-flags.md" 2>/dev/null; then
    printf '## Open stale flags\n'
    grep '^## ' "$PROJECT_DIR/memory/_stale-flags.md" | head -5
    printf '_See .cursor/memory/_stale-flags.md for details._\n\n'
  fi

  local broken_refs=""
  if [[ -d "$PROJECT_DIR/rules" ]]; then
    while IFS= read -r line; do
      local ref
      ref=$(printf '%s' "$line" | grep -oE '@\.cursor/[^ )\\]+\.md' | head -1)
      [[ -z "$ref" ]] && continue
      local target="$PROJECT_DIR/${ref#@.cursor/}"
      if [[ ! -f "$target" ]]; then
        broken_refs+="- $ref (missing)\n"
      fi
    done < <(grep -rh '^@\.cursor/' "$PROJECT_DIR/rules" 2>/dev/null || true)
  fi

  if [[ -n "$broken_refs" ]]; then
    printf '## WARNING: broken @-refs in rules\n'
    printf '%b' "$broken_refs"
    printf '\n'
  fi

  printf '## Slash skills (type /name in chat)\n'
  printf '/prime · /grill · /plan · /execute · /eval · /review · /handoff · /memory-update · /maintain-memory\n\n'
  printf '## Always loaded\n'
  printf -- '- `.cursor/rules/000-project-context.mdc`\n'
  printf -- '- `AGENTS.md` in your app repo (maintained by /maintain-memory)\n'
}

context="$(build_context 2>/dev/null || printf 'Workflow context build failed — see ~/.cursor/logs/hooks-*.log\n')"
emit_context "$context"
log_info "done"
