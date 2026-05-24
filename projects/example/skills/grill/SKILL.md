---
name: grill
description: 7-category requirement interrogation before coding. Writes a brief file that /plan consumes. User must say ENOUGH to finish.
disable-model-invocation: true
---

# /grill — Requirement interrogation

## Purpose
Force crisp requirements before any code. Output: `plans/<slug>.brief.md` in the workflow repo (path below).

## Workflow repo path

Plans live in your **workflow git repo**, not the app repo:

```
<WORKFLOW_ROOT>/projects/<PROJECT>/plans/<slug>.brief.md
```

Ask the user for `WORKFLOW_ROOT` and `PROJECT` if unknown (shown at install time).

## Contract

The agent asks. The user answers. The only exits:

1. User types `ENOUGH`, `STOP`, `DONE`, `LGTM`, or `save it`
2. User invokes `/plan` or `/execute`

## Steps

### 0. Confirm understanding
Restate the idea in ≤3 sentences. Propose a kebab-case `<slug>` (e.g. `fix-duplicate-contact-email`).

### 1. TodoWrite scoreboard (7 categories)

```
- [ ] 1. Problem statement
- [ ] 2. Success criteria
- [ ] 3. Scope IN
- [ ] 4. Scope OUT
- [ ] 5. Code impact (file:line pointers)
- [ ] 6. Risks / unknowns
- [ ] 7. Rollback plan
```

### 2. Walk categories one question at a time
Read code before asking when the answer is in the repo. Mark each todo completed only with a concrete answer.

### 3. Final sweep
After 7/7: "Is there anything else before we lock this in?" Wait for `ENOUGH`.

### 4. Write brief

```markdown
---
slug: <slug>
type: brief
date: <YYYY-MM-DD>
status: complete
---

# Brief: <title>

## 1. Problem statement
## 2. Success criteria
## 3. Scope — IN
## 4. Scope — OUT
## 5. Code impact
## 6. Risks
## 7. Rollback plan

## Next step
/plan
```

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "We have enough context." | Ask anyway. Briefs prevent rework. |
| "I'll skip the brief file." | `/plan` reads the file by path — chat alone is not enough. |
