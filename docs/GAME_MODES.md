# Snake App — Game Modes & Level Variants

**Status:** Implemented (Classic · Wrap · Maze · Wrap maze)  
**Related:** [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md) · [UX_DESIGN.md](./UX_DESIGN.md) · [ARCHITECTURE.md](./ARCHITECTURE.md)  
**Goal:** Give players meaningful variety beyond “same rules, faster tick,” while keeping offline-first play, fair controls, and clear progression.

---

## 1. Why game modes

Today the campaign mixes **Classic**, **Wrap**, **Maze**, and **Wrap maze**. Speed and board density still rise with level; maze levels also grow **obstacle box count and size**.

Modes should:

- Teach one new rule at a time (onboarding-friendly)
- Create distinct “sessions” players want to return to
- Reuse the same engine, HUD, and profile persistence
- Stay readable on phone / tablet / desktop (including rotation)

**Design rule:** Prefer a small set of strong modes over many gimmicks.

---

## 2. Core modes (requested)

### 2.1 Classic (solid walls) — current default

| | |
|--|--|
| **Rule** | Leaving the board edge = game over. Body collision = game over. |
| **Feel** | Tight, tactical, “don’t paint yourself into a corner.” |
| **Best for** | Learning, fair high-score chasing, early levels. |
| **UX notes** | Keep as **Level 1+ default**. Label clearly so wrap mode doesn’t surprise veterans. |

### 2.2 Wrap (portal / torus board)

| | |
|--|--|
| **Rule** | Crossing a wall reappears on the **opposite** side (same row/column). Self-collision still kills. |
| **Feel** | Open, continuous, more “flow”; length becomes the main threat. |
| **Best for** | Mid/late levels, combo chasing, relaxed-but-skillful play. |
| **UX notes** | Subtle edge glow or dashed border so players see the board is wrap. Short tip on first wrap level: “Edges loop.” |
| **Fairness** | On orientation resize, remapping must keep wrap semantics (same as today for solid). |

### 2.3 Obstacles (maze / blockers)

| | |
|--|--|
| **Rule** | Fixed cells are **blocked**. Hitting a blocker = game over (same as wall). Food never spawns on blockers or the snake. |
| **Feel** | Puzzle-snake: path planning, corridors, chokepoints. |
| **Best for** | Mid game variety; “puzzle” identity without a new control scheme. |
| **UX notes** | Distinct blocker art (stone / stump / fence — nature-arcade). Show a tiny preview on level select. |
| **Variants** | Static maze · sparse rocks · shifting pattern every N eats (Phase 2). |

---

## 3. Additional modes worth considering (UX-first)

Ranked for impact vs complexity. Recommend shipping **A–C** after the three core modes; park **D+** for later.

### A. Zen / Endless (no level fail from time)

| | |
|--|--|
| **Rule** | Classic or Wrap walls; no level unlock gate — play until death; optional soft goals (reach length / score). |
| **Why UX** | Low pressure; good for “one more run” and new players. |
| **Entry** | Separate Home tile or Levels tab: **Zen**, not mixed into numbered campaign without labeling. |

### B. Sprint (timed challenge)

| | |
|--|--|
| **Rule** | Survive or score as much as possible in **60s / 90s**. Walls: Classic or Wrap per level. |
| **Why UX** | Clear session length; great for mobile “bus stop” play; shares well (“I got 420 in Sprint”). |
| **HUD** | Countdown ring or bold timer; end sheet shows score vs personal best for that sprint layout. |

### C. Collector (mission eats)

| | |
|--|--|
| **Rule** | Win the level by eating **N target collectibles** (e.g. 3 rare / 1 epic), not by score alone. Walls + optional obstacles. |
| **Why UX** | Gives a **win condition** beyond “don’t die,” which levels currently lack (only unlock-by-score). |
| **UX notes** | Progress chips: `Rare 1/3`. Failure still on collision; success sheet unlocks next. |

### D. Shrink (closing arena) — Phase 2

| | |
|--|--|
| **Rule** | Every M eats (or every T seconds), the playable rectangle shrinks one ring (new solid border). |
| **Why UX** | Rising tension without only speeding the tick. |
| **Risk** | Orientation + shrink + obstacles can feel unfair — keep off MVP modes. |

### E. Twin food / Hot–Cold — Phase 2

| | |
|--|--|
| **Rule** | Two foods: high-value “hot” and safe “cold,” or one that moves slowly. |
| **Why UX** | Choice and risk; pairs well with Wrap. |
| **Risk** | Cluttered HUD/board on small phones — careful density. |

### F. Ghost bite (phase power) — Phase 2 / polish backlog

| | |
|--|--|
| **Rule** | Occasional power-up: briefly pass through self or one obstacle. |
| **Why UX** | Clutch recovery moments (engagement). |
| **Risk** | Complexity + balance; only after core modes feel solid. Product plan previously deferred full power-ups for MVP — keep here as optional Phase 2. |

### G. Mirror / reverse inputs — **Not recommended**

Hard to discover, frustrating on touch, bad for accessibility. Skip unless as a rare optional challenge with strong warning.

---

## 4. How modes show up in the product

### Recommended structure (campaign-first)

