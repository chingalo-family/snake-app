# Continuous Integration

GitHub Actions for Snake App — inspired by Kanisani Hub desktop CI patterns.

## Workflows

| Workflow | File | Purpose |
|----------|------|---------|
| Flutter CI — Analyze & Test | `.github/workflows/flutter-ci.yml` | `flutter analyze`, `flutter test`, coverage artifact |
| Desktop — Build | `.github/workflows/desktop-build.yml` | Release builds for Windows, macOS, Linux + **GitHub Release** |

## Triggers

- **Push / PR to `main`** — run tests; build desktop zips
- **Push to `main` or manual `workflow_dispatch` on `main`** — after all three desktop builds succeed, create/update a GitHub Release
- Docs / `.cursor` / markdown-only changes are ignored for CI paths

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

## Notes

- macOS CI builds are typically **unsigned**. First open on a Mac may require right-click → Open.
- Linux CI installs GTK/CMake toolchains on `ubuntu-latest`.
- Bump `version:` in `pubspec.yaml` (especially the `+build` number) before merging to `main` when you want a new release tag.
