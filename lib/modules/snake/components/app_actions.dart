import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/core/app_state/snake_state.dart';
import 'package:snake_game/core/constants/app_info_reference.dart';

class AppActions extends StatelessWidget {
  const AppActions({
    super.key,
  });

  Widget _getActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: IconButton(
        icon: Icon(
          icon,
          size: 30.0,
        ),
        onPressed: onTap,
      ),
    );
  }

  void onPauseOrResumeGame(BuildContext context) {
    Provider.of<SnakeState>(context, listen: false).pauseOrResumeGame();
  }

  void onResetGame(BuildContext context) {
    Provider.of<SnakeState>(context, listen: false).restartGame();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SnakeState>(
      builder: (context, snakeState, child) {
        bool isGamePaused = snakeState.isGamePaused;
        return Container(
          color: AppInfoReference.defaultAppColor.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Row(
            children: [
              _getActionButton(
                context,
                icon: isGamePaused ? Icons.play_arrow_sharp : Icons.pause_sharp,
                onTap: () => onPauseOrResumeGame(context),
              ),
              Visibility(
                visible: true,
                child: _getActionButton(
                  context,
                  icon: Icons.refresh,
                  onTap: () => onResetGame(context),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
