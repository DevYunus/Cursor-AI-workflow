---
name: prime
description: Orient at session start. Reads recent git activity, open tasks, and stale memory flags. Use after a break or when switching tasks.
disable-model-invocation: true
---

# /prime — Session orientation

## Purpose
Bring a cold agent up to speed in under 2 minutes. Read-only — no file writes.

## Steps

1. **Read Tier-1 context.** `Read` `.cursor/rules/000-project-context.mdc`.
2. **Recent git activity.** Run `git log --oneline -15 --no-merges` in the app repo. Summarize 2–3 themes.
3. **Open work.** List in-progress branches, TODO comments, or issue tracker items if MCP/issue tools are configured.
4. **Stale flags.** If `.cursor/memory/_stale-flags.md` exists, list open items.
5. **Summarize in chat** — 5 bullets max.

## Artifact
None.

## Red flags
- Uncommitted changes from a different feature → mention before starting new work.
