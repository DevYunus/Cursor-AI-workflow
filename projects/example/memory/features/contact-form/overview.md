# Feature: Contact form

- **Slug:** contact-form
- **Status:** example / documentation only

## What it is

Users submit a message through a contact form. The backend sends one confirmation email to the user and one notification to the team inbox.

## Known issue (example walkthrough)

Under some conditions the confirmation email is sent twice when the user double-clicks Submit or when the API retries a slow request.

## Where to look (customize for your repo)

| Layer | Typical path |
|---|---|
| Route / handler | `src/routes/contact.ts` or `app/Http/Controllers/ContactController.php` |
| Mail / notification | `src/services/mail.ts` or `app/Mail/ContactConfirmation.php` |
| Tests | `tests/contact.test.ts` or `tests/Feature/ContactFormTest.php` |

## Related memory files

- `changelog.md` — what shipped and when
- `bugs.md` — post-mortems
- `lessons.md` — patterns to reuse
- `open-questions.md` — unknowns
