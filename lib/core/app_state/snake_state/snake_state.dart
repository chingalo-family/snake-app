import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/game_direction.dart';
import 'package:snake_app/core/constants/game_store_reference.dart';
import 'package:snake_app/core/constants/snake_reference.dart';
import 'package:snake_app/core/models/game_score.dart';

class SnakeState with ChangeNotifier {
  int _foodIndex = 0;
  int _gamePanelHeight = 0;
  int _gameBoxSize = 0;
  GameScore? _gameScore;
  List<int> _snake = [];
  bool _isGameOver = false;
  bool _isGamePaused = true;
  int _score = 0;
  GameDirection _direction = GameDirection.right;
  Timer? timer;

  List<int> get snake => _snake;
  int get gamePanelHeight => _gamePanelHeight;
  int get gameBoxSize => _gameBoxSize;
  int get score => _score;
  int get foodIndex => _foodIndex;
  bool get hasGameStarted => _snake.isNotEmpty;
  GameDirection get direction => _direction;
  bool get isGameOver => _isGameOver;
  bool get isGamePaused => _isGamePaused;
  GameScore get gameScore => _gameScore ?? GameStoreReference.gameScores.first;

  void resetSnakeState() {
    _gameScore = GameStoreReference.gameScores.first;
    _gamePanelHeight = 0;
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

  void restartGame({required int gamePanelHeight, required int gameBoxSize}) {
    _gamePanelHeight = gamePanelHeight;
    _gameBoxSize = gameBoxSize;
    notifyListeners();
    try {
      timer?.cancel();
    } catch (e) {
      //
    }
    _isGameOver = false;
    _isGamePaused = false;
    resetSnake();
    startGame();
  }

  void startGame() {
    const duration = Duration(milliseconds: 300);
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
  }) {
    _gamePanelHeight = gamePanelHeight;
    _gameBoxSize = gameBoxSize;
    _gamePanelHeight = gamePanelHeight;
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
    _foodIndex = DateTime.now().millisecondsSinceEpoch % gamePanelHeight;
    _gameScore = GameStoreReference
        .gameScores[Random().nextInt(GameStoreReference.gameScores.length)];
    if (_snake.contains(_foodIndex)) {
      generateSnakeFood();
    } else {
      notifyListeners();
    }
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

  void moveSnakePosition() {
    int head = _snake.first;
    switch (_direction) {
      case GameDirection.up:
        if (head < AppInfoReference.gridColumnsCount) {
          _isGameOver = true;
        }
        head -= AppInfoReference.gridColumnsCount;
        break;
      case GameDirection.down:
        if (head >= gamePanelHeight - AppInfoReference.gridColumnsCount) {
          _isGameOver = true;
        }
        head += AppInfoReference.gridColumnsCount;
        break;
      case GameDirection.left:
        if (head % AppInfoReference.gridColumnsCount == 0) {
          _isGameOver = true;
        }
        head--;
        break;
      case GameDirection.right:
        if ((head + 1) % AppInfoReference.gridColumnsCount == 0) {
          _isGameOver = true;
        }
        head++;
        break;
    }
    if (snake.contains(head)) {
      _isGameOver = true;
    }
    if (!isGameOver) {
      _snake = [
        ...[head],
        ..._snake,
      ];
      if (head == foodIndex) {
        generateSnakeFood();
        _score += gameScore.score;
      } else {
        int last = _snake.last;
        _snake = _snake.where((val) => val != last).toList();
      }
    }
    notifyListeners();
  }
}
