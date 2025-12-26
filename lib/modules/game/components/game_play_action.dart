import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/components/combo_display.dart';
import 'package:snake_app/core/components/power_up_display.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/utils/grid_util.dart';

class GamePlayAction extends StatelessWidget {
  const GamePlayAction({super.key, this.gamePanelHeight = 0});

  final int gamePanelHeight;

  void _onPauseOrResumeGame(BuildContext context) {
    int gridColumnsCount = GridUtil.getGridColumnsCount(context);
    int numberOfRows = GridUtil.getNumberOfRows(
      context,
      gamePanelHeight,
      gridColumnsCount,
    );
    int totalBoxes = numberOfRows * gridColumnsCount;
    Provider.of<SnakeState>(context, listen: false).pauseOrResumeGame(
      gamePanelHeight: gamePanelHeight,
      gameBoxSize: GridUtil.getPanelBoxSize(context, gridColumnsCount),
      totalBoxes: totalBoxes,
      gridColumnsCount: gridColumnsCount,
    );
  }

  void _onResetGame(BuildContext context) {
    int gridColumnsCount = GridUtil.getGridColumnsCount(context);
    int numberOfRows = GridUtil.getNumberOfRows(
      context,
      gamePanelHeight,
      gridColumnsCount,
    );
    int totalBoxes = numberOfRows * gridColumnsCount;
    Provider.of<SnakeState>(context, listen: false).resetSnakeState();
    Provider.of<SnakeState>(context, listen: false).restartGame(
      gamePanelHeight: gamePanelHeight,
      gameBoxSize: GridUtil.getPanelBoxSize(context, gridColumnsCount),
      totalBoxes: totalBoxes,
      gridColumnsCount: gridColumnsCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.inverseSurface,
            Theme.of(context).colorScheme.surface.withOpacity(0.8),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      child: Consumer<SnakeState>(
        builder: (context, snakeState, child) {
          bool isGamePaused = snakeState.isGamePaused;
          int score = snakeState.score;
          int foodCollected = snakeState.foodCollected;
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Score display
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(),
                          child: Chip(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            avatar: Text(
                              IconReference.trophy,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            labelStyle:
                                Theme.of(context).textTheme.titleSmall,
                            label: Text('Score: $score'),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Food collected badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '🍎 $foodCollected',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Control button
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
              ),
              // Combo and Power-up display row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ComboDisplay(),
                  const Spacer(),
                  const PowerUpDisplay(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
