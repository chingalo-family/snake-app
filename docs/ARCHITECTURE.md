# Snake App - Code Architecture Guide

## Overview
This document provides a comprehensive guide to the Snake App's code architecture, explaining the structure, patterns, and best practices used throughout the codebase.

## Architecture Pattern

The app follows a **layered architecture** pattern with clear separation of concerns:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│    (UI Widgets & Components)        │
├─────────────────────────────────────┤
│      State Management Layer         │
│   (Provider/ChangeNotifier)         │
├─────────────────────────────────────┤
│        Business Logic Layer         │
│    (Services & Utilities)           │
├─────────────────────────────────────┤
│          Data Layer                 │
│   (Models & Constants)              │
└─────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── core/                          # Core application components
│   ├── app_state/                # State management
│   │   ├── snake_state/          # Snake game state
│   │   ├── game_score_state/     # Score management state
│   │   ├── user_state/           # User authentication state
│   │   └── app_update_state/     # App update state
│   ├── components/               # Reusable UI components
│   │   ├── app_bar_container.dart
│   │   ├── combo_display.dart
│   │   └── power_up_display.dart
│   ├── constants/                # App-wide constants
│   │   ├── app_info_reference.dart
│   │   ├── game_direction.dart
│   │   ├── power_up_reference.dart
│   │   └── achievement_reference.dart
│   ├── models/                   # Data models
│   │   ├── power_up.dart
│   │   ├── combo.dart
│   │   ├── achievement.dart
│   │   └── game_food_score.dart
│   ├── services/                 # Business logic services
│   │   ├── game_sound_service.dart
│   │   ├── user_service.dart
│   │   └── dhis2_http_service.dart
│   ├── utils/                    # Utility functions
│   │   ├── grid_util.dart
│   │   └── app_util.dart
│   └── offline_db/               # Local database
│       └── user_database.dart
├── modules/                      # Feature modules
│   ├── game/                     # Game module
│   │   ├── game.dart            # Game home screen
│   │   ├── pages/
│   │   │   └── game_play.dart   # Main gameplay screen
│   │   └── components/
│   │       ├── game_play_container.dart
│   │       ├── game_play_action.dart
│   │       └── game_confirmation_modal.dart
│   ├── splash/                   # Splash screen module
│   ├── leaderboard/             # Leaderboard module
│   ├── user/                    # User authentication module
│   ├── settings/                # Settings module
│   └── about/                   # About screen module
└── main.dart                    # App entry point
```

## Layer Details

### 1. Data Layer

#### Models (`lib/core/models/`)
Immutable data classes representing domain entities.

**Key Principles:**
- Immutable by default (use `final` fields)
- Include `toString()` for debugging
- Provide `toJson()`/`fromJson()` for serialization when needed
- Use enums for type safety

**Example:**
```dart
class PowerUp {
  final PowerUpType type;
  final String icon;
  final String name;
  final Duration duration;
  
  const PowerUp({
    required this.type,
    required this.icon,
    required this.name,
    required this.duration,
  });
}
```

#### Constants (`lib/core/constants/`)
Static configuration and reference data.

**Key Principles:**
- Use `static const` for compile-time constants
- Group related constants in reference classes
- Provide helper methods for lookups

**Example:**
```dart
class PowerUpReference {
  static const PowerUp speedBoost = PowerUp(...);
  static const PowerUp shield = PowerUp(...);
  
  static List<PowerUp> get allPowerUps => [speedBoost, shield];
  static PowerUp? getPowerUpByType(PowerUpType type) {...}
}
```

### 2. Business Logic Layer

#### Services (`lib/core/services/`)
Encapsulate business logic and external interactions.

**Key Principles:**
- Single responsibility per service
- Async operations return `Future<T>`
- Handle errors gracefully
- Use dependency injection

**Example:**
```dart
class GameSoundService {
  static final GameSoundService instance = GameSoundService._internal();
  
  factory GameSoundService() => instance;
  GameSoundService._internal();
  
