# Plan 07 — Recommended enhancements as versioned releases

**Status:** Planning (not a store changelog)  
**Baseline today:** app **1.1.0+2** — 30-level campaign, Classic / Wrap / Maze / Wrap maze, tiered collectibles + combos, guest play, local profile saves, share card, EN/SW, swipe + arrows  
**Related:** [GAME_EXPERIENCE.md](../GAME_EXPERIENCE.md) · **[releases/](../releases/README.md)** (full-release specs) · [00-enhancement-roadmap.md](./00-enhancement-roadmap.md) · [UX_DESIGN.md](../UX_DESIGN.md) · [GAME_MODES.md](../GAME_MODES.md)

This is the **product summary**: what to ship in which **1.x / 2.x** release so the app grows without breaking how people already play.

---

## UX contract (do not break in 1.x)

Every release below must keep the **current experience** as the default path:

| Keep | Meaning |
|------|---------|
| Campaign-first | Home **Play** still opens **level select** → **Start Level**. Do not replace Play with a mode menu. |
| One job per screen | Home stays brand + Play + light secondary actions — not a dashboard of every mode. |
| Same controls | Swipe on touch; arrows (optional WASD) on desktop; reverse-into-self still rejected. |
| Same playground | Responsive board, rotation soft-pause, nature-arcade HUD (score · level · best · pause). |
| Same end of run | Pause / game over sheets, share image, “create profile to save” for guests. |
| Same progress | Existing unlocks and per-level bests stay valid. New modes do **not** reset the 30-level ladder. |
| Same audio model | SFX and BGM remain separate toggles. |
| Same languages | New copy in English + Kiswahili; mode **chip before Start** (same as Wrap/Maze today). |
| Offline-first | A full run never requires the network. |

**How new content appears:** add a single secondary entry — **Challenges** — as a chip on Home or a tab/filter on Levels (not a third navigation paradigm). New rules show a **mode chip + one-line tip** like Wrap and Maze already do.

**Campaign vs Challenges:** teach a mechanic in Challenges first; only then add **a few** expert campaign levels that use it. Do not retcon levels 1–12.

---

## Version map (from 1.1)

```
1.1  current  ── campaign + four modes + combos
  │
1.2  Sprint challenge (timed)          ← new session shape, same board
1.3  Zen + Collector                   ← low pressure + real “level clear”
1.4  Bonus critter + growing walls     ← familiar food + Maze-like rocks
1.5  Burrows + bitter fruit            ← new chips, same steering
1.6  Shield + Dash                     ← HUD extras, swipe unchanged
1.7  Daily seed + ghost (local)        ← High scores / Challenges, still offline
  │
2.0  optional  Arena (bots), lantern, mix-two, desktop 2P
               only if 1.x still feels like the same app
```

Patch releases (**1.2.1**, …) stay for bug fixes and balance. Do not dump two waves into one store version.

---

## 1.1 — Current (shipped)

**Players already have:** onboarding → Home → Play → 30 levels; mode chips; collectibles and combos; profile-gated saves; scores and share.

**Product job of later versions:** more *reasons to open the app* and *rule variety*, without a new control scheme or a new information architecture.

---

## 1.2 — Timed Sprint (recommended next)

**Theme:** [01-session-and-objectives.md](./01-session-and-objectives.md) Sprint  
**Why this first:** short, comparable scores; engine mostly needs a clock and a success sheet; campaign untouched.

| Add | UX fit |
|-----|--------|
| **Challenges → Sprint** (60s or 90s) on 3–5 seeded layouts | Play FAB unchanged. One extra Home/Levels control, same visual language as “Level N unlocked.” |
| HUD countdown (amber, already the reward color) | Compact; last-10s SFX only if SFX is on. |
| Time-up = **success sheet** (not collision thud) unless they crash | Game over still used for crash; Restart / Quit to Challenges mirrors Pause. |
| Best per Sprint layout next to high scores | Same scores module; no cloud board. |

**Do not in 1.2:** extra Home tiles for Zen/Collector/Arena; growing walls; new gestures.

**Exit criteria:** player can finish a Sprint without opening Settings; English + Kiswahili chips; rotation pauses the timer.

---

## 1.3 — Zen and Collector

**Theme:** [01](./01-session-and-objectives.md)  
**Why after Sprint:** Challenges IA already exists; these reuse it.

| Add | UX fit |
|-----|--------|
| **Zen** — endless Classic or Wrap, no timer | Same playground; HUD omits timer. Tip: “No levels — just grow.” |
| **Collector** — eat N marked rares/epics to **clear** | Progress chips in HUD (`Rare 1/3`), same as “one job.” |
| Optional: 2–4 **existing maze levels** gain a Collector clear **in addition to** score unlock | Do not change unlock math for the whole ladder in one release. |

**Do not in 1.3:** Peaceful fill-the-board; lives; reverse controls.

**Exit criteria:** Zen never fails on time; Collector can always spawn remaining targets (not unwinnable); campaign veterans see the same level numbers.

---

## 1.4 — Nokia extras on the current board

**Theme:** [03](./03-nokia-and-arcade-inspired.md) bonus critter · [02](./02-google-snake-inspired.md) growing walls  

