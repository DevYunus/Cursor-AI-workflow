# API module (example scout doc)

Loaded when you edit files matching `api.mdc` globs, or when you run `/prime-module api`.

## What this area owns

- HTTP routes and handlers/controllers
- Request validation and response formatting
- Auth checks at the endpoint boundary

## Typical layout (customize)

| Piece | Example path |
|---|---|
| Routes | `routes/`, `src/api/routes.ts` |
| Handlers | `src/api/handlers/`, `app/Http/Controllers/` |
| Tests | `test/api/`, `tests/Feature/Api/` |

## Conventions

- One handler per use case; avoid god-controllers.
- Return consistent error shapes (`{ "message": "...", "code": "..." }`).

## Related memory

- `.cursor/memory/features/contact-form/` — example feature that touches the public contact endpoint
