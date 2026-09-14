# Contributing to Snake App

Thanks for helping improve Snake App. By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## How we work

1. Search [existing issues](https://github.com/chingalo-family/snake-app/issues) before opening a new one.
2. Use the issue templates for bugs and feature requests.
3. Open a pull request against `main` using the [PR template](.github/PULL_REQUEST_TEMPLATE.md).
4. Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages (and the PR title).

### Conventional Commits

Format: `type(optional-scope): short description`

Common types:

| Type | Use for |
|------|---------|
| `feat` | A user-visible feature |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `test` | Tests only |
| `ci` | GitHub Actions / CI |
| `refactor` | Code change that is not a fix or feature |
| `chore` | Maintenance (deps, generated files, housekeeping) |
| `style` | Formatting that does not change behavior |
| `perf` | Performance |

Examples:

```text
feat(game): reject reverse direction on swipe
fix(profile): persist high score after first profile create
docs: clarify Linux GStreamer packages
```

## Development setup

Requirements:

- [Flutter](https://docs.flutter.dev/get-started/install) **stable** channel
- Dart SDK **^3.12.2** (from `pubspec.yaml`)

```bash
git clone https://github.com/chingalo-family/snake-app.git
cd snake-app
flutter pub get
flutter run
```

Full walkthrough: [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md).

## Quality checks

CI on PRs to `main` runs:

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test --coverage
```

Desktop builds also run on PRs (Windows, macOS, Linux). Markdown-only changes under `docs/` and `.cursor/` are skipped by path filters.

Before you open a PR that touches `lib/`:

```bash
flutter analyze --fatal-infos
flutter test
```

If you change Drift tables or `app_database.dart`, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Commit the updated `*.g.dart` files.

## Project conventions

- Offline-first for scores and levels; a local profile gates **saving**, not play access
- Separate SFX and BGM settings
- Swipe on touch; arrow keys on desktop
- User-facing strings go in `lib/l10n/app_en.arb` and `lib/l10n/app_sw.arb` (do not hardcode copy in widgets)
- Package imports: `package:snake_app/...`
- Keep `docs/` in sync when behavior, UX, theme, architecture, or CI changes
- Audio clip sources and licenses: `assets/audio/ATTRIBUTION.md`

More detail: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) and [docs/IMPLEMENTATION_PLAN.md](docs/IMPLEMENTATION_PLAN.md).

## Pull requests

- One focused change per PR when practical
- Describe **why**, not only what
- Link related issues
- Do not include secrets, local `build/` output, or IDE scratch files
- Security issues: report privately per [SECURITY.md](SECURITY.md) — do not open a public PR that discloses an exploit

## License

Contributions are accepted under the [BSD 3-Clause License](LICENSE).
