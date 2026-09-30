# Snake App — Implementation Plan

**Package ID:** `chingalo.family.snake_app`  
**Display name:** Snake App  
**Platforms:** Android, iOS, Linux, macOS, Windows, Web  
**Status:** Planning / scaffold ready — awaiting review before feature build  

This document is the primary implementation blueprint for the rebuilt Snake App. It is based on a review of the existing `snake-app` codebase and the product goals for a more engaging, responsive, offline-first experience.

---

## 1. Current App Review (Summary)

The legacy app (`../snake-app`) already includes useful building blocks:

| Area | Legacy status | Gap vs new goals |
|------|---------------|------------------|
| Swipe controls | Implemented | Works; needs cleaner gesture thresholds + landscape |
| Keyboard controls | Missing | Required for desktop (Linux / macOS / Windows) |
| Orientation | Portrait locked | Must support phone/tablet rotation |
| Food / animals scoring | Emoji food list with score tiers | Keep & expand; clearer rarity + SFX per collectible |
| Sound | Single toggle for music + effects | Split: **SFX** and **Background music** |
| Levels | Field exists; not a real progression system | Full level select, unlock, difficulty curves |
| User / saves | DHIS2 sign-in + remote sync | Local profile required to persist high scores / levels |
| Onboarding | Splash only | Multi-step first-run onboarding |
| About / Settings | Present | Keep, refresh UX + theme |
| App updates | Custom DHIS2 APK download | Prefer **Google Play Store** update check / deep link |
| Theme | Dark + cyan seed | New UX-first palette (see `THEME_AND_COLORS.md`) |

**Product direction:** keep the addictive gameplay ideas (combos, power-ups, animal collectibles), drop the DHIS2-centric auth/sync as a hard dependency for core play, and rebuild around **local profile + offline progress**, responsive boards, and platform-correct controls.

---

## 2. Product Vision

An engaging, addictive Snake game that feels premium on every device:

- Instantly understandable after a short onboarding
- Satisfying to replay through levels, collectibles, sound, and high-score chasing
- Responsive playground that stays fair and readable on phone, tablet, and desktop—including rotation
- Offline-first progress tied to a simple local player profile
- Clear Settings / About / Profile modules for trust and polish
- Gentle nudge to update when a newer Play Store version exists

---

## 3. Information Architecture

```
Splash
  ├─ First launch → Onboarding → Home
  └─ Returning → Home (optional update check)

Home
  ├─ Play → Level Select → Playground
  ├─ Profile (create / edit if needed)
  ├─ High Scores (local)
  ├─ Settings
  └─ About
```

### Modules

| Module | Purpose |
|--------|---------|
| `onboarding` | First-run tips: swipe / arrows, food values, levels, profile to save |
| `home` | Hub: Play, scores, profile status, update badge |
| `levels` | Level list, unlock state, difficulty preview |
| `game` | Responsive playground + HUD + pause / game over |
| `profile` | Username, full name; optional email / phone |
| `scores` | Offline best scores & highest level reached |
| `settings` | Audio, haptics, theme preference, controls help |
| `about` | App story, version, credits, privacy link |
| `updates` | Play Store version check + open store listing |

---

## 4. Feature Specifications

### 4.1 Onboarding

**Goal:** Teach controls and the “save progress” loop in ≤ 3–4 screens.

Suggested slides:

1. **Welcome** — brand + one-line promise (“Grow, collect, climb levels”)
2. **How to move** — device-aware: swipe demo on touch; arrow keys on desktop
3. **Collect & score** — animal/object icons with different point values
4. **Levels & profile** — unlock levels; create a profile to keep high scores offline

Actions: Skip | Next | Get Started → Home.

Persist `onboarding_completed` in local preferences.

### 4.2 About

- App name, version, package id
- Short description and feature highlights
- Chingalo Family credit
- Links: Privacy Policy, Contact (optional)
- Open-source / asset attributions if needed

### 4.3 Settings

| Setting | Default | Notes |
|---------|---------|-------|
| Sound effects | On | Eat, collide, power-up, UI taps |
| Background music | On | Looping menu / gameplay tracks; independent of SFX |
| Haptic feedback | On | Mobile only; no-op on desktop |
| Show control hints | On | First few games or until dismissed |
| Theme | System / Light / Dark | Uses brand palette tokens |
| Check for updates | Action | Manual trigger + auto on launch (Android) |

### 4.4 Responsive Playground

**Layout rules**

- Grid cell size derived from available board area (not a fixed portrait box)
- Safe areas respected (notches, system bars)
- Portrait & landscape supported on phone and tablet
- Desktop: fixed max board with letterboxing so the grid stays square/readable
- HUD (score, level, lives/power-ups) reflows: top bar in portrait; side or compact top in landscape

**Breakpoints (logical)**

