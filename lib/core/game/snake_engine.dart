import 'dart:math';

import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/constants/collectibles.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/models/direction.dart';

enum GamePhase { ready, running, paused, gameOver }

class EatEvent {
  const EatEvent({
    required this.points,
    required this.collectible,
    required this.comboCount,
    required this.cellIndex,
  });

  final int points;
  final Collectible collectible;
  final int comboCount;
  final int cellIndex;
}

class SnakeEngineSnapshot {
  const SnakeEngineSnapshot({
    required this.snake,
    required this.direction,
    required this.pendingDirection,
    required this.foodIndex,
    required this.food,
    required this.score,
    required this.comboCount,
    required this.bestCombo,
    required this.phase,
    required this.level,
    required this.columns,
    required this.rows,
    required this.itemsEaten,
    this.lastEat,
  });

  final List<int> snake;
  final Direction direction;
  final Direction pendingDirection;
  final int foodIndex;
  final Collectible food;
  final int score;
  final int comboCount;
  final int bestCombo;
  final GamePhase phase;
  final int level;
  final int columns;
  final int rows;
  final int itemsEaten;
  final EatEvent? lastEat;

  int get head => snake.first;
  int get totalCells => columns * rows;
}

/// Pure snake simulation — no Flutter timers or widgets.
class SnakeEngine {
  SnakeEngine({
    required this.level,
    Random? random,
  })  : _random = random ?? Random(),
        columns = LevelsCatalog.byLevel(level).columns,
        rows = LevelsCatalog.byLevel(level).rows {
    reset();
  }

  final int level;
  final Random _random;
  late int columns;
  late int rows;

  late List<int> _snake;
  late Direction _direction;
  late Direction _pendingDirection;
  late int _foodIndex;
  late Collectible _food;
  late int _score;
  late int _comboCount;
  late int _bestCombo;
  late GamePhase _phase;
  late int _itemsEaten;
  DateTime? _lastEatAt;
  EatEvent? _lastEat;

  SnakeEngineSnapshot get snapshot => SnakeEngineSnapshot(
        snake: List.unmodifiable(_snake),
        direction: _direction,
        pendingDirection: _pendingDirection,
        foodIndex: _foodIndex,
        food: _food,
        score: _score,
        comboCount: _comboCount,
        bestCombo: _bestCombo,
        phase: _phase,
        level: level,
        columns: columns,
        rows: rows,
        itemsEaten: _itemsEaten,
        lastEat: _lastEat,
      );

  void reset() {
    final startColumnIndex = (columns / 2).floor().clamp(2, columns - 1);
    final startRowIndex = (rows / 2).floor();
    final headCellIndex = startRowIndex * columns + startColumnIndex;
    _snake = [headCellIndex, headCellIndex - 1, headCellIndex - 2];
    _direction = Direction.right;
    _pendingDirection = Direction.right;
    _score = 0;
    _comboCount = 0;
    _bestCombo = 0;
    _itemsEaten = 0;
    _lastEatAt = null;
    _lastEat = null;
    _phase = GamePhase.ready;
    _spawnFood();
  }

  void start() {
    if (_phase == GamePhase.ready || _phase == GamePhase.paused) {
      _phase = GamePhase.running;
    }
  }

  void pause() {
    if (_phase == GamePhase.running) {
      _phase = GamePhase.paused;
    }
  }

  void resume() {
    if (_phase == GamePhase.paused) {
      _phase = GamePhase.running;
    }
  }

  /// Queue a direction change; reverse into self is rejected.
  bool queueDirection(Direction nextDirection) {
    if (_phase != GamePhase.running && _phase != GamePhase.ready) {
      return false;
    }
    final pendingDirection = _pendingDirection;
    if (nextDirection.isOppositeOf(pendingDirection)) return false;
    _pendingDirection = nextDirection;
    if (_phase == GamePhase.ready) {
      _phase = GamePhase.running;
    }
    return true;
  }

  /// Advance one tick. Returns eat event when food is collected.
  EatEvent? tick() {
    _lastEat = null;
    if (_phase != GamePhase.running) return null;

    _direction = _pendingDirection;
    final nextHeadIndex = _nextIndex(_snake.first, _direction);
    if (nextHeadIndex == null || _snake.contains(nextHeadIndex)) {
      _phase = GamePhase.gameOver;
      return null;
    }

    _snake.insert(0, nextHeadIndex);

    if (nextHeadIndex == _foodIndex) {
      final now = DateTime.now();
      if (_lastEatAt != null &&
          now.difference(_lastEatAt!).inMilliseconds <=
              AppConstants.comboTimeoutMs) {
        _comboCount += 1;
      } else {
        _comboCount = 1;
      }
      _lastEatAt = now;
      if (_comboCount > _bestCombo) _bestCombo = _comboCount;

      final comboBonus = (_comboCount - 1) * 5;
      final multiplier = 1.0 + ((_comboCount - 1) * 0.1);
      final points = ((_food.score + comboBonus) * multiplier).round();
      _score += points;
      _itemsEaten += 1;

      final eatEvent = EatEvent(
        points: points,
        collectible: _food,
        comboCount: _comboCount,
        cellIndex: nextHeadIndex,
      );
      _lastEat = eatEvent;
      _spawnFood();
      return eatEvent;
    }

    _snake.removeLast();
    return null;
  }

