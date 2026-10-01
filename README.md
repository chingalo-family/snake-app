# Snake App

Offline-first snake game by **Chingalo Family**. Grow, collect, climb 30 levels, and chase local high scores - without a cloud account for core play.

| | |
|--|--|
| **Package ID** | `chingalo.family.snake_app` |
| **Display name** | Snake App |
| **Version** | `2.0.0+4` |
| **Platforms** | Android, iOS, Linux, macOS, Windows, Web |
| **Google Play** | [chingalo.family.snake_app](https://play.google.com/store/apps/details?id=chingalo.family.snake_app) |

## Get the app

- **Android:** [Snake App on Google Play](https://play.google.com/store/apps/details?id=chingalo.family.snake_app)
- **Desktop:** GitHub Release zips (Windows, macOS, Linux) - see [Technical requirements](docs/TECHNICAL_REQUIREMENTS.md)
- **iOS:** App Store listing is not published yet (`appStoreId` is still empty in code)

## Features

- First-run onboarding, then splash → home
- Responsive playground (phone, tablet, desktop, rotation)
- Swipe on touch · arrow keys on desktop
- Thirty levels mixing **Classic**, **Wrap**, **Maze**, and **Wrap maze**
- Challenges hub (timed sprints, daily run, and other local modes) beside the campaign
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

See [docs/TECHNICAL_REQUIREMENTS.md](docs/TECHNICAL_REQUIREMENTS.md) for platforms, tests, Drift codegen, and Linux desktop packages.

### Linux desktop build deps

On Debian/Ubuntu, install Flutter Linux toolchain packages and GStreamer (required by `audioplayers`):

```bash
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
```

See [docs/TECHNICAL_REQUIREMENTS.md](docs/TECHNICAL_REQUIREMENTS.md) for the full CI package list.

## Test and lint

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test --coverage
```

These match [`.github/workflows/flutter-ci.yml`](.github/workflows/flutter-ci.yml).

## CI

GitHub Actions are **manual only** (`workflow_dispatch`). They do not run on push or pull request. From Actions, run **Flutter CI** (analyze + tests) or **Desktop - Build** (Windows, macOS, Linux zips). A desktop run on `main` publishes a **GitHub Release**. See [docs/TECHNICAL_REQUIREMENTS.md](docs/TECHNICAL_REQUIREMENTS.md).

## Documentation

| Doc | Description |
|-----|-------------|
| [Product requirements](docs/PRODUCT_REQUIREMENTS.md) | Audience, scope, and success criteria |
| [Technical requirements](docs/TECHNICAL_REQUIREMENTS.md) | Stack, quality gates, CI, local preference keys |
| [App flow](docs/APP_FLOW.md) | Routes and screen-by-screen flow |
| [UI/UX design brief](docs/UI_UX_DESIGN_BRIEF.md) | Palette, screen rules, feedback |
| [Backend schema](docs/BACKEND_SCHEMA.md) | On-device Drift tables and preference stores |
| [Implementation plan](docs/IMPLEMENTATION_PLAN.md) | Shipped modules and acceptance checks |
| [Architecture](docs/ARCHITECTURE.md) | Layers, engine, startup, profile gate |
| [Contributing](CONTRIBUTING.md) | How to send changes |
| [Security](SECURITY.md) | Vulnerability reporting |
| [Code of Conduct](CODE_OF_CONDUCT.md) | Community standards |
| [Cursor setup](.cursor/README.md) | Project rules & agent skills |

Marketing site (separate repo): [chingalo-family/snake-app-website](https://github.com/chingalo-family/snake-app-website).

## Environment variables

This app does not use `.env` files or compile-time environment variables. Player settings and progress are stored on device. See [docs/TECHNICAL_REQUIREMENTS.md](docs/TECHNICAL_REQUIREMENTS.md) and [docs/BACKEND_SCHEMA.md](docs/BACKEND_SCHEMA.md).

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md). We use [Conventional Commits](https://www.conventionalcommits.org/) and pull requests against `main`.

## License

[BSD 3-Clause](LICENSE).
