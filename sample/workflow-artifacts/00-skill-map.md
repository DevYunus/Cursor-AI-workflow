# Skill map

This repo ships two kinds of skills.

## Daily workflow skills

| Skill | Value | Output |
|---|---|---|
| `/prime` | Cold-start orientation | Chat summary |
| `/prime-module <slug>` | Rehydrate previous context for one area | Chat summary with rules, docs, git, memory, plans |
| `/grill <slug>` | Clarify requirements before coding | `plans/<slug>.brief.md` |
| `/plan` | Convert brief into tested tasks | `plans/<slug>.plan.md` |
| `/execute` | Implement plan task-by-task | Code changes + `plans/<slug>.execution-report.md` |
| `/eval` | Check success criteria, not just tests | `plans/<slug>.eval-report.md` |
| `/review` | Parallel specialist review | Findings grouped by severity |
| `/handoff` | Compress session state | `handoffs/<date>-<slug>.md` |
| `/memory-update` | Capture post-ship feature learning | `memory/features/<slug>/*.md` updates |
| `/maintain-memory` | Promote reusable session lessons | `AGENTS.md` updates |

## Authoring skills

| Skill | Value |
|---|---|
| `create-skill` | Add a new slash workflow |
| `create-rule` | Add a new project or path-scoped rule |
| `create-hook` | Add automation around Cursor agent events |

## Agent patterns included

- `/plan` uses parallel exploration agents for files, APIs, tests, and prior art.
- `/review` uses parallel specialist agents for correctness, tests, security, and maintainability.
- Hooks add session context and queue `/maintain-memory` instead of forcing the model to remember everything in chat.
