#!/usr/bin/env bash
# Smoke test both install modes against throwaway non-app projects.

set -euo pipefail

WORKFLOW_ROOT="${WORKFLOW_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SMOKE_ROOT="${SMOKE_ROOT:-${TMPDIR:-/tmp}}"
RUN_ROOT="$(mktemp -d "$SMOKE_ROOT/cursor-workflow-smoke.XXXXXX")"
FAKE_HOME="$RUN_ROOT/home"
SYMLINK_APP="$RUN_ROOT/workflow-smoke-test"
COPY_APP="$RUN_ROOT/workflow-copy-smoke-test"
SAMPLE_APP="$WORKFLOW_ROOT/sample/tiny-contact-app"
FLAGSHIP_SAMPLE_APP="$WORKFLOW_ROOT/sample/project-tasks-app"

pass() { printf 'ok - %s\n' "$1"; }
fail() { printf 'not ok - %s\n' "$1" >&2; exit 1; }
assert_file() { [[ -f "$1" ]] || fail "missing file: $1"; }
assert_dir() { [[ -d "$1" ]] || fail "missing dir: $1"; }
assert_symlink() { [[ -L "$1" ]] || fail "missing symlink: $1"; }
assert_not_symlink() { [[ ! -L "$1" ]] || fail "unexpected symlink: $1"; }
assert_contains() {
  local needle="$1" file="$2"
  grep -qxF "$needle" "$file" 2>/dev/null || fail "expected '$needle' in $file"
}

make_tiny_app() {
  local app="$1"
  mkdir -p "$app/test"
  git init -q "$app"
  cat > "$app/package.json" <<'JSON'
{"scripts":{"test":"node test/smoke.test.js"}}
JSON
  cat > "$app/test/smoke.test.js" <<'JS'
const fs = require('fs');
if (!fs.existsSync('.cursor/skills/prime/SKILL.md')) {
  throw new Error('prime skill is not discoverable');
}
if (!fs.existsSync('.cursor/skills/prime-module/SKILL.md')) {
  throw new Error('prime-module skill is not discoverable');
}
if (!fs.existsSync('.cursor/rules/000-project-context.mdc')) {
  throw new Error('project rule is not discoverable');
}
JS
}

json_ok() {
  python3 -c "import json, sys; json.load(open(sys.argv[1]))" "$1"
}

mkdir -p "$FAKE_HOME"
make_tiny_app "$SYMLINK_APP"
make_tiny_app "$COPY_APP"

assert_file "$WORKFLOW_ROOT/sample/README.md"
assert_file "$WORKFLOW_ROOT/sample/workflow-artifacts/00-skill-map.md"
assert_file "$WORKFLOW_ROOT/sample/workflow-artifacts/project-tasks/README.md"
assert_file "$FLAGSHIP_SAMPLE_APP/package.json"
(
  cd "$FLAGSHIP_SAMPLE_APP"
  npm test --silent >/dev/null
)
pass "flagship sample app"

assert_file "$SAMPLE_APP/package.json"
(
  cd "$SAMPLE_APP"
  npm test --silent >/dev/null
)
pass "tiny sample app"

HOME="$FAKE_HOME" APP_ROOT="$SYMLINK_APP" PROJECT=example "$WORKFLOW_ROOT/install.sh" --apply >/dev/null
assert_symlink "$SYMLINK_APP/.cursor"
assert_symlink "$FAKE_HOME/.cursor/hooks.json"
json_ok "$WORKFLOW_ROOT/hooks.json"
assert_file "$SYMLINK_APP/.cursor/skills/prime/SKILL.md"
assert_file "$SYMLINK_APP/.cursor/skills/prime-module/SKILL.md"
assert_contains ".cursor" "$SYMLINK_APP/.git/info/exclude"
(
  cd "$SYMLINK_APP"
  npm test --silent >/dev/null
)
printf '{"cwd":"%s","workspace_roots":["%s"]}\n' "$SYMLINK_APP" "$SYMLINK_APP" \
  | "$WORKFLOW_ROOT/hooks/session-start.sh" | grep -q '/prime' \
  || fail "symlink session-start did not expose skills"
pass "symlink mode"

HOME="$FAKE_HOME" APP_ROOT="$COPY_APP" PROJECT=example "$WORKFLOW_ROOT/install.sh" --mode copy --apply >/dev/null
assert_dir "$COPY_APP/.cursor"
assert_not_symlink "$COPY_APP/.cursor"
assert_file "$COPY_APP/.cursor/hooks.json"
assert_file "$COPY_APP/.cursor/hooks/session-start.sh"
assert_file "$COPY_APP/.cursor/hooks/lib/common.sh"
json_ok "$COPY_APP/.cursor/hooks.json"
assert_contains ".cursor/hooks/state/maintain-memory-pending.jsonl" "$COPY_APP/.gitignore"
assert_contains ".cursor/memory/sessions/" "$COPY_APP/.gitignore"
assert_contains "AGENTS.md" "$COPY_APP/.gitignore"
(
  cd "$COPY_APP"
  npm test --silent >/dev/null
  git status --short .cursor/skills/prime/SKILL.md | grep -q '^\?\?' \
    || fail "copy mode .cursor skills should be trackable"
  printf '{"cwd":"%s","workspace_roots":["%s"]}\n' "$COPY_APP" "$COPY_APP" \
    | .cursor/hooks/session-start.sh | grep -q '/prime' \
    || fail "copy session-start did not expose skills"
  printf '{"command":"git commit -m test","cwd":"%s"}\n' "$COPY_APP" \
    | .cursor/hooks/before-shell-execution.sh | grep -q '"permission": "allow"' \
    || fail "before-shell hook should allow app commits"
  printf '{"conversation_id":"session-smoke","workspace_roots":["%s"]}\n' "$COPY_APP" \
    | .cursor/hooks/session-end.sh >/dev/null
  assert_file ".cursor/memory/sessions/$(date +%Y-%m-%d).md"
  printf '{}\n' > transcript.jsonl
  printf '{"conversation_id":"stop-smoke","transcript_path":"%s/transcript.jsonl","workspace_roots":["%s"]}\n' "$COPY_APP" "$COPY_APP" \
    | .cursor/hooks/maintain-memory.sh | grep -q '"followup_message"' \
    || fail "stop hook should return followup_message"
  assert_file ".cursor/hooks/state/maintain-memory-pending.jsonl"
  grep -q 'stop-smoke' .cursor/hooks/state/maintain-memory-pending.jsonl \
    || fail "maintain-memory queue missing stop-smoke"
)
pass "copy mode"

printf 'Smoke projects kept at: %s\n' "$RUN_ROOT"
