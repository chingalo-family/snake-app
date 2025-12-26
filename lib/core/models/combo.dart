/// Model for combo system to make gameplay more engaging
class Combo {
  final int count;
  final double multiplier;
  final int bonusScore;

  const Combo({
    required this.count,
    required this.multiplier,
    this.bonusScore = 0,
  });

  /// Get combo tier name for display
  String get tierName {
    if (count >= 20) return 'LEGENDARY';
    if (count >= 15) return 'EPIC';
    if (count >= 10) return 'SUPER';
    if (count >= 5) return 'GREAT';
    if (count >= 3) return 'NICE';
    return 'COMBO';
  }

  /// Get combo color based on tier
  String get colorName {
    if (count >= 20) return 'purple';
    if (count >= 15) return 'orange';
    if (count >= 10) return 'red';
    if (count >= 5) return 'yellow';
    if (count >= 3) return 'green';
    return 'blue';
  }

  @override
  String toString() {
    return 'Combo x$count ($tierName) - ${multiplier}x multiplier';
  }
}
