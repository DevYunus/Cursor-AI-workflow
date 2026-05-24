---
name: plan
description: WISC-style implementation plan from a grill brief. Dispatches parallel explore sub-agents, writes plans/<slug>.plan.md with per-task test gates.
disable-model-invocation: true
---

# /plan — Implementation plan

## Purpose
Turn a brief into a task-level plan with validation gates.

## Prerequisites
- Brief at `<WORKFLOW_ROOT>/projects/<PROJECT>/plans/<slug>.brief.md`

## Phases (TodoWrite: 5 todos)

### Phase 1 — Feature understanding
Read the brief. Restate problem, scope, success criteria, rollback.

### Phase 2 — Codebase intelligence (4 parallel sub-agents)
Dispatch in one message:
- **A** — Files that will change (≤1000 tokens)
- **B** — Public APIs / interfaces affected
- **C** — Closest existing tests to copy
- **D** — Prior art in `memory/features/` and git history

### Phase 3 — External research (optional)
Use docs MCP or web search only when framework/library behavior is uncertain.

### Phase 4 — Strategic thinking
Architecture choices, blast radius, top 3 risks, rollback steps.

### Phase 5 — Write plan file

Sections:
1. Spec/brief reference
2. Decisions
3. Codebase landscape (from sub-agents)
4. **Tasks** — each with files, test command, dependencies
5. Final validation gate (full test suite command for your stack)
6. Manual verification steps
7. Rollback plan

Use your project's test runner in task gates (e.g. `npm test -- --grep=Contact`, `pytest tests/test_contact.py`, `go test ./...`).

## Artifact
`plans/<slug>.plan.md`

## Next step
`/execute`
