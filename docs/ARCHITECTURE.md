# Snake App — Architecture Notes

## Principles

1. **Offline-first** — core play, scores, levels, and profile work without network
2. **Feature modules** — UI + state colocated under `features/`
3. **Thin services** — audio, storage, updates have single responsibilities
4. **Responsive by construction** — grid metrics from constraints, not hard-coded portrait sizes
5. **Platform-correct input** — touch gestures vs keyboard focus handled in the game feature

## Layers

```
UI (features/*)
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
  if (!profileExists) → prompt CreateProfile
  else → upsert best scores / level unlocks
```

## Updates (Android)

```
App start → package_info version
         → in_app_update check OR Play Store scrape/listing open
         → dialog → update / dismiss
```

## Testing focus

- Grid math unit tests (columns/rows for sample sizes)
- Direction reverse rejection
- Level unlock rules
- Profile required for persistence
- Settings toggles mute the correct audio channel
