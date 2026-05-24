# Plan: Build project and task management

## Brief reference

`sample/workflow-artifacts/project-tasks/03-grill-brief.md`

## Decisions

- Keep the sample dependency-free and in-memory so it runs with plain Node.
- Model role checks in the domain layer to make security review meaningful.
- Treat audit logging as a success criterion, not a nice-to-have side effect.

## Codebase landscape

- New sample app: `sample/project-tasks-app/`.
- Domain logic: `src/project-tasks.js`.
- Tests: `test/project-tasks.test.js`.
- Test command: `cd sample/project-tasks-app && npm test`.

## Tasks

1. Create the sample app shell.
   - Files: `package.json`, `src/project-tasks.js`, `test/project-tasks.test.js`
   - Test: `cd sample/project-tasks-app && npm test`
2. Implement project creation with role and uniqueness validation.
   - Files: `src/project-tasks.js`
   - Test: `cd sample/project-tasks-app && npm test`
3. Implement task creation with assignee and due-date validation.
   - Files: `src/project-tasks.js`
   - Test: `cd sample/project-tasks-app && npm test`
4. Implement status transitions and audit logging.
   - Files: `src/project-tasks.js`, `test/project-tasks.test.js`
   - Test: `cd sample/project-tasks-app && npm test`
5. Update sample docs and smoke test coverage.
   - Files: `sample/README.md`, `README.md`, `tests/smoke-test.sh`
   - Test: `tests/smoke-test.sh`

## Final validation gate

```bash
cd sample/project-tasks-app && npm test
tests/smoke-test.sh
```

## Manual verification

- Try creating a project as a `member`; it should fail.
- Try assigning a task to a missing user; it should fail.
- Try moving a `done` task back to `todo`; it should fail.
- Verify audit log entries exist for each successful mutation.

## Rollback plan

Remove the project-task sample folder and docs. No installer behavior changes are required.
