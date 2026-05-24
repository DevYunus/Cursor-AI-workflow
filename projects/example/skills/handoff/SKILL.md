---
name: handoff
description: End-of-session summary for the next session. Writes handoffs/<date>-<slug>.md with a one-paragraph resume command.
disable-model-invocation: true
---

# /handoff — Session compression

## Purpose
Write a compact file so tomorrow's session starts fresh without re-explaining context.

## Steps

1. **Done** — files edited, tests run, decisions made
2. **Pending** — unfinished plan tasks
3. **Blockers** — user decisions needed
4. **Read next** — plan, execution report, memory paths
5. **Write** `handoffs/<YYYY-MM-DD>-<slug>.md` using template in `templates/handoff.md`
6. **Resume command** — one paragraph the user can paste into a new chat

## Validation
- File < 150 lines
- All paths exist
- Resume command is copy-paste ready
