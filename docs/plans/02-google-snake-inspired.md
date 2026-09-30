# Plan 02 — Google Snake–inspired modes

**Status:** Planning  
**Inspired by:** [Google Snake](https://en.wikipedia.org/wiki/Snake_(video_game_genre)) doodle **modes** (Classic, Wall, Portal, Borderless, Cheese, Winged, Key, Poison, Light, Statue, Peaceful, Blender, and others). Snake App already covers **Classic**, **Borderless ≈ Wrap**, and **static Wall ≈ Maze**. This file is the remainder, renamed for our theme.

We are **not** cloning the doodle UI, apples, or unlock meta. We steal **rules that teach well**.

---

## Already covered (do not duplicate)

| Google-ish name | Snake App today |
|-----------------|-----------------|
| Classic | `GameMode.classic` |
| Borderless | `GameMode.wrap` |
| Static walls / maze | `maze` / `wrapMaze` |

---

## B1. Growing walls (“Wall mode”)

| | |
|--|--|
| **Working name** | **Rising stumps** or **Growing walls** |
| **Rule** | After every N eats (Google: often every other fruit), a new blocked cell appears. Hit it = death. Never spawn on snake, food, or in a way that traps the head with no exit (validate spawn). |
| **Feel** | Board gets meaner without only speeding the tick. Different from our **seeded static** maze. |
| **UX** | Distinct from Maze chip. Tip: “New rocks appear as you eat.” Nature-arcade stumps/stones. |
| **Fairness** | Taxicab spawn radius around the head (Google uses a small “avoidable” radius). Orientation: remap existing blockers by row/col. |

**Tests:** blocker count increases on eat cadence; food excluded; no spawn on occupied cells; classic still dies on outer edge.

---

## B2. Paired portals (not edge wrap)

| | |
|--|--|
| **Working name** | **Burrows** or **Portals** |
| **Rule** | Two fixed (or seeded) portal cells. Entering one exits the other, **same facing**. Self-collision still kills. Distinct from Wrap (whole edge loops). |
| **Feel** | Path prediction; mid-skill “aha.” |
| **UX** | Matching amber rings on both tiles; optional soft whoosh (SFX toggle). Tip: “Burrows swap you to the other hole.” |
| **Campaign** | Expert band or Challenges — not Level 1. |
| **Skip** | Random teleport after every eat (chaotic; some fan write-ups confuse this with Portal). |

**Tests:** A→B and B→A; wrap mode unchanged; food never on portal cells; length does not skip collision on the exit tile.

---

## B3. Key and lock

| | |
|--|--|
| **Working name** | **Key fruit** |
| **Rule** | Eat a **key** collectible first; then a **lock** becomes edible (or opens a gated tile). Hitting the lock before the key = death (or bounce — prefer **death** only if the lock looks solid). |
| **Feel** | Two-step routing; good maze pairing. |
| **HUD** | Key icon filled when held. |
| **UX** | Key as uncommon animal/object; lock as bark chest. Localized tip. |

---

## B4. Poison bait

| | |
|--|--|
| **Working name** | **Bitter fruit** |
| **Rule** | Two foods: safe (scores) and gray/wilted (avoid). Eating bitter: **short scramble** (forced turns for K ticks) **or** instant death. Prefer **scramble with recovery** so it is a skill check, not a gotcha — but Google’s random-turn poison is harsh on swipe. **Snake App recommendation:** bitter fruit = **score 0 + shrink 2 segments + brief slow**, not random direction. Optional hard modifier later. |
| **Feel** | Discrimination; caution. |
| **UX** | Wilted vs ripe art; never color-only (colorblind). Shape + icon difference. |

---

## B5. Fleeing / bouncing food

| | |
|--|--|
| **Working name** | **Skittish** (Cheese: steps away) · **Winged** (bounces) |
| **Rule** | After a delay, food steps away from the head, **or** continuously bounces off edges/body. |
| **Feel** | Aggression and intercepts; pairs with Wrap. |
| **Risk** | Small phones: keep one mover, not five. Tick food movement on the engine clock, not a second timer that desyncs. |

Maps also to Slither “chase pellets” — see [04](./04-slither-and-io-inspired.md).

---

## B6. Fog / lantern (Light)

| | |
|--|--|
| **Working name** | **Lantern** |
| **Rule** | Only cells within Manhattan distance R of the head are fully lit; rest dim. Food may ping on HUD. |
| **Feel** | Tension; memory. |
| **Risk** | Unfair with Growing walls + rotation. Phase **F** only; keep R generous on phones. |

---

## B7. Statue leftovers

| | |
|--|--|
| **Working name** | **Shed skin** |
| **Rule** | Every eat, one tail cell (or a dropped segment) becomes a **permanent blocker**. |
| **Feel** | You pollute your own arena. |
| **Risk** | Combined with Maze = unfair. Use on a spacious Classic board first. |

---

## B8. Peaceful fill

| | |
|--|--|
| **Rule** | Cannot die on self/wall (or walls off); run ends when no empty cell remains. |
| **Feel** | Patterning / Hamilton-path toy. |
| **Entry** | Sub-mode of Zen, not campaign. |

---

## Parked from the doodle list

| Google mode | Snake App stance |
|-------------|------------------|
| Twin / Yin Yang | Skip for touch + rotate ([00](./00-enhancement-roadmap.md)) |
| Sokoban | Different game; park |
| Minesweeper / Dimension / Magnet / Gate / Arrow / Hotdog | Low identity fit; revisit only if Wave F is exhausted |
| Blender | See mix-two-rules in [05](./05-power-ups-combos-modifiers.md) — Challenges “wild card,” not a 20-mode picker |

## Priority

Wave **B**: Growing walls, then Portals, then Bitter fruit. Key/lock after Collector exists so the HUD pattern is familiar. Lantern / Shed skin in Wave **F**.
