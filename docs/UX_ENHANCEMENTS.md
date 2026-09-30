# Snake App — UI/UX enhancements (for next releases)

**Status:** Planning — does not change shipped 1.1 screens until implemented  
**Shipped UX:** [UX_DESIGN.md](./UX_DESIGN.md)  
**Why:** [GAME_EXPERIENCE.md](./GAME_EXPERIENCE.md) · **When:** [releases/](./releases/README.md)  
**Theme:** [THEME_AND_COLORS.md](./THEME_AND_COLORS.md) (nature-arcade; no purple defaults)

Suggestions so **Challenges, Sprint, Zen, Collector, board spices, Shield/Dash, Daily/ghost** fit the app players already know. Prefer reuse of cards, chips, sheets, and the Play FAB over new navigation systems.

---

## 1. UX contract (do not break)

| Keep | UI implication |
|------|----------------|
| One job per screen | Challenges is **one hub**, not a Home of six FABs |
| Fast path to Play | Play FAB stays primary; Challenges is secondary (same weight as High Scores / level chip) |
| Device-correct controls | Swipe still steers; Dash is a **hold control**, never a joystick |
| Calm nature-arcade | New modes = chips, edge cues, amber timer — not neon overlays |
| Offline + profile gate | Success/game over still offer “create profile to save” |
| EN + SW | Every new label, tip, and sheet |
| Rotation | Extra HUD (timer, Dash) reflows; never covers the board’s last row of cells |

When a suggestion below would violate this table, skip it.

---

## 2. Information architecture

```
Home
  Play (FAB)           → Level select (campaign, unchanged)
  Challenges (text/chip) → Challenges hub → Start a challenge
  High Scores          → Campaign bests + (from 1.2) Sprint / Daily sections
  Profile / Settings   → unchanged groups; small Display additions later
```

**Do not:** bottom tab bar of Play | Challenges | Scores (competes with FAB and More sheet).  
**Do not:** mode hubs that replace campaign-first Home.

**More sheet (non-home):** add **Challenges** next to Scoreboard / Profile / Settings so landscape and deep links stay consistent.

---

## 3. Home (from 1.2)

Keep the current stack. Insert **one** control only:

| Placement | Recommendation |
|-----------|----------------|
| Compact portrait | Text button or outlined chip **Challenges** in the nav row with High Scores — **not** a second FAB |
| Next to progress chip | Optional small “Sprint best” or “Today’s grove” **only if** it stays one line; hide if it crowds the tip card |
| Visual weight | Outlined / tonal; Play stays filled primary green |

Empty/guest: Challenges still open (play without profile); save prompt stays on the end sheet.

First visit: **one coach mark** on Challenges (“Timed runs and practice — campaign is still Play”). Do **not** add a fifth onboarding page in 1.2.

---

## 4. Challenges hub (new screen)

Same chrome as Level select: app bar Home + More, raised cards, mode chips, Start CTA.

```
┌─────────────────────────────────────┐
│  ← Home          Challenges    More │
├─────────────────────────────────────┤
│  Sprint          60s · Wrap         │
│  [mini board]    Best 420           │
│  Edges loop.                    Start│
├─────────────────────────────────────┤
│  Zen             Classic            │  ← 1.3
│  No levels — just grow.         Start│
└─────────────────────────────────────┘
```

**Card anatomy (match level cards):**

1. Title + duration or mode chips  
2. Mini board silhouette (reuse level-select preview)  
3. **One-line tip** (same as Wrap/Maze tips)  
4. Personal best (muted if guest / no score)  
5. **Start** (48×48 min)

**As the list grows (1.3–1.7):** group with **section headers** (Timed · Practice · Today), not filters that hide Sprint. Daily card shows **device date**, not a globe icon.

Locked future rows: mute + lock + “Comes in a later update” only if we show placeholders — **prefer omitting** unreleased modes until that version ships.

---

## 5. Playground HUD (grow without clutter)

**Portrait default (1.1):** `Score · Level · Best · Pause`

Add **at most two extra slots**. Overflow goes to a **single overflow chip** (`···`) that opens a tiny sheet — do not wrap the HUD to three rows on phones.

| Release | Extra HUD | Visual |
|---------|-----------|--------|
| 1.2 Sprint | Countdown | Amber (`brand.secondary`) **digits or thin ring**; last 10s pulse **if** Reduce Motion off |
| 1.3 Zen | Length optional | Replace Level with `Length` or keep Level hidden; no timer |
| 1.3 Collector | `Rare 1/3` | Compact chips; target icons **pulse once** on spawn (Reduce Motion: static ring) |
| 1.4 Bonus | Timer ring on **tile**, not HUD | HUD stays clean |
| 1.5 Burrows | None extra | Board rings only |
| 1.5 Bitter | None extra | Distinct wilted icon |
| 1.6 Shield | One pip | `brand.info` used **sparingly** (already the shield token) |
| 1.6 Dash | Hold control | See §7 — **not** a third HUD text column |
| 1.7 Ghost | Optional faint trail | Settings toggle; Reduce Motion hides it |

**Landscape:** timer / chips / Dash live in the **existing stats panel**, not over the board.

**Challenge runs:** HUD label **Challenge** or layout name instead of `Level N` so players are not told they are on campaign level 14.

---

## 6. End-of-run sheets (success ≠ death)

Today everything ends in **game over**. New sessions need a second pattern that **reuses the same sheet chrome**.

