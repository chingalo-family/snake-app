# UI/UX Design Brief

**Direction:** nature arcade. Fresh green and warm amber on deep forest surfaces. Dark is the default for play. Light is available for daytime and preference. The look should stay calm across long sessions.

Tokens live in `lib/core/theme/`. Do not scatter raw hex through feature widgets. If a token changes, update this brief in the same change.

## Brand tokens

| Token | Hex | Role |
|-------|-----|------|
| Primary | `#1FA87A` | Actions, snake accent |
| Primary dark | `#14825C` | Pressed / emphasis |
| Primary light | `#3ECF98` | Success, soft highlight |
| Secondary | `#F0A202` | Score, rare food, secondary emphasis |
| Secondary muted | `#D4890A` | Secondary pressed |
| Danger | `#E85D4C` | Game over, errors |
| Info | `#3D8BFD` | Shields and info, used sparingly |

### Dark surfaces

| Token | Hex |
|-------|-----|
| Background | `#0B1F1A` |
| Raised (cards, sheets) | `#12352C` |
| Board | `#0F2A23` |
| Grid line | `#1A4338` |
| Text primary | `#F2F7F4` |
| Text secondary | `#A8C4B8` |
| Text muted | `#6F8F82` |

### Light surfaces

| Token | Hex |
|-------|-----|
| Background | `#F3F8F5` |
| Raised | `#FFFFFF` |
| Board | `#E5F2EB` |
| Grid line | `#C5DCD0` |
| Text primary | `#0F2A23` |
| Text secondary | `#3D5C50` |
| Text muted | `#6A8579` |

Typeface: **Nunito**. Radii: 16 for screens and cards, 12 for controls, 8 for chips. Prefer tonal surfaces over stacked shadows.

## Screen rules

- One job per screen.
- Home is brand, welcome, and Play. It is not a dashboard of stats.
- Challenges, scores, profile, and settings are secondary to Play.
- Locked levels use a lock icon as well as muted color.
- Empty board cells are a low-contrast grid.
- Wrap boards show a dashed edge. Maze blockers read as bark or amber obstacles.
- Food is centered in the cell. Rare and epic food may pulse. Reduce Motion turns that off.
- Snake head shows a facing wedge. Skins are cosmetic and also use pattern, not color alone.

### Snake skins

Unlocked by `highest_level_unlocked`. Default is Forest.

| Id | Unlocks at |
|----|------------|
| `forest` | 1 |
| `amber_leaf` | 5 |
| `river` | 10 |
| `sunset` | 15 |
| `midnight` | 20 |
| `champion` | 25 |

## Feedback

| Event | Visual | Audio | Haptic |
|-------|--------|-------|--------|
| Eat common | Score float | Soft pop | Light |
| Eat rare or epic | Stronger float | Higher cue | Medium |
| Collision | Light shake | Thud | Heavy |
| New best | Short banner | Short fanfare | Success |
| Share score | Branded image | None | None |

Motion budget: onboarding transition, food pulse, score float, level unlock, head blink, tip card, share prepare. No continuous glow on the HUD.

## Share image

9:16 branded card with the app icon, player name, score, and store marks. Android, iOS, macOS, and Windows use the system share sheet. Linux saves a PNG under Downloads/Snake App and opens that folder. After adding the share plugin, use a full restart so native code registers.

## Accessibility and chrome

- Minimum tap target 48×48 on touch.
- Body text stays readable on both themes.
- Respect Reduce Motion.
- Android draws edge to edge. System bar icons follow the theme. Content uses `SafeArea` or page scroll padding. Do not opt out of edge-to-edge enforcement.

## Icon

Launcher art is `assets/app-icon.png`. Adaptive icon background is `#0B1F1A`. Theme color for web launcher metadata is `#1FA87A`.
