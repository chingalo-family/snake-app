# Snake App

Offline-first snake game by **Chingalo Family**. Grow, collect, climb 30 levels, and chase local high scores — without a cloud account for core play.

| | |
|--|--|
| **Package ID** | `chingalo.family.snake_app` |
| **Display name** | Snake App |
| **Version** | `1.1.0+2` |
| **Platforms** | Android, iOS, Linux, macOS, Windows, Web |
| **Google Play** | [chingalo.family.snake_app](https://play.google.com/store/apps/details?id=chingalo.family.snake_app) |

## Get the app

- **Android:** [Snake App on Google Play](https://play.google.com/store/apps/details?id=chingalo.family.snake_app)
- **Desktop:** GitHub Release zips (Windows, macOS, Linux) — see [CI](docs/CI.md)
- **iOS:** App Store listing is not published yet (`appStoreId` is still empty in code)

## Features

- First-run onboarding, then splash → home
- Responsive playground (phone, tablet, desktop, rotation)
- Swipe on touch · arrow keys on desktop
- Thirty levels mixing **Classic**, **Wrap**, **Maze**, and **Wrap maze**
- Animal and object collectibles with tiered scores and combos
- Independent SFX and background music toggles
- Optional local profile: play as a guest; create a profile to save scores and unlocks
- Offline high scores and level progress (Drift / SQLite)
- English and Kiswahili; light, dark, and system themes
- Share a branded score image; Android update CTA opens the live Play Store listing

## Tech stack

- **Flutter / Dart** (`sdk: ^3.12.2`)
- **Riverpod** for app state
- **go_router** for navigation
- **Drift** + SQLite for offline profile, scores, and progress
- **shared_preferences** for settings
- **audioplayers** for BGM and SFX

Package manager: **pub** (`flutter pub get`).

## Quick start

```bash
git clone https://github.com/chingalo-family/snake-app.git
cd snake-app
flutter pub get
flutter run
```

See [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md) for platforms, tests, Drift codegen, and Linux desktop packages.

### Linux desktop build deps

On Debian/Ubuntu, install Flutter Linux toolchain packages and GStreamer (required by `audioplayers`):

```bash
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
```

See [docs/CI.md](docs/CI.md) for the full CI package list.

## Test and lint

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test --coverage
```

These match [`.github/workflows/flutter-ci.yml`](.github/workflows/flutter-ci.yml).

## CI

GitHub Actions are **manual only** (`workflow_dispatch`). They do not run on push or pull request. From Actions, run **Flutter CI** (analyze + tests) or **Desktop — Build** (Windows, macOS, Linux zips). A desktop run on `main` publishes a **GitHub Release**. See [docs/CI.md](docs/CI.md).

## Documentation

| Doc | Description |
|-----|-------------|
| [Getting started](docs/GETTING_STARTED.md) | Clone, run, test, project layout |
| [Implementation Plan](docs/IMPLEMENTATION_PLAN.md) | Features, phases, acceptance criteria |
| [UX Design](docs/UX_DESIGN.md) | Screens, flows, controls, feedback |
| [Theme & Colors](docs/THEME_AND_COLORS.md) | Palette, typography, Flutter theme tokens |
| [App Icon Concept](docs/APP_ICON_CONCEPT.md) | Icon directions & asset checklist |
| [Architecture](docs/ARCHITECTURE.md) | Technical structure |
| [Game Modes](docs/GAME_MODES.md) | Classic / Wrap / Maze / Wrap maze |
| [CI / GitHub Actions](docs/CI.md) | Test + desktop build workflows |
| [Contributing](CONTRIBUTING.md) | How to send changes |
| [Security](SECURITY.md) | Vulnerability reporting |
| [Code of Conduct](CODE_OF_CONDUCT.md) | Community standards |
| [Cursor setup](.cursor/README.md) | Project rules & agent skills |

Marketing site (separate repo): [chingalo-family/snake-app-website](https://github.com/chingalo-family/snake-app-website).

## Environment variables

This app does not use `.env` files or compile-time environment variables. Player settings and progress are stored on device. See [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md#environment-and-local-data).

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md). We use [Conventional Commits](https://www.conventionalcommits.org/) and pull requests against `main`.

## License

[BSD 3-Clause](LICENSE).
