import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/core/app_state/snake_state.dart';
import 'package:snake_game/core/constants/app_info_reference.dart';
import 'package:snake_game/modules/snake/components/app_actions.dart';
import 'package:snake_game/modules/snake/snake.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppInfoReference.defaultAppColor.withOpacity(0.5),
        title: Consumer<SnakeState>(
          builder: (context, snakeState, child) {
            int score = snakeState.score;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(),
                  child: Text(
                    'Snake Game',
                    style: const TextStyle().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
      body: const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppActions(),
        ),
        body: Snake(),
      ),
    );
  }
}
