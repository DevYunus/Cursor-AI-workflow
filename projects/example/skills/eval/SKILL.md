---
name: eval
description: Verify outcome against success criteria from the brief/plan. Routes FAIL back to /execute or /plan. Writes eval-report.md.
disable-model-invocation: true
---

# /eval — Outcome verification

## Purpose
Unit tests prove code paths; `/eval` proves the **feature behaves as promised** in the brief.

## Steps

### 0. TodoWrite — one todo per success criterion from brief/plan

### 1. Load success criteria from brief or plan

### 2. Run feature-scoped tests

### 3. Manual checks
For each criterion: find a test OR run a concrete manual step (curl, UI check, DB query).

### 4. Judge sub-agent
PASS / PARTIAL / FAIL per criterion with evidence.

### 5. Route
- All PASS → `/review`
- FAIL → back to `/execute` or `/plan` with specific gap
- PARTIAL → user decides ship vs fix

### 6. Write `plans/<slug>.eval-report.md`

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Tests passed." | Tests ≠ product outcome. Check the brief's success criteria. |

## Next step
`/review` if all PASS
