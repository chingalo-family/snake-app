import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/modules/game/components/game_play_action.dart';
import 'package:snake_app/modules/game/components/game_play_container.dart';

class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int gamePanelHeight = (constraints.maxHeight * 0.77).ceil();
        double gameScoreHeight = (constraints.maxHeight * 0.17)
            .ceil()
            .toDouble();
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBarContainer(),
            body: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(gameScoreHeight),
                child: GamePlayAction(gamePanelHeight: gamePanelHeight),
              ),
              body: GamePlayContainer(gamePanelHeight: gamePanelHeight),
            ),
          ),
        );
      },
    );
  }
}