  Future<void> playBackgroundMusic() async {...}
  Future<void> pauseAll() async {...}
}
```

#### Utilities (`lib/core/utils/`)
Pure functions for common operations.

**Key Principles:**
- Stateless utility functions
- No side effects
- Testable in isolation

**Example:**
```dart
class GridUtil {
  static int getGridColumnsCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AppInfoReference.getGridColumnsCount(width);
  }
}
```

### 3. State Management Layer

#### ChangeNotifier Pattern
Uses Provider package with ChangeNotifier for reactive state.

**Key Principles:**
- One state class per domain concern
- Private fields with public getters
- Call `notifyListeners()` after state changes
- Dispose of resources in cleanup

**Example:**
```dart
class SnakeState with ChangeNotifier {
  int _score = 0;
  int get score => _score;
  
  void updateScore(int points) {
    _score += points;
    notifyListeners();
  }
  
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
```

#### State Classes

**SnakeState** (`snake_state.dart`)
- Manages snake position, direction, movement
- Handles power-ups and combos
- Controls game loop timer
- Tracks score and statistics

**GameScoreState** (`game_score_state.dart`)
- Manages leaderboard data
- Handles score submission
- Tracks best scores

**UserState** (`user_state.dart`)
- Manages user authentication
- Stores user preferences
- Handles login/logout

### 4. Presentation Layer

#### Components (`lib/core/components/`)
Reusable, self-contained UI widgets.

**Key Principles:**
- Stateless when possible
- Accept configuration via constructor
- Use composition over inheritance
- Keep widget tree shallow

**Example:**
```dart
class ComboDisplay extends StatefulWidget {
  const ComboDisplay({super.key});
  
  @override
  State<ComboDisplay> createState() => _ComboDisplayState();
}
```

#### Pages/Screens
Top-level screens that compose components.

**Key Principles:**
- Use `Consumer<T>` to subscribe to state
- Handle navigation
- Compose smaller components
- Separate UI from business logic

**Example:**
```dart
class GamePlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: Column(
        children: [
          GamePlayAction(),
          GamePlayContainer(),
        ],
      ),
    );
  }
}
```

## Design Patterns

### 1. Provider Pattern
**Used For:** State management and dependency injection

**Benefits:**
- Reactive UI updates
- Minimal boilerplate
- Easy testing with mock providers

### 2. Singleton Pattern
**Used For:** Services that need single instances

**Example:** `GameSoundService.instance`

### 3. Factory Pattern
**Used For:** Creating objects from JSON

**Example:** `Achievement.fromJson(json)`

### 4. Builder Pattern
**Used For:** Complex widget construction

**Example:** `Consumer<SnakeState>` builder function

### 5. Observer Pattern
**Used For:** UI reacting to state changes

**Implementation:** ChangeNotifier + Provider

## State Flow

### Game Loop Flow
```
User Action (Swipe)
    ↓
updateSnakeDirection()
    ↓
Timer tick
    ↓
moveSnakePosition()
    ↓
Check collision/food
    ↓
Update state
    ↓
notifyListeners()
    ↓
UI rebuilds (Consumer)
```

### Power-Up Flow
```
generateSnakeFood()
    ↓
Random chance (20%)
    ↓
_generatePowerUp()
    ↓
Snake collects power-up
    ↓
activatePowerUp()
    ↓
Start timer for duration
    ↓
Apply effects
    ↓
Timer expires
    ↓
_deactivatePowerUp()
```

## Best Practices

### Code Style

#### 1. Naming Conventions
- **Classes:** PascalCase (`SnakeState`, `PowerUp`)
- **Files:** snake_case (`snake_state.dart`)
- **Variables:** camelCase (`_comboCount`, `hasShield`)
- **Constants:** camelCase (`defaultAppColor`)
- **Private:** Prefix with underscore (`_score`, `_resetCombo`)

#### 2. Documentation
- Add doc comments for public APIs
- Explain "why" not "what" in comments
- Document complex algorithms

```dart
/// Calculates final score with combo and power-up multipliers
/// 
/// The formula combines base food score with combo bonus,
/// then applies both combo multiplier and power-up multiplier
int _calculateScore(int baseScore) {
  // Implementation
}
```

#### 3. Error Handling
- Use try-catch for operations that can fail
- Log errors for debugging
- Provide user-friendly error messages
- Never swallow exceptions silently

```dart
try {
  await someRiskyOperation();
} catch (e) {
  debugPrint('Operation failed: $e');
  // Show user feedback
}
```

### Performance Optimization

#### 1. Widget Rebuilds
- Use `const` constructors when possible
- Limit Consumer widget scope
- Extract static widgets

```dart
// ❌ Bad: Entire screen rebuilds
Consumer<SnakeState>(
  builder: (context, state, child) {
    return Scaffold(
      body: Column(children: [/* many widgets */]),
    );
  },
)

