import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/l10n/app_localizations.dart';

class SnakeSkin {
  const SnakeSkin({
    required this.id,
    required this.unlockLevel,
    required this.headLight,
    required this.headDark,
    required this.body,
    required this.bodyStripe,
    required this.hasStripe,
  });

  final String id;
  final int unlockLevel;
  final Color headLight;
  final Color headDark;
  final Color body;
  final Color bodyStripe;
  final bool hasStripe;

  String label(AppLocalizations l10n) => switch (id) {
        'forest' => l10n.skinForest,
        'amber_leaf' => l10n.skinAmberLeaf,
        'river' => l10n.skinRiver,
        'sunset' => l10n.skinSunset,
        'midnight' => l10n.skinMidnight,
        'champion' => l10n.skinChampion,
        _ => id,
      };
}

abstract final class SnakeSkinsCatalog {
  static const forest = SnakeSkin(
    id: 'forest',
    unlockLevel: 1,
    headLight: AppColors.brandPrimaryLight,
    headDark: AppColors.brandPrimary,
    body: AppColors.brandPrimary,
    bodyStripe: AppColors.brandPrimaryDark,
    hasStripe: false,
  );

  static const amberLeaf = SnakeSkin(
    id: 'amber_leaf',
    unlockLevel: 5,
    headLight: Color(0xFFF5C542),
    headDark: AppColors.brandSecondary,
    body: Color(0xFFC4A035),
    bodyStripe: AppColors.brandSecondaryMuted,
    hasStripe: true,
  );

  static const river = SnakeSkin(
    id: 'river',
    unlockLevel: 10,
    headLight: Color(0xFF6ED6C4),
    headDark: Color(0xFF2A9B8F),
    body: Color(0xFF1F8A7E),
    bodyStripe: Color(0xFF147068),
    hasStripe: false,
  );

  static const sunset = SnakeSkin(
    id: 'sunset',
    unlockLevel: 15,
    headLight: Color(0xFFFFB347),
    headDark: Color(0xFFE07A2F),
    body: Color(0xFFC45C3A),
    bodyStripe: Color(0xFF9A3F28),
    hasStripe: true,
  );

  static const midnight = SnakeSkin(
    id: 'midnight',
    unlockLevel: 20,
    headLight: AppColors.brandPrimaryLight,
    headDark: AppColors.brandPrimary,
    body: Color(0xFF0D3D32),
    bodyStripe: Color(0xFF1A5C4A),
    hasStripe: false,
  );

  static const champion = SnakeSkin(
    id: 'champion',
    unlockLevel: 25,
    headLight: Color(0xFFFFE08A),
    headDark: AppColors.brandSecondary,
    body: AppColors.brandPrimaryDark,
    bodyStripe: AppColors.brandSecondary,
    hasStripe: true,
  );

  static const List<SnakeSkin> all = [
    forest,
    amberLeaf,
    river,
    sunset,
    midnight,
    champion,
  ];

  static SnakeSkin byId(String? skinId) {
    for (final skin in all) {
      if (skin.id == skinId) return skin;
    }
    return forest;
  }

  static bool isUnlocked(SnakeSkin skin, int highestLevelUnlocked) {
    return highestLevelUnlocked >= skin.unlockLevel;
  }

  
  static List<SnakeSkin> unlockedBetween({
    required int previousHighest,
    required int nextHighest,
  }) {
    return all
        .where(
          (skin) =>
              skin.unlockLevel > previousHighest &&
              skin.unlockLevel <= nextHighest,
        )
        .toList(growable: false);
  }
}
