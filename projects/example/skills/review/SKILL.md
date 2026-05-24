---
name: review
description: Four parallel specialist reviewers on uncommitted diff — correctness, testing, security, maintainability. Use before you commit.
disable-model-invocation: true
---

# /review — Multi-persona review

## Purpose
Catch issues before commit via 4 parallel reviewers.

## Steps

1. **Capture diff:** `git diff > /tmp/review-<slug>.diff` (include staged if needed: `git diff HEAD`)
2. **Dispatch 4 sub-agents in one message:**
   - **Correctness** — logic, edge cases, error handling
   - **Testing** — coverage gaps, missing failure paths
   - **Security** — injection, auth, secrets, input validation
   - **Maintainability** — project conventions from `.cursor/rules/` and `AGENTS.md`
3. **Aggregate** by severity: critical → major → minor
4. **User decides** fix / defer / ignore per finding
5. Apply approved fixes and re-run relevant tests

## Severity bar

- **critical** — must fix before commit (data loss, security, wrong behavior)
- **major** — fix or track with issue
- **minor** — optional

## Proof gate
Each finding needs: location, problem, concrete fix. Discard vague style nits.

## Next step
User commits. If behavior changed, re-run `/eval`.
