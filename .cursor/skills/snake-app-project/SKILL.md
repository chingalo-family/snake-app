---
name: snake-app-project
description: Snake App Flutter project conventions for features, verification, and docs. Use when implementing features, fixing bugs, reviewing changes, or verifying work in this repository.
---

# Snake App Project Skill

Use this skill whenever working in this repository to keep implementation style, verification, and documentation consistent.

## Project identity
- Product: **Snake App** (Chingalo Family)
- Package: `snake_app` · Application ID: `chingalo.family.snake_app`
- Stack: Flutter game, offline-first local storage, SFX/BGM audio, responsive multi-platform UI
- Platforms: Android, iOS, Linux, macOS, Windows, Web
- Docs baseline: `README.md`, `docs/IMPLEMENTATION_PLAN.md`, `docs/UX_DESIGN.md`, `docs/THEME_AND_COLORS.md`, `docs/ARCHITECTURE.md`, `docs/APP_ICON_CONCEPT.md`

## First-step checklist
1. Read `docs/IMPLEMENTATION_PLAN.md` for scope and acceptance criteria.
2. Align UX with `docs/UX_DESIGN.md` and theme with `docs/THEME_AND_COLORS.md`.
3. Map the change to a feature module (`onboarding`, `home`, `levels`, `game`, `profile`, `scores`, `settings`, `about`, `updates`).
4. If gameplay/controls/board/levels/scoring → follow `.cursor/skills/snake-app-gameplay/SKILL.md`.
5. If profile/scores/persistence → follow `.cursor/skills/snake-app-offline-profile/SKILL.md`.

## Target layout
```
lib/
├── app/           # MaterialApp, router, bootstrap
├── core/          # theme, constants, models, services, utils
├── features/      # feature modules (UI + local state)
└── shared/        # cross-feature widgets
```

Until folders exist, place new code toward this layout rather than dumping everything in `lib/main.dart`.

## Consistency rules
- Offline-first for scores/levels; no DHIS2 dependency for core play
- Profile gates **persistence**, not play access
- Separate SFX and BGM settings
- Swipe on touch; arrow keys on desktop
- Responsive board + rotation support
- Theme tokens centralized — no purple default Material demos
- Package imports: `package:snake_app/...`
- Descriptive loop indexes (not `i`/`j`/`k`)
- Update docs when behavior/architecture/theme changes
- App icon source: `assets/app-icon.png` via `flutter_launcher_icons` in `pubspec.yaml`

## After any code change — check what changed
```bash
git status
git diff
```

Catch accidental files, confirm test/doc scope, and update `.cursor/` if conventions drifted.

## Required verification
```bash
flutter pub get
flutter analyze
flutter test
```

`flutter analyze` must report no errors. Prefer targeted tests for narrow changes.

## Documentation sync
| Change type | Update |
|-------------|--------|
| Feature / acceptance | `docs/IMPLEMENTATION_PLAN.md` |
| Screens / flows | `docs/UX_DESIGN.md` |
| Colors / type | `docs/THEME_AND_COLORS.md` |
| Structure / packages | `docs/ARCHITECTURE.md` |
| Icon / branding mark | `docs/APP_ICON_CONCEPT.md` |
| CI / desktop builds | `docs/CI.md` + `.github/workflows/` |
| Overview | `README.md` |

## Related skills
- [snake-app-gameplay](../snake-app-gameplay/SKILL.md)
- [snake-app-offline-profile](../snake-app-offline-profile/SKILL.md)
