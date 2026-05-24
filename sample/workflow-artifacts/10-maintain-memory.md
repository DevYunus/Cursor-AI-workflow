# Maintain-memory example

Prompt:

```text
/maintain-memory
```

Example `AGENTS.md` update:

```markdown
# Learned Patterns

## Workflow

- Use `/prime-module <slug>` before feature fixes in known areas; it recovers rules, docs, feature memory, session logs, and plans.

## API

- User-facing sends that can be triggered by retries or double-clicks need idempotency at the API boundary.
```

Why it matters: `/maintain-memory` keeps reusable lessons small and available in future chats without storing every transcript in prompt context.
