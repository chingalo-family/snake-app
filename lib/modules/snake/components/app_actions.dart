import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';

class AppActions extends StatelessWidget {
  const AppActions({super.key, this.gamePanelHeight = 0});

  final int gamePanelHeight;

  Widget _getActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: IconButton(
        icon: Icon(icon, size: 30.0, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }

  void onPauseOrResumeGame(BuildContext context) {
    Provider.of<SnakeState>(context, listen: false).pauseOrResumeGame(
      gamePanelHeight: gamePanelHeight,
      gameBoxSize: _getPanelBoxSize(context),
    );
  }

  void onResetGame(BuildContext context) {
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
    return Consumer<SnakeState>(
      builder: (context, snakeState, child) {
        bool isGamePaused = snakeState.isGamePaused;
        bool isGameOver = snakeState.isGameOver;
        bool hasGameStarted = snakeState.hasGameStarted;
        return Container(
          color: Theme.of(context).colorScheme.inversePrimary,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Visibility(
                visible: !isGameOver,
                child: _getActionButton(
                  context,
                  icon: isGamePaused
                      ? Icons.play_arrow_sharp
                      : Icons.pause_sharp,
                  onTap: () => onPauseOrResumeGame(context),
                ),
              ),
              Visibility(
                visible: isGameOver,
                child: _getActionButton(
                  context,
                  icon: Icons.refresh,
                  onTap: () => onResetGame(context),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(),
                  child: Text(
                    !hasGameStarted
                        ? 'Press to start'
                        : isGameOver
                        ? 'Game is over'
                        : isGamePaused
                        ? 'Game has been paused'
                        : '',
                    style: const TextStyle().copyWith(
                      fontSize: 15.0,
                      color: isGameOver ? Colors.redAccent : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
