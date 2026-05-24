---
name: memory-update
description: Post-ship learning capture. Updates memory/features/<slug>/ changelog, bugs, and lessons after deploy.
disable-model-invocation: true
---

# /memory-update — Post-deploy memory

## Purpose
Record what actually happened in production so the next iteration starts smarter.

## When
After deploy (or merge to main), not after every local commit.

## Steps

1. Read `plans/<slug>.plan.md` and `plans/<slug>.execution-report.md`
2. Gather signals: error tracker, issue status, user feedback
3. **Append `memory/features/<slug>/changelog.md`**
   ```markdown
   ## YYYY-MM-DD — Shipped
   - What: ...
   - Behavior: ...
   ```
4. **Append `bugs.md`** for any post-deploy issues (symptom, root cause, fix, lesson)
5. **Append `lessons.md`** for reusable patterns
6. If a lesson recurs 3+ times, propose a Tier-2 rule update

## Validation
At least one memory file updated with dated entry.
