import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/utils/grid_util.dart';
import 'package:snake_app/modules/leaderboard/leaderboard.dart';

class GameConfirmationModal extends StatelessWidget {
  const GameConfirmationModal({
    super.key,
    required this.topBorderRadius,
    required this.gamePanelHeight,
  });

  final double topBorderRadius;
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

  void _onDirectToLeaderboard(BuildContext context) {
    String orgUnitId = Provider.of<UserState>(context, listen: false).orgUnitId;
    Provider.of<GameScoreState>(
      context,
      listen: false,
    ).resetGameScoreState(orgUnitId: orgUnitId);
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Leaderboard(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20.0),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.inverseSurface,
            Theme.of(context).colorScheme.surface.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topBorderRadius),
        ),
      ),
      child: Consumer<SnakeState>(
        builder: (context, snakeState, child) {
          bool isGameOver = snakeState.isGameOver;
          int foodCollected = snakeState.foodCollected;
          int highestCombo = snakeState.highestCombo;
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  isGameOver ? 'Game Over' : 'Game Paused',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Points Earned',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (isGameOver) ...[
                const SizedBox(height: 20.0),
                // Game stats
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _StatRow(
                        icon: '🍎',
                        label: 'Food Collected',
                        value: foodCollected.toString(),
                      ),
                      const SizedBox(height: 8),
                      _StatRow(
                        icon: '🔥',
                        label: 'Highest Combo',
                        value: 'x$highestCombo',
                      ),
                      const SizedBox(height: 8),
                      _StatRow(
                        icon: '📏',
                        label: 'Snake Length',
                        value: snakeState.snake.length.toString(),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20.0),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (isGameOver) {
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
              const SizedBox(height: 10.0),
              Visibility(
                visible: isGameOver,
                child: OutlinedButton(
                  onPressed: () => _onDirectToLeaderboard(context),
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
                            IconReference.trophy,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          "Leaderboard",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
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

/// Stat row widget for displaying game statistics
class _StatRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
