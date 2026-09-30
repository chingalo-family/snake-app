# Plan 00 — Enhancement roadmap

**Status:** Planning  
**Related:** [GAME_MODES.md](../GAME_MODES.md) · [IMPLEMENTATION_PLAN.md](../IMPLEMENTATION_PLAN.md) · [plans/README.md](./README.md)

## 1. What we already have

Campaign levels already mix **Classic** (solid walls), **Wrap** (torus board), **Maze**, and **Wrap maze**. Speed and obstacle density rise with level. That covers Nokia-style walls vs wrap and Nibbles-style mazes.

The gap is **session shape** (how a run starts and ends) and **rule spices** players recognize from other snake games, without turning the app into a mode museum.

## 2. Recommended ship order

| Wave | Theme | Why first | Docs |
|------|--------|-----------|------|
| **A** | Zen, Sprint, Collector | New reasons to open the app; small engine surface | [01](./01-session-and-objectives.md) |
| **B** | Growing walls, pair portals, poison bait | Distinct from static maze; proven in Google Snake | [02](./02-google-snake-inspired.md) |
| **C** | Timed bonus critter, eat-all maze clear | Nokia / arcade nostalgia; fits collectible tiers | [03](./03-nokia-and-arcade-inspired.md) |
| **D** | Combos + 1–2 power-ups | Engagement without a new mode picker | [05](./05-power-ups-combos-modifiers.md) |
| **E** | Boost + fleeing food (solo) | Slither feel without online | [04](./04-slither-and-io-inspired.md) |
| **F** | Fog-of-war, statue leftovers, mix-two-rules | Expert spice | [02](./02-google-snake-inspired.md), [05](./05-power-ups-combos-modifiers.md) |
| **G** | Ghost replay, daily seed, hot-seat | Social without servers | [06](./06-local-challenge-and-party.md) |

Map waves to **full-release specs** in [releases/README.md](../releases/README.md). Sequence notes: [07-versioned-releases.md](./07-versioned-releases.md). Keep Home → Play → levels as the default path.

## 3. Skip or park (unless playtests demand it)

| Idea | Source vibe | Why park |
|------|-------------|----------|
| Reverse / scrambled inputs | “Hard mode” clones | Frustrating on swipe; bad accessibility |
| True Twin (two snakes, one input) | Google Twin | Tiny phones; unfair on rotate |
| Yin–Yang mirror snake | Google Yin Yang | Same as Twin plus collision with shadow |
| Sokoban-on-snake | Google Sokoban | Different genre; huge UX and engine cost |
| Minesweeper cells | Google Minesweeper | Obscure; weak snake identity |
| Online .io arena | Slither.io / Snake.io | Breaks offline-first MVP; needs netcode, moderation |
| Analog joystick + boost as **only** control | .io mobile | Conflicts with swipe-first Snake App |

## 4. Product placement

Keep **campaign-first** (numbered levels with a mode chip). Add a Home row or Levels filter for **Challenges**:

- Zen
- Sprint
- later: Daily seed, Arena (bots)

Do not hide new rules only as later campaign levels unless the chip and a first-run tip are visible **before** Start.

## 5. Engine sketch (shared)

Extend existing `LevelConfig` rather than forking the loop:

```
GameMode / modifiers
  walls: solid | wrap
  obstacles: none | staticMaze | growingWalls | statueTrail
  portals: none | edgeWrap | pairedTiles
  foods: single | poisonTwin | fleeing | wingedBounce
  objective: survive | scoreGate | collectTargets | timed | fillBoard | eatAllDots
  powers: none | boost | shield | keyLock
  visibility: full | fogAroundHead
```

Persistence: per-level bests stay; add `bestByChallengeId` for Zen / Sprint / Daily. Profile gate unchanged.

## 6. Acceptance for any new mode

1. Named on level/challenge select before play (EN + SW).
2. Unit tests for the new movement or spawn rule.
3. Orientation remapping does not instant-kill solely from the new rule.
4. Food never spawns on snake, blockers, or portal tiles.
5. `flutter analyze` clean; gameplay tests pass.
6. Theme cues from [THEME_AND_COLORS.md](../THEME_AND_COLORS.md).

## 7. Open decisions

1. Wave A: Sprint vs Collector first (recommend **Sprint** for shareable scores, then Collector for “win the level”).
2. Growing walls vs static maze in the same campaign band — keep Maze as static; Growing walls as a **named** challenge.
3. Whether paired portals replace or sit beside Wrap (recommend **beside**: Wrap = whole edge; Portal = two tiles).
