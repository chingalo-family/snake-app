import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/collectibles.dart';
import 'package:snake_app/core/game/snake_engine.dart';
import 'package:snake_app/core/models/direction.dart';
import 'package:snake_app/core/models/game_mode.dart';
import 'package:snake_app/core/models/grid_metrics.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/core/theme/snake_skins.dart';

class BoardPainter extends CustomPainter {
  BoardPainter({
    required this.metrics,
    required this.engineSnapshot,
    required this.isDark,
    required this.snakeSkin,
    required this.headPulse,
  });

  final GridMetrics metrics;
  final SnakeEngineSnapshot engineSnapshot;
  final bool isDark;
  final SnakeSkin snakeSkin;
  final double headPulse;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = isDark ? AppColors.darkGridLine : AppColors.lightGridLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (var rowIndex = 0; rowIndex < metrics.rows; rowIndex++) {
      for (var columnIndex = 0; columnIndex < metrics.columns; columnIndex++) {
        final rect = Rect.fromLTWH(
          columnIndex * metrics.cellSize,
          rowIndex * metrics.cellSize,
          metrics.cellSize,
          metrics.cellSize,
        );
        canvas.drawRect(rect, gridPaint);
      }
    }

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = engineSnapshot.mode.wrapsEdges ? 2.2 : 1.4
      ..color = engineSnapshot.mode.wrapsEdges
          ? AppColors.brandInfo.withValues(alpha: 0.55)
          : (isDark ? AppColors.darkGridLine : AppColors.lightGridLine);
    if (engineSnapshot.mode.wrapsEdges) {
      const dash = 6.0;
      const gap = 4.0;
      _drawDashedRect(
        canvas,
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        edgePaint,
        dash,
        gap,
      );
    }

