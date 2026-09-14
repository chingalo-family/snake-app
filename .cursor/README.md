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
| `snake-app-community-docs` | README, CONTRIBUTING, SECURITY, CoC, GETTING_STARTED, GitHub templates |

## Purpose
- Align AI-assisted development with `docs/IMPLEMENTATION_PLAN.md`
- Keep offline-first, responsive, and platform-correct control rules consistent
- Enforce **meaningful variable names** (see `snake-app-project` skill Naming)
- Standardize analyze/test/docs checks before handoff

## Docs baseline
- `README.md`
- `docs/GETTING_STARTED.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `CODE_OF_CONDUCT.md`
- `docs/IMPLEMENTATION_PLAN.md`
- `docs/UX_DESIGN.md`
- `docs/THEME_AND_COLORS.md`
- `docs/ARCHITECTURE.md`
- `docs/GAME_MODES.md`
- `docs/APP_ICON_CONCEPT.md`
- `docs/CI.md`

When marketing-facing product facts change and `../snake-app-website` is present, update that repo’s `docs/` as well.

## Keeping skills current
When layout, gameplay contracts, persistence schema, theme tokens, locales/ARB strings, CI workflows, quality gates, or community-health facts (commands, stack, store links, contacts) change, update this `.cursor/` folder **and** the matching community files in the same PR. Treat stale skills/rules as defects. Use `.cursor/skills/snake-app-community-docs/`.

## Team usage
- Keep these files version-controlled
- Prefer invoking the matching skill when starting feature work in that area
