import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/game_direction.dart';
import 'package:snake_app/core/constants/game_food_store_reference.dart';
import 'package:snake_app/core/constants/snake_reference.dart';
import 'package:snake_app/core/models/game_food_score.dart';
import 'package:snake_app/core/utils/app_util.dart';

class SnakeState with ChangeNotifier {
  int _foodIndex = 0;
  int _gamePanelHeight = 0;
  int _gameBoxSize = 0;
  int _totalBoxes = 0;
  int _gridColumnsCount = AppInfoReference.defaultGridColumnsCount;
  GameFoodScore? _gameFoodScore;
  List<int> _snake = [];
  bool _isGameOver = false;
  bool _isGamePaused = true;
  int _score = 0;
  int _level = 1;
  String _gameScoreId = AppUtil.getUid();
  GameDirection _direction = GameDirection.right;
  Timer? timer;

  List<int> get snake => _snake;
  String get gameScoreId => _gameScoreId;
  int get gamePanelHeight => _gamePanelHeight;
  int get gameBoxSize => _gameBoxSize;
  int get gridColumnsCount => _gridColumnsCount;
  int get score => _score;
  int get level => _level;
  int get foodIndex => _foodIndex;
  bool get hasGameStarted => _snake.isNotEmpty;
  GameDirection get direction => _direction;
  bool get isGameOver => _isGameOver;
  bool get isGamePaused => _isGamePaused;
  GameFoodScore get gameFoodScore =>
      _gameFoodScore ?? GameStoreReference.gameFoodScores.first;

  void resetSnakeState() {
    _gameScoreId = AppUtil.getUid();
    _level = 1;
    _gameFoodScore = GameStoreReference.gameFoodScores.first;
    _gamePanelHeight = 0;
    _gridColumnsCount = AppInfoReference.defaultGridColumnsCount;
    _foodIndex = 0;
    _snake = [];
    _isGameOver = false;
    _isGamePaused = true;
    _score = 0;
    _direction = GameDirection.right;
    timer?.cancel();
    notifyListeners();
  }

  void resetSnake() {
    _snake = SnakeReference.defaultPosition;
    _direction = GameDirection.right;
    _score = 0;
    if (gamePanelHeight > 0) {
      generateSnakeFood();
    }
    notifyListeners();
  }

  void initiateTheGame() {
    resetSnake();
  }

  void updateLevel({int level = 1}) {
    _level = level;
    notifyListeners();
  }

  void restartGame({
    required int gamePanelHeight,
    required int gameBoxSize,
    required int totalBoxes,
    required int gridColumnsCount,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    _gamePanelHeight = gamePanelHeight;
    _gameBoxSize = gameBoxSize;
    _totalBoxes = totalBoxes;
    _gridColumnsCount = gridColumnsCount;
    notifyListeners();
    try {
      timer?.cancel();
    } catch (e) {
      //
    }
    _isGameOver = false;
    _isGamePaused = false;
    resetSnake();
    startGame(duration: duration);
  }

  void startGame({Duration duration = const Duration(milliseconds: 250)}) {
    timer = Timer.periodic(duration, (Timer timer) {
      if (!isGameOver) {
        if (!isGamePaused) {
          moveSnakePosition();
          checkForSnakeFood();
        }
      }
    });
  }

  void pauseOrResumeGame({
    required int gamePanelHeight,
    required int gameBoxSize,
    required int totalBoxes,
    required int gridColumnsCount,
  }) {
    _gamePanelHeight = gamePanelHeight;
    _gameBoxSize = gameBoxSize;
    _totalBoxes = totalBoxes;
    _gridColumnsCount = gridColumnsCount;
    _isGamePaused = !isGamePaused;
    if (snake.isEmpty) {
      initiateTheGame();
    }
    try {
      timer?.cancel();
    } catch (e) {
      //
    }
    notifyListeners();
    if (!_isGamePaused) {
      startGame();
    }
  }

  void generateSnakeFood() {
    if (_totalBoxes <= 0) return;
    final random = Random();
    int newFoodIndex = random.nextInt(_totalBoxes);
    while (_snake.contains(newFoodIndex)) {
      newFoodIndex = random.nextInt(_totalBoxes);
    }
    _foodIndex = newFoodIndex;
    _gameFoodScore =
        GameStoreReference.gameFoodScores[random.nextInt(
          GameStoreReference.gameFoodScores.length,
        )];
    notifyListeners();
  }

  void updateSnakeDirection(GameDirection direction) {
    _direction = direction;
    notifyListeners();
  }

  void checkForSnakeFood() {
    if (snake.first == foodIndex) {
      snake.add(snake.last);
      generateSnakeFood();
    }
  }

  void moveSnakePosition() async {
    int head = _snake.first;
    switch (_direction) {
      case GameDirection.up:
        if (head < _gridColumnsCount) {
          _isGameOver = true;
        } else {
          head -= _gridColumnsCount;
        }
        break;
      case GameDirection.down:
        if (head >= _totalBoxes - _gridColumnsCount) {
          _isGameOver = true;
        } else {
          head += _gridColumnsCount;
        }
        break;
      case GameDirection.left:
        if (head % _gridColumnsCount == 0) {
          _isGameOver = true;
        } else {
          head--;
        }
        break;
      case GameDirection.right:
        if ((head + 1) % _gridColumnsCount == 0) {
          _isGameOver = true;
        } else {
          head++;
        }
        break;
    }
    if (head < 0 || head >= _totalBoxes) {
      _isGameOver = true;
    }
    if (_snake.contains(head)) {
      _isGameOver = true;
    }
    if (!_isGameOver) {
      _snake = [head, ..._snake];
      if (head == _foodIndex) {
        _score += gameFoodScore.score;
        _snake.add(_snake.last);
        generateSnakeFood();
        await Haptics.vibrate(HapticsType.success);
      } else {
        _snake.removeLast();
      }
    } else {
      await Haptics.vibrate(HapticsType.error);
    }
    notifyListeners();
  }
}
