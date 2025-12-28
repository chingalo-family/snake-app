import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/constants/game_direction.dart';
import 'package:snake_app/core/constants/power_up_reference.dart';
import 'package:snake_app/core/models/game_food_score.dart';
import 'package:snake_app/core/utils/app_modal_util.dart';
import 'package:snake_app/core/utils/grid_util.dart';
import 'package:snake_app/modules/game/components/game_confirmation_modal.dart';
import 'package:snake_app/modules/game/components/game_food_icon.dart';
import 'dart:math' as math;

class GamePlayContainer extends StatefulWidget {
  const GamePlayContainer({super.key, this.gamePanelHeight = 0});

  final int gamePanelHeight;

  @override
  State<GamePlayContainer> createState() => _GamePlayContainerState();
}

class _GamePlayContainerState extends State<GamePlayContainer> {
  bool _isModalVisible = false;

  @override
  void initState() {
    super.initState();
    _setAppStateForModalAction();
  }

  Future<void> _submitGameScore() async {
    final snakeState = Provider.of<SnakeState>(context, listen: false);
    String bestScore = Provider.of<GameScoreState>(
      context,
      listen: false,
    ).bestScore;
    final score = snakeState.score;
    final level = snakeState.level;
    final gameScoreId = snakeState.gameScoreId;
    if (score <= 0) return;
    Provider.of<GameScoreState>(context, listen: false).submitGameScore(
      score: score,
      level: level,
      bestScore: bestScore,
      gameScoreId: gameScoreId,
    );
  }

