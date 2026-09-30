# Plan 04 — Slither / .io-inspired play (offline)

**Status:** Planning  
**Inspired by:** [Slither.io](https://en.wikipedia.org/wiki/Slither.io), Snake.io, and other arena snakes: **boost** (spend length to go faster), **fleeing high-value pellets**, **kill by cutting off**, pellets dropped on death.

**Hard product rule:** core play stays **offline**. No live .io lobby, no accounts, no ads-for-mass. If we want the *feel*, we use **bots + a larger wrap map** or **single-snake boost**.

---

## E1. Burst boost (single player)

| | |
|--|--|
| **Working name** | **Dash** |
| **Rule** | Hold a control to move at 1.5–2× tick for a short time, **consuming length** (cannot dash below a minimum length). Optional: drop 1–2 low-value pellets behind (recoverable). |
| **Touch** | Second gesture: **double-tap** or a hold-on-HUD **Dash** button (large target). Do **not** replace swipe with a virtual stick. |
| **Desktop** | Space or Shift while arrows/WASD. |
| **Feel** | Clutch saves and aggressive intercepts of fleeing food. |
| **Audio** | Short whoosh on SFX channel only. |

**Tests:** cannot reverse into self while dashing; length floor; pellets dropped only if enabled.

---

## E2. Fleeing pellet

Same family as Google Cheese — implement once, reuse in Classic and in Arena. See [02 § B5](./02-google-snake-inspired.md).

---

## E3. Offline arena (bots)

| | |
|--|--|
| **Working name** | **Grove arena** |
| **Rule** | Large wrap board. 3–8 CPU snakes with simple AI (seek food, weak dash, avoid heads). Player dies on hitting **any** body. Dead snakes become pellet trails. Last surviving or first to length L wins. |
| **Feel** | Slither without the network. |
| **Risk** | AI fairness, performance on mid phones, HUD clutter. Wave **E** after Dash works in solo. |
| **Persistence** | Wins / best length in arena; profile gated. |

**Do not** require always-on internet. Bots run locally.

---

## E4. What we will not copy

- Coiling grief as the only skill (frustrating vs bots too).
- Cosmetic paywall skins as progression (keep nature-arcade unlocks cosmetic-optional later).
- Mouse-follow as the only desktop control (keep arrows; optional pointer later).

## Priority

Wave **E**: Dash in campaign or Zen first. Fleeing food can ship with Wave B. Arena only if Dash + Wrap feel good and frame time stays healthy.
