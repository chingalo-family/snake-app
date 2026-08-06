import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/game/obstacle_generator.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/models/game_mode.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class LevelsPage extends ConsumerWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(profileControllerProvider).highestLevelUnlocked;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: SnakePageAppBar(
        title: Text(l10n.levels),
        showBackButton: true,
        showHomeButton: true,
        showMoreButton: true,
      ),
      body: AtmosphereBackground(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          itemCount: LevelsCatalog.levels.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, levelIndex) {
            final levelConfig = LevelsCatalog.levels[levelIndex];
            final isUnlocked = levelConfig.level <= unlocked;
            return SurfaceCard(
              onTap: isUnlocked
                  ? () => context.push(AppRoutes.play(levelConfig.level))
                  : null,
              child: Row(
                children: [
                  _LevelPreviewThumb(
                    levelConfig: levelConfig,
                    isUnlocked: isUnlocked,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          levelConfig.title(l10n),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _ModeChip(
                              label: levelConfig.modeLabel(l10n),
                              mode: levelConfig.mode,
                            ),
                            if (isUnlocked)
                              Text(
                                l10n.speedDensity(
                                  levelConfig.speedLabel(l10n),
                                  levelConfig.densityLabel(l10n),
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.65),
                                ),
                              )
                            else
                              Text(
                                l10n.levelUnlockHint(
                                  LevelsCatalog.byLevel(levelConfig.level - 1)
                                      .unlockScore,
                                  levelConfig.level - 1,
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.65),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          levelConfig.mode.tip(l10n),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUnlocked)
                    FilledButton(
                      onPressed: () =>
                          context.push(AppRoutes.play(levelConfig.level)),
                      child: Text(l10n.start),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label, required this.mode});

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

class _LevelPreviewThumb extends StatelessWidget {
  const _LevelPreviewThumb({
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
              painter: _MiniBoardPainter(levelConfig: levelConfig),
            )
          : Icon(
              Icons.lock_outline_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
    );
  }
}

class _MiniBoardPainter extends CustomPainter {
  _MiniBoardPainter({required this.levelConfig});

  final LevelConfig levelConfig;

  @override
  void paint(Canvas canvas, Size size) {
    final previewColumns = 8;
    final previewRows = 8;
    final cellWidth = size.width / previewColumns;
    final cellHeight = size.height / previewRows;

    final boardPaint = Paint()
      ..color = AppColors.darkBoard
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(6),
      ),
      boardPaint,
    );

    if (levelConfig.mode.wrapsEdges) {
      final borderPaint = Paint()
        ..color = AppColors.brandInfo.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
          const Radius.circular(5),
        ),
        borderPaint,
      );
    } else {
      final borderPaint = Paint()
        ..color = AppColors.brandPrimaryLight.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
          const Radius.circular(5),
        ),
        borderPaint,
      );
    }

    if (levelConfig.mode.hasObstacles) {
      final boxes = ObstacleGenerator.generate(
        level: levelConfig.level,
        columns: previewColumns,
        rows: previewRows,
        enabled: true,
      );
      final rockPaint = Paint()..color = AppColors.brandSecondaryMuted;
      for (final box in boxes) {
        for (final cellIndex in box.cellIndexes(columns: previewColumns)) {
          final rowIndex = cellIndex ~/ previewColumns;
          final columnIndex = cellIndex % previewColumns;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                columnIndex * cellWidth + 1,
                rowIndex * cellHeight + 1,
                cellWidth - 2,
                cellHeight - 2,
              ),
              const Radius.circular(2),
            ),
            rockPaint,
          );
        }
      }
    }

    final levelLabel = TextPainter(
      text: TextSpan(
        text: '${levelConfig.level}',
        style: const TextStyle(
          color: AppColors.brandPrimaryLight,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    levelLabel.paint(
      canvas,
      Offset(
        (size.width - levelLabel.width) / 2,
        (size.height - levelLabel.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _MiniBoardPainter oldDelegate) {
    return oldDelegate.levelConfig.level != levelConfig.level ||
        oldDelegate.levelConfig.mode != levelConfig.mode;
  }
}
