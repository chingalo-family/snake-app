import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:snake_game/core/constants/app_info_reference.dart';
import 'package:snake_game/core/constants/game_direction.dart';
import 'package:snake_game/core/constants/snake_reference.dart';

class SnakeState with ChangeNotifier {
  int _foodIndex = (AppInfoReference.gridSizeCount * 0.45).ceil();
  List<int> _snake = [];
  bool _isGameOver = false;
  bool _isGamePaused = true;
  GameDirection _direction = GameDirection.right;
  Timer? timer;

  List<int> get snake => _snake;
  int get foodIndex => _foodIndex;
  GameDirection get direction => _direction;
  bool get isGameOver => _isGameOver;
  bool get isGamePaused => _isGamePaused;

  void resetSnake() {
    _snake = SnakeReference.defaultPosition;
    _direction = GameDirection.right;
    generateSnakeFood();
  }

  void initiateTheGame() {
    resetSnake();
  }

  void startGame() {
    const duration = Duration(milliseconds: 300);
    timer = Timer.periodic(
      duration,
      (Timer timer) {
        if (!isGameOver) {
          if (!isGamePaused) {
            moveSnakePosition();
            checkForSnakeFood();
          }
        } else {
          print("need to reset");
          //Hnadling game over  scenario when user presses the space bar again after the game has ended.
        }
      },
    );
  }

  void pauseOrResumeGame() {
    if (snake.isEmpty) {
      initiateTheGame();
    }
    _isGamePaused = !isGamePaused;
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
    _foodIndex =
        DateTime.now().millisecondsSinceEpoch % AppInfoReference.gridSizeCount;
    if (snake.contains(_foodIndex)) {
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
        if (head >=
            AppInfoReference.gridSizeCount -
                AppInfoReference.gridColumnsCount) {
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
        ..._snake
      ];
      if (head == foodIndex) {
        generateSnakeFood();
      } else {
        int last = _snake.last;
        _snake = _snake.where((val) => val != last).toList();
      }
    }

    notifyListeners();
  }
}
