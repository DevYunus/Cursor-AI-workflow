# Sample: contact form workflow tour

This folder shows the workflow value without making users install anything first.

Scenario: a contact form sometimes sends duplicate confirmation emails. The sample walks through how the Cursor workflow would orient, interrogate, plan, execute, evaluate, review, hand off, and remember the fix.

## What to look at first

| Path | Purpose |
|---|---|
| `tiny-contact-app/` | Minimal JavaScript app used by the demo scenario |
| `workflow-artifacts/` | Example outputs from every project skill |
| `workflow-artifacts/00-skill-map.md` | One-page map of all skills/agents this repo offers |

## Try the tiny app

```bash
cd sample/tiny-contact-app
npm test
```

The app is intentionally small: one handler, one mailer, and one test for duplicate submits. It exists so users can see the workflow against real files instead of abstract instructions.

## Tour the skills

Read these in order:

1. `workflow-artifacts/01-prime.md`
2. `workflow-artifacts/02-prime-module-api.md`
3. `workflow-artifacts/03-grill-brief.md`
4. `workflow-artifacts/04-plan.md`
5. `workflow-artifacts/05-execution-report.md`
6. `workflow-artifacts/06-eval-report.md`
7. `workflow-artifacts/07-review.md`
8. `workflow-artifacts/08-handoff.md`
9. `workflow-artifacts/09-memory-update.md`
10. `workflow-artifacts/10-maintain-memory.md`

## Install the workflow into the sample app

From the repo root:

```bash
APP_ROOT="$PWD/sample/tiny-contact-app" PROJECT=example ./install.sh --mode copy --apply
```

Restart Cursor, open `sample/tiny-contact-app`, then try:

```text
/prime
/prime-module api
/grill fix duplicate contact form emails
```

Use copy mode for the sample because it puts `.cursor/` directly inside the demo app, making the skills, rules, docs, and memory visible in one place.
