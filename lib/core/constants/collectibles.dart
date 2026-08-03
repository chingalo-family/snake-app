import 'dart:math';

enum CollectibleTier { common, uncommon, rare, epic }

class Collectible {
  const Collectible({
    required this.icon,
    required this.score,
    required this.tier,
  });

  final String icon;
  final int score;
  final CollectibleTier tier;
}

abstract final class CollectiblesCatalog {
  static const List<Collectible> all = [
    Collectible(icon: '🍭', score: 10, tier: CollectibleTier.common),
    Collectible(icon: '🍇', score: 30, tier: CollectibleTier.common),
    Collectible(icon: '🍌', score: 30, tier: CollectibleTier.common),
    Collectible(icon: '🍉', score: 20, tier: CollectibleTier.common),
    Collectible(icon: '🍓', score: 20, tier: CollectibleTier.common),
    Collectible(icon: '🍕', score: 20, tier: CollectibleTier.uncommon),
    Collectible(icon: '🍔', score: 20, tier: CollectibleTier.uncommon),
    Collectible(icon: '🥑', score: 25, tier: CollectibleTier.uncommon),
    Collectible(icon: '🐠', score: 40, tier: CollectibleTier.uncommon),
    Collectible(icon: '🐖', score: 55, tier: CollectibleTier.uncommon),
    Collectible(icon: '🎂', score: 50, tier: CollectibleTier.rare),
    Collectible(icon: '🦆', score: 60, tier: CollectibleTier.rare),
    Collectible(icon: '🐓', score: 55, tier: CollectibleTier.rare),
    Collectible(icon: '🐐', score: 70, tier: CollectibleTier.rare),
    Collectible(icon: '🦈', score: 65, tier: CollectibleTier.epic),
    Collectible(icon: '🐬', score: 70, tier: CollectibleTier.epic),
    Collectible(icon: '🐄', score: 80, tier: CollectibleTier.epic),
    Collectible(icon: '🐂', score: 85, tier: CollectibleTier.epic),
    Collectible(icon: '🦌', score: 90, tier: CollectibleTier.epic),
  ];

  /// Weighted pick; rarer tiers unlock gradually by level.
  static Collectible pickWeighted(int level, [Random? random]) {
    final randomSource = random ?? Random();
    final allowed = all.where((collectible) {
      return switch (collectible.tier) {
        CollectibleTier.common => true,
        CollectibleTier.uncommon => level >= 2,
        CollectibleTier.rare => level >= 4,
        CollectibleTier.epic => level >= 8,
      };
    }).toList();

    final weights = allowed.map((collectible) {
      return switch (collectible.tier) {
        CollectibleTier.common => level >= 20 ? 28 : 40,
        CollectibleTier.uncommon => 25,
        CollectibleTier.rare => level >= 15 ? 14 : 10,
        CollectibleTier.epic => level >= 15 ? 7 : 4,
      };
    }).toList();

    final totalWeight = weights.fold<int>(0, (sum, weight) => sum + weight);
    var roll = randomSource.nextInt(totalWeight);
    for (var collectibleIndex = 0;
        collectibleIndex < allowed.length;
        collectibleIndex++) {
      roll -= weights[collectibleIndex];
      if (roll < 0) return allowed[collectibleIndex];
    }
    return allowed.last;
  }
}
