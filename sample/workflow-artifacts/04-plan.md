# Plan: Fix duplicate contact-form confirmation emails

## Brief reference

`workflow-artifacts/03-grill-brief.md`

## Decisions

- Use `email + requestId` as the idempotency key for the sample.
- Keep storage in memory because the sample app has no database.
- Test behavior at the handler boundary where retries enter.

## Codebase landscape

- Handler and mailer helper live in `sample/tiny-contact-app/src/contact-form.js`.
- Existing test runner is plain Node via `npm test`.
- No external dependencies are needed.
- Prior memory says duplicate email bugs usually come from multiple entry points hitting the mailer.

## Tasks

1. Add contact-form state reset and mailer test helper.
   - Files: `sample/tiny-contact-app/src/contact-form.js`
   - Test: `cd sample/tiny-contact-app && npm test`
2. Add idempotency guard around confirmation send.
   - Files: `sample/tiny-contact-app/src/contact-form.js`
   - Test: `cd sample/tiny-contact-app && npm test`
3. Add duplicate-submit regression test.
   - Files: `sample/tiny-contact-app/test/contact-form.test.js`
   - Test: `cd sample/tiny-contact-app && npm test`

## Final validation gate

```bash
cd sample/tiny-contact-app && npm test
```

## Manual verification

Call `submitContactForm()` twice with the same `requestId`; verify one email. Call it again with a new `requestId`; verify a second email.

## Rollback plan

Remove the idempotency key set and the duplicate-submit test.
