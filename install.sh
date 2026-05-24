#!/usr/bin/env bash
# install.sh — Wire cursor-workflow into Cursor and your app repo.
#
# Usage:
#   ./install.sh                                # dry-run preview
#   ./install.sh --apply                        # live symlink install
#   ./install.sh --mode copy --apply            # copy .cursor into app repo
#   APP_ROOT=~/code/myapp PROJECT=example ./install.sh --apply
#
# Stages:
#   1. Symlink skills-cursor → ~/.cursor/skills-cursor
#   2. Symlink mode: render hooks.json.tmpl → hooks.json, symlink → ~/.cursor/hooks.json
#   3. Symlink mode: symlink projects/<PROJECT> → $APP_ROOT/.cursor
#      Copy mode: copy projects/<PROJECT> + hooks into $APP_ROOT/.cursor

set -euo pipefail

WORKFLOW_ROOT="${WORKFLOW_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
CURSOR_ROOT="$HOME/.cursor"
APP_ROOT="${APP_ROOT:-$HOME/code/my-app}"
PROJECT="${PROJECT:-example}"
INSTALL_MODE="${INSTALL_MODE:-symlink}"

DRY_RUN=1
while [[ $# -gt 0 ]]; do
  arg="$1"
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --apply) DRY_RUN=0 ;;
    --copy) INSTALL_MODE="copy" ;;
    --symlink) INSTALL_MODE="symlink" ;;
    --mode)
      shift
      INSTALL_MODE="${1:-}"
      ;;
    --mode=*)
      INSTALL_MODE="${arg#--mode=}"
      ;;
    -h|--help)
      sed -n '1,13p' "$0"
      echo
      echo "Modes:"
      echo "  symlink  Keep .cursor in cursor-workflow/projects/<PROJECT> and symlink app .cursor (default)."
      echo "  copy     Copy project workflow files directly into APP_ROOT/.cursor; no app .cursor symlink."
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: $arg" >&2
      exit 2
      ;;
  esac
  shift
done

case "$INSTALL_MODE" in
  symlink|copy) ;;
  *)
    echo "ERROR: INSTALL_MODE must be 'symlink' or 'copy' (got: $INSTALL_MODE)" >&2
    exit 2
    ;;
esac

say()    { printf "  %s\n" "$1"; }
header() { printf "\n%s\n" "$1"; }
run_cmd() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf "  [dry]"
    printf " %q" "$@"
    printf "\n"
  else
    "$@"
  fi
}

render_hooks_json() {
  local out="$1" hooks_dir="$2"
  if [[ ! -f "$WORKFLOW_ROOT/hooks.json.tmpl" ]]; then
    say "skip (missing): $WORKFLOW_ROOT/hooks.json.tmpl"
    return 0
  fi
  if [[ $DRY_RUN -eq 1 ]]; then
    say "[dry] render hooks.json.tmpl → $out with HOOKS_DIR=$hooks_dir"
    return 0
  fi
  python3 - "$WORKFLOW_ROOT/hooks.json.tmpl" "$out" "$hooks_dir" <<'PY'
import json
import sys
from pathlib import Path

template_path, out_path, hooks_dir = sys.argv[1:4]
text = Path(template_path).read_text().replace("__HOOKS_DIR__", hooks_dir)
Path(out_path).parent.mkdir(parents=True, exist_ok=True)
Path(out_path).write_text(text)
json.loads(text)
PY
  say "rendered $out"
}

copy_contents() {
  local src="$1" dst="$2"
  if [[ ! -d "$src" ]]; then
    say "skip (missing): $src"
    return 0
  fi
  if [[ $DRY_RUN -eq 1 ]]; then
    say "[dry] copy $src/. → $dst/"
    return 0
  fi
  mkdir -p "$dst"
  cp -R "$src/." "$dst/"
  say "copied $src → $dst"
}

append_lines_once() {
  local file="$1"
  shift
  if [[ $DRY_RUN -eq 1 ]]; then
    for line in "$@"; do
      say "[dry] ensure '$line' in $file"
    done
    return 0
  fi
  mkdir -p "$(dirname "$file")"
  touch "$file"
  for line in "$@"; do
    grep -qxF "$line" "$file" 2>/dev/null || printf '%s\n' "$line" >> "$file"
  done
}

