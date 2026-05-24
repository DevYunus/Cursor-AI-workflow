# Eval report: build project and task management

## Success criteria

| Criterion | Result | Evidence |
|---|---|---|
| Managers/admins create projects | PASS | Tests cover manager success and member failure |
| Project names unique per workspace | PASS | Duplicate normalized name throws |
| Managers/admins create tasks | PASS | Task creation requires manager role |
| Assignee must be workspace member | PASS | Missing user throws before task creation |
| Due date cannot be in past | PASS | Past date throws |
| Status transitions are valid | PASS | Tests cover valid moves and terminal `done` failure |
| Audit logs are written | PASS | Tests assert audit events for project, task, and status changes |

## Product outcome

The sample now demonstrates a realistic workflow with permissions, validation, state transitions, and audit side effects.

## Route

All criteria pass. Next step: `/review`.
