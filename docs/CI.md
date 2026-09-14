# Continuous Integration

GitHub Actions for Snake App — inspired by Kanisani Hub desktop CI patterns.

## Workflows

| Workflow | File | Purpose |
|----------|------|---------|
| Flutter CI — Analyze & Test | `.github/workflows/flutter-ci.yml` | `flutter analyze`, `flutter test`, coverage artifact |
| Desktop — Build | `.github/workflows/desktop-build.yml` | Release builds for Windows, macOS, Linux + **GitHub Release** |

## Triggers

Workflows **do not** run on push or pull request. Start them by hand:

1. GitHub → **Actions**
2. Choose **Flutter CI — Analyze & Test** or **Desktop — Build (Windows, macOS, Linux)**
3. **Run workflow** (use the `main` branch for a GitHub Release)

A desktop run **on `main`** creates/updates a GitHub Release after all three platform builds succeed. Dispatching from another branch builds artifacts only (no release).

## GitHub Release (after desktop builds)

When Windows, macOS, and Linux builds all succeed on `main`, the workflow:

1. Collects all three zip assets
2. Builds release notes with:
   - **Summary** (version, build, commit, workflow link)
   - **What changed** (commit messages since the previous release tag)
   - **Download assets** table (actual zip filenames)
   - **How to install** per platform
3. Creates a **new** GitHub Release tagged `v{semver}-build.{build}` from `pubspec.yaml`  
   Example: `version: 1.0.0+2` → tag `v1.0.0-build.2`  
   If that tag already exists (re-run), notes and assets are replaced (`--clobber`).

## Artifacts (Actions tab)

| Artifact name | Contents |
|---------------|----------|
| `snake-app-windows` | `snake-app-v{semver}-windows-x64.zip` → run `snake_app.exe` |
| `snake-app-macos` | `snake-app-v{semver}-macos-{arm64\|x64}.zip` → open `Snake App.app` |
| `snake-app-linux` | `snake-app-v{semver}-linux-x64.zip` → run `bundle/snake_app` |
| `coverage-lcov` | `coverage/lcov.info` from the test job |

## Local equivalents

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test --coverage

flutter build windows --release
flutter build macos --release
flutter build linux --release
```

### Linux system packages (Debian / Ubuntu)

`flutter build linux` needs the usual Flutter desktop toolchain **plus** GStreamer headers used by `audioplayers_linux` (`pkg_check_modules` for `gstreamer-1.0`, `gstreamer-app-1.0`, `gstreamer-audio-1.0`):

```bash
sudo apt-get update -y
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
```

Optional runtime plugins (not required to compile; useful if you play more formats locally):

```bash
sudo apt-get install -y \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good
```

CI’s Linux job installs the same build packages (plus `libstdc++-12-dev`) in `.github/workflows/desktop-build.yml`.

## Notes

- macOS CI builds are typically **unsigned**. First open on a Mac may require right-click → Open.
- Linux CI on `ubuntu-latest` installs GTK/CMake **and** GStreamer `-dev` packages so `audioplayers` can link.
- Bump `version:` in `pubspec.yaml` (especially the `+build` number), then run **Desktop — Build** on `main` when you want a new release tag.
- Android uses **AGP 8.13** + Kotlin 2.2.20 for now (see `android/settings.gradle.kts`). Flutter 3.44’s AGP 9 + Built-in Kotlin path still conflicts with some plugins; stay on AGP 8 until that stack is stable.
