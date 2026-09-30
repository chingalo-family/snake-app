# Plan 06 — Local challenges and party play

**Status:** Planning  
**Inspired by:** Ghost/time-trial racing; daily challenges in arcade mobiles; Nokia two-player snake on some devices; Tron two-player light cycles.

Still **no account server**. Fun that you can show a sibling on the same device.

---

## G1. Ghost run

| | |
|--|--|
| **Rule** | After a PB, optionally replay with a **ghost snake** that replays your best path (or a seeded “par” path). Collision with ghost does **not** kill (ghost is cosmetic) **or** does kill in a “rival” variant — pick cosmetic for v1. |
| **Feel** | Beat your own routing. |
| **Storage** | Compressed list of directions per tick; cap length; local only. |
| **Privacy** | Never upload ghosts in MVP. |

---

## G2. Daily seed

| | |
|--|--|
| **Rule** | One `layoutId` derived from **local calendar date** (device timezone) + mode. Same day → same maze/food seed for comparable scores on that phone. |
| **Feel** | “Today’s grove” without a server. |
| **Honesty** | Different timezones ≠ global leaderboard — do not claim worldwide ranks. Show **this device, today**. |
| **HUD** | Date + mode chips. |

Offline-first and truthful.

---

## G3. Hot-seat high score

| | |
|--|--|
| **Rule** | Two (or more) local profiles take turns on the same Sprint layout. Pass-the-phone. |
| **Feel** | Party without netcode. |
| **UX** | Prompt “Hand to the next player” between runs. |

Uses existing profile model; do not invent cloud friends.

---

## G4. Two-player light cycle (desktop)

| | |
|--|--|
| **Rule** | Split controls: arrows vs WASD. Vine trails ([03](./03-nokia-and-arcade-inspired.md)). First to hit a trail loses. |
| **Platform** | Linux / macOS / Windows / keyboard web. **Skip** two-thumb swipe on one phone. |
| **Feel** | Classic party game. |

---

## G5. Share sheet (optional)

Share **score + mode + level** as text/image. No requirement to open a social SDK. Keep later; not a mode.

## Priority

Wave **G** after Waves A–C so there is something worth ghosting and dailies. Daily seed is cheap once layouts are data-driven. Two-player trail is desktop-only polish.
