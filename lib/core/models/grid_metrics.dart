import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:snake_app/core/constants/app_constants.dart';

@immutable
class GridMetrics {
  const GridMetrics({
    required this.columns,
    required this.rows,
    required this.cellSize,
    required this.boardWidth,
    required this.boardHeight,
  });

  final int columns;
  final int rows;
  final double cellSize;
  final double boardWidth;
  final double boardHeight;

  int get totalCells => columns * rows;

  
  
  static GridMetrics fromConstraints({
    required double maxWidth,
    required double maxHeight,
    required int baseColumns,
    required int baseRows,
  }) {
    final usableWidth = maxWidth.clamp(80.0, double.infinity);
    final usableHeight = maxHeight.clamp(80.0, double.infinity);
    final targetCells = (baseColumns * baseRows).clamp(80, 900);
    final aspectRatio = usableWidth / usableHeight;

    var columns = math.sqrt(targetCells * aspectRatio).round();
    var rows = math.max(1, (targetCells / columns).round());

    columns = columns.clamp(
      AppConstants.minGridColumns,
      AppConstants.maxGridColumns,
    );
    rows = rows.clamp(AppConstants.minGridRows, AppConstants.maxGridRows);

    var cellSize = math.min(usableWidth / columns, usableHeight / rows);
    cellSize = cellSize.clamp(
      AppConstants.minCellSize,
      AppConstants.maxCellSize,
    );

    final maxColumnsByWidth =
        (usableWidth / AppConstants.minCellSize).floor().clamp(
              AppConstants.minGridColumns,
              AppConstants.maxGridColumns,
            );
    final maxRowsByHeight =
        (usableHeight / AppConstants.minCellSize).floor().clamp(
              AppConstants.minGridRows,
              AppConstants.maxGridRows,
            );

    while (columns < maxColumnsByWidth &&
        cellSize * (columns + 1) <= usableWidth + 0.5 &&
        math.min(usableWidth / (columns + 1), usableHeight / rows) >=
            AppConstants.minCellSize) {
      columns += 1;
      cellSize = math.min(usableWidth / columns, usableHeight / rows);
    }
    while (rows < maxRowsByHeight &&
        cellSize * (rows + 1) <= usableHeight + 0.5 &&
        math.min(usableWidth / columns, usableHeight / (rows + 1)) >=
            AppConstants.minCellSize) {
      rows += 1;
      cellSize = math.min(usableWidth / columns, usableHeight / rows);
    }

    return _finalize(
      columns: columns,
      rows: rows,
      usableWidth: usableWidth,
      usableHeight: usableHeight,
    );
  }

  
  static GridMetrics fitFixedGrid({
    required double maxWidth,
    required double maxHeight,
    required int columns,
    required int rows,
  }) {
    final usableWidth = maxWidth.clamp(80.0, double.infinity);
    final usableHeight = maxHeight.clamp(80.0, double.infinity);
    return _finalize(
      columns: columns,
      rows: rows,
      usableWidth: usableWidth,
      usableHeight: usableHeight,
    );
  }

  static GridMetrics _finalize({
    required int columns,
    required int rows,
    required double usableWidth,
    required double usableHeight,
  }) {
    var cellSize = math
        .min(usableWidth / columns, usableHeight / rows)
        .clamp(AppConstants.minCellSize, AppConstants.maxCellSize);

    var boardWidth = cellSize * columns;
    var boardHeight = cellSize * rows;

    final longestSide = math.max(boardWidth, boardHeight);
    if (longestSide > AppConstants.desktopMaxBoard) {
      final scale = AppConstants.desktopMaxBoard / longestSide;
      cellSize = (cellSize * scale).clamp(
        AppConstants.minCellSize,
        AppConstants.maxCellSize,
      );
      boardWidth = cellSize * columns;
      boardHeight = cellSize * rows;
    }

    return GridMetrics(
      columns: columns,
      rows: rows,
      cellSize: cellSize,
      boardWidth: boardWidth,
      boardHeight: boardHeight,
    );
  }

  int indexFor(int rowIndex, int columnIndex) =>
      rowIndex * columns + columnIndex;

  (int rowIndex, int columnIndex) rowColumnFor(int cellIndex) {
    return (cellIndex ~/ columns, cellIndex % columns);
  }
}
