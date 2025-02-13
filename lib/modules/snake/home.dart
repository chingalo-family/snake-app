import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state.dart';
import 'package:snake_app/modules/snake/components/app_actions.dart';
import 'package:snake_app/modules/snake/snake.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int gamePanelHeight = (constraints.maxHeight * 0.85).ceil();
      double gameScoreHeight = (constraints.maxHeight * 0.17).ceil().toDouble();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Consumer<SnakeState>(
            builder: (context, snakeState, child) {
              int score = snakeState.score;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(),
                    child: Text(
                      'Snake App',
                      style: const TextStyle().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(),
                    child: Text(
                      'Score : $score',
                      style: const TextStyle().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        body: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(gameScoreHeight),
            child: AppActions(
              gamePanelHeight: gamePanelHeight,
            ),
          ),
          body: Snake(
            gamePanelHeight: gamePanelHeight,
          ),
        ),
      );
    });
  }
}
