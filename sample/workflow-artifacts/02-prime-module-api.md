# Example output: /prime-module api

Prompt:

```text
/prime-module api
```

Result:

- Purpose: API handlers own request validation, authorization checks, and stable response shapes.
- Entry points: `src/contact-form.js`, `test/contact-form.test.js`, `.cursor/rules/api.mdc`.
- Rules to remember: validate at the boundary; check auth in the endpoint path; do not leak internal details in errors.
- Recent git themes: sample app and contact-form memory were added as the demo workflow path.
- Feature memory: `memory/features/contact-form/bugs.md` says duplicate submits can happen from double-clicks and API retries.
- Prior sessions/plans: no existing handoff for this tiny sample.
- Suggested next step: `/grill fix-duplicate-contact-email`.

Why it matters: `/prime-module` extracts previous context for one area before the agent proposes a fix.
