# Plan 05 — Combos, power-ups, and mix-and-match rules

**Status:** Planning  
**Inspired by:** Snake App [IMPLEMENTATION_PLAN.md](../IMPLEMENTATION_PLAN.md) §§4.6–4.8 (combos, power-ups); Google Snake **Blender** (stack two modes); arcade score multipliers.

These enhance **existing** Classic / Wrap / Maze rather than adding a new Home tile each time.

---

## D1. Combo multiplier

| | |
|--|--|
| **Rule** | Consecutive eats within T ticks (or without a “gap” move count) raise a multiplier (×1.2 … cap ×3). Break on pause? **No** — pause should freeze combo timer. Break on long path without eat. |
| **HUD** | Compact `×2` near score. Float text on eat. |
| **Feel** | Rewards efficient routing; pairs with Wrap. |
| **Tests** | Tiered base score × multiplier; cap; reset rules. |

Phase 2 in the product plan; still worth doing **before** many new modes.

---

## D2. Power-ups (small set)

MVP deferred full power-ups; if we add them, **three is enough**:

| Id | Effect | Duration | Risk |
|----|--------|----------|------|
| **Shield** | Survive one self-or-obstacle hit (not optional suicide). | Until used or timeout | Must be visually obvious (bark armor). |
| **Slow sap** | Tick rate eases for N seconds. | Short | Do not stack with Dash. |
| **Score bloom** | ×2 on eats. | Short | Stacking with combo: define order (base × combo × bloom). |

Spawn as rare collectibles, not a shop. Ghost-through-self (GAME_MODES “Ghost bite”) can wait until Shield exists.

**Audio:** distinct SFX; BGM unchanged. Settings toggles still split.

---

## D3. Shrink arena

Already in [GAME_MODES.md](../GAME_MODES.md) as Phase 2 **Shrink**. Every M eats or T seconds, playable rectangle loses one ring.

| | |
|--|--|
| **Feel** | Battle-royale tension without .io. |
| **Risk** | Unfair with Maze + rotation. Challenges-only, spacious Classic first. |

---

## D4. Mix two rules (“blender”)

| | |
|--|--|
| **Rule** | Challenge card lists **exactly two** modifiers, e.g. Wrap + Bitter fruit, or Maze + Bonus critter. |
| **UX** | Two chips, never a 12-toggle debugger. Seeded so we can QA. |
| **Feel** | Novelty without a mode explosion. |

Do not expose a sandbox of all flags in Settings for v1.

---

## D5. Speed bands vs modifiers

Keep campaign difficulty as **tickMs + density** first. Add at most **one** extra modifier per level in the expert band so the chip stays readable.

## Priority

Wave **D**: combos, then Shield. Slow sap / bloom / shrink / mix-two after Waves A–C have identity.
