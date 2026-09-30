# Plan 03 — Nokia, Nibbler, and arcade-inspired play

**Status:** Planning  
**Inspired by:** Nokia **Snake** / **Snake II** (mazes, wrap, timed bonus creatures), arcade **Nibbler** (eat everything in a maze, speed up), **Tron** light-cycle trails, classic **Snake Byte** apples-in-a-room.

Snake App’s campaign already delivers Snake II’s two big ideas: **solid walls vs wrap** and **labyrinth levels**. This file adds the missing arcade **loops**.

---

## C1. Timed bonus critter (Nokia Snake II)

| | |
|--|--|
| **Working name** | **Bonus critter** |
| **Rule** | After every M common eats, a **high-value, short-lived** animal appears (legacy Nokia: bonus after five items; value rises if you skip it). Timer ring on that tile. Miss it → despawn, next bonus worth more **or** reset — pick one and document it. |
| **Feel** | Risk a detour vs stay on the safe path. |
| **UX** | Distinct SFX/pitch for bonus eat (honor SFX toggle). Do not require new controls. |
| **Fit** | Works in Classic and Wrap; be careful in dense Maze (bonus must have a path). |

**Tests:** spawn cadence; despawn; score tier; no spawn on blockers.

This is the highest-value Nokia leftover because we already have collectible **tiers**.

---

## C2. Eat-all maze (Nibbler)

| | |
|--|--|
| **Working name** | **Clear the grove** |
| **Rule** | Many static low-value pellets fill open cells (or a pattern). Eating all **clears** the level. Optional: speed up after each full clear (stage 2 on same maze). Hitting wall/self fails. |
| **Feel** | Routing and leftover-tail management; a true level complete. |
| **HUD** | `Pellets 12/40`. |
| **Density** | Do not fill 100% of cells; leave corridors. Seeded patterns. |
| **Entry** | Challenge or late campaign with Collector-style success sheet. |

---

## C3. Lives / continue (optional Nokia-era)

| | |
|--|--|
| **Rule** | 3 lives per campaign level; extra life at score milestones. |
| **Stance** | **Optional.** Snake App currently reads as one-life arcade. Lives reduce Sprint’s “clean PB” feeling. If added, only on campaign, not Sprint. |

---

## C4. Light-cycle trail (Tron)

| | |
|--|--|
| **Working name** | **Vine trail** |
| **Rule** | Head leaves a **solid trail** that never retracts (or retracts slowly). Collision with trail = death. Collectibles still spawn in remaining space. |
| **Feel** | Territory + self-trapping; very different from growing-length snake. |
| **UX** | Nature-arcade vines, not neon Tron (stay on theme). |
| **Risk** | Needs a shorter session or shrinking unused trail. Wave **F**. |

Related: **Shed skin** in [02](./02-google-snake-inspired.md) is “drop blockers on eat”; vine trail is “always paint.”

---

## C5. Two-player light cycle (local)

See [06](./06-local-challenge-and-party.md). Keyboard vs keyboard on desktop; skip dual-swipe on one phone.

---

## Priority

Wave **C**: Bonus critter first (small spawn change). Eat-all maze after Collector HUD exists. Vine trail later.