| Add | UX fit |
|-----|--------|
| **Bonus critter** — timed high-value animal after M eats | Same collectible art/SFX pattern; no new button. Safe to enable on some campaign levels with a small HUD ring. |
| **Growing walls** challenge (new rocks as you eat) | Looks like Maze (stumps/stones), **different chip** so veterans are not surprised. Keep static Maze as-is. |

**Do not in 1.4:** replace Maze with growing walls; fill the board with Nibbler pellets yet (heavier HUD).

**Exit criteria:** bonus never spawns in a closed pocket; growing-wall spawn radius never traps the head unfairly; Wrap/Maze campaign levels unchanged unless explicitly listed.

---

## 1.5 — New rule chips (still one-swipe snake)

**Theme:** [02](./02-google-snake-inspired.md) burrows, bitter fruit  

| Add | UX fit |
|-----|--------|
| **Burrows** — two portal tiles (not a replacement for Wrap) | Edge glow stays Wrap; burrows are matching amber rings + first-run tip like “Edges loop.” |
| **Bitter fruit** — wilted extra food; **shrink + brief slow**, not random steering | Shape/icon difference (not color-only). Swipe behavior unchanged. |

Optional: **Key fruit** only if Collector HUD from 1.3 feels natural.

**Do not in 1.5:** Twin / mirror snake; random teleport-on-eat; Sokoban.

**Exit criteria:** Wrap still means whole-edge loop; Burrows is a separate chip; colorblind-safe bait.

---

## 1.6 — Clutch tools (HUD, not new steering)

**Theme:** [05](./05-power-ups-combos-modifiers.md) Shield · [04](./04-slither-and-io-inspired.md) Dash  

Combos already exist — do not relaunch them as a “new mode.”

| Add | UX fit |
|-----|--------|
| **Shield** rare collectible — survive one hit | Power-up glow already in the UX feedback table; one HUD pip. |
| **Dash** — hold a **large HUD control** (touch) or Space/Shift (desktop); spends length | Swipe stays the only direction input. No virtual joystick. |

**Do not in 1.6:** online arena; dash as the only move; stacking Slow + Dash + Shield on every level.

**Exit criteria:** guests can use both; Settings still only SFX/BGM/haptics for audio/feel; Dash cannot reverse into self.

---

## 1.7 — Local “social” without a new app

**Theme:** [06](./06-local-challenge-and-party.md)  

| Add | UX fit |
|-----|--------|
| **Daily seed** — today’s layout from device date | Lives under Challenges; copy says **this device, today** (no fake global ranks). |
| **Ghost** of your PB (cosmetic, no collision) | Optional toggle; Reduce Motion can hide it. |
| **Hot-seat** Sprint — pass the phone between local profiles | Uses existing profiles; “Hand to next player” sheet in current dialog style. |

**Do not in 1.7:** accounts, live leaderboards, share-required to play.

Share image can mention Sprint/Daily **when those scores exist** — same branded PNG flow as 1.1.

---

## 2.0 — Only if 1.x still feels like Snake App

Bigger or noisier ideas. Ship only after playtests say 1.2–1.7 are clear.

| Candidate | Why it might wait for 2.0 |
|-----------|---------------------------|
| **Grove arena** (local bots) | New session fantasy; easy to clutter HUD. |
| **Lantern** fog, **shed skin**, **vine trail**, **eat-all maze** | Strong but easy to combine unfairly with Maze + rotate. |
| **Mix-two-rules** challenge cards | Fun if limited to two chips; a blender UI would break “one job.” |
| **Desktop two-player** vine trail | Keyboard-only; do not force it on phones. |
| Home IA change (mode hubs instead of campaign-first) | Would be a **deliberate** 2.0 UX change — not required. |

**Still never (unless the product goal changes):** online .io, reverse inputs as default, Twin on a phone.

---

## What each version does *not* ask of returning players

| They already know | Still true after 1.2–1.7 |
|-------------------|---------------------------|
| Play → pick a level → swipe/arrows | Yes |
| Guest can play; profile saves | Yes |
| Four campaign mode names | Yes; new names are extra chips, not renames |
| Pause, restart, quit to levels | Yes; Challenges uses the same verbs |
| Light/dark, language, SFX vs music | Yes |

---

## Suggested store/version notes (when a version actually ships)

Use real `pubspec.yaml` versions at release time. Planning labels:

| Label | Intended `version` bump | Player-facing one-liner (EN) |
|-------|-------------------------|------------------------------|
| Current | `1.1.0` | Climb 30 levels in Classic, Wrap, and Maze. |
| Next | `1.2.0` | Sprint: beat the clock on the same snake you know. |
| Then | `1.3.0` | Zen practice and mission clears — campaign unchanged. |
| Then | `1.4.0` | Bonus critters and rising rocks as optional challenges. |
| Then | `1.5.0` | Burrows and bitter fruit — new chips, same swipe. |
| Then | `1.6.0` | Shield and Dash when you need a clutch. |
| Then | `1.7.0` | Today’s grove and ghost runs — still on this device. |
| Later | `2.0.0` | Only with a playtested extra pillar (e.g. local arena). |

Update README / Play listing **only when that version is implemented** — these lines are not live claims.

---

## Decision recap

1. **Stay on 1.x** while Play → levels remains the spine.  
2. **One new habit per release** (Sprint, then Zen/Collector, then board spices).  
3. **Challenges** absorb novelty so the 30-level story and current HUD stay familiar.  
4. **Skip** anything that changes steering or requires the network.
