import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/game/snake_engine.dart';
import 'package:snake_app/core/models/direction.dart';

class GameController extends ChangeNotifier {
  GameController({required this.level}) {
    _engine = SnakeEngine(level: level);
    _tickMs = LevelsCatalog.byLevel(level).tickMs;
  }

  final int level;
  late SnakeEngine _engine;
  late int _tickMs;
  Timer? _timer;
  EatEvent? lastEatEvent;
  bool softPausedForLayout = false;
  bool _disposed = false;

  SnakeEngineSnapshot get snapshot => _engine.snapshot;

  void start() {
    _engine.start();
    _restartTimer();
    notifyListeners();
  }

  void pause() {
    _engine.pause();
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (softPausedForLayout) {
      softPausedForLayout = false;
    }
    _engine.resume();
    _restartTimer();
    notifyListeners();
  }

  void restart() {
    _timer?.cancel();
    _engine.reset();
    lastEatEvent = null;
    softPausedForLayout = false;
    _engine.start();
    _restartTimer();
    notifyListeners();
  }

  void queueDirection(Direction direction) {
    final changed = _engine.queueDirection(direction);
    if (changed && snapshot.phase == GamePhase.running && _timer == null) {
      _restartTimer();
    }
    if (changed) notifyListeners();
  }

  void onLayoutChanged() {
    if (_disposed || snapshot.phase != GamePhase.running) return;
    softPausedForLayout = true;
    pause();
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (!_disposed && softPausedForLayout) {
        resume();
      }
    });
  }

  /// Apply orientation-aware grid size; remaps snake/food by row/col.
  void applyGridSize({required int columns, required int rows}) {
    if (_disposed) return;
    if (snapshot.columns == columns && snapshot.rows == rows) return;
    final wasRunning = snapshot.phase == GamePhase.running;
    if (wasRunning) {
      softPausedForLayout = true;
      pause();
    }
    _engine.resizeTo(newColumns: columns, newRows: rows);
    notifyListeners();
    if (wasRunning) {
      Future<void>.delayed(const Duration(milliseconds: 280), () {
        if (!_disposed && softPausedForLayout) {
          resume();
        }
      });
    }
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: _tickMs), (_) {
      if (_disposed) return;
      final eatEvent = _engine.tick();
      lastEatEvent = eatEvent;
      if (_engine.snapshot.phase == GamePhase.gameOver) {
        _timer?.cancel();
        _timer = null;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