```
Home → Levels (campaign)
         Level card shows: number · mode chip · speed · density · unlock hint
       → optional “Modes” or “Challenges” later (Zen / Sprint)
```

**Campaign mix (example for 30 levels):**

| Band | Levels | Dominant mode |
|------|--------|----------------|
| Learn | 1–5 | Classic |
| Open up | 6–12 | Mix Classic + introduce Wrap |
| Puzzle | 13–20 | Obstacles (Classic walls) + some Wrap+light rocks |
| Expert | 21–30 | Harder mazes, Wrap+obstacles, optional Sprint/Collector missions |

Players should **see the mode chip before Start** (e.g. `Classic` · `Wrap` · `Maze`).

### Alternate structure (mode hubs)

Home → Classic campaign · Wrap campaign · Maze campaign  

Strong for clarity, weaker for one continuous unlock story. Prefer **campaign-first** for Snake App’s existing 30-level ladder; add hubs only if playtests ask for it.

---

## 5. Engine & data sketch (for later implementation)

Do **not** implement in this doc — planning only.

```
LevelConfig
  level, tickMs, columns, rows, unlockScore
  + mode: classic | wrap | obstacles | …   // or GameModeId
  + obstaclePatternId? / obstacleCells?
  + objective?: survive | scoreGate | collectTargets | timed
  + objectiveParams?: { durationSec, targetTier, targetCount }
```

`SnakeEngine` movement:

- `classic` → edge = null → death (today)
- `wrap` → edge indexes modulo columns/rows
- blockers → treat like walls in `_nextIndex` / collision set

Persistence:

- Keep per-level bests; optionally store `bestByMode` later for Zen/Sprint
- Profile gate unchanged (save scores still needs profile)

UX / onboarding:

- One tip page or first-run coach mark per new mode family
- Settings: no change required for MVP modes

---

## 6. Visual & audio language (theme-aligned)

| Mode | Board cue | Optional SFX |
|------|-----------|--------------|
| Classic | Solid edge line | Existing thud on death |
| Wrap | Soft dashed / glowing edge | Soft “whoosh” on wrap (subtle) |
| Obstacles | Raised blockers in brand greens / bark amber | Light “knock” on near-miss optional |
| Sprint | Timer accent (amber) | Tick in last 10s (respect SFX toggle) |
| Collector | Target icons highlighted in HUD | Existing eat SFX; fanfare on objective complete |

Stay on nature-arcade palette (`THEME_AND_COLORS.md`); avoid purple defaults.

---

## 7. Phased delivery plan

### Phase 0 — Spec & fixtures (docs + constants design)

- [x] This planning doc
- [x] Finalize mode enum names and campaign mix table
- [x] Seeded obstacle generation (scaling box count/size by level)

### Phase 1 — Engine modes (must-have)

- [x] `GameMode.classic` (explicit) + `GameMode.wrap`
- [x] Level catalog fields + level-select mode chips
- [x] Tests: wrap teleport; classic still dies on edge
- [x] First-run tip strings (EN + SW) on level cards / onboarding reverse hint

### Phase 2 — Obstacles

- [x] Blocker collision + food spawn exclusion
- [x] Seeded patterns that densify by level; paint blockers on board
- [x] Levels that use obstacles (`maze` from 13+, `wrapMaze` in expert band)

### Phase 3 — Session variety

- [ ] Collector objectives **or** Sprint timer (pick one first by playtest)
- [ ] Zen endless entry point
- [ ] Per-mode / per-challenge bests if needed

### Phase 4 — Advanced (optional)

- [ ] Shrink arena, twin food, limited power-ups

---

## 8. Acceptance criteria (Phase 1–2)

1. Player can tell Classic vs Wrap vs Maze from level select **before** playing.
2. Wrap never kills on edge; Classic always does.
3. Obstacles never spawn food on blocked cells; hitting blocker ends run.
4. Orientation change does not unfairly kill solely due to mode remapping (same soft-pause policy as today).
5. All copy localized (English + Kiswahili).
6. Analyze/tests green; new unit tests for movement modes.

---

## 9. Open decisions

1. **Campaign mix:** Exact level numbers for first Wrap / first Maze? (Proposal: Wrap @ 6, Maze @ 13.)
2. **Win condition:** Keep unlock-by-score only until Collector/Sprint, or add “clear” for maze levels earlier?
3. **Zen placement:** Home secondary tile vs Levels filter chip?
4. **Wrap + obstacles together:** Allow in expert band only, or forbid until both feel fair alone?
5. **Naming:** `Wrap` vs `Portal` vs `Loop` — pick one word for chips and l10n.

---

## 10. Summary recommendation

| Priority | Mode | Ship when |
|----------|------|-----------|
| P0 | Classic (named) | Already playable — label it |
| P0 | Wrap | Next engine feature |
| P0 | Obstacles / Maze | Right after Wrap |
| P1 | Collector **or** Sprint | After modes feel distinct |
| P1 | Zen | Parallel lightweight entry |
| P2 | Shrink / twin food / powers | Only if retention needs more spice |

This keeps Snake App’s strength (simple controls, offline progress) while giving the level ladder a **story of rules**, not only a story of speed.
