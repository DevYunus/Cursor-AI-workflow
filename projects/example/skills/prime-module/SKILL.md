---
name: prime-module
description: Deep-orient on one area of the codebase (api, auth, billing, etc.). Loads the matching Tier-2 rule, scout doc, scoped git history, and feature memory. Use before work limited to a single module or domain.
disable-model-invocation: true
---

# /prime-module — Module / area orientation

## Purpose

Deep-prime on **one** slice of the project — not the whole repo. Output is an in-session summary; no file writes.

**Why this skill exists:** `/prime` is session-wide (git, open work). `/prime-module` **rehydrates accumulated context** for one area — rules, docs, commits, feature memory, recent sessions, and plans — so you do not re-discover the same gotchas every chat.

Use after `/prime` when you know the area (e.g. `api`, `auth`, `contact-form`).

## Prerequisites

- Harness installed (`.cursor/rules/`, `.cursor/skills/`).
- You know the **module slug** — usually the basename of a Tier-2 rule (without `.mdc`), e.g. `api`, `auth`, `contact-form`.

## Steps

### 0. Resolve the module slug

If the user did not name one, list available modules:

```bash
ls .cursor/rules/*.mdc
```

Skip `000-project-context.mdc`. Each other file is a candidate: `api.mdc` → slug `api`.

Ask the user to pick one if ambiguous.

### 1. Load the Tier-2 rule

`Read` `.cursor/rules/<slug>.mdc`.

This is the short, path-scoped constraint set (globs, conventions, red flags). Cite `file:line` from the rule when summarizing.

### 2. Load the scout doc (if it exists)

Check in order (first match wins):

- `.cursor/docs/modules/<slug>.md`
- `.cursor/docs/integrations/<slug>.md`
- `.cursor/docs/patterns/<slug>.md`

If missing, say so — suggest adding one and referencing it from the rule with `@.cursor/docs/...`.

### 3. Scoped git history

Read `globs:` from the rule frontmatter. Pick 1–3 path prefixes that represent this module in **your** repo layout, then run:

```bash
git log --oneline -20 --no-merges -- <path1> <path2>
```

Examples by stack (adjust to your tree):

| Slug hint | Typical paths |
|---|---|
| `api` | `src/api/`, `routes/`, `app/Http/Controllers/` |
| `auth` | `src/auth/`, `app/Http/Middleware/`, `middleware/` |
| Laravel module | `app/Modules/<Name>/` |

If globs use `**`, derive a reasonable directory prefix rather than passing raw glob syntax to `git log`.

### 4. Feature memory (prior work on this area)

If `.cursor/memory/features/<slug>/` exists, read:

- `overview.md` — what this area does
- `changelog.md` — last ~30 lines (up to ~200 if dense)
- `bugs.md` — recent post-mortems and known landmines
- `lessons.md` — patterns to reuse
- `open-questions.md` — unresolved decisions

If the slug differs from the memory folder name (e.g. rule `api.mdc` but memory `contact-form/`), read the folder named in `memory/_ownership.yaml` or that the user names.

### 5. Session & plan artifacts (conversation continuity)

Recover **what you already did in past chats** for this area:

1. **Session log** — search `.cursor/memory/sessions/*.md` for the slug or feature name; read the newest 1–2 matching entries (often ends with `skill: /prime-module` or module name).
2. **Plans & handoffs** — list `.cursor/plans/` and `.cursor/handoffs/`; read any file whose name or first ~20 lines mention the slug.
3. **AGENTS.md** — skim for bullets mentioning this slug or its paths (promoted learnings from `/maintain-memory`).

If nothing matches, say "no prior session/plan hits" — that is useful too.

### 6. Stale flags

If `.cursor/memory/_stale-flags.md` mentions this slug, surface those entries before any implementation work.

### 7. Summarize in chat (6–8 bullets)

- **Purpose** — one sentence
- **Key entry points** — files or directories
- **Rules to remember** — top 2–3 from the Tier-2 rule
- **Recent git themes** — scoped `git log`
- **Feature memory** — bugs, lessons, changelog highlights
- **Prior sessions / plans** — what was already tried or decided
- **Stale flags** — if any
- **Suggested next step** — `/grill` (new work), `/plan` (clear scope), or read `bugs.md` first (fix)

## Validation

None — read-only.

## Artifact

None.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Tier-1 is enough." | Tier-1 is global and thin. Module gotchas live in Tier-2 + docs. |
| "I'll discover the module by reading code." | Scout docs + memory save 15+ reads and surface non-obvious constraints. |
| "I'll skip git log." | Recent commits show what the team actually changed here. |
| "Memory files are enough." | Session logs and plans capture *this week's* decisions that never made it into memory yet. |

## Red flags

- Unknown slug → list valid slugs from `.cursor/rules/` and ask.
- Stale flags for this slug → warn before coding in that area.
- No Tier-2 rule for the area → offer to add `.cursor/rules/<slug>.mdc` + a matching doc under `.cursor/docs/`.
