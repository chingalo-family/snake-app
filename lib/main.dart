import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/core/app_state/snake_state.dart';
import 'package:snake_game/core/constants/app_info_reference.dart';
import 'package:snake_game/modules/home.dart';

void main() {
  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SnakeState(),
        )
      ],
      child: MaterialApp(
        title: 'Snake Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppInfoReference.defaultAppColor,
          ),
          useMaterial3: true,
        ),
        home: const Home(),
      ),
    );
  }
}
