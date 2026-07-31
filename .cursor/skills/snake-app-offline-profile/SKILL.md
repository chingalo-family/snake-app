---
name: snake-app-offline-profile
description: Snake App local profile and offline high-score/level persistence. Use when implementing profile forms, score saving, level unlock storage, or gates that require a user before persisting progress.
---

# Snake App Offline Profile Skill

Use when working on local player profile, offline score/level persistence, or the “create profile to save” gate.

## Read first
- `docs/IMPLEMENTATION_PLAN.md` §4.9
- `docs/UX_DESIGN.md` (Profile + Game over sheets)
- Project skill: `.cursor/skills/snake-app-project/SKILL.md`

## Product rules
1. **Play without profile is allowed**
2. **Saving high scores and highest levels requires a profile**
3. Storage is **local** (SQLite/Drift/Hive + SharedPreferences) — offline-first
4. No DHIS2 / remote auth dependency for MVP core saves

## Profile fields
| Field | Required |
|-------|----------|
| Username | Yes (unique locally) |
| Full name | Yes |
| Email | Optional |
| Phone number | Optional |

## Persistence gate
```
onGameOver / submitScore / unlockLevel
  if (!hasProfile) → prompt CreateProfile (do not silently discard if user opts in)
  else → upsert bests + level unlocks
```

## Suggested local records
- `profile` — id, username, fullName, email?, phone?, createdAt, updatedAt
- `high_scores` — profileId, level, score, achievedAt
- `progress` — profileId, highestLevelUnlocked, gamesPlayed, bestOverallScore
- Prefs flags: `onboarding_completed`, settings toggles

## UI expectations
- Game over without profile: primary CTA **Save score — create profile**
- Profile screen: edit fields + stats (best score, highest level, games played)
- Validate username/full name before save; optional fields never block play

## Migration hygiene
- Do not casually rename/drop persisted columns
- Version schema; append migrations
- Keep save paths backward-compatible when possible

## Tests to prefer
- Submit score without profile → no DB best written (or pending until profile created)
- Submit with profile → best updated only when higher
- Level unlock persisted and reloaded after app restart (mocked storage OK)

## Do not
- Force sign-in before first Play
- Sync scores to a server as a blocker for local save
- Store passwords for local MVP profile (not an auth account)
