---
name: maintain-memory
description: Process queued session transcripts into AGENTS.md learned patterns. Run after sessions or when stop hook queues pending items.
disable-model-invocation: true
---

# /maintain-memory — Continual learning

## Purpose
Extract **durable, reusable** patterns from recent sessions into `AGENTS.md` in your app repo. This is how the agent remembers conventions across sessions without you repeating them.

The **stop hook** appends pending transcripts to:

```
.cursor/hooks/state/maintain-memory-pending.jsonl
```

This skill processes that queue (or the current session transcript if invoked manually).

## What belongs in AGENTS.md

**Include:**
- Project-specific conventions ("always validate X before Y")
- Non-obvious gotchas with evidence (`file:line`)
- Test patterns, tooling quirks, deployment notes

**Exclude:**
- Session-specific task status (use `/handoff` instead)
- Secrets, tokens, PII
- One-off debugging noise

## Steps

1. **Read pending queue** at `.cursor/hooks/state/maintain-memory-pending.jsonl` (if empty, use current session context).
2. **Read existing `AGENTS.md`** in the app repo root (create `# Learned Patterns` if missing).
3. **Read index** `.cursor/hooks/state/continual-learning-index.json` — skip already-processed `conversation_id`s.
4. **For each new transcript**, extract 0–5 high-signal bullets. Merge duplicates. Update contradicted bullets instead of appending conflicts.
5. **Write `AGENTS.md`** under themed headings (e.g. `## Testing`, `## API`, `## Workflow`).
6. **Update index** with `conversation_id` + `processed_at`.
7. **Clear processed lines** from pending queue (rewrite file with only unprocessed entries).

## Soft limits

- Keep `AGENTS.md` scannable (~200 lines soft target). Archive old sections to `memory/features/` via `/memory-update` when a topic grows large.

## Validation

- Index updated for each processed conversation
- No secrets in AGENTS.md
- User can skim new bullets in under 2 minutes

## When to run

- End of a substantial session (hook queues automatically)
- Weekly cleanup
- After you correct the agent twice on the same convention

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "AGENTS.md is getting long." | Promote stable feature knowledge to `memory/features/`; keep AGENTS.md for cross-cutting patterns. |
| "Nothing important happened." | Confirming a convention works is still worth one bullet. |
