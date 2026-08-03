import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/constants/collectibles.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/game/snake_engine.dart';
import 'package:snake_app/core/models/direction.dart';
import 'package:snake_app/core/models/grid_metrics.dart';

void main() {
  group('Direction reverse rejection', () {
    test('opposite directions are detected', () {
      expect(Direction.up.isOppositeOf(Direction.down), isTrue);
      expect(Direction.left.isOppositeOf(Direction.right), isTrue);
      expect(Direction.up.isOppositeOf(Direction.left), isFalse);
    });

    test('engine rejects reverse into self', () {
      final engine = SnakeEngine(level: 1, random: Random(1));
      engine.start();
      expect(engine.queueDirection(Direction.left), isFalse);
      expect(engine.queueDirection(Direction.up), isTrue);
    });
  });

  group('GridMetrics', () {
    test('portrait keeps a tall board', () {
      final metrics = GridMetrics.fromConstraints(
        maxWidth: 320,
        maxHeight: 520,
        baseColumns: 15,
        baseRows: 19,
      );
      expect(metrics.rows, greaterThanOrEqualTo(metrics.columns));
      expect(metrics.boardHeight, greaterThan(metrics.boardWidth * 0.9));
      expect(metrics.cellSize, greaterThan(0));
    });

    test('landscape uses a wide board that fills most width', () {
      final metrics = GridMetrics.fromConstraints(
        maxWidth: 700,
        maxHeight: 280,
        baseColumns: 15,
        baseRows: 19,
      );
      expect(metrics.columns, greaterThan(metrics.rows));
      expect(metrics.boardWidth / 700, greaterThan(0.85));
      expect(metrics.boardHeight / 280, greaterThan(0.85));
    });

    test('fitFixedGrid keeps requested dimensions', () {
      final metrics = GridMetrics.fitFixedGrid(
        maxWidth: 320,
        maxHeight: 480,
        columns: 16,
        rows: 20,
      );
      expect(metrics.columns, 16);
      expect(metrics.rows, 20);
      expect(metrics.boardWidth, metrics.cellSize * 16);
      expect(metrics.boardHeight, metrics.cellSize * 20);
    });
  });

  group('Orientation remap', () {
    test('resizeTo remaps snake without emptying it', () {
      final engine = SnakeEngine(level: 1, random: Random(3));
      engine.start();
      final previousLength = engine.snapshot.snake.length;
      engine.resizeTo(newColumns: 24, newRows: 12);
      expect(engine.snapshot.columns, 24);
      expect(engine.snapshot.rows, 12);
      expect(engine.snapshot.snake, isNotEmpty);
      expect(engine.snapshot.snake.length, lessThanOrEqualTo(previousLength));
      expect(
        engine.snapshot.snake.every(
          (cellIndex) => cellIndex >= 0 && cellIndex < 24 * 12,
        ),
        isTrue,
      );
    });
  });

  group('Level unlock', () {
    test('unlocks next level when score threshold met', () {
      final levelConfig = LevelsCatalog.byLevel(1);
      expect(
        LevelsCatalog.canUnlockNext(
          completedLevel: 1,
          scoreOnLevel: levelConfig.unlockScore,
          highestUnlocked: 1,
        ),
        isTrue,
      );
      expect(
        LevelsCatalog.canUnlockNext(
          completedLevel: 1,
          scoreOnLevel: levelConfig.unlockScore - 1,
          highestUnlocked: 1,
        ),
        isFalse,
      );
    });

    test('catalog spans thirty progressive levels', () {
      expect(LevelsCatalog.levels, hasLength(AppConstants.totalLevels));
      expect(AppConstants.totalLevels, 30);

      for (var levelIndex = 1; levelIndex < AppConstants.totalLevels; levelIndex++) {
        final previous = LevelsCatalog.byLevel(levelIndex);
        final next = LevelsCatalog.byLevel(levelIndex + 1);
        expect(next.tickMs, lessThanOrEqualTo(previous.tickMs));
        expect(previous.unlockScore, greaterThan(0));
      }
      expect(LevelsCatalog.byLevel(AppConstants.totalLevels).unlockScore, 0);
    });
  });

  group('Collectibles', () {
    test('weighted pick returns catalog item', () {
      final collectible = CollectiblesCatalog.pickWeighted(1, Random(42));
      expect(CollectiblesCatalog.all.contains(collectible), isTrue);
      expect(collectible.tier, CollectibleTier.common);
    });

    test('score increases on eat', () {
      final engine = SnakeEngine(level: 1, random: Random(7));
      final head = engine.snapshot.head;
      final foodCell = head + 1;
      final food = CollectiblesCatalog.all.first;
      engine.debugPlaceFood(foodCell, food);
      engine.start();
      engine.queueDirection(Direction.right);
      final event = engine.tick();
      expect(event, isNotNull);
      expect(event!.points, food.score);
      expect(engine.snapshot.score, food.score);
      expect(engine.snapshot.snake.length, 4);
    });
  });
}
