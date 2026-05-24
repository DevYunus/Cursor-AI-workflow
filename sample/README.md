# Sample: project/task workflow tour

This folder shows the workflow value without making users install anything first.

Flagship scenario:

> Build project and task creation for a small SaaS workspace. Managers can create projects, add tasks, assign them to workspace members, enforce due dates, move tasks through valid statuses, and write audit logs.

This is intentionally bigger than a toy bug. It has requirements, permissions, edge cases, state transitions, and audit behavior, so the whole workflow has something real to do.

## What to look at first

| Path | Purpose |
|---|---|
| `workflow-artifacts/00-skill-map.md` | One-page map of all skills/agents this repo offers |
| `project-tasks-app/` | Runnable flagship sample app |
| `workflow-artifacts/project-tasks/` | Example outputs for the full project/task workflow |
| `tiny-contact-app/` | Minimal smoke demo for a tiny bug fix |

## Try the flagship app

```bash
cd sample/project-tasks-app
npm test
```

The app is dependency-free JavaScript: one domain module and one test file. It proves role checks, project uniqueness, task assignment, due dates, status transitions, and audit logs.

## Tour the flagship workflow

Read these in order:

1. `workflow-artifacts/project-tasks/01-prime.md`
2. `workflow-artifacts/project-tasks/02-prime-module-api.md`
3. `workflow-artifacts/project-tasks/03-grill-brief.md`
4. `workflow-artifacts/project-tasks/04-plan.md`
5. `workflow-artifacts/project-tasks/05-execution-report.md`
6. `workflow-artifacts/project-tasks/06-eval-report.md`
7. `workflow-artifacts/project-tasks/07-review.md`
8. `workflow-artifacts/project-tasks/08-memory-update.md`

## Tiny smoke demo

`tiny-contact-app/` is still useful as a 30-second sanity check:

```bash
cd sample/tiny-contact-app
npm test
```

Its artifacts live at `workflow-artifacts/01-prime.md` through `10-maintain-memory.md`.

## Install the workflow into the sample app

From the repo root:

```bash
APP_ROOT="$PWD/sample/project-tasks-app" PROJECT=example ./install.sh --mode copy --apply
```

Restart Cursor, open `sample/project-tasks-app`, then try:

```text
/prime
/prime-module api
/grill build project and task creation
```

Use copy mode for the sample because it puts `.cursor/` directly inside the demo app, making the skills, rules, docs, and memory visible in one place.
