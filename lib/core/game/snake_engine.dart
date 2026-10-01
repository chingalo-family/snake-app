import 'dart:math';

import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/constants/collectibles.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/game/obstacle_generator.dart';
import 'package:snake_app/core/models/direction.dart';
import 'package:snake_app/core/models/game_mode.dart';
import 'package:snake_app/core/models/run_spec.dart';

enum GamePhase { ready, running, paused, gameOver, cleared }

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
    required this.mode,
    required this.obstacleCellIndexes,
    required this.spec,
    required this.remainingTicks,
    required this.targetsEaten,
    required this.shieldCharges,
    required this.bitterIndex,
    required this.bonusIndex,
    required this.bonusTicksLeft,
    required this.burrowA,
    required this.burrowB,
    required this.pelletIndexes,
    required this.keyIndex,
    required this.lockIndex,
    required this.hasKey,
    required this.ghostCell,
    required this.botSnakes,
    required this.dashHeld,
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
  final GameMode mode;
  final Set<int> obstacleCellIndexes;
  final RunSpec spec;
  final int? remainingTicks;
  final int targetsEaten;
  final int shieldCharges;
  final int? bitterIndex;
  final int? bonusIndex;
  final int bonusTicksLeft;
  final int? burrowA;
  final int? burrowB;
  final Set<int> pelletIndexes;
  final int? keyIndex;
  final int? lockIndex;
  final bool hasKey;
  final int? ghostCell;
  final List<List<int>> botSnakes;
  final bool dashHeld;
  final EatEvent? lastEat;

  int get head => snake.first;
  int get totalCells => columns * rows;

  int? get remainingSeconds {
    final ticks = remainingTicks;
    if (ticks == null) return null;
    final tickMs = spec.tickMs;
    return (ticks * tickMs / 1000).ceil();
  }
}

class _Bot {
  _Bot({required this.cells, required this.direction});

  List<int> cells;
  Direction direction;
  bool alive = true;
}

class SnakeEngine {
  SnakeEngine({
    required this.level,
    Random? random,
    RunSpec? spec,
    String? ghostTrace,
  })  : _spec = spec ?? RunSpec.campaign(LevelsCatalog.byLevel(level)),
        _random = random ??
            (spec?.seed != null ? Random(spec!.seed!) : Random()) {
    _ghostPath = _parseGhost(ghostTrace);
    columns = _spec.columns;
    rows = _spec.rows;
    reset();
  }

  final int level;
  final RunSpec _spec;
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
  late Set<int> _obstacleCellIndexes;
  late int _elapsedTicks;
  int? _lastEatTick;
  int? _remainingTicks;
  int _targetsEaten = 0;
  int _shieldCharges = 0;
  int _slowTicks = 0;
  int? _bitterIndex;
  int? _bonusIndex;
  int _bonusTicksLeft = 0;
  int? _burrowA;
  int? _burrowB;
  final Set<int> _pellets = {};
  int? _keyIndex;
  int? _lockIndex;
  bool _hasKey = false;
  bool _dashHeld = false;
  EatEvent? _lastEat;
  List<int> _ghostPath = const [];
  int? _ghostCell;
  final List<int> _recordedHeads = [];
  final List<_Bot> _bots = [];

  static const bitterFood = Collectible(
    icon: '🥀',
    score: 0,
    tier: CollectibleTier.common,
  );
  static const bonusFood = Collectible(
    icon: '🦉',
    score: 120,
    tier: CollectibleTier.epic,
  );
  static const keyFood = Collectible(
    icon: '🔑',
    score: 40,
    tier: CollectibleTier.uncommon,
  );
  static const lockFood = Collectible(
    icon: '🪵',
    score: 80,
    tier: CollectibleTier.rare,
  );
  static const pelletFood = Collectible(
    icon: '🌰',
    score: 8,
    tier: CollectibleTier.common,
  );

  RunSpec get spec => _spec;
  GameMode get mode => _spec.mode;

