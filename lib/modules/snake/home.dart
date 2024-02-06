import 'package:flutter/material.dart';
import 'package:snake_game/modules/snake/components/app_actions.dart';
import 'package:snake_game/modules/snake/snake.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
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
