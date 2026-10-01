---
name: snake-app-offline-profile
description: Snake App local profile and offline high-score/level persistence. Use when implementing profile forms, score saving, level unlock storage, or gates that require a user before persisting progress.
---

# Snake App Offline Profile Skill

Use when working on local player profile, offline score/level persistence, or the “create profile to save” gate.

## Read first
- `docs/IMPLEMENTATION_PLAN.md`
- `docs/BACKEND_SCHEMA.md`
- `docs/APP_FLOW.md` (Profile and game over)
- Project skill: `.cursor/skills/snake-app-project/SKILL.md`
- Inspiration: `duka_mkononi_app` Drift + PreferenceService split

## Product rules
1. **Play without profile is allowed**
2. **Saving high scores and highest levels requires a profile**
3. Storage is **local** - offline-first
4. No DHIS2 / remote auth dependency for MVP core saves

## Storage split (Duka-style)

| Store | Technology | Contents |
|-------|------------|----------|
| Domain DB | **Drift `AppDatabase`** (SQLite) | `profile`, `progress`, `high_scores` |
| Preferences | **`PreferenceService`** → SharedPreferences | sfx, bgm, haptics, hints, theme, locale, onboarding |

**No flutter_secure_storage for MVP** - profiles have no passwords. If secrets are added later, use a dedicated secure-storage service (do not store secrets in Drift plaintext or prefs).

## Profile fields
| Field | Required |
|-------|----------|
| Name | Yes |
| Avatar | Yes (pick from suggested catalog) |
| Email | Optional |
| Phone number | Optional |

## Persistence gate
```
onGameOver / submitScore / unlockLevel
  if (!hasProfile)
    → stash PendingRun (level, score, bestCombo)
    → prompt CreateProfile (do not silently discard if user opts in)
    → after createOrUpdate → flush PendingRun with submitRun
  else → upsert bests + level unlocks
```

## Drift layout
```
lib/core/offline_db/
  app_database.dart              # @DriftDatabase + singleton instance
  app_database.g.dart            # generated - run build_runner
  offline_database_migrations.dart
  database_path.dart
  connection/                    # native + web conditional export
  tables/                        # Profiles, ProgressEntries, HighScores
```

- Access via `ProfileRepository(AppDatabase)` / `appDatabaseProvider`
- Tests: `AppDatabase.forTesting(NativeDatabase.memory())`
- Schema changes: edit tables → append migration → `dart run build_runner build`

## Preferences
- Keys: `lib/core/constants/preference_keys.dart`
- Typed API: `SettingsService` on top of `PreferenceService`

## UI expectations
- Game over without profile: primary CTA **Save score - create profile**
- Profile screen: avatar picker + name/email/phone + stats (best score, highest level, games played)
- Validate name and optional email/phone before save (`ProfileValidators`)
- After successful save → snackbar + navigate to Home

## Migration hygiene
- Do not casually rename/drop persisted columns
- Version schema via append-only Drift migrations
- Keep save paths backward-compatible when possible

## Tests to prefer
- Submit score without profile → no DB best written; PendingRun stashed
- Create profile after guest run → pending score flushed to Drift
- Submit with profile → best updated only when higher
- Level unlock persisted (in-memory Drift OK)

## Naming (persistence code)
- Prefer `database`, `profileRepository`, `preferenceService`, `profileId`, `highestLevelUnlocked`
- Avoid `db`, `repo`, `prefs`, cryptic abbreviations
- See project skill Naming section for full rules

## Do not
- Force sign-in before first Play
- Sync scores to a server as a blocker for local save
- Store passwords for local MVP profile (not an auth account)
- Use cryptic abbreviations in repository/service locals
- Reintroduce sqflite for domain tables - use Drift
