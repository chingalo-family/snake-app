import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/core/app_state/snake_state.dart';
import 'package:snake_game/modules/snake/snake.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
      ),
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            color: Colors.amber,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(),
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow_sharp,
                      size: 30.0,
                    ),
                    onPressed: () =>
                        Provider.of<SnakeState>(context, listen: false)
                            .pauseOrResumeGame(),
                  ),
                )
              ],
            ),
          ),
        ),
        body: const Snake(),
      ),
    );
  }
}