// ✅ Good: Only score widget rebuilds
Scaffold(
  body: Column(
    children: [
      Consumer<SnakeState>(
        builder: (context, state, child) {
          return Text('Score: ${state.score}');
        },
      ),
      const StaticWidget(), // Won't rebuild
    ],
  ),
)
```

#### 2. Memory Management
- Dispose controllers and listeners
- Cancel timers
- Clear large data structures

```dart
@override
void dispose() {
  _controller.dispose();
  _timer?.cancel();
  super.dispose();
}
```

#### 3. Animations
- Use `AnimationController` efficiently
- Reuse controllers when possible
- Keep animation duration reasonable (100-500ms)

### Testing Strategy

#### Unit Tests
Test business logic in isolation:
- State calculations
- Service methods
- Utility functions

#### Widget Tests
Test UI components:
- Widget rendering
- User interactions
- State integration

#### Integration Tests
Test complete features:
- Game flow
- Navigation
- State persistence

## Module Structure

### Game Module Example
```
game/
├── game.dart                    # Module entry point
├── pages/                       # Screens in this module
│   └── game_play.dart
└── components/                  # Module-specific widgets
    ├── game_play_container.dart # Grid rendering
    ├── game_play_action.dart    # Controls
    └── game_confirmation_modal.dart # Dialogs
```

**Benefits:**
- Clear feature boundaries
- Easy to locate related code
- Supports team collaboration
- Enables code reuse

## Dependency Management

### Internal Dependencies
```dart
// ✅ Good: Clear, single-direction flow
Models → Constants
  ↓
Services → Utils
  ↓
State
  ↓
UI Components
```

### External Packages
Key dependencies and their purposes:

- **provider:** State management
- **flutter_svg:** Vector graphics
- **audioplayers:** Sound effects
- **haptic_feedback:** Tactile feedback
- **sqflite:** Local database
- **shared_preferences:** Simple storage

## Adding New Features

### Step-by-Step Guide

#### 1. Define the Model
```dart
// lib/core/models/new_feature.dart
class NewFeature {
  final String id;
  final int value;
  
  const NewFeature({required this.id, required this.value});
}
```

#### 2. Add Constants (if needed)
```dart
// lib/core/constants/new_feature_reference.dart
class NewFeatureReference {
  static const NewFeature example = NewFeature(id: 'ex', value: 10);
}
```

#### 3. Update State
```dart
// Add to existing state or create new state class
class SnakeState with ChangeNotifier {
  NewFeature? _activeFeature;
  NewFeature? get activeFeature => _activeFeature;
  
  void activateFeature(NewFeature feature) {
    _activeFeature = feature;
    notifyListeners();
  }
}
```

#### 4. Create UI Component
```dart
// lib/core/components/new_feature_display.dart
class NewFeatureDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SnakeState>(
      builder: (context, state, child) {
        if (state.activeFeature == null) return SizedBox.shrink();
        return Container(/* UI */);
      },
    );
  }
}
```

#### 5. Integrate into Game
```dart
// Update game_play_container.dart or relevant file
children: [
  // ... existing widgets
  NewFeatureDisplay(),
]
```

## Conclusion

This architecture promotes:
- **Maintainability:** Clear structure and separation
- **Testability:** Isolated, testable components
- **Scalability:** Easy to add features
- **Reusability:** Shared components and utilities
- **Performance:** Optimized rebuilds and resource usage

Following these patterns ensures consistent, high-quality code across the project.
