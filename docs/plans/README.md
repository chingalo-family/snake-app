# Snake App — Enhancement plans

**Status:** Planning only (not shipped)  
**Shipped modes:** Classic · Wrap · Maze · Wrap maze — see [GAME_MODES.md](../GAME_MODES.md)  
**Constraints:** Offline-first play, swipe + arrow keys, responsive board, English + Kiswahili, nature-arcade theme

These files collect **suggestive** modes and play loops inspired by well-known snake-family games. They are not a promise to ship everything. Prefer a small set of strong modes over many gimmicks.

## How to use this folder

1. Read [../releases/README.md](../releases/README.md) for **next full releases** (experience, UX, acceptance).
2. Read [../UX_ENHANCEMENTS.md](../UX_ENHANCEMENTS.md) for Challenges hub, HUD, and sheets.
3. Read [07-versioned-releases.md](./07-versioned-releases.md) for sequencing vs current 1.1 UX.
3. Read [00-enhancement-roadmap.md](./00-enhancement-roadmap.md) for waves, skip list, and engine sketch.
4. Open the theme file for the mechanic you want to spec or implement.
5. When a mode actually ships, update [GAME_MODES.md](../GAME_MODES.md), [UX_DESIGN.md](../UX_DESIGN.md), [UX_ENHANCEMENTS.md](../UX_ENHANCEMENTS.md), l10n, tests, and this folder’s status lines in the same change set.

Do **not** treat these plans as implemented product facts in README or store copy.

## Index

| File | Focus | Inspired by (public games / genres) |
|------|--------|-------------------------------------|
| [07-versioned-releases.md](./07-versioned-releases.md) | **Summary:** 1.2–2.0 releases vs current 1.1 UX | Product sequencing |
| [00-enhancement-roadmap.md](./00-enhancement-roadmap.md) | Waves, skip list, engine sketch | All sources below |
| [01-session-and-objectives.md](./01-session-and-objectives.md) | Timed runs, endless, mission eats | Mobile “short session” games; Snake App Phase 3 notes |
| [02-google-snake-inspired.md](./02-google-snake-inspired.md) | Portals, growing walls, key/lock, poison, fog, chase food | [Google Snake](https://en.wikipedia.org/wiki/Snake_(video_game_genre)) doodle modes |
| [03-nokia-and-arcade-inspired.md](./03-nokia-and-arcade-inspired.md) | Bonus critters, maze eat-all, light-cycle trails | Nokia Snake / Snake II, Nibbler, Tron light cycles |
| [04-slither-and-io-inspired.md](./04-slither-and-io-inspired.md) | Boost, fleeing pellets, offline arena | Slither.io, Snake.io (single-player / bots only) |
| [05-power-ups-combos-modifiers.md](./05-power-ups-combos-modifiers.md) | Combos, shields, speed, mix-and-match rules | Implementation plan Phase 2–3; Google “Blender” idea |
| [06-local-challenge-and-party.md](./06-local-challenge-and-party.md) | Hot-seat, ghost runs, daily seeds | High-score culture; local party play |

## Design rules (every proposal)

- Reuse `SnakeEngine`, HUD, and profile persistence; add `LevelConfig` / `GameMode` fields rather than a second engine.
- Profile still gates **saving**, not play.
- No network required for a complete run.
- Readable on phone, tablet, and desktop, including rotation (soft-pause on resize).
- Touch stays swipe-primary; avoid modes that need two simultaneous analog sticks.
- Skip reverse-input / “drunk controls” as a default mode (accessibility).
- Visual language stays on [THEME_AND_COLORS.md](../THEME_AND_COLORS.md).

## Inspiration (not clones)

Mechanics are described in our own names and nature-arcade theme. Do not copy Google Doodle art, Nokia assets, or .io skins. Cite the **idea** (wrap, portals, boost) and implement original board cues.
