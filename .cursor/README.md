# Cursor Setup for Snake App

Shared Cursor configuration for this repository.

## Included

### Rules (`.cursor/rules/`)
| File | When |
|------|------|
| `snake-app-consistency.mdc` | Always applied |
| `snake-app-theme.mdc` | Theme / UI Dart + theme docs |
| `snake-app-gameplay.mdc` | Game / levels / grid code |

### Skills (`.cursor/skills/`)
| Skill | Use for |
|-------|---------|
| `snake-app-project` | General conventions, verification, docs sync |
| `snake-app-gameplay` | Board, controls, scoring, levels, audio feedback |
| `snake-app-offline-profile` | Local profile + offline score/level persistence |

## Purpose
- Align AI-assisted development with `docs/IMPLEMENTATION_PLAN.md`
- Keep offline-first, responsive, and platform-correct control rules consistent
- Standardize analyze/test/docs checks before handoff

## Docs baseline
- `README.md`
- `docs/IMPLEMENTATION_PLAN.md`
- `docs/UX_DESIGN.md`
- `docs/THEME_AND_COLORS.md`
- `docs/ARCHITECTURE.md`
- `docs/APP_ICON_CONCEPT.md`
- `docs/CI.md`

## Keeping skills current
When layout, gameplay contracts, persistence schema, theme tokens, CI workflows, or quality gates change, update this `.cursor/` folder in the same PR. Treat stale skills/rules as defects.

## Team usage
- Keep these files version-controlled
- Prefer invoking the matching skill when starting feature work in that area
