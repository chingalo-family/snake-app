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

| Page | Content | Visual |
|------|---------|--------|
| Welcome | “Snake App” + tagline | Full-bleed soft green atmosphere + snake mark |
| Move | Swipe OR arrows (adaptive copy) | Animated gesture / key hint |
| Collect | Animal & food icons with point chips | Icon row + score badges |
| Save | Profile unlocks offline records | Simple profile silhouette |

Footer: page dots · Skip · Next / Get Started

### 3. Home

**Composition (not a dense dashboard)**

1. Brand / wordmark
2. Primary CTA: **Play**
3. Secondary: Level progress chip (“Level 4 unlocked”)
4. Row: High Scores · Profile · Settings
5. Footer link: About · Update available? (if any)

Avoid stacking stats walls on the first viewport.

### 4. Level select

- Scrollable list or grid of level cards
- Locked levels: muted + lock icon + unlock hint
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
**Snake:** rounded segments, clear head  
**Food:** icon-centered, gentle pulse on rare/epic  

### 6. Pause / Game over sheets

- Pause: Resume · Restart · Quit to Levels
- Game over: Score · Level · Personal best delta  
  - If no profile: **Save score — create profile**  
  - If profile: “New best!” or “Almost — try again”

### 7. Profile

- Avatar initial from username
- Form: username*, full name*, email, phone
- Stats block: best score, highest level, games played
- Edit / Save

### 8. Settings

Grouped:

- **Audio** — SFX, Music
- **Feel** — Haptics (mobile)
- **Display** — Theme, control hints
- **App** — Check for updates, About, Privacy

### 9. About

Short story, version, package id, Chingalo Family, policy links.

### 10. High scores

Local only: overall best + per-level bests. Empty state encourages Play + Profile.

---

## Interaction patterns

### Swipe (touch)

- Direction from dominant axis of the gesture
- Minimum distance ~24–32 logical px
- One direction change per tick window (prevent spam)

### Keyboard (desktop)

- Arrow keys change pending direction
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

---

## Accessibility

- Minimum tap targets 48×48 on touch
- Contrast AA for text on surfaces
- Don’t rely on color alone for locked vs unlocked
- Respect Reduce Motion: disable non-essential pulses

---

## Motion budget (intentional, not noisy)

1. Onboarding page transition (slide/fade)
2. Food pulse (subtle)
3. Score float on eat
4. Level unlock celebration (short)

Avoid continuous glow stacks and particle spam in HUD.
