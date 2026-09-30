# Plan 01 — Session shapes and objectives

**Status:** Planning (called out as Phase 3 in [GAME_MODES.md](../GAME_MODES.md))  
**Inspired by:** Short-session mobile arcade (timed high scores); “peaceful / endless” practice modes; mission-based level clears rather than score-only unlocks.

Snake App’s ladder today is mostly **don’t die until you beat a score gate**. Other snake products keep the same steering but change **why the run ends**.

---

## A. Zen / Endless

| | |
|--|--|
| **Rule** | Classic or Wrap walls; play until collision. No countdown. Optional soft goals (length, score) that do not fail the run. |
| **Feel** | Low pressure; practice routing; “one more run.” |
| **Entry** | Home secondary tile or Levels filter — **not** mixed into numbered campaign without a Zen chip. |
| **HUD** | Score, length, personal best. No fail timer. |
| **Persistence** | `bestZenScore` / `bestZenLength` with profile. |
| **UX notes** | First-run tip: “No levels — just grow.” Optional Peaceful variant later (cannot die; run ends when the board is full — Google Peaceful). Park Peaceful until Zen exists. |

**Skip:** Auto-increasing speed with no cap (feels like punishment, not zen).

---

## B. Sprint (timed challenge)

| | |
|--|--|
| **Rule** | Score as much as possible in **60s** or **90s**. Walls: Classic or Wrap per layout. Optional light maze. |
| **Feel** | Bus-stop session; comparable personal bests (“420 in Sprint”). |
| **HUD** | Bold timer or countdown ring (amber accent). Last 10s: optional SFX tick if SFX enabled. |
| **End** | Time up → success sheet (not “game over thud” unless they also crashed). Crash still ends early. |
| **Layouts** | 3–5 seeded boards so Bests are fair. |
| **Persistence** | `bestSprintScore` per layout id. |

**Fairness:** Orientation change pauses the clock for the same soft-pause as campaign.

---

## C. Collector (mission eats)

| | |
|--|--|
| **Rule** | Clear by eating **N target collectibles** (e.g. 3 rare / 1 epic), not by score alone. Collision still fails. |
| **Feel** | A real **win** for maze levels; teaches rarity without only RNG score. |
| **HUD** | Progress chips: `Rare 1/3`. Highlight target icons on the board (subtle pulse). |
| **Success** | Fanfare (existing eat / distinct complete SFX) + unlock next if used in campaign. |
| **Spawn** | Targets guaranteed within a max eat count so a run is never unwinnable. |

Pairs well with static Maze (path planning toward a marked tile).

---

## D. Eat-all / Nibbler clear (optional follow-on)

See [03-nokia-and-arcade-inspired.md](./03-nokia-and-arcade-inspired.md). Same “objective” slot as Collector: `eatAllDots` on a maze with many low-value pellets plus one mover.

---

## Engine / data

```
objective: survive | scoreGate | collectTargets | timed | fillBoard
objectiveParams: { durationSec, targetTier, targetCount, layoutId }
```

Campaign can keep `scoreGate`. Challenges use `timed` or none (Zen).

## Tests

- Sprint: clock expiry ends run in success state; crash ends in failure; pause stops the timer.
- Collector: eating non-target does not complete; N targets complete; collision fails.
- Zen: no timer; bests update only with profile.

## Priority

Wave **A** in [00-enhancement-roadmap.md](./00-enhancement-roadmap.md). Implement Sprint **or** Collector first; Zen is the cheapest third.
