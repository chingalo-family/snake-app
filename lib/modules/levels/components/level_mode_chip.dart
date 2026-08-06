import 'package:flutter/material.dart';
import 'package:snake_app/core/models/game_mode.dart';
import 'package:snake_app/core/theme/app_colors.dart';

class LevelModeChip extends StatelessWidget {
  const LevelModeChip({
    super.key,
    required this.label,
    required this.mode,
  });

  final String label;
  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    final accent = switch (mode) {
      GameMode.classic => AppColors.brandPrimaryLight,
      GameMode.wrap => AppColors.brandInfo,
      GameMode.maze => AppColors.brandSecondary,
      GameMode.wrapMaze => AppColors.brandDanger,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
