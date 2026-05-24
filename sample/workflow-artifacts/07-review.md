# Review summary

Prompt:

```text
/review
```

## Findings

No critical findings.

## Major

- `sample/tiny-contact-app/src/contact-form.js`: in-memory idempotency is fine for the demo, but production apps should use durable storage or a provider idempotency key. Fix: document this as sample-only.

## Minor

- `sample/tiny-contact-app/test/contact-form.test.js`: add a second-request-id assertion if this grows beyond a tiny demo.

## Fixes applied

- README and plan artifacts call out that the sample uses in-memory state because it has no database.

## Next

User commits after reviewing the diff. If behavior changes, re-run `/eval`.
