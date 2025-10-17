import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';

class GamePlayAction extends StatelessWidget {
  const GamePlayAction({super.key, this.gamePanelHeight = 0});

  final int gamePanelHeight;

  void _onPauseOrResumeGame(BuildContext context) {
    Provider.of<SnakeState>(context, listen: false).pauseOrResumeGame(
      gamePanelHeight: gamePanelHeight,
      gameBoxSize: _getPanelBoxSize(context),
    );
  }

  void _onResetGame(BuildContext context) {
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
    return Container(
      color: Theme.of(context).colorScheme.inverseSurface,
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      child: Consumer<SnakeState>(
        builder: (context, snakeState, child) {
          bool isGamePaused = snakeState.isGamePaused;
          int score = snakeState.score;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(),
                child: Chip(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  avatar: Text(
                    IconReference.trophy,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  label: Text('Score: $score'),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              IconButton(
                icon: !snakeState.isGameOver
                    ? Icon(
                        isGamePaused ? Icons.play_arrow : Icons.pause,
                        size: 30.0,
                      )
                    : Icon(Icons.refresh, size: 30.0),
                onPressed: () => !snakeState.isGameOver
                    ? _onPauseOrResumeGame(context)
                    : _onResetGame(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
