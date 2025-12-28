import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/game_direction.dart';
import 'package:snake_app/core/constants/game_food_store_reference.dart';
import 'package:snake_app/core/constants/power_up_reference.dart';
import 'package:snake_app/core/constants/snake_reference.dart';
import 'package:snake_app/core/models/combo.dart';
import 'package:snake_app/core/models/game_food_score.dart';
import 'package:snake_app/core/models/power_up.dart';
import 'package:snake_app/core/services/game_settings_service.dart';
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

  // New features for modern gameplay
  int _comboCount = 0;
  int _foodCollected = 0;
  int _highestCombo = 0;
  Timer? _comboTimer;
  PowerUp? _activePowerUp;
  Timer? _powerUpTimer;
  bool _hasShield = false;
  double _scoreMultiplier = 1.0;
  int _powerUpIndex = -1;
  int _powerUpRemainingSeconds = 0;
  Timer? _powerUpCountdownTimer;
  Duration _baseDuration = const Duration(milliseconds: 250);
  PowerUpType? _previousSpeedPowerUp;

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

  // New getters for modern features
  int get comboCount => _comboCount;
  int get foodCollected => _foodCollected;
  int get highestCombo => _highestCombo;
  PowerUp? get activePowerUp => _activePowerUp;
  bool get hasShield => _hasShield;
  double get scoreMultiplier => _scoreMultiplier;
  int get powerUpIndex => _powerUpIndex;
  int get powerUpRemainingSeconds => _powerUpRemainingSeconds;

  Combo get currentCombo {
    double multiplier = 1.0 + (_comboCount * 0.1);
    return Combo(
      count: _comboCount,
      multiplier: multiplier,
      bonusScore: _comboCount * 5,
    );
  }

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

    // Reset new features
    _comboCount = 0;
    _foodCollected = 0;
    _highestCombo = 0;
    _comboTimer?.cancel();
    _powerUpTimer?.cancel();
    _powerUpCountdownTimer?.cancel();
    _activePowerUp = null;
    _hasShield = false;
    _scoreMultiplier = 1.0;
    _powerUpIndex = -1;
    _powerUpRemainingSeconds = 0;

    notifyListeners();
  }

  void resetSnake() {
    _snake = SnakeReference.defaultPosition;
    _direction = GameDirection.right;
    _score = 0;
    _comboCount = 0;
    _foodCollected = 0;
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
    // Store the base duration if this is the first call or a reset
    if (_activePowerUp == null ||
        (_activePowerUp!.type != PowerUpType.speedBoost &&
            _activePowerUp!.type != PowerUpType.slowMotion)) {
      _baseDuration = duration;
    }

    timer = Timer.periodic(duration, (Timer timer) {
      if (!isGameOver) {
        if (!isGamePaused) {
          moveSnakePosition();
          checkForSnakeFood();

          // Check if we need to adjust speed based on active power-up
          if (_activePowerUp != null &&
              (_activePowerUp!.type == PowerUpType.speedBoost ||
                  _activePowerUp!.type == PowerUpType.slowMotion)) {
            // Only restart timer if this is a new speed power-up
            if (_previousSpeedPowerUp != _activePowerUp!.type) {
              _previousSpeedPowerUp = _activePowerUp!.type;
              Duration newDuration = _baseDuration;
              if (_activePowerUp!.type == PowerUpType.speedBoost) {
                newDuration = Duration(
                  milliseconds: (_baseDuration.inMilliseconds * 0.7).round(),
                );
              } else if (_activePowerUp!.type == PowerUpType.slowMotion) {
                newDuration = Duration(
                  milliseconds: (_baseDuration.inMilliseconds * 1.5).round(),
                );
              }
              timer.cancel();
              startGame(duration: newDuration);
            }
          } else if (_previousSpeedPowerUp != null) {
            // Power-up expired, return to base speed
            _previousSpeedPowerUp = null;
            timer.cancel();
            startGame(duration: _baseDuration);
          }
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
    while (_snake.contains(newFoodIndex) || newFoodIndex == _powerUpIndex) {
      newFoodIndex = random.nextInt(_totalBoxes);
    }
    _foodIndex = newFoodIndex;
    _gameFoodScore =
        GameStoreReference.gameFoodScores[random.nextInt(
          GameStoreReference.gameFoodScores.length,
        )];

    // Randomly spawn power-ups (20% chance)
    if (random.nextDouble() < 0.2 && _activePowerUp == null) {
      _generatePowerUp();
    }

    notifyListeners();
  }

  void _generatePowerUp() {
    if (_totalBoxes <= 0) return;
    final random = Random();
    int newPowerUpIndex = random.nextInt(_totalBoxes);
    while (_snake.contains(newPowerUpIndex) || newPowerUpIndex == _foodIndex) {
      newPowerUpIndex = random.nextInt(_totalBoxes);
    }
    _powerUpIndex = newPowerUpIndex;
    notifyListeners();
  }

  void _clearPowerUpFromGrid() {
    _powerUpIndex = -1;
    notifyListeners();
  }

  void activatePowerUp(PowerUp powerUp) {
    _activePowerUp = powerUp;
    _powerUpTimer?.cancel();
    _powerUpCountdownTimer?.cancel();

    // Initialize countdown timer
    _powerUpRemainingSeconds = powerUp.duration.inSeconds;

    switch (powerUp.type) {
      case PowerUpType.shield:
        _hasShield = true;
        break;
      case PowerUpType.scoreMultiplier:
        _scoreMultiplier = powerUp.multiplier;
        break;
      case PowerUpType.speedBoost:
      case PowerUpType.slowMotion:
        // Speed changes handled in game timer
        break;
    }

    // Start countdown display timer (updates every second)
    _powerUpCountdownTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      if (_powerUpRemainingSeconds > 0) {
        _powerUpRemainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });

    // Set timer for power-up expiration
    _powerUpTimer = Timer(powerUp.duration, () {
      _deactivatePowerUp();
    });

    notifyListeners();
  }

  void _deactivatePowerUp() {
    if (_activePowerUp != null) {
      switch (_activePowerUp!.type) {
        case PowerUpType.scoreMultiplier:
          _scoreMultiplier = 1.0;
          break;
        default:
          break;
      }
      _activePowerUp = null;
      _powerUpRemainingSeconds = 0;
      _powerUpCountdownTimer?.cancel();
      notifyListeners();
    }
  }

  void _incrementCombo() {
    _comboCount++;
    if (_comboCount > _highestCombo) {
      _highestCombo = _comboCount;
    }

    // Reset combo timer
    _comboTimer?.cancel();
    _comboTimer = Timer(const Duration(seconds: 3), () {
      _resetCombo();
    });

    notifyListeners();
  }

  void _resetCombo() {
    _comboCount = 0;
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

    // Shield protection
    if (_isGameOver && _hasShield) {
      _isGameOver = false;
      _hasShield = false;
      final hapticEnabled =
          await GameSettingsService.getHapticFeedbackEnabled();
      if (hapticEnabled) {
        await Haptics.vibrate(HapticsType.warning);
      }
    }

    if (!_isGameOver) {
      _snake = [head, ..._snake];

      // Check for food collection
      if (head == _foodIndex) {
        _foodCollected++;
        _incrementCombo();

        // Calculate score with combo and power-up multipliers
        int baseScore = gameFoodScore.score;
        int comboBonus = currentCombo.bonusScore;
        double totalMultiplier = currentCombo.multiplier * _scoreMultiplier;
        int earnedScore = ((baseScore + comboBonus) * totalMultiplier).round();

        _score += earnedScore;
        _snake.add(_snake.last);
        generateSnakeFood();
        final hapticEnabled =
            await GameSettingsService.getHapticFeedbackEnabled();
        if (hapticEnabled) {
          await Haptics.vibrate(HapticsType.success);
        }
      }
      // Check for power-up collection
      else if (head == _powerUpIndex && _powerUpIndex != -1) {
        final random = Random();
        final powerUp = PowerUpReference
            .allPowerUps[random.nextInt(PowerUpReference.allPowerUps.length)];
        activatePowerUp(powerUp);
        _clearPowerUpFromGrid();
        final hapticEnabled =
            await GameSettingsService.getHapticFeedbackEnabled();
        if (hapticEnabled) {
          await Haptics.vibrate(HapticsType.heavy);
        }
      } else {
        _snake.removeLast();
      }
    } else {
      _resetCombo();
      final hapticEnabled =
          await GameSettingsService.getHapticFeedbackEnabled();
      if (hapticEnabled) {
        await Haptics.vibrate(HapticsType.error);
      }
    }
    notifyListeners();
  }
}
