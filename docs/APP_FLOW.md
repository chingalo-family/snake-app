# App Flow

Routes live in `lib/app/routes.dart` and `lib/app/router.dart`. The router starts at `/splash`.

```
/splash
  ├─ first run  → /onboarding → /home
  └─ returning  → /home

/home
  ├─ Play           → /levels → /play/:level
  ├─ Challenges     → /challenges → /challenge/:id
  ├─ Profile        → /profile
  ├─ High scores    → /scores
  ├─ Settings       → /settings
  └─ About          → /about
```

Non-home screens expose Home and a More sheet (Scoreboard, Profile, Settings).

## Splash

Brand mark on the dark launch background. Preferences, the database, and audio finish behind the first frame. A failed startup shows retry. Android may check for a store update without blocking the route. First launch goes to onboarding; later launches go home.

## Onboarding

Three to four pages: welcome, how to move, collect and score, save with a profile. Footer: dots, Skip, Next / Get Started. Completing or skipping sets `onboarding_completed` and opens Home.

## Home

1. Wordmark
2. Welcome row: profile name and avatar, or Guest (tap opens Profile)
3. Play as the primary action
4. Level progress chip
5. Optional tip card (dismissible for the session; Settings can hide it)
6. Secondary actions: Challenges, High Scores, Profile, Settings

Play is the main job of the screen. Challenges stay secondary.

## Level select

Scrollable level cards for levels 1–30.

- Locked cards show a lock and the unlock hint.
- Each card shows the mode (Classic, Wrap, Maze, Wrap maze), a short tip, and a small board preview.
- The selected level shows speed and density, then Start Level.
- Start opens `/play/{level}`.

Unlock rule: the best score on the current level must reach that level’s `unlockScore`. Level 30 has no next level (`unlockScore` 0).

## Campaign play (`/play/:level`)

```
HUD: score, level, best, pause
Board: fills the remaining space
```

On a wide landscape layout, stats sit beside the board.

- Pause: Resume, Restart, Quit to Levels.
- Game over: score, level, personal-best delta, skin unlock lines.
  - Share image when the score is greater than 0.
  - No profile: **Save score - create profile**. The run stays in memory and is written when the profile is saved.
  - Profile exists: new best, or a prompt to try again.
- Eat, collision, and game over drive score float, audio, and haptics according to settings.

Input:

- Touch: direction from the dominant axis of a swipe (about 24–32 logical pixels). One direction change per tick window. Reverse is ignored.
- Desktop: arrow keys change the pending direction. Escape pauses.

## Challenges (`/challenges` → `/challenge/:id`)

The hub groups runs (timed, practice, board, clutch, today, expert). Choosing one opens the same playground with a `RunSpec` for that id.

An unknown id falls back to the first catalog entry. The daily id is `daily-YYYY-MM-DD`. If a profile exists and ghost display is on, the previous ghost trace for that challenge can render on the board. Bests update in preferences for that profile.

## Profile

Create or edit one local profile: avatar, name, optional email and phone. Stats: best score, highest level, games played. Saving flushes a pending guest run when one exists.

## High scores

Local only: overall best and per-level bests. Empty state points at Play and Profile. Overall best can be shared as an image when it is greater than 0.

## Settings

- Audio: sound effects, music
- Feel: haptics (mobile)
- Display: control hints, daily tip, ghost, snake look, language, theme
- App: check for updates, About, privacy

## About

Short story, version, package id, Chingalo Family, policy links.
