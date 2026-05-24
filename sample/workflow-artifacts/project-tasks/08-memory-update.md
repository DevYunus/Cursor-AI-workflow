# Memory update: project-tasks

## `memory/features/project-tasks/changelog.md`

```markdown
## 2026-05-24 - Shipped
- What: Added a sample project/task workflow with role checks, assignment validation, due-date validation, status transitions, and audit logging.
- Behavior: Managers/admins can create projects and tasks; invalid users, past due dates, and invalid transitions fail.
```

## `memory/features/project-tasks/bugs.md`

```markdown
## 2026-05-24 - Permission and audit risks
- Symptom: Project/task workflows can look correct while missing role checks or audit entries.
- Root cause: Tests often cover happy-path creation but skip failure paths and side effects.
- Fix: Treat permissions and audit logs as success criteria in the brief and eval report.
- Lesson: State-changing SaaS workflows should test authorization, validation, state transitions, and audit behavior together.
```

## `AGENTS.md` candidate via `/maintain-memory`

```markdown
## Workflow

- For state-changing features, put permissions, validation, state transitions, and audit logs in the brief before implementation.
```

Why it matters: future `/prime-module` runs can recover the lesson instead of rediscovering it.
