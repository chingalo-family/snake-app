# Backend Schema

Snake App has no remote backend. Persistence is an on-device Drift database plus shared preferences. This document is the local schema.

**File:** `snake_app.db`  
**Definition:** `lib/core/offline_db/`  
**Schema version:** `1 + migration count`. The only migration adds `profile.avatar_id`, so the current version is **2**.

New installs create all tables. Upgrades run each migration whose target version is greater than `from` and less than or equal to `to`.

## `profile`

One row is the local player. Guest play does not insert a row.

| Column | Type | Notes |
|--------|------|--------|
| `id` | integer PK | Autoincrement |
| `username` | text | Required |
| `full_name` | text | Required |
| `avatar_id` | text | Default `snake`. Added in schema version 2 |
| `email` | text | Nullable |
| `phone` | text | Nullable |
| `created_at` | datetime | |
| `updated_at` | datetime | |

## `progress`

One row per profile. Primary key is `profile_id`.

| Column | Type | Default |
|--------|------|---------|
| `profile_id` | integer PK | |
| `highest_level_unlocked` | integer | 1 |
| `games_played` | integer | 0 |
| `best_overall_score` | integer | 0 |
| `best_combo` | integer | 0 |

## `high_scores`

Best score for a profile on one campaign level.

| Column | Type | Notes |
|--------|------|--------|
| `id` | integer PK | Autoincrement |
| `profile_id` | integer | |
| `level` | integer | Campaign level number |
| `score` | integer | Best score for that level |
| `achieved_at` | datetime | |

Unique key: (`profile_id`, `level`).

## What is not in SQLite

| Data | Store | Key pattern |
|------|--------|-------------|
| Settings and cosmetics | SharedPreferences | See `preference_keys.dart` |
| Challenge personal bests | SharedPreferences | `challenge_bests_{profileId}` |
| Challenge ghost trace | SharedPreferences | `challenge_ghost_{profileId}_{challengeId}` (trimmed to 4000 characters) |
| Unsaved guest run | Memory (`PendingRun`) | Written only after a profile exists |

## Write rules

- `submitScore` with no profile stashes the latest run in memory and asks the player to create a profile. It does not insert high scores.
- After a profile save, that pending run is flushed: upsert the level best, update overall best, games played, best combo, and `highest_level_unlocked` when the unlock score is met.
- Challenge results do not create `high_scores` rows. They update the preference keys for that profile.

## Relations

```
profile 1 ── 1 progress
profile 1 ── * high_scores
```

There is no foreign-key cascade declared in the Drift tables. Application code treats `profile.id` as the owner of `progress.profile_id` and `high_scores.profile_id`.
