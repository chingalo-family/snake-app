# Implementation Plan

**Status:** Version `2.0.0+4` is the current app. Campaign, challenges, local profile, and offline scores are implemented in `lib/`. This plan is the map of that build and the checks for changing it.

## Delivered

| Area | Where | Done when |
|------|--------|-----------|
| Startup and routing | `lib/app/` | Splash never waits on plugins before the first frame. First run opens onboarding. |
| Campaign, 30 levels | `lib/core/constants/levels.dart` | Modes follow Classic → Wrap mix → Maze → Wrap maze. Unlock uses `unlockScore`. |
| Playground | `lib/modules/game/`, `lib/core/game/` | Board size follows constraints. Swipe and arrows both work. Reverse is rejected. |
| Challenges | `lib/core/constants/challenges.dart` | Hub lists catalog runs. `/challenge/:id` uses that `RunSpec`. Daily id is date-seeded. |
| Profile and scores | `lib/core/offline_db/`, profile and scores modules | Guest run stays in memory until a profile exists, then it is stored. |
| Settings and audio | settings module, `AudioService` | SFX and music mute separately. Theme and locale persist. |
| Share and Android update | game over, scores, update service | Score image share works on supported platforms. Android can open the Play listing. |
| Copy | `lib/l10n/` | English and Kiswahili strings cover the shipped screens. |

## Module map

| Module | Responsibility |
|--------|----------------|
| `splash` | Brand frame and route to onboarding or home |
| `onboarding` | First-run controls and profile explanation |
| `home` | Play, progress, secondary navigation, tip |
| `levels` | Campaign list and start |
| `challenges` | Challenge hub |
| `game` | Board, HUD, pause, game over, campaign and challenge runs |
| `profile` | Create and edit the local profile |
| `scores` | Local bests |
| `settings` | Audio, feel, display, language, theme |
| `about` | Version, credits, policy links |

## How to change the game

1. Read this plan and [ARCHITECTURE.md](ARCHITECTURE.md) before adding a module.
2. Put UI and its state under `lib/modules/<module>/`. Shared widgets stay in `lib/shared/`.
3. Campaign numbers belong in `LevelsCatalog`. Challenge layouts belong in `ChallengesCatalog` as a `RunSpec`, not as a one-off board in the page.
4. New persisted player fields go through Drift with a migration in `offline_database_migrations.dart`. Settings keys go in `preference_keys.dart`.
5. New player-facing strings go in both ARB locales.
6. Theme colors go in `lib/core/theme/` and [UI_UX_DESIGN_BRIEF.md](UI_UX_DESIGN_BRIEF.md).
7. Run `flutter analyze --fatal-infos` and `flutter test`.

## Acceptance checks

- Onboarding can be skipped and does not show again.
- Level 1 is playable with no profile. Creating a profile afterward keeps that run’s score.
- A level stays locked until its unlock score is reached on the previous level.
- Classic ends on the wall. Wrap continues on the opposite edge. Maze ends on a blocker.
- A challenge best survives restart for the signed-in local profile.
- Turning music off leaves sound effects on, and the reverse.
- `flutter analyze --fatal-infos` and `flutter test` pass.

## Release process

GitHub Actions are started by hand. See [TECHNICAL_REQUIREMENTS.md](TECHNICAL_REQUIREMENTS.md).

- **Flutter CI** for analyze and tests.
- **Desktop - Build** on `main` for Windows, macOS, and Linux zips and a GitHub Release.
- Android store updates ship through Google Play. The in-app update action opens that listing.
- iOS store metadata stays unpublished until `AppConstants.appStoreId` is set.

## Known gaps

- `AppConstants.appStoreId` is empty, so there is no live App Store URL.
- Offline SQLite is not implemented for web.
- There is no cloud account or remote leaderboard. Do not add one as part of a local gameplay change.
