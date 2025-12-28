import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/app_update_state/app_update_state.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/app_sound_reference.dart';
import 'package:snake_app/core/services/game_settings_service.dart';
import 'package:snake_app/core/services/game_sound_service.dart';
import 'package:snake_app/modules/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cache = AudioCache(prefix: AppSoundReference.assetsPath);
  await cache.loadAll(AppSoundReference.getCachedSounds());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const AppGame()));
}

class AppGame extends StatefulWidget {
  const AppGame({super.key});

  @override
  State<AppGame> createState() => _AppGameState();
}

class _AppGameState extends State<AppGame> with WidgetsBindingObserver {
  final soundManger = GameSoundService.instance;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeSound();
  }

  Future<void> _initializeSound() async {
    final soundEnabled = await GameSettingsService.getSoundEffectsEnabled();
    if (soundEnabled) {
      soundManger.playBackgroundMusic();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final soundEnabled = await GameSettingsService.getSoundEffectsEnabled();
    if (!soundEnabled) return;
    
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      soundManger.pauseAll();
    }
    if (state == AppLifecycleState.resumed) {
      soundManger.resumeAll();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    soundManger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SnakeState()),
        ChangeNotifierProvider(create: (_) => GameScoreState()),
        ChangeNotifierProvider(create: (_) => UserEntryFormState()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => AppUpdateState()),
      ],
      child: MaterialApp(
        title: AppInfoReference.appName,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppInfoReference.defaultAppColor,
          ),
          scaffoldBackgroundColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: const Splash(),
      ),
    );
  }
}
