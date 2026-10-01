---
name: snake-app-community-docs
description: Keep open-source community-health files accurate when Snake App source, stack, CI, store listings, or contributor workflow change. Use after editing pubspec.yaml, lib/, test/, .github/workflows, analysis_options, l10n, or when updating README, CONTRIBUTING, SECURITY, CODE_OF_CONDUCT, TECHNICAL_REQUIREMENTS, LICENSE, or GitHub issue/PR templates.
---

# Snake App Community Docs

After **source** changes, update community-health files in the **same change set** if facts they state drifted. Do not invent commands, env vars, emails, or store listings.

## Files this skill owns

| File | Must stay true to |
|------|-------------------|
| `README.md` | Product one-liner, features, stack, clone/run/test, Play listing, license |
| `docs/TECHNICAL_REQUIREMENTS.md` | Prereqs, commands, CI, prefs keys, no fake `.env` |
| `CONTRIBUTING.md` | Flutter/pub commands, Conventional Commits, PR target `main` |
| `SECURITY.md` | Reporting path; supported version from `pubspec.yaml` |
| `CODE_OF_CONDUCT.md` | Enforcement contact only (do not rewrite Covenant text) |
| `.github/PULL_REQUEST_TEMPLATE.md` | Analyze/test checklist matching CI |
| `.github/ISSUE_TEMPLATE/*` | Platforms, version field, security contact link |
| `LICENSE` | BSD 3-Clause - **do not change** unless the user asks |

Also keep `docs/TECHNICAL_REQUIREMENTS.md` aligned when workflows change (existing product docs skill still applies).

## Constants (do not “correct” without evidence)

- GitHub: `chingalo-family/snake-app`
- Package ID: `chingalo.family.snake_app`
- Security + conduct email: `chingalo.family@gmail.com`
- Google Play (live): `https://play.google.com/store/apps/details?id=chingalo.family.snake_app`
- iOS App Store: only if `AppConstants.appStoreId` in `lib/core/constants/app_constants.dart` is non-empty
- Commits: Conventional Commits; PRs against `main`

## When source changes, what to patch

Inspect `pubspec.yaml`, `lib/`, `test/`, `.github/workflows/`, `analysis_options.yaml`, `l10n.yaml` - never guess.

| Source change | Update |
|---------------|--------|
| `pubspec.yaml` version / SDK / dependencies | README version + stack; TECHNICAL_REQUIREMENTS prereqs; SECURITY supported version |
| New/removed module under `lib/modules/` or `lib/app/` | ARCHITECTURE module map; README features if user-visible |
| New SharedPreferences keys | TECHNICAL_REQUIREMENTS preference table (`preference_keys.dart`) |
| New real env / dart-define / `.env.example` | TECHNICAL_REQUIREMENTS + README (only names found in repo) |
| `flutter analyze` / `flutter test` / workflow commands | README, TECHNICAL_REQUIREMENTS, CONTRIBUTING, PR template |
| Platforms, desktop Linux packages, audio/GStreamer | README + TECHNICAL_REQUIREMENTS |
| Store IDs / Play or App Store live status | README Get the app; PRODUCT_REQUIREMENTS platforms |
| Contact email | SECURITY, CODE_OF_CONDUCT, issue templates |
| Drift schema / `build_runner` | BACKEND_SCHEMA + CONTRIBUTING codegen steps |
| CI triggers or branch | CONTRIBUTING, README, TECHNICAL_REQUIREMENTS (today: `workflow_dispatch` only) |

If a fact is **not** in the repo, leave `<!-- TODO: ... -->` rather than fabricating it.

## Accuracy rules

- Commands must match CI: `flutter pub get`, `flutter analyze --fatal-infos`, `flutter test` / `--coverage`
- No `.env` section unless a file or `String.fromEnvironment` exists
- README features = **implemented** behavior, not stale “planned” lists
- Marketing claims that also appear on the website: update `../snake-app-website/docs/` when that checkout exists
- Do not rewrite LICENSE text or switch license family

## Finish checklist

- [ ] Community files still match `pubspec.yaml` and actual scripts/workflows
- [ ] Emails and Play URL unchanged unless the user requested a change
- [ ] No leftover `chingao.family` or placeholder `<org>/<repo>`
