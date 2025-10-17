import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';

class GameConfirmationModal extends StatelessWidget {
  const GameConfirmationModal({
    super.key,
    required this.topBorderRadius,
    required this.gamePanelHeight,
  });

  final double topBorderRadius;
  final int gamePanelHeight;

  void _onPauseOrResumeGame(BuildContext context) {
    Provider.of<SnakeState>(context, listen: false).pauseOrResumeGame(
      gamePanelHeight: gamePanelHeight,
      gameBoxSize: _getPanelBoxSize(context),
    );
  }

  void _onResetGame(BuildContext context) {
    Provider.of<SnakeState>(context, listen: false).resetSnakeState();
    Provider.of<SnakeState>(context, listen: false).restartGame(
      gamePanelHeight: gamePanelHeight,
      gameBoxSize: _getPanelBoxSize(context),
    );
  }

  int _getPanelBoxSize(BuildContext context) {
    double gamePanelWidth = MediaQuery.of(context).size.width * 0.95;
    double boxSize =
        (gamePanelWidth - AppInfoReference.gridPadding) /
            AppInfoReference.gridColumnsCount -
        AppInfoReference.gridPadding;
    return boxSize.toInt();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20.0),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topBorderRadius),
        ), // Top border radius for the inner container.
      ),
      child: Consumer<SnakeState>(
        builder: (context, snakeState, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  snakeState.isGameOver ? 'Game Over' : 'Game Paused',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                IconReference.trophy,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 50.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                '${snakeState.score}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Points Earned',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20.0),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (snakeState.isGameOver) {
                    _onResetGame(context);
                  } else {
                    _onPauseOrResumeGame(context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  width: size.width * 0.70,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          IconReference.gamePad,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        snakeState.isGameOver ? 'Restart Game' : 'Resume Game',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