| Class | Width | Grid / UI |
|-------|-------|-----------|
| Phone | < 600 | Compact HUD, larger touch targets |
| Tablet | 600–1024 | Larger board, optional side panel |
| Desktop | > 1024 | Keyboard-first, side stats optional |

**Rotation:** listen to size/orientation changes; rebuild grid metrics; pause briefly if mid-move to avoid unfair collisions on layout jump (optional soft pause).

### 4.5 Controls

| Platform | Primary | Secondary |
|----------|---------|-----------|
| Phone / tablet (touch) | Swipe (up/down/left/right) | Optional D-pad for accessibility |
| Desktop (Linux / macOS / Windows) | Arrow keys | WASD optional |
| Web | Touch and/or keyboard based on input | Same rules |

**Rules**

- Ignore reverse direction into self (classic snake)
- Debounce / threshold swipe so diagonal noise doesn’t flip direction
- Focus keyboard listener while playground is active
- Pause with Esc / system back (with confirm)

### 4.6 Scoring — Objects & Animals

Collectibles are themed objects/animals with icons and base scores. Expand legacy food list into clear tiers:

| Tier | Example icons | Base score | Spawn weight |
|------|---------------|------------|--------------|
| Common | 🍭 🍇 🍌 🍉 🍓 | 10–30 | High |
| Uncommon | 🍕 🍔 🥑 🐠 🐖 | 25–55 | Medium |
| Rare | 🎂 🦆 🐓 🐐 | 50–70 | Low |
| Epic | 🦈 🐬 🐄 🐂 🦌 | 65–90 | Very low |

**Engagement loops (recommended, phased)**

- Phase 1: tiered collectibles + SFX per tier
- Phase 2: combo multiplier for consecutive eats
- Phase 3: power-ups (speed, shield, score x2, slow-mo)

Each collect plays a short SFX; epic/rare may use a distinct cue.

### 4.7 Audio

- **SFX player** and **BGM player** as separate services
- Settings toggles apply immediately
- Pause / mute BGM on app background; resume on foreground if enabled
- Respect system silent mode where platform APIs allow (mobile)

### 4.8 Levels

Progressive difficulty, offline unlock.

Suggested model (tunable):

| Level | Speed | Grid density | Special rules |
|-------|-------|--------------|---------------|
| 1–3 | Slow | Spacious | Tutorial-friendly |
| 4–7 | Medium | Standard | Introduce rare foods |
| 8–12 | Fast | Tighter | Power-ups appear |
| 13+ | Very fast | Dense | Epic foods + hazards (optional later) |

Unlock rule examples:

- Reach score threshold on previous level, **or**
- Survive N seconds / eat N items

Persist: `highest_level_unlocked`, `best_score_per_level`, `best_score_overall`.

### 4.9 Offline Persistence & User Profile

**Saving high scores and levels requires a local user profile.**

Required fields:

- Username (unique locally)
- Full name

Optional:

- Email
- Phone number

Without a profile: player can play freely, but game-over offers “Create profile to save your score.”

With a profile:

- Auto-save best scores and highest level
- Profile module: view/edit details, stats (games played, best combo, etc.)

**Storage:** local SQLite (or Hive) + SharedPreferences for flags/settings. No account server required for MVP.

### 4.10 Google Play Updates

On Android launch (and from Settings):

1. Query Play Store listing / use Play In-App Updates API (`in_app_update`) when available
2. If newer version than `package_info_plus` version → show non-blocking or flexible update dialog
3. CTA opens Play Store page for `chingalo.family.snake_app` or starts flexible/immediate update flow

Fallback: open `market://` / HTTPS Play Store URL if in-app update unavailable.

iOS / desktop: show “You’re up to date” or platform-appropriate store link later; MVP focus is Android Play.

---

## 5. UX Principles for Engagement

1. **Fast time-to-fun** — Play from Home in one tap after onboarding
2. **Clear feedback** — score pop, haptic, SFX on every meaningful action
3. **Visible progress** — level unlock bar, personal bests always nearby
4. **Fair difficulty** — readable grid on all sizes; no surprise shrink on rotate mid-death without pause
5. **Low friction profile** — short form; optional contact fields never block play
6. **Delight without clutter** — one job per screen; HUD shows only live-critical info

---

## 6. Proposed Technical Architecture

```
lib/
├── main.dart
├── app/
│   ├── app.dart                 # MaterialApp + theme + routes
│   ├── router.dart
│   └── bootstrap.dart           # init prefs, audio, orientation
├── core/
│   ├── theme/                   # colors, typography, ThemeData
│   ├── constants/
│   ├── models/
│   ├── services/                # audio, settings, storage, updates
│   └── utils/                   # grid math, responsive helpers
├── modules/
│   ├── onboarding/
│   ├── home/
│   │   └── components/
│   ├── levels/
│   │   └── components/
│   ├── game/                    # playground, controls, HUD
│   │   ├── components/
│   │   └── utils/
│   ├── profile/
│   │   └── components/
│   ├── scores/
│   ├── settings/
│   │   └── components/
│   ├── about/
│   │   └── components/
│   └── splash/
└── shared/                      # buttons, dialogs, icons
```

