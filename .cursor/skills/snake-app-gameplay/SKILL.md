---
name: snake-app-gameplay
description: Snake App gameplay engine conventions for board, controls, scoring, levels, and audio feedback. Use when changing game loop, swipe/keyboard input, collectibles, levels, HUD, or playground responsiveness.
---

# Snake App Gameplay Skill

Use when implementing or changing the play loop, controls, board layout, collectibles, levels, or in-game feedback.

## Read first
- `docs/IMPLEMENTATION_PLAN.md` §§4.4–4.8
- `docs/UX_DESIGN.md` (playground + feedback tables)
- Rule: `.cursor/rules/snake-app-gameplay.mdc`

## Controls checklist
- [ ] Touch: swipe uses dominant axis + minimum distance (~24–32 px)
- [ ] Reject 180° reverse into self
- [ ] Desktop: Arrow keys (optional WASD); Esc → pause
- [ ] Web: support touch and/or keyboard based on input
- [ ] Do not leave a global keyboard listener active outside playground

## Responsive board checklist
- [ ] Cell size / columns derived from board `BoxConstraints`
- [ ] Works phone + tablet; portrait + landscape
- [ ] Desktop: readable board (letterbox / max size OK)
- [ ] Orientation change recomputes metrics without unfair instant death
- [ ] Safe areas respected (notch, system bars)

## Collectibles & scoring
- Tiered objects/animals with icons and different base scores (common → epic)
- Distinct SFX (or pitch) for rarer tiers when audio assets exist
- Score float / light haptic on eat (mobile); collision thud + heavy haptic

## Levels
- Clear unlock rule (score threshold and/or survival / eat count)
- Persist `highest_level_unlocked` and per-level bests via offline-profile skill
- Speed / density increase by level — document constants in code or `docs/`

## Audio
- SFX channel ≠ BGM channel
- Honor Settings toggles immediately
- Pause/mute BGM on app background; resume if still enabled

## Tests to prefer
- Direction reverse rejection
- Grid metrics for sample widths/heights
- Level unlock predicates
- Score calculation with tiers (and combos/power-ups if present)

## Do not
- Lock orientation to portrait only
- Combine music + SFX into one setting
- Hardcode a phone-only grid size for all devices
- Require network for gameplay
