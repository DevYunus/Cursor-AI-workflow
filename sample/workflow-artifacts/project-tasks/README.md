# Flagship workflow: project and task management

This is the richer sample that justifies the full workflow.

Scenario:

> Build project and task creation for a small SaaS workspace. Managers can create projects, add tasks, assign them to workspace members, enforce due dates, move tasks through valid statuses, and write audit logs for project/task changes.

Why this is a good workflow demo:

- Requirements have real edge cases: roles, duplicate project names, invalid assignees, due dates, and status transitions.
- `/plan` can split work across domain logic, tests, and audit behavior.
- `/eval` can check product criteria that plain tests might miss.
- `/review` has meaningful security and correctness risks to catch.
- `/memory-update` captures durable lessons about role-gated workflows and audit logs.

Read the artifact set in order:

1. `01-prime.md`
2. `02-prime-module-api.md`
3. `03-grill-brief.md`
4. `04-plan.md`
5. `05-execution-report.md`
6. `06-eval-report.md`
7. `07-review.md`
8. `08-memory-update.md`
