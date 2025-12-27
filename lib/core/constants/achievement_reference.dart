import 'package:snake_app/core/models/achievement.dart';

/// Reference constants for game achievements
class AchievementReference {
  static final List<Achievement> allAchievements = [
    // Score-based achievements
    Achievement(
      id: 'score_100',
      title: 'Getting Started',
      description: 'Reach a score of 100',
      icon: '🌟',
      targetValue: 100,
      type: AchievementType.score,
    ),
    Achievement(
      id: 'score_500',
      title: 'Snake Amateur',
      description: 'Reach a score of 500',
      icon: '🎯',
      targetValue: 500,
      type: AchievementType.score,
    ),
    Achievement(
      id: 'score_1000',
      title: 'Snake Pro',
      description: 'Reach a score of 1000',
      icon: '🏆',
      targetValue: 1000,
      type: AchievementType.score,
    ),
    Achievement(
      id: 'score_2500',
      title: 'Snake Master',
      description: 'Reach a score of 2500',
      icon: '👑',
      targetValue: 2500,
      type: AchievementType.score,
    ),
    Achievement(
      id: 'score_5000',
      title: 'Snake Legend',
      description: 'Reach a score of 5000',
      icon: '💎',
      targetValue: 5000,
      type: AchievementType.score,
    ),

    // Streak-based achievements
    Achievement(
      id: 'streak_5',
      title: 'On Fire',
      description: 'Get a 5x combo streak',
      icon: '🔥',
      targetValue: 5,
      type: AchievementType.streak,
    ),
    Achievement(
      id: 'streak_10',
      title: 'Unstoppable',
      description: 'Get a 10x combo streak',
      icon: '💥',
      targetValue: 10,
      type: AchievementType.streak,
    ),
    Achievement(
      id: 'streak_20',
      title: 'Legendary Streak',
      description: 'Get a 20x combo streak',
      icon: '⚡',
      targetValue: 20,
      type: AchievementType.streak,
    ),

    // Food collected achievements
    Achievement(
      id: 'food_50',
      title: 'Hungry Snake',
      description: 'Collect 50 food items in one game',
      icon: '🍎',
      targetValue: 50,
      type: AchievementType.foodCollected,
    ),
    Achievement(
      id: 'food_100',
      title: 'Feast Mode',
      description: 'Collect 100 food items in one game',
      icon: '🍕',
      targetValue: 100,
      type: AchievementType.foodCollected,
    ),

    // Games played achievements
    Achievement(
      id: 'games_10',
      title: 'Dedicated Player',
      description: 'Play 10 games',
      icon: '🎮',
      targetValue: 10,
      type: AchievementType.gamesPlayed,
    ),
    Achievement(
      id: 'games_50',
      title: 'Snake Enthusiast',
      description: 'Play 50 games',
      icon: '🎪',
      targetValue: 50,
      type: AchievementType.gamesPlayed,
    ),
    Achievement(
      id: 'games_100',
      title: 'Snake Addict',
      description: 'Play 100 games',
      icon: '🎊',
      targetValue: 100,
      type: AchievementType.gamesPlayed,
    ),
  ];

  static Achievement? getAchievementById(String id) {
    try {
      return allAchievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}
