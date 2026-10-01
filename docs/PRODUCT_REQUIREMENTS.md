# Product Requirements Document

**Product:** Snake App  
**Publisher:** Chingalo Family  
**Package ID:** `chingalo.family.snake_app`  
**Version:** `2.0.0+4`  
**Status:** Shipped. Core play is offline. A local profile is optional until the player wants scores and unlocks saved.

## Problem

Players want a snake game they can open and understand immediately, on a phone or a desktop, without creating an account. Progress still has to feel personal: levels unlock, best scores stick, and later sessions are harder than the first ones.

## Product promise

Grow a snake, collect food, climb 30 campaign levels, and chase local high scores. Guest play is allowed. Creating a profile keeps scores, level unlocks, challenge bests, and cosmetics on the device.

## Audience

- Casual players who want a short run on a phone
- Players who want a longer campaign with clearer difficulty steps
- Desktop players who use a keyboard

## Platforms

| Platform | Distribution |
|----------|----------------|
| Android | [Google Play](https://play.google.com/store/apps/details?id=chingalo.family.snake_app) |
| Windows, macOS, Linux | GitHub Release zips from a manual desktop build on `main` |
| iOS | Built with Flutter. App Store listing is not published (`appStoreId` is empty) |

Languages: English and Kiswahili. Theme: light, dark, or system.

## In scope

### Campaign

- 30 levels. Speed and board density rise with the level number.
- Modes by band:
  - Levels 1–5: Classic (solid walls)
  - Levels 6–12: Classic and Wrap, alternating
  - Levels 13–20: Maze
  - Levels 21–30: Maze, with Wrap maze when the level number is divisible by 3
- Reaching that level’s unlock score opens the next level.
- Tiered collectibles and combo scoring.
- Snake skins unlock from the highest level reached.

### Challenges

A secondary hub, never equal in weight to Play on Home. Each challenge is a fixed run (board, walls, food rule, objective). Personal bests are local. A daily run is seeded from the calendar date. Optional ghost trace of a previous best can be shown.

### Profile and scores

- Play as a guest. The latest finished guest run stays in memory until a profile is created, then it is saved.
- One local profile: display name, optional email and phone, avatar.
- High scores are per level. Overall best, games played, best combo, and highest unlocked level live with the profile.

### Session quality

- First-run onboarding (move, collect, save).
- Swipe on touch. Arrow keys on desktop. Pause and game over sheets.
- Separate sound effects and music. Haptics on mobile.
- Share a branded score image.
- Android can open the Play Store listing to update.
- Home may show a dismissible daily tip.

## Out of scope

- Accounts, cloud sync, and remote leaderboards
- Real-time online multiplayer
- In-app purchases

Hot-seat and arena challenges are local only (same device).

## Success criteria

- A new player can finish onboarding and start level 1 without a profile.
- A profile stores the best score for a level and unlocks the next level only after the unlock score is met.
- Campaign modes match the bands above.
- Challenges are reachable from Home and do not replace the Play path.
- Core play works with no network. Settings and progress survive an app restart.
- Text and controls stay readable in light and dark themes, in English and Kiswahili.