**State:** Provider or Riverpod (recommend Riverpod for new app; Provider acceptable for parity with legacy).

**Key packages (planned)**

| Package | Use |
|---------|-----|
| `shared_preferences` | Flags, settings |
| `sqflite` / `drift` | Offline scores & profile |
| `audioplayers` | SFX + BGM |
| `package_info_plus` | Current version |
| `url_launcher` | Open Play Store |
| `in_app_update` | Android Play updates |
| `flutter_svg` | Icon assets if vector |

---

## 7. Implementation Phases

### Phase 0 — Scaffold & design system (current)
- [x] Flutter project `snake_app` with package `chingalo.family.snake_app`
- [x] Display name **Snake App**
- [x] Docs: plan, UX, theme, icon concept
- [ ] Apply theme tokens in `lib/core/theme`
- [ ] Empty routed shell (Home / Settings / About placeholders)

### Phase 1 — Core play loop
- [ ] Responsive grid engine (phone/tablet/desktop + rotation)
- [ ] Swipe + keyboard controls
- [ ] Collectibles with tiered scores & icons
- [ ] Pause / game over UI
- [ ] Split SFX / BGM with Settings toggles

### Phase 2 — Progression & profile
- [ ] Levels + unlock logic
- [ ] Local profile create/edit
- [ ] Gate score/level persistence on profile
- [ ] Local high-score screens

### Phase 3 — Polish & store
- [ ] Onboarding flow
- [ ] About content
- [ ] Play Store update check
- [ ] Haptics, animations, combo/power-ups (as scoped)
- [ ] App icon final assets from concept doc
- [ ] QA matrix across devices/orientations

### Phase 4 — Soft launch
- [ ] Privacy policy link
- [ ] Store listing assets
- [ ] Performance pass (60fps target on mid phones)

### Phase 5 — Next full releases (experience)
Planning only until implemented. Specs: [GAME_EXPERIENCE.md](./GAME_EXPERIENCE.md) and [releases/](./releases/README.md).

- [ ] 1.2 Sprint + Challenges
- [ ] 1.3 Zen + Collector
- [ ] 1.4 Bonus critter + growing walls
- [ ] 1.5 Burrows + bitter fruit
- [ ] 1.6 Shield + Dash
- [ ] 1.7 Daily seed + ghost + hot-seat
- [ ] 2.0 optional extra pillar after playtest

---

## 8. Acceptance Criteria (MVP)

- [ ] Onboarding shows once; skippable
- [ ] Playground usable in portrait & landscape on phone and tablet
- [ ] Touch devices move by swipe; desktop by arrow keys
- [ ] Different collectible icons yield different scores + sound
- [ ] Music and SFX independently toggleable in Settings
- [ ] At least 5 playable levels with unlock progression
- [ ] Without profile: play OK, cannot persist bests; with profile: offline bests & level reach saved
- [ ] Profile shows username, full name, optional email/phone
- [ ] About shows version and app identity
- [ ] Android can detect / deep-link to Play Store update
- [ ] Theme matches documented palette; UI remains readable and uncluttered

---

## 9. Open Questions for Review

1. Keep combos & power-ups in MVP, or Phase 1 = classic + levels only?
2. Max levels for v1 (e.g. 10 vs 20)?
3. Allow multiple local profiles on one device, or single player profile?
4. Light mode required for v1, or dark-first is enough?
5. Should optional email/phone be used for anything beyond display (e.g. future sync)?

---

## 10. Related Docs

- [UX Design & Flows](./UX_DESIGN.md)
- [UI/UX enhancements](./UX_ENHANCEMENTS.md) — Challenges hub, HUD, sheets for 1.2–1.7
- [Theme & Colors](./THEME_AND_COLORS.md)
- [Game Modes](./GAME_MODES.md) — Classic / Wrap / Maze / Wrap maze (shipped) and Phase 3–4 variants
- [Game experience](./GAME_EXPERIENCE.md) — current loops vs gaps
- [Next full releases](./releases/README.md) — 1.2–2.0 experience specs
- [Enhancement plans](./plans/README.md) — suggested modes and play loops inspired by other snake-family games
- [Versioned releases (notes)](./plans/07-versioned-releases.md) — 1.2–2.0 sequence vs current 1.1 UX
- [App Icon Concept](./APP_ICON_CONCEPT.md)
- [Architecture Notes](./ARCHITECTURE.md)
- [CI / GitHub Actions](./CI.md)

---

*Prepared for Chingalo Family review — July 2026*
