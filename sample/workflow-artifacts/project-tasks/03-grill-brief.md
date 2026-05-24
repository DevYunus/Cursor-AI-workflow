---
slug: build-project-task-management
type: brief
date: 2026-05-24
status: complete
---

# Brief: Build project and task management

## 1. Problem statement

The sample needs a realistic SaaS workflow where users can create projects and project tasks. It should be complex enough to demonstrate why requirements, planning, eval, review, and memory matter.

## 2. Success criteria

- Managers and admins can create projects.
- Project names are unique inside a workspace.
- Managers and admins can create tasks for an existing project.
- Tasks can only be assigned to workspace members.
- Task due dates cannot be in the past.
- Tasks move only through valid statuses: `todo` → `in_progress` → `done`; `in_progress` can return to `todo`; `done` is terminal.
- Project creation, task creation, and status changes create audit log entries.

## 3. Scope - IN

- In-memory project/task domain logic.
- Role checks for project and task creation.
- Assignment validation.
- Status transition validation.
- Focused tests for success and failure paths.

## 4. Scope - OUT

- Persistence/database layer.
- UI.
- Authentication/session middleware.
- Notifications.

## 5. Code impact

- `sample/project-tasks-app/src/project-tasks.js`
- `sample/project-tasks-app/test/project-tasks.test.js`

## 6. Risks

- Missing role checks would let members create projects.
- Missing assignment checks would allow tasks for non-members.
- Status transitions could skip reviewable workflow states.
- Tests could pass while audit logs are missing.

## 7. Rollback plan

Remove `sample/project-tasks-app/` and the project-task workflow artifacts. The existing tiny contact-form sample remains available.

## Next step

`/plan`
