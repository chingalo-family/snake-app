import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/game/obstacle_generator.dart';
import 'package:snake_app/core/models/game_mode.dart';
import 'package:snake_app/core/theme/app_colors.dart';

class MiniBoardPainter extends CustomPainter {
  MiniBoardPainter({required this.levelConfig});

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
  bool shouldRepaint(covariant MiniBoardPainter oldDelegate) {
    return oldDelegate.levelConfig.level != levelConfig.level ||
        oldDelegate.levelConfig.mode != levelConfig.mode;
  }
}
