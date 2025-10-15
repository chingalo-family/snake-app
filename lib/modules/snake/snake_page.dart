import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/modules/snake/components/app_actions.dart';
import 'package:snake_app/modules/snake/components/snake_container.dart';

class SnakePage extends StatelessWidget {
  const SnakePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int gamePanelHeight = (constraints.maxHeight * 0.77).ceil();
        double gameScoreHeight = (constraints.maxHeight * 0.17)
            .ceil()
            .toDouble();
        return Scaffold(
          appBar: AppBarContainer(),
          body: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(gameScoreHeight),
              child: AppActions(gamePanelHeight: gamePanelHeight),
            ),
            body: SnakeContainer(gamePanelHeight: gamePanelHeight),
          ),
        );
      },
    );
  }
}
