---
slug: fix-duplicate-contact-email
type: brief
date: 2026-05-24
status: complete
---

# Brief: Fix duplicate contact-form confirmation emails

## 1. Problem statement

Users sometimes receive two confirmation emails after submitting the contact form once. The likely causes are double-clicks, browser retries, or API retries.

## 2. Success criteria

- A repeated submit with the same `requestId` sends exactly one confirmation email.
- A submit with a different `requestId` can still send a legitimate new confirmation.
- Invalid requests fail before the mailer is called.

## 3. Scope - IN

- Add idempotency around the confirmation send.
- Normalize email before building the idempotency key.
- Add a focused duplicate-submit test.

## 4. Scope - OUT

- No email copy changes.
- No admin notification changes.
- No database migration in the tiny sample app.

## 5. Code impact

- `sample/tiny-contact-app/src/contact-form.js`
- `sample/tiny-contact-app/test/contact-form.test.js`

## 6. Risks

- A key that is too broad could suppress legitimate future messages.
- A key that is too narrow would miss retries.

## 7. Rollback plan

Revert the idempotency guard and test. The behavior returns to one send per handler invocation.

## Next step

`/plan`
