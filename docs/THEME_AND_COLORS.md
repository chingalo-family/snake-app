# Snake App — Theme & Colors

## Direction

**Nature arcade** — fresh greens and warm amber accents on deep forest surfaces.  
Readable for long play sessions. Distinct from generic purple/indigo AI UI and from flat single-color dark themes.

Supports **light** and **dark**. Dark is default for gameplay immersion; light for daytime / accessibility preference.

---

## Brand tokens

| Token | Hex | Role |
|-------|-----|------|
| `brand.primary` | `#1FA87A` | Primary actions, snake accent, key highlights |
| `brand.primaryDark` | `#14825C` | Pressed / emphasis |
| `brand.primaryLight` | `#3ECF98` | Soft glows, success chips |
| `brand.secondary` | `#F0A202` | Score pops, rare food accent, CTAs secondary |
| `brand.secondaryMuted` | `#D4890A` | Secondary pressed |
| `brand.danger` | `#E85D4C` | Game over, errors |
| `brand.info` | `#3D8BFD` | Shields / info (sparingly) |

### Dark surfaces

| Token | Hex | Role |
|-------|-----|------|
| `surface.bg` | `#0B1F1A` | App background |
| `surface.raised` | `#12352C` | Cards, sheets |
| `surface.board` | `#0F2A23` | Playground field |
| `surface.gridLine` | `#1A4338` | Subtle cell separators |
| `text.primary` | `#F2F7F4` | Titles / HUD |
| `text.secondary` | `#A8C4B8` | Subtitles |
| `text.muted` | `#6F8F82` | Hints |

### Light surfaces

| Token | Hex | Role |
|-------|-----|------|
| `surface.bg` | `#F3F8F5` | App background |
| `surface.raised` | `#FFFFFF` | Cards |
| `surface.board` | `#E5F2EB` | Playground |
| `surface.gridLine` | `#C5DCD0` | Grid |
| `text.primary` | `#0F2A23` | Titles |
| `text.secondary` | `#3D5C50` | Subtitles |
| `text.muted` | `#6A8579` | Hints |

### Snake & entities

| Element | Dark | Light |
|---------|------|-------|
| Snake head | `#3ECF98` → `#1FA87A` gradient | `#1FA87A` → `#14825C` |
| Snake body | `#1FA87A` at 85% opacity | `#14825C` |
| Common food ring | `#A8C4B8` | `#6A8579` |
| Rare food ring | `#F0A202` | `#D4890A` |
| Epic food ring | `#E85D4C` + soft pulse | same |

---

## Typography

Avoid Inter / Roboto / Arial as display.

| Role | Suggestion | Fallback |
|------|------------|----------|
| Display / brand | **Nunito** or **Fredoka** (rounded, playful) | `sans-serif` rounded |
| HUD / numbers | **JetBrains Mono** or **Space Grotesk** | tabular figures |
| Body | **Nunito Sans** / **Source Sans 3** | system UI |

Load via `google_fonts` or bundled assets.

---

## Elevation & shape

- Corner radius: **16** screens/cards, **12** controls, **8** chips, **999** only for true circular avatars (not every button)
- Prefer soft tonal separation over multi-layer drop shadows
- Sheets: top radius 24, subtle scrim

---

## Gradients (atmosphere, not purple)

Dark home / splash:

```
linear: #0B1F1A → #12352C → #0B1F1A
optional radial highlight: #1FA87A at 8% opacity top-center
```

Avoid purple-to-indigo and cream/terracotta stock looks.

---

## Flutter `ColorScheme` seed map

```dart
// Conceptual — implement in lib/core/theme/app_theme.dart
ColorScheme.dark(
  primary: Color(0xFF1FA87A),
  secondary: Color(0xFFF0A202),
  error: Color(0xFFE85D4C),
  surface: Color(0xFF12352C),
  onPrimary: Color(0xFF0B1F1A),
  onSecondary: Color(0xFF0B1F1A),
  onSurface: Color(0xFFF2F7F4),
);
```

Scaffold background should use `surface.bg` (`#0B1F1A`), not pure black.

---

## UX color rules

1. Primary green = “go / play / success”
2. Amber = “reward / score / attention” — use sparingly so it stays special
3. Red = “stop / death” only
4. Never encode difficulty only with red/green; add labels/icons
5. Board contrast: snake and food must pop against `surface.board` at a glance

---

## Web / PWA

`theme_color`: `#1FA87A`  
`background_color`: `#0B1F1A`
