#!/usr/bin/env bash
# uninstall.sh — Remove cursor-workflow symlinks (does not delete real files).

set -euo pipefail

WORKFLOW_ROOT="${WORKFLOW_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
CURSOR_ROOT="$HOME/.cursor"
APP_ROOT="${APP_ROOT:-$HOME/code/my-app}"
PROJECT="${PROJECT:-example}"

unlink_if_points() {
  local dst="$1" expected="$2"
  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$expected" ]]; then
    rm "$dst"
    echo "unlinked $dst"
  fi
}

for dir in "$WORKFLOW_ROOT/skills-cursor"/*/; do
  [[ -d "$dir" ]] || continue
  unlink_if_points "$CURSOR_ROOT/skills-cursor/$(basename "$dir")" "${dir%/}"
done

unlink_if_points "$CURSOR_ROOT/hooks.json" "$WORKFLOW_ROOT/hooks.json"
unlink_if_points "$APP_ROOT/.cursor" "$WORKFLOW_ROOT/projects/$PROJECT"

echo "Uninstall complete."
