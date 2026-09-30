# Getting started

This guide is for running **Snake App** from source. The Dart package name is `snake_app`; the GitHub repository is [chingalo-family/snake-app](https://github.com/chingalo-family/snake-app).

Android users can install the published build from [Google Play](https://play.google.com/store/apps/details?id=chingalo.family.snake_app).

## Prerequisites

- Flutter **stable** ([install](https://docs.flutter.dev/get-started/install))
- Dart SDK **^3.12.2** (see `environment.sdk` in `pubspec.yaml`)
- A device, emulator, or desktop target (`flutter devices`)

Confirm the toolchain:

```bash
flutter doctor
flutter --version
```

### Linux desktop extras

`flutter build linux` / `flutter run -d linux` need the Flutter Linux toolchain **and** GStreamer headers used by `audioplayers`:

```bash
sudo apt-get update -y
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
```

Optional runtime plugins for extra audio formats:

```bash
sudo apt-get install -y \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good
```

## Install and run

```bash
git clone https://github.com/chingalo-family/snake-app.git
cd snake-app
flutter pub get
flutter run
```

Useful variants:

```bash
flutter run -d chrome
flutter run -d macos
flutter run -d linux
flutter run -d windows
```

Entry point: `lib/main.dart` (`main()` paints `StartupGate`, then `bootstrap()` → `SnakeApp`). Launch does not wait on prefs, SQLite, or audio before the first frame.

## Test, analyze, and generate

```bash
flutter analyze --fatal-infos
flutter test
flutter test --coverage
```

After changing Drift tables or `lib/core/offline_db/app_database.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Regenerate launcher icons from `assets/app-icon.png` (see `flutter_launcher_icons` in `pubspec.yaml`):

```bash
dart run flutter_launcher_icons
```

Release builds used in CI:

```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## Environment and local data

There is **no** `.env` file and the app does not read compile-time environment variables.

Settings are stored on device with **SharedPreferences**. Keys (see `lib/core/constants/preference_keys.dart`):

| Key | Purpose |
|-----|---------|
| `sfx_enabled` | Sound effects on/off (default on) |
| `bgm_enabled` | Background music on/off (default off) |
| `haptics_enabled` | Haptic feedback on mobile |
| `show_control_hints` | On-board swipe / keyboard tips |
| `theme_mode` | `system` / `light` / `dark` |
| `locale_code` | `en` or `sw` |
| `onboarding_completed` | First-run onboarding finished |
| `snake_skin_id` | Selected cosmetic snake look |
| `show_daily_tip` | Daily quote card visibility |
| `daily_quote_last_index` | Last shown daily quote index |

Offline profile, high scores, and level progress use Drift. Database file name: `snake_app.db` (`lib/core/offline_db/database_path.dart`).

## Project structure

```text
.
├── lib/
│   ├── main.dart                 # App entry
│   ├── app/                      # MaterialApp, router, bootstrap, providers
│   ├── core/
│   │   ├── bootstrap/            # Desktop window setup
│   │   ├── constants/            # App IDs, levels, collectibles, prefs keys
│   │   ├── game/                 # Snake engine, obstacle generator
│   │   ├── l10n/                 # l10n helpers
│   │   ├── models/
│   │   ├── offline_db/           # Drift schema, migrations, connections
│   │   ├── services/             # Audio, settings, profile, updates, share
│   │   ├── theme/
│   │   └── utils/
│   ├── modules/                  # Screens (UI + local widgets)
│   │   ├── splash/
│   │   ├── onboarding/
│   │   ├── home/
│   │   ├── levels/
│   │   ├── game/
│   │   ├── profile/
│   │   ├── scores/
│   │   ├── settings/
│   │   └── about/
│   ├── shared/                   # Cross-module widgets
│   └── l10n/                     # ARB files (en, sw) + generated localizations
├── test/                         # Unit and widget tests
├── assets/
│   ├── app-icon.png
│   ├── audio/                    # BGM / SFX (see ATTRIBUTION.md)
│   └── fonts/
├── android/ ios/ linux/ macos/ web/ windows/
├── docs/                         # Product and engineering docs
│   ├── plans/                    # Suggested future modes (inspiration)
│   └── releases/                 # Next full-release experience specs
├── .github/
│   ├── workflows/                # flutter-ci.yml, desktop-build.yml
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
├── pubspec.yaml
├── analysis_options.yaml
└── l10n.yaml
```

## Next

- [CONTRIBUTING.md](../CONTRIBUTING.md) — commits, PRs, conventions
- [docs/ARCHITECTURE.md](ARCHITECTURE.md) — module layout and persistence
- [docs/UX_DESIGN.md](UX_DESIGN.md) — shipped screens and controls
- [docs/UX_ENHANCEMENTS.md](UX_ENHANCEMENTS.md) — planned UI for next releases
- [docs/GAME_MODES.md](GAME_MODES.md) — shipped play modes
- [docs/GAME_EXPERIENCE.md](GAME_EXPERIENCE.md) — current vs next experience
- [docs/releases/](releases/README.md) — next full release specs (1.2–2.0)
- [docs/plans/](plans/README.md) — suggested future modes and play loops
- [docs/CI.md](CI.md) — GitHub Actions and release zips
