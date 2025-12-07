import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/constants/game_direction.dart';
import 'package:snake_app/core/models/game_food_score.dart';
import 'package:snake_app/core/utils/app_modal_util.dart';
import 'package:snake_app/core/utils/grid_util.dart';
import 'package:snake_app/modules/game/components/game_confirmation_modal.dart';
import 'package:snake_app/modules/game/components/game_food_icon.dart';

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
              initialHeightRatio: 0.65,
              maxHeightRatio: 0.50,
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
              initialHeightRatio: 0.50,
              maxHeightRatio: 0.65,
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
        GameDirection direction = snakeState.direction;
        bool hasGameStarted = snakeState.hasGameStarted;
        GameFoodScore gameFoodScore = snakeState.gameFoodScore;
        int gameBoxSize = snakeState.gameBoxSize;
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
            color: Theme.of(
              context,
            ).colorScheme.inversePrimary.withValues(alpha: 0.1),
            padding: const EdgeInsets.all(2),
            child: GridView.count(
              crossAxisCount: gridColumnsCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(totalBoxes, (index) {
                bool isSnake = snake.contains(index);
                bool isHead = snake.isNotEmpty && snake.first == index;
                return Center(
                  child: isSnake
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              isHead ? 4.0 : gameBoxSize.toDouble(),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              color: isHead
                                  ? Theme.of(context).colorScheme.inversePrimary
                                        .withValues(alpha: 0.9)
                                  : Theme.of(context).colorScheme.primary,
                              width: isHead
                                  ? gameBoxSize * 1.5
                                  : gameBoxSize.toDouble(),
                              height: isHead
                                  ? gameBoxSize * 1.5
                                  : gameBoxSize.toDouble(),
                            ),
                          ),
                        )
                      : index == foodIndex && hasGameStarted
                      ? Center(child: GameFoodIcon(icon: gameFoodScore.icon))
                      : Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withValues(alpha: 0.05),
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
