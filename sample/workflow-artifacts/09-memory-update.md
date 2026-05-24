# Memory update: contact-form

## `memory/features/contact-form/changelog.md`

```markdown
## 2026-05-24 - Shipped
- What: Added request-id idempotency to the sample contact-form confirmation email path.
- Behavior: Duplicate submits with the same request id send one confirmation.
```

## `memory/features/contact-form/bugs.md`

```markdown
## 2026-05-24 - Duplicate confirmation emails
- Symptom: One user action produced two confirmation emails.
- Root cause: Retry/double-submit path could reach the mailer twice.
- Fix: Guard confirmation send by normalized email + request id.
- Lesson: User-facing sends need idempotency at the boundary where retries enter.
```

## `memory/features/contact-form/lessons.md`

```markdown
- For form submits, build tests around retry and double-click behavior, not only the happy path.
```

Why it matters: `/memory-update` records the production lesson where future `/prime-module` runs can find it.
