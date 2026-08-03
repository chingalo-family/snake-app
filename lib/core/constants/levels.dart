import 'dart:math' as math;

import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/l10n/app_localizations.dart';

class LevelConfig {
  const LevelConfig({
    required this.level,
    required this.tickMs,
    required this.columns,
    required this.rows,
    required this.unlockScore,
  });

  final int level;
  final int tickMs;
  final int columns;
  final int rows;
  final int unlockScore;

  String densityLabel(AppLocalizations l10n) {
    final cells = columns * rows;
    if (cells >= 360) return l10n.densityDense;
    if (cells >= 240) return l10n.densityStandard;
    return l10n.densitySpacious;
  }

  String speedLabel(AppLocalizations l10n) {
    if (tickMs <= 110) return l10n.speedVeryFast;
    if (tickMs <= 160) return l10n.speedFast;
    if (tickMs <= 220) return l10n.speedMedium;
    return l10n.speedSlow;
  }

  String title(AppLocalizations l10n) => l10n.levelNumber(level);
}

abstract final class LevelsCatalog {
  static final List<LevelConfig> levels = List.generate(
    AppConstants.totalLevels,
    (levelIndex) {
      final level = levelIndex + 1;
      return LevelConfig(
        level: level,
        tickMs: _tickFor(level),
        columns: _columnsFor(level),
        rows: _rowsFor(level),
        unlockScore: _unlockScoreFor(level),
      );
    },
  );

  static LevelConfig byLevel(int level) {
    final clamped = level.clamp(1, AppConstants.totalLevels);
    return levels[clamped - 1];
  }

  /// Tick interval in ms — slower early, ramps toward a playable floor.
  static int _tickFor(int level) {
    if (level <= 5) return 280 - ((level - 1) * 16);
    if (level <= 10) return 216 - ((level - 6) * 12);
    if (level <= 15) return 156 - ((level - 11) * 8);
    if (level <= 20) return 116 - ((level - 16) * 4);
    if (level <= 25) return 100 - ((level - 21) * 2);
    return math.max(88, 92 - ((level - 26) * 1));
  }

  /// Portrait density hints (GridMetrics remaps for landscape).
  static int _columnsFor(int level) {
    if (level <= 5) return 14 + level;
    if (level <= 10) return 18 + ((level - 5) ~/ 2);
    if (level <= 20) return 20 + ((level - 10) ~/ 3);
    return math.min(26, 23 + ((level - 20) ~/ 4));
  }

  static int _rowsFor(int level) {
    if (level <= 5) return 18 + level;
    if (level <= 10) return 22 + ((level - 5) ~/ 2);
    if (level <= 20) return 24 + ((level - 10) ~/ 3);
    return math.min(30, 27 + ((level - 20) ~/ 4));
  }

  /// Score needed on level N to unlock level N+1.
  static int _unlockScoreFor(int level) {
    if (level >= AppConstants.totalLevels) return 0;
    if (level <= 10) return 80 + (level * 40);
    if (level <= 20) return 120 + (level * 45);
    return 180 + (level * 50);
  }

  static bool canUnlockNext({
    required int completedLevel,
    required int scoreOnLevel,
    required int highestUnlocked,
  }) {
    if (completedLevel < highestUnlocked) return false;
    if (completedLevel >= AppConstants.totalLevels) return false;
    final levelConfig = byLevel(completedLevel);
    return scoreOnLevel >= levelConfig.unlockScore;
  }
}