  void _setAppStateForModalAction() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snakeState = Provider.of<SnakeState>(context, listen: false);
      snakeState.addListener(() {
        if (!mounted) return;

        if (_isModalVisible) return;

        if (snakeState.hasGameStarted) {
          if (snakeState.isGamePaused) {
            _isModalVisible = true;
            setState(() {});
            AppModalUtil.showActionSheetModal(
              context: context,
              topBorderRadius: 20,
              initialHeightRatio: 0.40,
              maxHeightRatio: 0.60,
              actionSheetContainer: GameConfirmationModal(
                topBorderRadius: 20,
                gamePanelHeight: widget.gamePanelHeight,
              ),
            ).then((_) {
              _isModalVisible = false;
              setState(() {});
            });
            ;
          }
          if (snakeState.isGameOver) {
            _isModalVisible = true;
            setState(() {});
            _submitGameScore();
            AppModalUtil.showActionSheetModal(
              context: context,
              topBorderRadius: 20,
              initialHeightRatio: 0.60,
              maxHeightRatio: 0.75,
              actionSheetContainer: GameConfirmationModal(
                topBorderRadius: 20,
                gamePanelHeight: widget.gamePanelHeight,
              ),
            ).then((_) {
              _isModalVisible = false;
              setState(() {});
            });
            ;
          }
        }
      });
    });
  }

  void onVerticalDragUpdate(
    DragUpdateDetails details,
    GameDirection direction,
  ) {
    if (details.primaryDelta! > 0 && direction != GameDirection.up) {
      Provider.of<SnakeState>(
        context,
        listen: false,
      ).updateSnakeDirection(GameDirection.down);
    } else if (details.primaryDelta! < 0 && direction != GameDirection.down) {
      Provider.of<SnakeState>(
        context,
        listen: false,
      ).updateSnakeDirection(GameDirection.up);
      direction = GameDirection.up;
    }
  }

  void onHorizontalDragUpdate(
    DragUpdateDetails details,
    GameDirection direction,
  ) {
    if (details.primaryDelta! > 0 && direction != GameDirection.left) {
      Provider.of<SnakeState>(
        context,
        listen: false,
      ).updateSnakeDirection(GameDirection.right);
    } else if (details.primaryDelta! < 0 && direction != GameDirection.right) {
      Provider.of<SnakeState>(
        context,
        listen: false,
      ).updateSnakeDirection(GameDirection.left);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SnakeState>(
      builder: (context, snakeState, child) {
        List<int> snake = snakeState.snake;
        int foodIndex = snakeState.foodIndex;
        int powerUpIndex = snakeState.powerUpIndex;
        GameDirection direction = snakeState.direction;
        bool hasGameStarted = snakeState.hasGameStarted;
        GameFoodScore gameFoodScore = snakeState.gameFoodScore;
        int gameBoxSize = snakeState.gameBoxSize;
        bool hasShield = snakeState.hasShield;
        int gridColumnsCount = GridUtil.getGridColumnsCount(context);
        int numberOfRows = GridUtil.getNumberOfRows(
          context,
          widget.gamePanelHeight,
          gridColumnsCount,
        );
        int totalBoxes = numberOfRows * gridColumnsCount;

        return GestureDetector(
          onVerticalDragUpdate: (details) =>
              onVerticalDragUpdate(details, direction),
          onHorizontalDragUpdate: (details) =>
              onHorizontalDragUpdate(details, direction),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface.withOpacity(0.3),
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
                ],
              ),
            ),
            padding: const EdgeInsets.all(2),
            child: GridView.count(
              crossAxisCount: gridColumnsCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: List.generate(totalBoxes, (index) {
                bool isSnake = snake.contains(index);
                bool isHead = snake.isNotEmpty && snake.first == index;
                bool isPowerUp = index == powerUpIndex && powerUpIndex != -1;

                return Center(
                  child: isSnake
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              isHead ? 6.0 : gameBoxSize.toDouble(),
                            ),
                            child: Stack(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    gradient: isHead
                                        ? LinearGradient(
                                            colors: hasShield
                                                ? [
                                                    Colors.blue.withValues(
                                                      alpha: 0.9,
                                                    ),
                                                    Colors.cyan.withValues(
                                                      alpha: 0.7,
                                                    ),
                                                  ]
                                                : [
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withValues(alpha: 0.8),
                                                  ],
                                          )
                                        : null,
                                    color: !isHead
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                    boxShadow: isHead
                                        ? [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  width: isHead
                                      ? gameBoxSize * 1.5
                                      : gameBoxSize.toDouble(),
                                  height: isHead
                                      ? gameBoxSize * 1.5
                                      : gameBoxSize.toDouble(),
                                ),
                                if (isHead && hasShield)
                                  Positioned.fill(
                                    child: Center(
                                      child: Icon(
                                        Icons.shield,
                                        size: gameBoxSize * 0.8,
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : isPowerUp
                      ? _PowerUpCell(gameBoxSize: gameBoxSize)
                      : index == foodIndex && hasGameStarted
                      ? _FoodCell(
                          icon: gameFoodScore.icon,
                          gameBoxSize: gameBoxSize,
                        )
                      : Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.inversePrimary.withOpacity(0.05),
                            ),
                          ),
                        ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

/// Animated food cell widget
class _FoodCell extends StatefulWidget {
  final String icon;
  final int gameBoxSize;

  const _FoodCell({required this.icon, required this.gameBoxSize});

  @override
  State<_FoodCell> createState() => _FoodCellState();
}

class _FoodCellState extends State<_FoodCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GameFoodIcon(icon: widget.icon),
        );
      },
    );
  }
}

/// Animated power-up cell widget
class _PowerUpCell extends StatefulWidget {
  final int gameBoxSize;

  const _PowerUpCell({required this.gameBoxSize});

  @override
  State<_PowerUpCell> createState() => _PowerUpCellState();
}

class _PowerUpCellState extends State<_PowerUpCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = math.Random();
    final powerUpIcon = PowerUpReference
        .allPowerUps[random.nextInt(PowerUpReference.allPowerUps.length)]
        .icon;

    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.amber.withValues(alpha: 0.8),
                  Colors.orange.withValues(alpha: 0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                powerUpIcon,
                style: TextStyle(fontSize: widget.gameBoxSize * 0.8),
              ),
            ),
          ),
        );
      },
    );
  }
}
