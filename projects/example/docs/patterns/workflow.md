# AI workflow patterns

This project uses cursor-workflow skills. The daily loop:

```
/prime → /prime-module <slug> → /grill → /plan → /execute → /eval → /review → you commit → /memory-update
```

Use `/prime-module api` (or your rule slug) when work is scoped to one area — loads Tier-2 rule + scout doc + scoped git log.

## Artifacts

| Skill | Writes to |
|---|---|
| `/grill` | workflow repo `projects/<project>/plans/<slug>.brief.md` |
| `/plan` | `plans/<slug>.plan.md` |
| `/execute` | `plans/<slug>.execution-report.md` |
| `/eval` | `plans/<slug>.eval-report.md` |
| `/handoff` | `handoffs/<YYYY-MM-DD>-<slug>.md` |
| `/memory-update` | `memory/features/<slug>/*.md` |
| `/maintain-memory` | `AGENTS.md` in your app repo |

## Hooks (automatic)

- **sessionStart** — surfaces available docs and skills
- **sessionEnd** — appends session metadata to `memory/sessions/`
- **stop → maintain-memory** — queues transcripts; run `/maintain-memory` to process
- **beforeShellExecution** — enforces `Context:` bullets on workflow-repo commits only
