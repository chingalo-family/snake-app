# Snake App — UX Design & Flows

## Design goals

- One clear job per screen
- Fast path to Play
- Device-correct controls without explanation after onboarding
- Progress (levels + scores) always visible and motivating
- Calm, nature-forward visuals that support long sessions (not neon overload)

---

## Screen map

### 1. Splash

- Brand mark + app name
- Short load (prefs, audio, profile)
- Route: onboarding if first run, else Home
- Optional silent update check on Android

### 2. Onboarding (3–4 pages)

Slide composition (scrollable body; footer pinned): **title → visual → short body and/or distinct hint cards** — never duplicate the same sentence as both body and hint.

| Page | Content | Visual |
|------|---------|--------|
| Welcome | “Snake App” + tagline | Full-bleed soft green atmosphere + snake mark |
| Move | Swipe OR arrows + reverse tip | Animated gesture / key hint |
| Collect | Point values + combo tip (body only; no duplicate hint) | Soft panel with icon + score chip wrap (not cramped in the icon circle) |
| Save | Profile unlocks offline records | Simple profile silhouette |

Footer: page dots · Skip · Next / Get Started

### 3. Home

**Composition (not a dense dashboard)**

1. Brand / wordmark
2. Welcome banner — avatar + name when profile exists; otherwise Guest + default avatar (tappable → Profile)
3. Primary CTA: **Play** (FAB)
4. Secondary: Level progress chip (“Level 4 unlocked”)
5. Optional **A tip for you** card — fresh random quote each app open (dismissible for the session; Settings toggle)
6. Actions: High Scores · Profile · Settings

Avoid stacking stats walls on the first viewport.

### 4. Level select

- Scrollable list or grid of level cards
- Locked levels: muted + lock icon + unlock hint
- Mode chip (**Classic** / **Wrap** / **Maze** / **Wrap maze**) + short tip
- Mini board silhouette (edge + obstacles preview)
- Selected level: difficulty tags (Speed / Density)
- CTA: Start Level

### 5. Playground

```
┌─────────────────────────────────────┐
│  Score  •  Level  •  Best   [❚❚]   │  ← HUD
├─────────────────────────────────────┤
│                                     │
│           GAME BOARD                │  ← fills remaining space
│         (responsive grid)           │
│                                     │
└─────────────────────────────────────┘
```

Landscape tablet/desktop optional:

```
┌──────────────┬──────────────────────┐
│  Stats panel │                      │
│  Score       │      BOARD           │
│  Level       │                      │
│  Last eat    │                      │
│  [Pause]     │                      │
└──────────────┴──────────────────────┘
```

**Empty board cells:** subtle grid, low contrast  
**Snake:** unlockable skins; clear head with facing wedge; soft blink (Reduce Motion off)  
**Food:** icon-centered, gentle pulse on rare/epic  
**Wrap:** dashed edge cue · **Maze:** bark/amber blockers  

### 6. Pause / Game over sheets

- Pause: Resume · Restart · Quit to Levels
- Game over: Score · Level · Personal best delta · skin unlock lines  
  - **Share as image** when score > 0 (9:16 branded PNG with app icon, name, Google Play & App Store, unlocks)  
    - Mobile (Android/iOS) + macOS/Windows: system share sheet  
    - Linux: saves PNG under Downloads/Snake App and opens the folder (file share unsupported there)  
    - After adding the share plugin, use a full app restart (not hot restart) so native code registers  
  - If no profile: **Save score — create profile** (keeps the just-finished run in memory and persists it when the profile is saved)  
  - If profile: “New best!” or “Almost — try again”

### 7. Profile

- Avatar picker with suggested choices (10 quick avatars)
- Form: name*, email, phone
- Stats block: best score, highest level, games played
- Edit / Save

### 8. Settings

Grouped:

- **Audio** — SFX, Music
- **Feel** — Haptics (mobile)
- **Display** — Control hints, daily tip, snake look, language
- **App** — Check for updates, About, Privacy

### 9. About

Short story, version, package id, Chingalo Family, policy links.

### 10. High scores

Local only: overall best + per-level bests. Empty state encourages Play + Profile.  
Share overall best as a social image when `bestOverallScore > 0` (same platform behavior as game-over share).

### Navigation bar

- Non-home pages show top actions for **Home** and **More**
- **More** opens an action sheet with: Scoreboard, Profile, Settings

---

## Interaction patterns

### Swipe (touch)

- Direction from dominant axis of the gesture
- Minimum distance ~24–32 logical px
- One direction change per tick window (prevent spam)
- Reverse into self rejected (no toast; optional light haptic)

### Keyboard (desktop)

- Arrow keys change pending direction (reverse rejected same as swipe)
- Esc → Pause
- Space → Pause/Resume (optional)
- Enter on game over → Restart

### Feedback

| Event | Visual | Audio | Haptic |
|-------|--------|-------|--------|
| Eat common | Score +N float | Soft pop | Light |
| Eat rare/epic | Stronger float + flash | Higher cue | Medium |
| Power-up | Glow on head/HUD | Distinct sting | Medium |
| Collision | Screen shake light | Thud | Heavy |
| New best | Confetti/brief banner | Fanfare short | Success |
| Share score | Branded PNG card | — | — |

---

## Accessibility

- Minimum tap targets 48×48 on touch
- Contrast AA for text on surfaces
- Don’t rely on color alone for locked vs unlocked (or skins — pattern/stripe too)
- Respect Reduce Motion: disable non-essential pulses / head blink

---

## System chrome (edge-to-edge)

- Android draws under status / navigation bars when targeting SDK 35+ (app enables `SystemUiMode.edgeToEdge` for older Android too)
- Transparent system bars; icon brightness follows light/dark theme
- Interactive content clears insets via `SafeArea` (home, game, splash, onboarding, sheets) or `pageScrollPadding` (scrollable app-bar pages)
- Do not opt out with `windowOptOutEdgeToEdgeEnforcement`

---

## Motion budget (intentional, not noisy)

1. Onboarding page transition (slide/fade)
2. Food pulse (subtle)
3. Score float on eat
4. Level unlock celebration (short)
5. Head idle blink (Reduce Motion off)
6. Tip card enter/dismiss
7. Share card prepare (brief)

Avoid continuous glow stacks and particle spam in HUD.