| Outcome | Title tone | Primary actions | Audio |
|---------|------------|-----------------|-------|
| Crash (any mode) | Existing game over | Retry · Quit to Levels **or** Challenges | Thud |
| Sprint **time up** | Success / “Time’s up” (not danger red) | Retry · Quit to Challenges | Soft complete, not thud |
| Collector **clear** | Success | Retry · Quit | Short fanfare (SFX on) |
| Zen crash | Game over (expected) | Retry · Quit to Challenges | Thud |
| Guest | Same **Save score — create profile** banner | Unchanged | — |

**Quit** must return to the **place they started** (Levels vs Challenges), not always Levels.

Share: same 9:16 card; add a small **Sprint / Daily** chip on the image when that score is what they share. Do not design a second share layout.

**Hot-seat (1.7):** between runs, a sheet: avatar + “Hand to the next player” + Continue. Same radii (16) as pause.

---

## 7. Dash and Shield (1.6) — touch and keyboard

**Touch Dash:** large **hold** control, bottom **opposite** the pause control (e.g. pause top-end, Dash bottom-start) so the thumb does not cover the snake head. Minimum 56×56; label or icon + “Hold”. Release = stop dash.

**Do not:** on-screen D-pad, floating joystick, or double-tap-anywhere (conflicts with swipe).

**Desktop:** arrows still steer. **Esc = pause** (keep). Prefer **Shift = Dash** so Space can stay pause/resume as today. Document the choice in [UX_DESIGN.md](./UX_DESIGN.md) when implementing.

**Shield:** pip in HUD + subtle bark/armor on the **head** (pattern, not color-only). Consume = pip empty + light haptic.

---

## 8. Board language (new rules, old materials)

Stay on existing snake / food / bark blockers. New rules need **one extra cue** each:

| Rule | Board cue | Avoid |
|------|-----------|--------|
| Sprint | Amber timer in HUD only | Full-screen clock |
| Wrap (existing) | Dashed / glow **edge** | — |
| Burrows | **Two matching amber rings** on cells | Calling it Wrap |
| Growing walls | Same stump art as Maze + **chip name different** | Silent new rocks in campaign Maze |
| Bonus critter | Existing epic/rare art + **ring on the cell** | Extra HUD row |
| Bitter fruit | Wilted **shape** + icon vs ripe sibling | Red vs green only |
| Collector targets | Soft highlight on those icons | Arrows covering cells |
| Ghost | 30–40% opacity snake, no collision VFX | Solid second snake |
| Lantern (2.0) | Dim far cells; generous radius on phones | Pitch-black board |

First-run of a new chip: **the card tip is enough**. Optional first-Start toast (one line, dismissible) — not a modal tutorial stack.

---

## 9. High scores, profile, settings

**Scores (1.2+):** keep overall + per-level. Add a **section** “Challenges” with Sprint layouts and (1.7) today’s Daily. Empty state: “Play a Sprint from Challenges” + link. Do not mix Daily into campaign level rows.

**Profile stats:** optional later: Sprint best, Zen length. Do not bury campaign highest level.

**Settings → Display (additive):**

| When | Control |
|------|---------|
| 1.7 | Show ghost (default on if Reduce Motion off) |
| 1.6 | none required for Dash |
| Always | Existing control hints, daily **quote** tip, snake look, language |

Do not add a “Modes” settings debugger (no blender toggles).

---

## 10. Motion, accessibility, l10n

**Motion budget add-ons (still short):** Sprint last-10s tick (visual + optional SFX), success sheet enter, Dash whoosh, burrow whoosh, bonus ring. Cap concurrent board pulses at **one**.

**Accessibility:**

- Timer and Collector counts are **text**, not color-only  
- Bitter vs ripe: shape + icon  
- Locked Challenges: lock icon + text  
- Dash/Pause targets ≥ 48×48  
- Reduce Motion: no last-10s pulse, no ghost, no food pulse stack  

**Copy:** ARB keys for hub title, every chip, every tip, success vs game over, “this device, today” (Daily honesty). Kiswahili in the same change set.

---

## 11. Map to full releases

| Version | UI/UX that must ship with it |
|---------|------------------------------|
| **1.2** | Home Challenges entry · hub with Sprint cards · amber timer · success sheet · scores section · Quit to Challenges · coach mark |
| **1.3** | Hub rows for Zen / Collector · HUD chips / no timer on Zen · Collector success · optional campaign level still uses existing level cards + extra objective chips |
| **1.4** | Bonus **on-tile** ring · Rising stumps card distinct from Maze |
| **1.5** | Burrow rings · bitter art · new chips/tips |
| **1.6** | Shield pip + head cue · Dash hold control · Shift vs Space documented |
| **1.7** | Daily date on card · ghost opacity · hot-seat hand-off · Settings ghost toggle |
| **2.0** | Only if the pillar is chosen; still one hub row, not a new IA |

Implement UI in the **same release** as the mechanic so Challenges never looks empty or “coming soon” for a shipped mode.

---

## 12. Explicitly not recommended

- Second Play-style FAB  
- Replacing campaign with a mode carousel on Home  
- Joystick or reverse-input “hard mode”  
- Color-only poison fruit  
- Global live leaderboard chrome  
- Tutorial of more than one coach mark per new hub  
- HUD that wraps to three lines on a phone  

---

## 13. When this becomes shipped UX

Move the implemented pieces into [UX_DESIGN.md](./UX_DESIGN.md) (screen map, HUD, sheets, keyboard) and keep this file as backlog for unreleased versions. Same change set: l10n, tests, [releases/](./releases/README.md) checkboxes.
