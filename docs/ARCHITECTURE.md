# Architecture Document

## Principles

1. **Offline-first.** Play, scores, levels, and profile do not need a network.
2. **Modules.** UI and state sit together under `lib/modules/<module>/`.
3. **Thin services.** Audio, storage, sharing, and updates each do one job.
4. **Responsive board.** Cell size comes from constraints, not a fixed portrait box.
5. **Platform-correct input.** Touch gestures and keyboard focus stay in the game module.

## Layout

```
lib/
├── app/            MaterialApp, router, bootstrap, StartupGate
├── core/           engine, constants, Drift, theme, services
├── modules/        splash, onboarding, home, levels, challenges,
│                   game, profile, scores, settings, about
└── shared/         widgets used by more than one module
```

A module looks like:

```
lib/modules/<module>/
├── <module>_page.dart
├── components/
├── utils/                    # optional pure helpers
└── <module>_controller.dart  # optional
```

Prefer `package:snake_app/...` imports. Large private widgets become public types in `components/`.

## Layers

```
UI (modules/*)
    ↓
State (Riverpod notifiers / controllers)
    ↓
Services (audio, settings, profile DB, challenges, updates, share)
    ↓
Local storage (Drift SQLite + SharedPreferences)
```

## Game engine

`SnakeEngine` advances a `RunSpec`:

- Campaign specs come from `LevelsCatalog` (30 levels).
- Challenge specs come from `ChallengesCatalog`.

Rules on the spec include wall behavior (solid or wrap), obstacles (none, static maze, growing, shed, vine), food behavior (standard, bonus, bitter, key/lock, pellets, fleeing), and objective (score gate, timed, endless, collect targets, eat all, peaceful fill, arena).

`GridMetrics` uses the board’s `BoxConstraints`, a target cell-size range, and column/row counts that keep the aspect. On orientation change, recompute metrics and map snake cells by row and column.

## Profile gate

```
submitScore()
  if no profile
    → keep PendingRun in memory
    → ask to create a profile
    → on save, flush the run
  else
    → upsert best score and level unlocks
```

Guest runs are not written to Drift until a profile exists.

## Startup

`main` configures system UI, then `runApp`. Preferences, SQLite, and audio finish behind `StartupGate`, each step time-boxed. If preferences do not answer, the session uses in-memory settings.

Android launch uses the brand dark background. Impeller stays enabled.

## Audio

`AudioService` owns separate BGM and SFX players. Settings mute each channel. Bootstrap starts music without blocking the first frame. App lifecycle pauses and resumes music. Clips live in `assets/audio/`. Missing music stays silent. Missing effects fall back to a system sound.

## Updates

On Android, app start can read the package version and open the Play Store listing. There is no custom APK download.

## Tests to keep

- Grid math for sample sizes
- Reverse direction rejected
- Level unlock rules
- Profile required before Drift writes
- Settings mute the correct audio channel
