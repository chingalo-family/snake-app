import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/game/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const AppGame()));
}

class AppGame extends StatelessWidget {
  const AppGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SnakeState())],
      child: MaterialApp(
        title: AppInfoReference.appName,
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppInfoReference.defaultAppColor,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const Game(),
      ),
    );
  }
}
