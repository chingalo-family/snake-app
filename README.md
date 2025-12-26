# Snake App 🐍

A modern, stylish, and addictive Snake game built with Flutter featuring power-ups, combos, and stunning visual effects!

## ✨ Features

### 🎮 Modern Gameplay
- **Power-Ups System**: Collect power-ups for temporary boosts (Speed, Shield, Score Multiplier, Slow Motion)
- **Combo System**: Build combos for exponential score multipliers (up to 3x+)
- **Dynamic Difficulty**: Progressive challenge as your snake grows
- **Smooth Controls**: Intuitive swipe gestures for fluid gameplay

### 🎨 Stylish Design
- **Modern UI**: Gradient backgrounds and glassmorphism effects
- **Smooth Animations**: Pulsing food, rotating power-ups, elastic combos
- **Visual Feedback**: Glow effects, shadows, and particle-like animations
- **Responsive Layout**: Optimized for all screen sizes

### 📊 Engagement Features
- **Statistics Tracking**: Score, food collected, highest combo, snake length
- **Leaderboard**: Compete with other players globally
- **Achievement System**: Unlock achievements for milestones (coming soon)
- **Progressive Rewards**: Higher combos = bigger rewards

### 🔊 Audio Experience
- Background music for immersive gameplay
- Haptic feedback on key events
- Sound effects (planned)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/chingalo-family/snake-app.git
   cd snake-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 How to Play

### Controls
- **Swipe Up**: Move snake upward
- **Swipe Down**: Move snake downward
- **Swipe Left**: Move snake left
- **Swipe Right**: Move snake right

### Game Elements
- **🍎 Food**: Collect to grow and score points (10-90 points)
- **⚡ Power-Ups**: Temporary boosts with special effects
- **🔥 Combos**: Consecutive food collection multiplies your score
- **🛡️ Shield**: Protects from one collision

### Score System
```
Final Score = (Base Score + Combo Bonus) × Combo Multiplier × Power-Up Multiplier
```

## 🎯 Power-Ups

| Icon | Name | Duration | Effect |
|------|------|----------|--------|
| ⚡ | Speed Boost | 5s | Increases speed by 1.5x |
| 🛡️ | Shield | 10s | Protects from one collision |
| 💎 | Score Multiplier | 8s | Doubles score gains |
| 🐌 | Slow Motion | 6s | Reduces speed to 70% |

## 🔥 Combo Tiers

| Combo Count | Tier | Multiplier | Color |
|-------------|------|------------|-------|
| 3-4 | NICE | 1.3x-1.4x | Green |
| 5-9 | GREAT | 1.5x-1.9x | Yellow |
| 10-14 | SUPER | 2.0x-2.4x | Red |
| 15-19 | EPIC | 2.5x-2.9x | Orange |
| 20+ | LEGENDARY | 3.0x+ | Purple |

## 📚 Documentation

Detailed documentation is available in the `docs/` folder:

- **[Getting Started Guide](docs/GETTING_STARTED.md)**: Complete player guide with tips and strategies
- **[Modern Features](docs/MODERN_FEATURES.md)**: Technical documentation of new features
- **[Architecture Guide](docs/ARCHITECTURE.md)**: Code structure and development guidelines

## 🏗️ Architecture

The app follows a **clean architecture** pattern with:
- **Presentation Layer**: UI widgets and components
- **State Management**: Provider pattern with ChangeNotifier
- **Business Logic**: Services and utilities
- **Data Layer**: Models and constants

### Key Technologies
- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **Audioplayers**: Background music and sound
- **Haptic Feedback**: Touch feedback
- **Sqflite**: Local database
- **Shared Preferences**: Settings storage

## 🎨 Design Principles

### Maintainability
- Clear separation of concerns
- Modular architecture
- Comprehensive documentation
- Consistent naming conventions

### Reusability
- Standalone components (`ComboDisplay`, `PowerUpDisplay`)
- Shared utilities and services
- Configurable constants

### Performance
- Optimized widget rebuilds
- Efficient animations
- Proper resource disposal

## 🛠️ Development

### Project Structure
```
lib/
├── core/                  # Core application components
│   ├── app_state/        # State management
│   ├── components/       # Reusable UI components
│   ├── constants/        # App-wide constants
│   ├── models/          # Data models
│   ├── services/        # Business logic
│   └── utils/           # Utility functions
└── modules/             # Feature modules
    ├── game/           # Game module
    ├── leaderboard/    # Leaderboard module
    ├── user/           # User authentication
    └── settings/       # Settings module
```

### Adding New Features

1. **Define Model**: Create model in `lib/core/models/`
2. **Add Constants**: Add to `lib/core/constants/`
3. **Update State**: Modify or create state in `lib/core/app_state/`
4. **Create UI**: Build component in `lib/core/components/`
5. **Integrate**: Add to relevant module

See [Architecture Guide](docs/ARCHITECTURE.md) for detailed instructions.

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Run with coverage
flutter test --coverage
```

## 🚀 Build & Deploy

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards
- Follow Flutter style guide
- Add documentation for public APIs
- Write tests for new features
- Ensure all tests pass before submitting

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- **Chingalo Family** - [GitHub](https://github.com/chingalo-family)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community contributors
- Open source packages used in this project

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/chingalo-family/snake-app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chingalo-family/snake-app/discussions)
- **Email**: support@chingalofamily.com

## 🗺️ Roadmap

### v1.1 (Planned)
- [ ] Achievement notifications
- [ ] Sound effects for power-ups
- [ ] Particle effects on food collection
- [ ] More power-up types

### v1.2 (Future)
- [ ] Daily challenges
- [ ] Custom skins
- [ ] Multiplayer mode
- [ ] Tournament system

### v2.0 (Future)
- [ ] 3D graphics mode
- [ ] AR mode
- [ ] Cross-platform sync
- [ ] Social features

## 📊 Stats

- **Version**: 1.0.1
- **Platform**: iOS, Android, Web
- **Language**: Dart
- **Framework**: Flutter 3.9.2+

---

Made with ❤️ by Chingalo Family

*Play. Compete. Enjoy!* 🎮✨

