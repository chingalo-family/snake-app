---
name: snake-app-project
description: Snake App Flutter project conventions for features, verification, and docs. Use when implementing features, fixing bugs, reviewing changes, or verifying work in this repository.
---

# Snake App Project Skill

Use this skill whenever working in this repository to keep implementation style, verification, and documentation consistent.

## Project identity
- Product: **Snake App** (Chingalo Family)
- Package: `snake_app` · Application ID: `chingalo.family.snake_app`
- Stack: Flutter game, offline-first local storage (Drift `AppDatabase` + PreferenceService), SFX/BGM audio, responsive multi-platform UI
- Platforms: Android, iOS, Linux, macOS, Windows, Web
- Docs baseline: `README.md`, `docs/IMPLEMENTATION_PLAN.md`, `docs/UX_DESIGN.md`, `docs/THEME_AND_COLORS.md`, `docs/ARCHITECTURE.md`, `docs/APP_ICON_CONCEPT.md`, `docs/GAME_MODES.md`

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
- **Meaningful variable names** — see Naming below
- **User-facing copy via l10n** — English (`en`, default) and Swahili (`sw`); ARBs in `lib/l10n/`; use `context.l10n` (see `lib/core/l10n/`)
- Update docs when behavior/architecture/theme changes
- App icon source: `assets/app-icon.png` via `flutter_launcher_icons` in `pubspec.yaml`

## Naming
Names must describe **what** the value is in domain terms — not how short you can type it.

### Do
- Prefer full words: `engineSnapshot`, `packageInfo`, `sharedPreferences`, `levelConfig`, `eatEvent`, `cellIndex`
- Loop / list indexes: `rowIndex`, `columnIndex`, `levelIndex`, `pageIndex`, `collectibleIndex`, `segmentIndex`
- Booleans as predicates: `isWideLayout`, `hasProfile`, `isHighValueCollectible`
- Locals mirror their type when helpful: `LevelConfig levelConfig`, `EatEvent? eatEvent`

### Do not
- Bare loop letters: `i`, `j`, `k`
- Cryptic abbreviations: `snap`, `db`, `tp`, `rng`, `prefs`, `cfg`, `repo`, `dir` (use `direction`)
- Vague catch-alls: `data`, `temp`, `tmp`, `val`, `res`, `item`, `info`, `obj` when a domain name exists
- Single-letter locals except rare math (`x`/`y` only for true coordinates if unavoidable — prefer `velocityX` / `offsetY`)

### Allowed idioms (do not rename for purity)
- Flutter: `context`, `ref`, `child`, `key`, `theme`, `tester`
- Unused: `_`
- Package import aliases when conventional: `import 'package:path/path.dart' as p`

When editing existing code, rename unclear locals/params in the same change if you touch that file.

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

Do **not** finish a task that changed anything under `lib/` until:
1. `flutter analyze` reports **no errors**
2. `flutter test` passes — prefer the **full** suite when audio, core services, game engine, persistence/profile, or app bootstrap/providers changed (or when unsure). Targeted tests are OK only for clearly isolated tweaks.

`flutter analyze` must report no errors. Prefer targeted tests for narrow non-`lib/` or docs-only changes.

## Documentation sync
| Change type | Update |
|-------------|--------|
| Feature / acceptance | `docs/IMPLEMENTATION_PLAN.md` |
| Screens / flows | `docs/UX_DESIGN.md` |
| Colors / type | `docs/THEME_AND_COLORS.md` |
| Structure / packages | `docs/ARCHITECTURE.md` |
| Icon / branding mark | `docs/APP_ICON_CONCEPT.md` |
| Game modes (planning) | `docs/GAME_MODES.md` |
| CI / desktop builds | `docs/CI.md` + `.github/workflows/` |
| Overview | `README.md` |
| UI strings / locales | `lib/l10n/app_*.arb` (+ regenerate) |
| Marketing-facing product facts | Sibling `../snake-app-website/docs/` when that repo is present |

## Localization
- Template: `lib/l10n/app_en.arb` (default)
- Swahili: `lib/l10n/app_sw.arb`
- Access: `context.l10n` from `package:snake_app/core/l10n/l10n_extensions.dart`
- Language preference persisted in settings (`locale_code`: `en` | `sw`)
- Do not hardcode user-visible English in feature widgets — add ARB keys instead

## Related skills
- [snake-app-gameplay](../snake-app-gameplay/SKILL.md)
- [snake-app-offline-profile](../snake-app-offline-profile/SKILL.md)