  int get currentTickMs {
    var tickMs = _spec.tickMs;
    if (_dashHeld && _snake.length > 4) {
      tickMs = (tickMs * 0.55).round();
    }
    if (_slowTicks > 0) {
      tickMs = (tickMs * 1.55).round();
    }
    return tickMs;
  }

  String get ghostTrace {
    final capped = _recordedHeads.length > 500
        ? _recordedHeads.sublist(_recordedHeads.length - 500)
        : _recordedHeads;
    return capped.join(',');
  }

  void setDashHeld(bool held) {
    _dashHeld = held;
  }

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
        level: _spec.isCampaign ? level : _spec.level,
        columns: columns,
        rows: rows,
        itemsEaten: _itemsEaten,
        mode: mode,
        obstacleCellIndexes: Set.unmodifiable(_obstacleCellIndexes),
        spec: _spec,
        remainingTicks: _remainingTicks,
        targetsEaten: _targetsEaten,
        shieldCharges: _shieldCharges,
        bitterIndex: _bitterIndex,
        bonusIndex: _bonusIndex,
        bonusTicksLeft: _bonusTicksLeft,
        burrowA: _burrowA,
        burrowB: _burrowB,
        pelletIndexes: Set.unmodifiable(_pellets),
        keyIndex: _keyIndex,
        lockIndex: _lockIndex,
        hasKey: _hasKey,
        ghostCell: _ghostCell,
        botSnakes: [
          for (final bot in _bots)
            if (bot.alive) List<int>.unmodifiable(bot.cells),
        ],
        dashHeld: _dashHeld,
        lastEat: _lastEat,
      );

  void reset() {
    _rebuildObstacles();
    final startColumnIndex = (columns / 2).floor().clamp(2, columns - 1);
    final startRowIndex = (rows / 2).floor();
    final headCellIndex = startRowIndex * columns + startColumnIndex;
    _snake = [headCellIndex, headCellIndex - 1, headCellIndex - 2];
    _snake = _snake
        .where((cellIndex) => !_obstacleCellIndexes.contains(cellIndex))
        .toList();
    while (_snake.length < 3) {
      final tailCellIndex = _snake.isEmpty ? headCellIndex : _snake.last;
      final extensionCellIndex = tailCellIndex - 1;
      if (extensionCellIndex < startRowIndex * columns) break;
      if (_obstacleCellIndexes.contains(extensionCellIndex)) break;
      _snake.add(extensionCellIndex);
    }
    if (_snake.isEmpty) {
      _snake = [headCellIndex, headCellIndex - 1, headCellIndex - 2];
    }
    _direction = Direction.right;
    _pendingDirection = Direction.right;
    _score = 0;
    _comboCount = 0;
    _bestCombo = 0;
    _itemsEaten = 0;
    _lastEatTick = null;
    _lastEat = null;
    _elapsedTicks = 0;
    _targetsEaten = 0;
    _shieldCharges = _spec.shieldEnabled ? 1 : 0;
    _slowTicks = 0;
    _bitterIndex = null;
    _bonusIndex = null;
    _bonusTicksLeft = 0;
    _keyIndex = null;
    _lockIndex = null;
    _hasKey = false;
    _pellets.clear();
    _dashHeld = false;
    _recordedHeads.clear();
    _ghostCell = null;
    _bots.clear();
    _phase = GamePhase.ready;
    if (_spec.durationSec > 0) {
      _remainingTicks = (_spec.durationSec * 1000 / _spec.tickMs).ceil();
    } else {
      _remainingTicks = null;
    }
    _placeBurrows();
    _placeSpecials();
    if (_spec.foodBehavior == FoodBehavior.pellets) {
      _spawnPellets();
      _foodIndex = _pellets.isEmpty ? -1 : _pellets.first;
      _food = pelletFood;
    } else {
      _spawnFood();
    }
    _spawnBots();
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

  bool queueDirection(Direction nextDirection) {
    if (_phase != GamePhase.running && _phase != GamePhase.ready) {
      return false;
    }
    if (nextDirection.isSameAxisAs(_direction)) return false;
    _pendingDirection = nextDirection;
    if (_phase == GamePhase.ready) {
      _phase = GamePhase.running;
    }
    return true;
  }

  EatEvent? tick() {
    _lastEat = null;
    if (_phase != GamePhase.running) return null;

    if (_slowTicks > 0) _slowTicks -= 1;
    _direction = _pendingDirection;
    final previousHead = _snake.first;
    var nextHeadIndex = _applyBurrow(
      _nextIndex(_snake.first, _direction, allowWrap: _spec.wrapsEdges),
      _direction,
    );

    if (_isFatal(nextHeadIndex)) {
      if (nextHeadIndex != null && _shieldCharges > 0) {
        _shieldCharges -= 1;
        _advanceWorld(moved: false);
        return null;
      }
      if (_spec.objective == ObjectiveKind.peacefulFill) {
        _advanceWorld(moved: false);
        _checkPeacefulFill();
        return null;
      }
      _phase = GamePhase.gameOver;
      return null;
    }

    _snake.insert(0, nextHeadIndex!);
    if (_spec.obstacles == ObstacleRule.vineTrail) {
      _obstacleCellIndexes.add(previousHead);
    }

    EatEvent? eatEvent;
    if (_pellets.contains(nextHeadIndex)) {
      eatEvent = _scoreEat(pelletFood, nextHeadIndex, grow: true);
      _pellets.remove(nextHeadIndex);
      if (_pellets.isEmpty && _spec.objective == ObjectiveKind.eatAll) {
        _phase = GamePhase.cleared;
      }
      _foodIndex = _pellets.isEmpty ? -1 : _pellets.first;
    } else if (_bonusIndex != null && nextHeadIndex == _bonusIndex) {
      eatEvent = _scoreEat(bonusFood, nextHeadIndex, grow: true);
      _bonusIndex = null;
      _bonusTicksLeft = 0;
    } else if (_bitterIndex != null && nextHeadIndex == _bitterIndex) {
      eatEvent = _scoreEat(bitterFood, nextHeadIndex, grow: false, points: 0);
      _shrink(2);
      _slowTicks = 8;
      _bitterIndex = null;
      _spawnBitter();
    } else if (_keyIndex != null && nextHeadIndex == _keyIndex) {
      eatEvent = _scoreEat(keyFood, nextHeadIndex, grow: true);
      _hasKey = true;
      _keyIndex = null;
    } else if (_lockIndex != null && nextHeadIndex == _lockIndex && _hasKey) {
      eatEvent = _scoreEat(lockFood, nextHeadIndex, grow: true);
      _lockIndex = null;
      _targetsEaten += 1;
    } else if (nextHeadIndex == _foodIndex && _foodIndex >= 0) {
      eatEvent = _scoreEat(_food, nextHeadIndex, grow: true);
      if (_spec.foodBehavior != FoodBehavior.pellets) {
        _spawnFood();
      }
    } else {
      _snake.removeLast();
      if (_dashHeld && _snake.length > 4) {
        _snake.removeLast();
      }
    }

    if (_spec.obstacles == ObstacleRule.shedSkin && eatEvent != null) {
      _obstacleCellIndexes.add(_snake.last);
    }
    if (_spec.obstacles == ObstacleRule.growing &&
        eatEvent != null &&
        _itemsEaten % 4 == 0) {
      _growWall();
    }
    if (_spec.foodBehavior == FoodBehavior.bonusCritter &&
        eatEvent != null &&
        _itemsEaten % 5 == 0) {
      _spawnBonus();
    }

    _advanceWorld(moved: true);
    _checkObjectives();
    return eatEvent;
  }

  void _advanceWorld({required bool moved}) {
    _elapsedTicks += 1;
    _recordedHeads.add(_snake.first);
    if (_ghostPath.isNotEmpty) {
      final index = min(_elapsedTicks, _ghostPath.length - 1);
      _ghostCell = _ghostPath[index];
    }
    if (_remainingTicks != null && _phase == GamePhase.running) {
      _remainingTicks = _remainingTicks! - 1;
      if (_remainingTicks! <= 0) {
        _phase = GamePhase.cleared;
      }
    }
    if (_bonusTicksLeft > 0) {
      _bonusTicksLeft -= 1;
      if (_bonusTicksLeft <= 0) _bonusIndex = null;
    }
    if (_spec.foodBehavior == FoodBehavior.fleeing && _elapsedTicks.isEven) {
      _stepFleeingFood();
    }
    if (moved && _spec.botCount > 0 && _phase == GamePhase.running) {
      _tickBots();
    }
  }

  void _checkObjectives() {
    if (_phase != GamePhase.running) return;
    if (_spec.objective == ObjectiveKind.collectTargets &&
        _targetsEaten >= _spec.targetCount &&
        _spec.targetCount > 0) {
      _phase = GamePhase.cleared;
    }
    if (_spec.objective == ObjectiveKind.arena &&
        _bots.isNotEmpty &&
        _bots.every((bot) => !bot.alive)) {
      _phase = GamePhase.cleared;
    }
    _checkPeacefulFill();
  }

  void _checkPeacefulFill() {
    if (_spec.objective != ObjectiveKind.peacefulFill) return;
    if (_phase != GamePhase.running) return;
    if (_emptyCells().isEmpty) {
      _phase = GamePhase.cleared;
    }
  }

  EatEvent _scoreEat(
    Collectible collectible,
    int cellIndex, {
    required bool grow,
    int? points,
  }) {
    final windowTicks = max(1, AppConstants.comboTimeoutMs ~/ _spec.tickMs);
    if (_lastEatTick != null &&
        _elapsedTicks - _lastEatTick! <= windowTicks) {
      _comboCount += 1;
    } else {
      _comboCount = 1;
    }
    _lastEatTick = _elapsedTicks;
    if (_comboCount > _bestCombo) _bestCombo = _comboCount;
    final comboBonus = (_comboCount - 1) * 5;
    final multiplier = 1.0 + ((_comboCount - 1) * 0.1);
    final awarded = points ??
        ((collectible.score + comboBonus) * multiplier).round();
    _score += awarded;
    _itemsEaten += 1;
    if (collectible.tier == _spec.targetTier &&
        _spec.objective == ObjectiveKind.collectTargets &&
        collectible.icon != lockFood.icon) {
      _targetsEaten += 1;
    }
    if (!grow) {
      if (_snake.length > 3) _snake.removeLast();
    }
    final eatEvent = EatEvent(
      points: awarded,
      collectible: collectible,
      comboCount: _comboCount,
      cellIndex: cellIndex,
    );
    _lastEat = eatEvent;
    return eatEvent;
  }

  void _shrink(int segments) {
    for (var index = 0; index < segments; index++) {
      if (_snake.length <= 3) break;
      _snake.removeLast();
    }
  }

  bool _isFatal(int? nextHeadIndex) {
    if (nextHeadIndex == null) return true;
    if (_snake.contains(nextHeadIndex)) return true;
    if (_obstacleCellIndexes.contains(nextHeadIndex)) return true;
    if (_lockIndex != null && nextHeadIndex == _lockIndex && !_hasKey) {
      return true;
    }
    for (final bot in _bots) {
      if (bot.alive && bot.cells.contains(nextHeadIndex)) return true;
    }
    return false;
  }

  int? _applyBurrow(int? nextHeadIndex, Direction direction) {
    if (nextHeadIndex == null || _burrowA == null || _burrowB == null) {
      return nextHeadIndex;
    }
    if (nextHeadIndex != _burrowA && nextHeadIndex != _burrowB) {
      return nextHeadIndex;
    }
    final exit = nextHeadIndex == _burrowA ? _burrowB! : _burrowA!;
    return _nextIndex(exit, direction, allowWrap: false) ?? exit;
  }

  int? _nextIndex(
    int headCellIndex,
    Direction direction, {
    required bool allowWrap,
  }) {
    final rowIndex = headCellIndex ~/ columns;
    final columnIndex = headCellIndex % columns;
    switch (direction) {
      case Direction.up:
        if (rowIndex <= 0) {
          if (!allowWrap) return null;
          return (rows - 1) * columns + columnIndex;
        }
        return headCellIndex - columns;
      case Direction.down:
        if (rowIndex >= rows - 1) {
          if (!allowWrap) return null;
          return columnIndex;
        }
        return headCellIndex + columns;
      case Direction.left:
        if (columnIndex <= 0) {
          if (!allowWrap) return null;
          return rowIndex * columns + (columns - 1);
        }
        return headCellIndex - 1;
      case Direction.right:
        if (columnIndex >= columns - 1) {
          if (!allowWrap) return null;
          return rowIndex * columns;
        }
        return headCellIndex + 1;
    }
  }

  void _rebuildObstacles() {
    if (_spec.obstacles == ObstacleRule.staticMaze) {
      final boxes = ObstacleGenerator.generate(
        level: _spec.level,
        columns: columns,
        rows: rows,
        enabled: true,
      );
      _obstacleCellIndexes = ObstacleGenerator.blockedCells(
        boxes: boxes,
        columns: columns,
      );
      return;
    }
    _obstacleCellIndexes = {};
  }

  void _placeBurrows() {
    _burrowA = null;
    _burrowB = null;
    if (!_spec.burrows) return;
    final empty = _emptyCells();
    if (empty.length < 2) return;
    _burrowA = empty[columns + 2 < empty.length ? 2 : 0];
    _burrowB = empty[empty.length - 3];
  }

  void _placeSpecials() {
    if (_spec.foodBehavior == FoodBehavior.bitter) {
      _spawnBitter();
    }
    if (_spec.foodBehavior == FoodBehavior.keyLock) {
      final empty = _emptyCells();
      if (empty.length >= 2) {
        _keyIndex = empty[min(4, empty.length - 1)];
        _lockIndex = empty[empty.length ~/ 2];
      }
    }
  }

  void _spawnFood() {
    final emptyCellIndexes = _emptyCells(excludeSpecials: true);
    if (emptyCellIndexes.isEmpty) {
      if (_spec.objective == ObjectiveKind.peacefulFill) {
        _phase = GamePhase.cleared;
      } else {
        _phase = GamePhase.gameOver;
      }
      _foodIndex = -1;
      _food = CollectiblesCatalog.all.first;
      return;
    }
    _foodIndex = emptyCellIndexes[_random.nextInt(emptyCellIndexes.length)];
    if (_spec.objective == ObjectiveKind.collectTargets &&
        _targetsEaten < _spec.targetCount &&
        (_itemsEaten - _targetsEaten) >= 3) {
      final matches = CollectiblesCatalog.all
          .where((collectible) => collectible.tier == _spec.targetTier)
          .toList();
      _food = matches[_random.nextInt(matches.length)];
      return;
    }
    _food = CollectiblesCatalog.pickWeighted(_spec.level, _random);
  }

  void _spawnBitter() {
    final empty = _emptyCells(excludeSpecials: true);
    if (empty.isEmpty) return;
    _bitterIndex = empty[_random.nextInt(empty.length)];
  }

  void _spawnBonus() {
    final empty = _emptyCells(excludeSpecials: true);
    if (empty.isEmpty) return;
    _bonusIndex = empty[_random.nextInt(empty.length)];
    _bonusTicksLeft = max(8, 2500 ~/ _spec.tickMs);
  }

  void _spawnPellets() {
    final empty = _emptyCells();
    final count = min(18, empty.length ~/ 2);
    final shuffled = List<int>.of(empty)..shuffle(_random);
    _pellets.addAll(shuffled.take(count));
  }

  void _growWall() {
    final head = _snake.first;
    final headRow = head ~/ columns;
    final headColumn = head % columns;
    final candidates = _emptyCells(excludeSpecials: true).where((cellIndex) {
      final rowIndex = cellIndex ~/ columns;
      final columnIndex = cellIndex % columns;
      final distance = (rowIndex - headRow).abs() + (columnIndex - headColumn).abs();
      return distance > 2;
    }).toList();
    if (candidates.isEmpty) return;
    _obstacleCellIndexes.add(candidates[_random.nextInt(candidates.length)]);
  }

  void _stepFleeingFood() {
    if (_foodIndex < 0) return;
    final head = _snake.first;
    final options = <int>[];
    for (final direction in Direction.values) {
      final next = _nextIndex(_foodIndex, direction, allowWrap: _spec.wrapsEdges);
      if (next == null) continue;
      if (_blocked(next)) continue;
      options.add(next);
    }
    if (options.isEmpty) return;
    options.sort((a, b) => _distance(b, head).compareTo(_distance(a, head)));
    _foodIndex = options.first;
  }

  int _distance(int cellIndex, int other) {
    final rowDelta = (cellIndex ~/ columns) - (other ~/ columns);
    final columnDelta = (cellIndex % columns) - (other % columns);
    return rowDelta.abs() + columnDelta.abs();
  }

  void _spawnBots() {
    if (_spec.botCount <= 0) return;
    final corners = [columns + 1, (rows - 2) * columns + 1];
    for (var index = 0; index < _spec.botCount && index < corners.length; index++) {
      final head = corners[index];
      if (_blocked(head)) continue;
      _bots.add(
        _Bot(
          cells: [head, head + 1, head + 2],
          direction: Direction.left,
        ),
      );
    }
  }

  void _tickBots() {
    for (final bot in _bots) {
      if (!bot.alive) continue;
      final toward = _directionToward(bot.cells.first, _foodIndex);
      final options = Direction.values.where((direction) {
        return !direction.isSameAxisAs(bot.direction) ||
            direction == bot.direction;
      });
      Direction chosen = bot.direction;
      var bestDistance = 1 << 30;
      for (final direction in options) {
        if (direction.isOppositeOf(bot.direction)) continue;
        final next = _nextIndex(
          bot.cells.first,
          direction,
          allowWrap: _spec.wrapsEdges,
        );
        if (next == null || _blocked(next) || bot.cells.contains(next)) {
          continue;
        }
        final distance = _foodIndex < 0 ? 0 : _distance(next, _foodIndex);
        if (direction == toward && distance <= bestDistance) {
          chosen = direction;
          bestDistance = distance;
        } else if (distance < bestDistance) {
          chosen = direction;
          bestDistance = distance;
        }
      }
      final next = _nextIndex(
        bot.cells.first,
        chosen,
        allowWrap: _spec.wrapsEdges,
      );
      if (next == null ||
          _blocked(next) ||
          bot.cells.contains(next) ||
          _snake.contains(next)) {
        bot.alive = false;
        continue;
      }
      bot.direction = chosen;
      bot.cells.insert(0, next);
      if (next == _foodIndex) {
        _spawnFood();
      } else {
        bot.cells.removeLast();
      }
      if (next == _snake.first) {
        if (_shieldCharges > 0) {
          _shieldCharges -= 1;
          bot.alive = false;
        } else if (_spec.objective != ObjectiveKind.peacefulFill) {
          _phase = GamePhase.gameOver;
        }
      }
    }
  }

  Direction _directionToward(int from, int to) {
    if (to < 0) return Direction.left;
    final rowDelta = (to ~/ columns) - (from ~/ columns);
    final columnDelta = (to % columns) - (from % columns);
    if (columnDelta.abs() > rowDelta.abs()) {
      return columnDelta > 0 ? Direction.right : Direction.left;
    }
    return rowDelta > 0 ? Direction.down : Direction.up;
  }

  bool _blocked(int cellIndex) {
    if (cellIndex < 0 || cellIndex >= columns * rows) return true;
    if (_obstacleCellIndexes.contains(cellIndex)) return true;
    if (_snake.contains(cellIndex)) return true;
    if (cellIndex == _burrowA || cellIndex == _burrowB) return true;
    if (cellIndex == _bitterIndex || cellIndex == _bonusIndex) return true;
    if (cellIndex == _keyIndex || cellIndex == _lockIndex) return true;
    if (_pellets.contains(cellIndex)) return true;
    return false;
  }

  List<int> _emptyCells({bool excludeSpecials = false}) {
    final empty = <int>[];
    for (var cellIndex = 0; cellIndex < columns * rows; cellIndex++) {
      if (_snake.contains(cellIndex)) continue;
      if (_obstacleCellIndexes.contains(cellIndex)) continue;
      if (excludeSpecials && _blocked(cellIndex) && !_snake.contains(cellIndex)) {
        if (cellIndex == _foodIndex) continue;
        if (_blocked(cellIndex)) continue;
      }
      if (excludeSpecials &&
          (cellIndex == _bitterIndex ||
              cellIndex == _bonusIndex ||
              cellIndex == _burrowA ||
              cellIndex == _burrowB ||
              cellIndex == _keyIndex ||
              cellIndex == _lockIndex ||
              _pellets.contains(cellIndex))) {
        continue;
      }
      empty.add(cellIndex);
    }
    return empty;
  }

  List<int> _parseGhost(String? ghostTrace) {
    if (ghostTrace == null || ghostTrace.isEmpty) return const [];
    return [
      for (final part in ghostTrace.split(','))
        if (int.tryParse(part) != null) int.parse(part),
    ];
  }

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
      return;
    }

    while (remappedSnake.length < 3) {
      final tailCellIndex = remappedSnake.last;
      final tailRowIndex = tailCellIndex ~/ newColumns;
      final tailColumnIndex = tailCellIndex % newColumns;
      final extensionColumnIndex = (tailColumnIndex - 1).clamp(0, newColumns - 1);
      final extensionCellIndex = tailRowIndex * newColumns + extensionColumnIndex;
      if (remappedSnake.contains(extensionCellIndex)) break;
      remappedSnake.add(extensionCellIndex);
    }

    final remappedFoodIndex = _foodIndex < 0
        ? -1
        : _remapCellIndex(
            cellIndex: _foodIndex,
            previousColumns: previousColumns,
            previousRows: previousRows,
            newColumns: newColumns,
            newRows: newRows,
          );

    columns = newColumns;
    rows = newRows;
    _snake = remappedSnake;
    _rebuildObstacles();
    _snake = _snake
        .where((cellIndex) => !_obstacleCellIndexes.contains(cellIndex))
        .toList();
    if (_snake.isEmpty) {
      reset();
      return;
    }
    _pellets.clear();
    _bonusIndex = null;
    _placeBurrows();
    _placeSpecials();
    if (_spec.foodBehavior == FoodBehavior.pellets) {
      _spawnPellets();
      _foodIndex = _pellets.isEmpty ? -1 : _pellets.first;
    } else if (_snake.contains(remappedFoodIndex) ||
        _obstacleCellIndexes.contains(remappedFoodIndex) ||
        remappedFoodIndex < 0) {
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

  void debugPlaceFood(int cellIndex, Collectible food) {
    assert(!_snake.contains(cellIndex));
    assert(!_obstacleCellIndexes.contains(cellIndex));
    _foodIndex = cellIndex;
    _food = food;
  }

  void debugSetObstacles(Set<int> cellIndexes) {
    _obstacleCellIndexes = Set<int>.of(cellIndexes);
  }

  void debugSetRemainingTicks(int ticks) {
    _remainingTicks = ticks;
  }
}