  int? _nextIndex(int headCellIndex, Direction direction) {
    final rowIndex = headCellIndex ~/ columns;
    final columnIndex = headCellIndex % columns;
    switch (direction) {
      case Direction.up:
        if (rowIndex <= 0) return null;
        return headCellIndex - columns;
      case Direction.down:
        if (rowIndex >= rows - 1) return null;
        return headCellIndex + columns;
      case Direction.left:
        if (columnIndex <= 0) return null;
        return headCellIndex - 1;
      case Direction.right:
        if (columnIndex >= columns - 1) return null;
        return headCellIndex + 1;
    }
  }

  void _spawnFood() {
    final occupiedCellIndexes = _snake.toSet();
    final emptyCellIndexes = <int>[];
    for (var cellIndex = 0; cellIndex < columns * rows; cellIndex++) {
      if (!occupiedCellIndexes.contains(cellIndex)) {
        emptyCellIndexes.add(cellIndex);
      }
    }
    if (emptyCellIndexes.isEmpty) {
      _phase = GamePhase.gameOver;
      _foodIndex = 0;
      _food = CollectiblesCatalog.all.first;
      return;
    }
    _foodIndex =
        emptyCellIndexes[_random.nextInt(emptyCellIndexes.length)];
    _food = CollectiblesCatalog.pickWeighted(level, _random);
  }

  /// Remap snake + food onto a new grid (orientation / size change).
  /// Positions are mapped by fractional row/column so play stays fair.
  void resizeTo({required int newColumns, required int newRows}) {
    if (newColumns == columns && newRows == rows) return;
    if (newColumns < 3 || newRows < 3) return;

    final previousColumns = columns;
    final previousRows = rows;

    final remappedSnake = <int>[];
    for (final cellIndex in _snake) {
      final remappedCellIndex = _remapCellIndex(
        cellIndex: cellIndex,
        previousColumns: previousColumns,
        previousRows: previousRows,
        newColumns: newColumns,
        newRows: newRows,
      );
      if (remappedSnake.contains(remappedCellIndex)) continue;
      remappedSnake.add(remappedCellIndex);
    }

    if (remappedSnake.isEmpty) {
      columns = newColumns;
      rows = newRows;
      reset();
      if (_phase == GamePhase.running || _phase == GamePhase.paused) {
        _phase = GamePhase.running;
      }
      return;
    }

    // Keep at least a short snake if remap collapsed segments.
    while (remappedSnake.length < 3) {
      final tailCellIndex = remappedSnake.last;
      final tailRowIndex = tailCellIndex ~/ newColumns;
      final tailColumnIndex = tailCellIndex % newColumns;
      final extensionColumnIndex =
          (tailColumnIndex - 1).clamp(0, newColumns - 1);
      final extensionCellIndex =
          tailRowIndex * newColumns + extensionColumnIndex;
      if (remappedSnake.contains(extensionCellIndex)) break;
      remappedSnake.add(extensionCellIndex);
    }

    final remappedFoodIndex = _remapCellIndex(
      cellIndex: _foodIndex,
      previousColumns: previousColumns,
      previousRows: previousRows,
      newColumns: newColumns,
      newRows: newRows,
    );

    columns = newColumns;
    rows = newRows;
    _snake = remappedSnake;

    if (_snake.contains(remappedFoodIndex)) {
      _spawnFood();
    } else {
      _foodIndex = remappedFoodIndex;
    }
  }

  int _remapCellIndex({
    required int cellIndex,
    required int previousColumns,
    required int previousRows,
    required int newColumns,
    required int newRows,
  }) {
    final previousRowIndex = cellIndex ~/ previousColumns;
    final previousColumnIndex = cellIndex % previousColumns;
    final newRowIndex = ((previousRowIndex + 0.5) / previousRows * newRows)
        .floor()
        .clamp(0, newRows - 1);
    final newColumnIndex =
        ((previousColumnIndex + 0.5) / previousColumns * newColumns)
            .floor()
            .clamp(0, newColumns - 1);
    return newRowIndex * newColumns + newColumnIndex;
  }

  /// Test helper: place food on a known empty cell.
  void debugPlaceFood(int cellIndex, Collectible food) {
    assert(!_snake.contains(cellIndex));
    _foodIndex = cellIndex;
    _food = food;
  }
}
