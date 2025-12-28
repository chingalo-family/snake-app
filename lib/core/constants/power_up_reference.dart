import 'package:snake_app/core/models/power_up.dart';

/// Reference constants for power-ups in the game
class PowerUpReference {
  static const PowerUp speedBoost = PowerUp(
    type: PowerUpType.speedBoost,
    icon: '⚡',
    name: 'Speed Boost',
    description: 'Increases snake speed for extra challenge',
    duration: Duration(seconds: 5),
    multiplier: 1.5,
  );

  static const PowerUp shield = PowerUp(
    type: PowerUpType.shield,
    icon: '🛡️',
    name: 'Shield',
    description: 'Protects from one collision',
    duration: Duration(seconds: 10),
  );

  static const PowerUp scoreMultiplier = PowerUp(
    type: PowerUpType.scoreMultiplier,
    icon: '💎',
    name: 'Score Multiplier',
    description: 'Doubles your score for a short time',
    duration: Duration(seconds: 8),
    multiplier: 2.0,
  );

  static const PowerUp slowMotion = PowerUp(
    type: PowerUpType.slowMotion,
    icon: '🐌',
    name: 'Slow Motion',
    description: 'Slows down the game for better control',
    duration: Duration(seconds: 6),
    multiplier: 0.7,
  );

  static List<PowerUp> get allPowerUps => [
    speedBoost,
    shield,
    scoreMultiplier,
    slowMotion,
  ];

  static PowerUp? getPowerUpByType(PowerUpType type) {
    try {
      return allPowerUps.firstWhere((p) => p.type == type);
    } catch (e) {
      return null;
    }
  }
}
