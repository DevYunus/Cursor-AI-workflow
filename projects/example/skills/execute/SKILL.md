---
name: execute
description: Run a plan task-by-task with a test gate after each task. Writes execution-report.md. Does not run git commit.
disable-model-invocation: true
---

# /execute — Run the plan

## Purpose
Execute `plans/<slug>.plan.md` with per-task tests. Agent never commits.

## Steps

### 0. TodoWrite — one todo per plan task

### 1. Read entire plan

### 2. Git sanity check
- Unrelated uncommitted changes → surface to user
- On shared branch without feature branch → ask user to branch

### 3. For each task (in order)
1. Make listed file changes
2. Run the task's test command
3. Fix failures before next task
4. Mark todo completed

### 4. Module/group tests (if plan specifies)

### 5. Final gate — full test suite for affected area

### 6. Write `plans/<slug>.execution-report.md`
- Tasks completed (PASS/FAIL per task)
- Deviations from plan
- Final gate result
- Manual verification steps
- Next: `/eval`

## Validation
All task tests and final gate pass (or pre-existing failures documented).

## Red flags
- Skipping a failing task test → not allowed
- Running `git commit` → user commits manually
