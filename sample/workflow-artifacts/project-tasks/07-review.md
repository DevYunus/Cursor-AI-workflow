# Review summary: project and task management

Prompt:

```text
/review
```

## Findings

No critical findings.

## Major

- `sample/project-tasks-app/src/project-tasks.js`: in-memory audit logs are fine for a sample, but production audit logs must be append-only and durable. Fix: keep this documented as a demo-only persistence model.

## Minor

- `sample/project-tasks-app/src/project-tasks.js`: role hierarchy is intentionally small; a real app may need per-project permissions instead of workspace-wide manager/admin roles.
- `sample/project-tasks-app/test/project-tasks.test.js`: add table-driven tests if more statuses or roles are added.

## Security notes

- Role checks happen before mutation.
- Missing assignee validation prevents tasks from referencing users outside the workspace.
- Audit events are written for every successful state-changing action.

## Next

User commits after reviewing the staged diff. If behavior changes, re-run `/eval`.
