# Snake App — Game experience (current vs next)

**Status:** Current = shipped in **1.1.0+2**. Next = planned full releases — not live until implemented.  
**Related:** [UX_DESIGN.md](./UX_DESIGN.md) · [UX_ENHANCEMENTS.md](./UX_ENHANCEMENTS.md) · [GAME_MODES.md](./GAME_MODES.md) · [releases/](./releases/README.md)

This file answers: **what should feel better** for players, without changing swipe, campaign Play, or offline saves.

---

## What players have today

| Loop | Experience |
|------|------------|
| Open app | Splash → Home (Play FAB, scores, profile, settings) |
| Play | Level select (30 levels) → playground → pause / game over |
| Variety | **Classic**, **Wrap**, **Maze**, **Wrap maze** + faster ticks and denser boards |
| Score | Tiered collectibles + combos; unlock next level by score |
| Save | Guest can play; profile keeps bests and unlocks |
| End | Game over sheet, share image, retry |

Controls, theme, languages, and rotation stay as in [UX_DESIGN.md](./UX_DESIGN.md).

---

## Experience gaps (why more modes help)

The ladder already teaches **walls vs wrap vs rocks**. Returning players still mostly do one thing: **don’t die until the score gate**. That is a strong core, but sessions feel similar.

| Gap | Player feel | Better experience |
|-----|-------------|-------------------|
| No short session | Opening the app means a campaign run | **Sprint** — 60/90s, comparable score |
| No low-pressure mode | Every run can fail a level | **Zen** — grow until you stop |
| No “I cleared it” | Maze is still score-or-die | **Collector** — eat N targets and win |
| Rules only change by level number | Same Home every day | **Challenges** next to Play (one extra entry) |
| Food is static after spawn | Routing is the only skill | Timed **bonus critter**, later **bitter fruit** / **burrows** |
| No clutch | Combos reward routing only | **Shield** and **Dash** (same swipe) |
| High scores are campaign-only | Nothing “today” or vs yesterday’s self | **Daily seed** + **ghost** (device-local) |

Do **not** fill these gaps by adding a mode wall on Home, a joystick, or online arenas. See the UX contract in [releases/README.md](./releases/README.md).

---

## How new experiences show up

```
Home
  Play  →  Levels (unchanged 30-level campaign)
  Challenges  →  Sprint, then Zen, Collector, …   (one secondary entry)
```

- **Play** stays the primary CTA.
- Each new rule has a **chip + one-line tip before Start** (same as Wrap / Maze).
- Teach in Challenges first; add at most a few expert **campaign** levels later.
- English + Kiswahili for every new string.

---

## Full releases that close the gaps

| Release | Experience added | Spec |
|---------|------------------|------|
| **1.2** | Timed high-score session | [releases/1.2-sprint.md](./releases/1.2-sprint.md) |
| **1.3** | Practice + real level clear | [releases/1.3-zen-collector.md](./releases/1.3-zen-collector.md) |
| **1.4** | Familiar food spice + rising rocks | [releases/1.4-bonus-growing-walls.md](./releases/1.4-bonus-growing-walls.md) |
| **1.5** | New board rules, same steering | [releases/1.5-burrows-bitter-fruit.md](./releases/1.5-burrows-bitter-fruit.md) |
| **1.6** | Clutch moments in the HUD | [releases/1.6-shield-dash.md](./releases/1.6-shield-dash.md) |
| **1.7** | Come back today; beat your ghost | [releases/1.7-daily-ghost.md](./releases/1.7-daily-ghost.md) |
| **2.0** | Optional extra pillar | [releases/2.0-optional.md](./releases/2.0-optional.md) |

Inspiration and skip lists: [plans/](./plans/README.md). Store one-liners stay planning-only until that version ships.
