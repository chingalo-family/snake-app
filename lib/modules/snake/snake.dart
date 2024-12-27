import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/game_direction.dart';

class Snake extends StatefulWidget {
  const Snake({
    super.key,
    this.gamePanelHeight = 0,
  });

  final int gamePanelHeight;

  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<SnakeState>(
      builder: (context, snakeState, child) {
        List<int> snake = snakeState.snake;
        int foodIndex = snakeState.foodIndex;
        GameDirection direction = snakeState.direction;
        int gamePanelHeight = snakeState.gamePanelHeight > 0
            ? snakeState.gamePanelHeight
            : widget.gamePanelHeight;
        return GestureDetector(
          onVerticalDragUpdate: (details) =>
              onVerticalDragUpdate(details, direction),
          onHorizontalDragUpdate: (details) =>
              onHorizontalDragUpdate(details, direction),
          child: Container(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppInfoReference.gridColumnsCount,
              ),
              itemCount: gamePanelHeight,
              itemBuilder: (BuildContext context, int index) {
                if (snake.contains(index)) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                } else if (index == foodIndex) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.local_pizza,
                        size: 20.0,
                        color: Colors.cyan,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.15),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
