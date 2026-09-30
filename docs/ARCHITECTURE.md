# Snake App — Architecture Notes

## Principles

1. **Offline-first** — core play, scores, levels, and profile work without network
2. **Modules** — UI + state colocated under `modules/` with local `components/` and optional `utils/`
3. **Thin services** — audio, storage, updates have single responsibilities
4. **Responsive by construction** — grid metrics from constraints, not hard-coded portrait sizes
5. **Platform-correct input** — touch gestures vs keyboard focus handled in the game module

## Module layout

```
lib/modules/<module>/
├── <module>_page.dart           # screen orchestration
├── components/                  # module-local widgets
├── utils/                       # optional pure helpers (e.g. game input mapping)
└── <module>_controller.dart     # optional local controller at module root
```

Large private widgets belong in `components/` as public types. Prefer
`package:snake_app/modules/...` imports. Shared cross-module widgets stay in
`lib/shared/`.

## Layers

```
UI (modules/*)
    ↓
State (ChangeNotifier / Notifiers)
    ↓
Services (audio, settings, profile_db, play_store_update)
    ↓
Local storage (sqflite + shared_preferences)
```

## Grid engine

`GridMetrics` computed from:

- `BoxConstraints` of the board region
- Target cell size range (min/max)
- Aspect-preserving column/row counts

On orientation change: recompute metrics; optionally soft-pause one frame to remount snake indices safely (map positions by row/col, not raw flat index alone).

## Profile gate

```
submitScore()
  if (!profileExists)
    → stash PendingRun in ProfileController
    → prompt CreateProfile (“Save score — create profile”)
    → on successful profile save → flush PendingRun via submitRun
  else → upsert best scores / level unlocks
```

Guest runs are not written to Drift until a profile exists; the latest unfinished
opt-in run is held in memory so creating a profile after game over still keeps
that score.

## Startup

`main` configures system UI, then calls `runApp` immediately. Prefs, SQLite, and audio finish behind `StartupGate`.

Play Store installs on some devices never leave the native launch screen if those plugins are awaited first: SharedPreferences can block behind backup restore, and the package manager can block version lookup. Each launch step is time-boxed. If preferences do not answer, the session uses in-memory settings and the next launch tries disk again.

Android keeps the default task affinity (so Play's Open button does not host the game inside the store task) and drops a duplicate launcher activity. Flutter Impeller stays **on** (the engine default); do not set `EnableImpeller` to false — that opt-out is deprecated and will be removed. If a GPU never draws the first frame, file a Flutter engine bug rather than disabling Impeller. The launch window background is the brand dark color.

## Updates (Android)

```
App start → package_info version
         → in_app_update check OR Play Store scrape/listing open
         → dialog → update / dismiss
```

## Audio

- `AudioService` owns separate BGM and SFX players (`audioplayers`).
- Settings (`sfx_enabled` / `bgm_enabled`) mute channels independently; SFX defaults **on**, BGM defaults **off**.
- Bootstrap starts `startBgm()` without blocking the first frame; app lifecycle pauses/resumes BGM in background.
- Bundled clips live under `assets/audio/` (see README there). Missing BGM → silent loop path; missing SFX → `SystemSound` fallback.
- Gameplay: eat → `playSfx`, collision/game over → `playCollision`.

## Testing focus

- Grid math unit tests (columns/rows for sample sizes)
- Direction reverse rejection
- Level unlock rules
- Profile required for persistence
- Settings toggles mute the correct audio channel
- Audio asset path constants / mute gating
