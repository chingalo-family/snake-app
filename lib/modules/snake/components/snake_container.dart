import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/game_direction.dart';

class SnakeContainer extends StatefulWidget {
  const SnakeContainer({
    super.key,
    this.gamePanelHeight = 0,
  });

  final int gamePanelHeight;

  @override
  State<SnakeContainer> createState() => _SnakeContainerState();
}

class _SnakeContainerState extends State<SnakeContainer> {
  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {}

  void onVerticalDragUpdate(
      DragUpdateDetails details, GameDirection direction) {
    if (details.primaryDelta! > 0 && direction != GameDirection.up) {
      Provider.of<SnakeState>(context, listen: false)
          .updateSnakeDirection(GameDirection.down);
    } else if (details.primaryDelta! < 0 && direction != GameDirection.down) {
      Provider.of<SnakeState>(context, listen: false)
          .updateSnakeDirection(GameDirection.up);
      direction = GameDirection.up;
    }
  }

  void onHorizontalDragUpdate(
      DragUpdateDetails details, GameDirection direction) {
    if (details.primaryDelta! > 0 && direction != GameDirection.left) {
      Provider.of<SnakeState>(context, listen: false)
          .updateSnakeDirection(GameDirection.right);
    } else if (details.primaryDelta! < 0 && direction != GameDirection.right) {
      Provider.of<SnakeState>(context, listen: false)
          .updateSnakeDirection(GameDirection.left);
    }
  }

  int _getNumberOfRows() {
    double gamePanelWidth = MediaQuery.of(context).size.width * 0.95;
    double boxSize = (gamePanelWidth - AppInfoReference.gridPadding) /
            AppInfoReference.gridColumnsCount -
        AppInfoReference.gridPadding;
    return ((widget.gamePanelHeight - AppInfoReference.gridPadding) /
            (boxSize + AppInfoReference.gridPadding))
        .toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SnakeState>(
      builder: (context, snakeState, child) {
        List<int> snake = snakeState.snake;
        int foodIndex = snakeState.foodIndex;
        GameDirection direction = snakeState.direction;
        int numberOfRows = _getNumberOfRows();
        int totalBoxes = numberOfRows * AppInfoReference.gridColumnsCount;
        return GestureDetector(
          onVerticalDragUpdate: (details) =>
              onVerticalDragUpdate(details, direction),
          onHorizontalDragUpdate: (details) =>
              onHorizontalDragUpdate(details, direction),
          child: Container(
            color: Theme.of(context).colorScheme.inversePrimary.withValues(
                  alpha: 0.1,
                ),
            padding: const EdgeInsets.all(10),
            child: GridView.count(
              crossAxisCount: AppInfoReference.gridColumnsCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                totalBoxes,
                (index) {
                  return Center(
                    child: snake.contains(index)
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                color: Colors.red,
                              ),
                            ),
                          )
                        : index == foodIndex
                            ? Center(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.local_pizza,
                                    size: 20.0,
                                    color: Colors.cyan,
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withValues(
                                            alpha: 0.2,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
