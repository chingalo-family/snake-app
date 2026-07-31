# Snake App

Engaging, addictive Snake game by **Chingalo Family**.

| | |
|--|--|
| **Package ID** | `chingalo.family.snake_app` |
| **Display name** | Snake App |
| **Platforms** | Android, iOS, Linux, macOS, Windows, Web |

## Status

Flutter scaffold is ready. Feature implementation follows the reviewed plan in `docs/`.

## Documentation (start here)

| Doc | Description |
|-----|-------------|
| [Implementation Plan](docs/IMPLEMENTATION_PLAN.md) | **Primary review doc** — features, phases, acceptance criteria |
| [UX Design](docs/UX_DESIGN.md) | Screens, flows, controls, feedback |
| [Theme & Colors](docs/THEME_AND_COLORS.md) | Palette, typography, Flutter theme tokens |
| [App Icon Concept](docs/APP_ICON_CONCEPT.md) | Icon directions & asset checklist |
| [Architecture](docs/ARCHITECTURE.md) | Technical structure |
| [CI / GitHub Actions](docs/CI.md) | Test + desktop build workflows |
| [Cursor setup](.cursor/README.md) | Project rules & agent skills |

## CI

On `main` (and PRs): analyze + tests. Desktop release zips for **Windows**, **macOS**, and **Linux** are built in Actions. After all three succeed on `main`, a **GitHub Release** is created with those zips as assets plus a change summary. See [docs/CI.md](docs/CI.md).

## Run

```bash
flutter pub get
flutter run
```

## Product highlights (planned)

- Onboarding, About, Settings
- Responsive playground (phone / tablet / rotation)
- Swipe on touch · arrow keys on desktop
- Animal & object collectibles with tiered scores
- Independent SFX and background music toggles
- Levels with offline unlock progress
- Local user profile to save high scores & levels
- Google Play update checks

## Related

Legacy experiment / previous codebase may live alongside at `../snake-app`. This project (`snake_app`) is the clean rebuild target.
