/// Represents different types of power-ups in the game
enum PowerUpType {
  speedBoost,
  shield,
  scoreMultiplier,
  slowMotion,
}

/// Model for game power-ups
class PowerUp {
  final PowerUpType type;
  final String icon;
  final String name;
  final String description;
  final Duration duration;
  final double multiplier;

  const PowerUp({
    required this.type,
    required this.icon,
    required this.name,
    required this.description,
    required this.duration,
    this.multiplier = 1.0,
  });

  @override
  String toString() {
    return 'PowerUp: $name ($type)';
  }
}
