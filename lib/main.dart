import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/core/app_state/snake_state.dart';
import 'package:snake_game/core/constants/app_info_reference.dart';
import 'package:snake_game/modules/snake/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const SnakeGame()));
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
        ),
        home: const Home(),
      ),
    );
  }
}
