import 'package:audioplayers/audioplayers.dart';
import 'package:snake_app/core/constants/app_sound_reference.dart';

class GameSoundService {
  static final GameSoundService instance = GameSoundService._internal();
  GameSoundService._internal();

  final _bgPlayer = AudioPlayer();
  bool isPaused = false;

  Future<void> playBackgroundMusic() async {
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.play(
      AssetSource(AppSoundReference.backgroundMusic),
      volume: 0.15,
    );
  }

  Future<void> pauseAll() async {
    isPaused = true;
    await _bgPlayer.pause();
  }

  Future<void> resumeAll() async {
    if (isPaused) {
      isPaused = false;
      await _bgPlayer.resume();
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _bgPlayer.stop();
    isPaused = false;
  }

  void dispose() {
    _bgPlayer.dispose();
  }
}
