# Example output: /prime-module api

Prompt:

```text
/prime-module api
```

Result:

- Purpose: API/domain handlers own validation, permission checks, stable errors, and audit-producing side effects.
- Entry points: `sample/project-tasks-app/src/project-tasks.js`, `sample/project-tasks-app/test/project-tasks.test.js`, `.cursor/rules/api.mdc`.
- Rules to remember: validate at the boundary; role checks must happen before mutation; errors should be stable and user-safe.
- Recent git themes: sample apps now demonstrate both tiny smoke checks and a richer feature workflow.
- Feature memory: use `memory/features/api/` until a real project/task feature memory folder exists.
- Prior sessions/plans: this sample was added because the contact-form bug was too small to prove the full workflow.
- Suggested next step: `/grill build project and task creation`.

Why it matters: `/prime-module` pulls previous context into the session before the agent invents a model.