    final rockPaint = Paint()
      ..color = isDark
          ? const Color(0xFF5A4632)
          : const Color(0xFF8B7355);
    final rockHighlight = Paint()
      ..color = AppColors.brandSecondary.withValues(alpha: 0.35);
    for (final cellIndex in engineSnapshot.obstacleCellIndexes) {
      final (rowIndex, columnIndex) = metrics.rowColumnFor(cellIndex);
      final inset = metrics.cellSize * 0.1;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          columnIndex * metrics.cellSize + inset,
          rowIndex * metrics.cellSize + inset,
          metrics.cellSize - inset * 2,
          metrics.cellSize - inset * 2,
        ),
        Radius.circular(metrics.cellSize * 0.18),
      );
      canvas.drawRRect(rect, rockPaint);
      canvas.drawRRect(rect.deflate(metrics.cellSize * 0.08), rockHighlight);
    }

    final bodyPaint = Paint()
      ..color = snakeSkin.body.withValues(alpha: 0.88);
    final stripePaint = Paint()
      ..color = snakeSkin.bodyStripe.withValues(alpha: 0.9);

    for (var segmentIndex = engineSnapshot.snake.length - 1;
        segmentIndex >= 1;
        segmentIndex--) {
      final cellIndex = engineSnapshot.snake[segmentIndex];
      final (rowIndex, columnIndex) = metrics.rowColumnFor(cellIndex);
      final inset = metrics.cellSize * 0.12;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          columnIndex * metrics.cellSize + inset,
          rowIndex * metrics.cellSize + inset,
          metrics.cellSize - inset * 2,
          metrics.cellSize - inset * 2,
        ),
        Radius.circular(metrics.cellSize * 0.28),
      );
      final useStripe =
          snakeSkin.hasStripe && segmentIndex.isOdd;
      canvas.drawRRect(rect, useStripe ? stripePaint : bodyPaint);
    }

    final headCellIndex = engineSnapshot.snake.first;
    final (headRowIndex, headColumnIndex) =
        metrics.rowColumnFor(headCellIndex);
    final headInset = metrics.cellSize * (0.1 - headPulse * 0.02);
    final headRect = Rect.fromLTWH(
      headColumnIndex * metrics.cellSize + headInset,
      headRowIndex * metrics.cellSize + headInset,
      metrics.cellSize - headInset * 2,
      metrics.cellSize - headInset * 2,
    );
    final headPaint = Paint()
      ..shader = LinearGradient(
        colors: [snakeSkin.headLight, snakeSkin.headDark],
      ).createShader(headRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        headRect,
        Radius.circular(metrics.cellSize * 0.3),
      ),
      headPaint,
    );

    final center = headRect.center;
    final tipOffset = metrics.cellSize * 0.28;
    final Offset tip;
    final Offset leftWing;
    final Offset rightWing;
    switch (engineSnapshot.direction) {
      case Direction.up:
        tip = Offset(center.dx, center.dy - tipOffset);
        leftWing = Offset(center.dx - tipOffset * 0.45, center.dy);
        rightWing = Offset(center.dx + tipOffset * 0.45, center.dy);
      case Direction.down:
        tip = Offset(center.dx, center.dy + tipOffset);
        leftWing = Offset(center.dx - tipOffset * 0.45, center.dy);
        rightWing = Offset(center.dx + tipOffset * 0.45, center.dy);
      case Direction.left:
        tip = Offset(center.dx - tipOffset, center.dy);
        leftWing = Offset(center.dx, center.dy - tipOffset * 0.45);
        rightWing = Offset(center.dx, center.dy + tipOffset * 0.45);
      case Direction.right:
        tip = Offset(center.dx + tipOffset, center.dy);
        leftWing = Offset(center.dx, center.dy - tipOffset * 0.45);
        rightWing = Offset(center.dx, center.dy + tipOffset * 0.45);
    }
    final wedgePath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(leftWing.dx, leftWing.dy)
      ..lineTo(rightWing.dx, rightWing.dy)
      ..close();
    canvas.drawPath(
      wedgePath,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    final eyeClosed = headPulse > 0.82;
    if (!eyeClosed) {
      final eyePaint = Paint()..color = const Color(0xFF0B1F1A);
      final eyeRadius = metrics.cellSize * 0.06;
      final eyeSpread = metrics.cellSize * 0.12;
      late final Offset eyeA;
      late final Offset eyeB;
      switch (engineSnapshot.direction) {
        case Direction.up:
          eyeA = Offset(center.dx - eyeSpread, center.dy - eyeSpread * 0.2);
          eyeB = Offset(center.dx + eyeSpread, center.dy - eyeSpread * 0.2);
        case Direction.down:
          eyeA = Offset(center.dx - eyeSpread, center.dy + eyeSpread * 0.2);
          eyeB = Offset(center.dx + eyeSpread, center.dy + eyeSpread * 0.2);
        case Direction.left:
          eyeA = Offset(center.dx - eyeSpread * 0.2, center.dy - eyeSpread);
          eyeB = Offset(center.dx - eyeSpread * 0.2, center.dy + eyeSpread);
        case Direction.right:
          eyeA = Offset(center.dx + eyeSpread * 0.2, center.dy - eyeSpread);
          eyeB = Offset(center.dx + eyeSpread * 0.2, center.dy + eyeSpread);
      }
      canvas.drawCircle(eyeA, eyeRadius, eyePaint);
      canvas.drawCircle(eyeB, eyeRadius, eyePaint);
    }

    final (foodRowIndex, foodColumnIndex) =
        metrics.rowColumnFor(engineSnapshot.foodIndex);
    final foodCenter = Offset(
      foodColumnIndex * metrics.cellSize + metrics.cellSize / 2,
      foodRowIndex * metrics.cellSize + metrics.cellSize / 2,
    );
    final ringColor = switch (engineSnapshot.food.tier) {
      CollectibleTier.common =>
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextMuted,
      CollectibleTier.uncommon => AppColors.brandPrimaryLight,
      CollectibleTier.rare => AppColors.brandSecondary,
      CollectibleTier.epic => AppColors.brandDanger,
    };
    canvas.drawCircle(
      foodCenter,
      metrics.cellSize * 0.38,
      Paint()
        ..color = ringColor.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill,
    );

    final foodIconPainter = TextPainter(
      text: TextSpan(
        text: engineSnapshot.food.icon,
        style: TextStyle(fontSize: metrics.cellSize * 0.62),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    foodIconPainter.paint(
      canvas,
      Offset(
        foodCenter.dx - foodIconPainter.width / 2,
        foodCenter.dy - foodIconPainter.height / 2,
      ),
    );
  }

  void _drawDashedRect(
    Canvas canvas,
    Rect rect,
    Paint paint,
    double dash,
    double gap,
  ) {
    void drawDashedLine(Offset start, Offset end) {
      final total = (end - start).distance;
      if (total == 0) return;
      final direction = (end - start) / total;
      var drawn = 0.0;
      var drawSegment = true;
      while (drawn < total) {
        final segmentLength = drawSegment ? dash : gap;
        final next = (drawn + segmentLength).clamp(0.0, total);
        if (drawSegment) {
          canvas.drawLine(
            start + direction * drawn,
            start + direction * next,
            paint,
          );
        }
        drawn = next;
        drawSegment = !drawSegment;
      }
    }

    drawDashedLine(rect.topLeft, rect.topRight);
    drawDashedLine(rect.topRight, rect.bottomRight);
    drawDashedLine(rect.bottomRight, rect.bottomLeft);
    drawDashedLine(rect.bottomLeft, rect.topLeft);
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.engineSnapshot != engineSnapshot ||
        oldDelegate.metrics.cellSize != metrics.cellSize ||
        oldDelegate.isDark != isDark ||
        oldDelegate.snakeSkin.id != snakeSkin.id ||
        oldDelegate.headPulse != headPulse;
  }
}
