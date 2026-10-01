# Technical Requirements Document

**Package:** `snake_app`  
**Version:** `2.0.0+4` (`pubspec.yaml`)  
**SDK:** Dart `^3.12.2`  
**Package manager:** pub (`flutter pub get`)

## Stack

| Concern | Requirement |
|---------|-------------|
| UI | Flutter, Material, Nunito |
| State | Riverpod (`flutter_riverpod`) |
| Navigation | go_router |
| Profile, progress, level scores | Drift + SQLite file `snake_app.db` |
| Settings, cosmetics, challenge bests, ghost traces | `shared_preferences` |
| Audio | `audioplayers`, separate SFX and BGM players |
| App info and store links | `package_info_plus`, `url_launcher` |
| Share | `share_plus` |
| Desktop window | `window_manager`, `screen_retriever` |
| Copy | `flutter_localizations` + ARB (English, Kiswahili) |

There is no application server, no `.env` file, and no compile-time environment variables.

## Runtime requirements

- Core play, pause, game over, settings, and local saves work offline.
- `main` calls `runApp` before preferences, SQLite, and audio finish. `StartupGate` completes those steps with timeouts so a blocked plugin cannot hold the native launch screen.
- The board size comes from the available constraints (`GridMetrics`), including rotation. Positions remap by row and column when the grid changes.
- Touch and keyboard input are platform-correct. Reversing into the snake’s own body is rejected.
- Sound effects default on. Music defaults off. Each channel mutes independently.
- Android keeps the default task affinity so Play’s Open action does not host the game inside the store task. Impeller stays on.
- SQLite path is implemented for Android, iOS, macOS, Linux, and Windows. Other platforms are unsupported for the offline database.

## Quality gates

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test --coverage
```

These match `.github/workflows/flutter-ci.yml`.

Drift codegen, when tables change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Continuous integration

Workflows are manual (`workflow_dispatch`). They do not run on push or pull request.

| Workflow | File | Result |
|----------|------|--------|
| Flutter CI - Analyze & Test | `.github/workflows/flutter-ci.yml` | Analyze, test, coverage artifact |
| Desktop - Build | `.github/workflows/desktop-build.yml` | Windows, macOS, and Linux zips |

A desktop run on `main`, after all three platform builds succeed, publishes a GitHub Release tagged `v{semver}-build.{build}` from `pubspec.yaml`. A run from another branch produces artifacts only.

### Linux desktop packages

Debian/Ubuntu needs the Flutter Linux toolchain and GStreamer headers used by `audioplayers`:

```bash
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
```

## Local data keys

Shared preferences (see `lib/core/constants/preference_keys.dart`):

| Key | Role |
|-----|------|
| `sfx_enabled` | Sound effects |
| `bgm_enabled` | Music |
| `haptics_enabled` | Haptics |
| `show_control_hints` | On-board control hints |
| `theme_mode` | Light, dark, or system |
| `locale_code` | Language |
| `onboarding_completed` | Skip onboarding after first run |
| `snake_skin_id` | Selected skin |
| `show_daily_tip` | Home tip card |
| `show_ghost` | Challenge ghost overlay |
| `daily_quote_last_index` | Last tip index |

Challenge bests and ghost traces use additional keys from `ChallengeProgressStore`: `challenge_bests_{profileId}` and `challenge_ghost_{profileId}_{challengeId}`.

## Non-functional requirements

- Tap targets at least 48×48 logical pixels on touch.
- Text contrast meets readable body text on brand surfaces. Locked vs unlocked states are not color-only.
- Reduce Motion disables non-essential pulses and the snake head blink.
- Android edge-to-edge: transparent system bars; interactive content clears insets.
- Startup steps that touch plugins are time-boxed. If preferences do not answer, the session uses in-memory settings and the next launch tries disk again.
