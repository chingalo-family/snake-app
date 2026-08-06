import 'dart:math';

class ObstacleBox {
  const ObstacleBox({
    required this.rowIndex,
    required this.columnIndex,
    required this.widthCells,
    required this.heightCells,
  });

  final int rowIndex;
  final int columnIndex;
  final int widthCells;
  final int heightCells;

  Iterable<int> cellIndexes({required int columns}) sync* {
    for (var rowOffset = 0; rowOffset < heightCells; rowOffset++) {
      for (var columnOffset = 0; columnOffset < widthCells; columnOffset++) {
        yield (rowIndex + rowOffset) * columns + (columnIndex + columnOffset);
      }
    }
  }
}

abstract final class ObstacleGenerator {
  static List<ObstacleBox> generate({
    required int level,
    required int columns,
    required int rows,
    required bool enabled,
  }) {
    if (!enabled || columns < 8 || rows < 8) return const [];

    final random = Random(level * 7919 + columns * 97 + rows);
    final boxCount = _boxCountFor(level);
    final boxes = <ObstacleBox>[];
    final blockedCellIndexes = <int>{};

    
    final spawnRowIndex = (rows / 2).floor();
    final spawnColumnIndex = (columns / 2).floor().clamp(2, columns - 1);
    for (var columnOffset = -2; columnOffset <= 4; columnOffset++) {
      final columnIndex = spawnColumnIndex + columnOffset;
      if (columnIndex < 0 || columnIndex >= columns) continue;
      blockedCellIndexes.add(spawnRowIndex * columns + columnIndex);
    }

    var attempts = 0;
    while (boxes.length < boxCount && attempts < boxCount * 40) {
      attempts++;
      final (widthCells, heightCells) = _boxSizeFor(level, random);
      if (widthCells >= columns - 2 || heightCells >= rows - 2) continue;

      final maxColumnIndex = columns - widthCells;
      final maxRowIndex = rows - heightCells;
      if (maxColumnIndex <= 1 || maxRowIndex <= 1) continue;

      final columnIndex = 1 + random.nextInt(maxColumnIndex - 1);
      final rowIndex = 1 + random.nextInt(maxRowIndex - 1);
      final candidate = ObstacleBox(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        widthCells: widthCells,
        heightCells: heightCells,
      );

      final candidateCells =
          candidate.cellIndexes(columns: columns).toSet();
      if (candidateCells.any(blockedCellIndexes.contains)) continue;

      
      final freeAfter =
          columns * rows - blockedCellIndexes.length - candidateCells.length;
      if (freeAfter < columns * rows ~/ 3) continue;

      boxes.add(candidate);
      blockedCellIndexes.addAll(candidateCells);
    }

    return List.unmodifiable(boxes);
  }

  static Set<int> blockedCells({
    required List<ObstacleBox> boxes,
    required int columns,
  }) {
    final cellIndexes = <int>{};
    for (final box in boxes) {
      cellIndexes.addAll(box.cellIndexes(columns: columns));
    }
    return cellIndexes;
  }

  static int _boxCountFor(int level) {
    if (level <= 14) return 1 + ((level - 13).clamp(0, 1));
    if (level <= 17) return 3 + (level - 15);
    if (level <= 20) return 5 + (level - 18);
    if (level <= 25) return 7 + ((level - 21) ~/ 2);
    return min(12, 9 + (level - 26));
  }

  static (int, int) _boxSizeFor(int level, Random random) {
    if (level <= 15) {
      final sizes = [(1, 1), (1, 2), (2, 1)];
      return sizes[random.nextInt(sizes.length)];
    }
    if (level <= 20) {
      final sizes = [(1, 1), (1, 2), (2, 1), (2, 2), (1, 3)];
      return sizes[random.nextInt(sizes.length)];
    }
    if (level <= 25) {
      final sizes = [(1, 1), (2, 2), (1, 3), (3, 1), (2, 3)];
      return sizes[random.nextInt(sizes.length)];
    }
    final sizes = [(2, 2), (2, 3), (3, 2), (1, 3), (3, 1), (1, 1)];
    return sizes[random.nextInt(sizes.length)];
  }
}
