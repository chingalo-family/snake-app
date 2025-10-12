import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/snake/snake_page.dart';

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
        title: 'Snake App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppInfoReference.defaultAppColor,
          ),
        ),
        home: const SnakePage(),
      ),
    );
  }
}
