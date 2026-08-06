import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/modules/levels/components/mini_board_painter.dart';

class LevelPreviewThumb extends StatelessWidget {
  const LevelPreviewThumb({
    super.key,
    required this.levelConfig,
    required this.isUnlocked,
  });

  final LevelConfig levelConfig;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.brandPrimary.withValues(alpha: 0.18)
            : theme.colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: isUnlocked
          ? CustomPaint(
              size: const Size(40, 40),
              painter: MiniBoardPainter(levelConfig: levelConfig),
            )
          : Icon(
              Icons.lock_outline_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
    );
  }
}