link() {
  local src="$1" dst="$2"
  if [[ ! -e "$src" ]]; then
    say "skip (missing): $src"
    return 0
  fi
  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      say "ok (linked): $dst"
      return 0
    fi
    say "WARN: $dst -> $current (expected $src)"
    return 0
  fi
  if [[ -e "$dst" ]]; then
    say "WARN: $dst exists and is not a symlink — skip"
    return 0
  fi
  run_cmd mkdir -p "$(dirname "$dst")"
  run_cmd ln -s "$src" "$dst"
  say "link $dst -> $src"
}

echo "========================================================================"
echo "  cursor-workflow installer"
echo "  WORKFLOW_ROOT: $WORKFLOW_ROOT"
echo "  APP_ROOT:      $APP_ROOT"
echo "  PROJECT:       $PROJECT"
echo "  INSTALL_MODE:  $INSTALL_MODE"
echo "  MODE:          $([[ $DRY_RUN -eq 1 ]] && echo DRY RUN || echo LIVE)"
echo "========================================================================"

project_dir="$WORKFLOW_ROOT/projects/$PROJECT"
if [[ ! -d "$project_dir" ]]; then
  echo "ERROR: project harness not found: $project_dir"
  echo "Copy projects/example to projects/<your-name> and set PROJECT=<your-name>"
  exit 1
fi

header "Stage 1 — skills-cursor → ~/.cursor"
run_cmd mkdir -p "$CURSOR_ROOT/skills-cursor"
if [[ -d "$WORKFLOW_ROOT/skills-cursor" ]]; then
  for dir in "$WORKFLOW_ROOT/skills-cursor"/*/; do
    [[ -d "$dir" ]] || continue
    name="$(basename "$dir")"
    link "${dir%/}" "$CURSOR_ROOT/skills-cursor/$name"
  done
fi

header "Stage 2 — hooks.json"
if [[ "$INSTALL_MODE" == "symlink" ]]; then
  render_hooks_json "$WORKFLOW_ROOT/hooks.json" "$WORKFLOW_ROOT/hooks"
  link "$WORKFLOW_ROOT/hooks.json" "$CURSOR_ROOT/hooks.json"
else
  say "copy mode uses project hooks at APP_ROOT/.cursor/hooks.json"
fi

header "Stage 3 — project harness → app .cursor"
if [[ ! -d "$APP_ROOT" ]]; then
  say "APP_ROOT not found ($APP_ROOT) — skipping app .cursor install"
  say "Create your app repo, then re-run with APP_ROOT=/path/to/your/app ./install.sh --apply"
else
  app_cursor="$APP_ROOT/.cursor"
  if [[ "$INSTALL_MODE" == "symlink" ]]; then
    if [[ -e "$app_cursor" && ! -L "$app_cursor" ]]; then
      backup="$app_cursor.pre-workflow-$(date +%Y%m%d-%H%M%S)"
      run_cmd mv "$app_cursor" "$backup"
      say "backed up existing .cursor → $backup"
    fi
    link "$project_dir" "$app_cursor"

    if [[ -d "$APP_ROOT/.git" ]]; then
      exclude="$APP_ROOT/.git/info/exclude"
      append_lines_once "$exclude" "# cursor-workflow" ".cursor" ".cursor.pre-workflow-*"
      say "ensured .cursor is excluded from app git"
    fi
  else
    if [[ -L "$app_cursor" ]]; then
      backup="$app_cursor.pre-workflow-$(date +%Y%m%d-%H%M%S)"
      run_cmd mv "$app_cursor" "$backup"
      say "backed up existing .cursor symlink → $backup"
    fi
    copy_contents "$project_dir" "$app_cursor"
    copy_contents "$WORKFLOW_ROOT/hooks" "$app_cursor/hooks"
    render_hooks_json "$app_cursor/hooks.json" ".cursor/hooks"

    if [[ -d "$APP_ROOT/.git" ]]; then
      gitignore="$APP_ROOT/.gitignore"
      append_lines_once "$gitignore" "# cursor-workflow local state" ".cursor/hooks/state/maintain-memory-pending.jsonl" ".cursor/memory/sessions/" "AGENTS.md"
      say "ensured only local workflow state is ignored"
    fi
  fi
fi

echo
echo "Done. Restart Cursor (Cmd+Q), open your app, type /prime in chat."
echo "Customize: copy projects/example → projects/<slug>, edit rules/ and memory/."
