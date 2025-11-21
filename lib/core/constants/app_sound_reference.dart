class AppSoundReference {
  static const String assetsPath = 'assets/sounds/';
  static const String backgroundMusic = 'sounds/background_music.mp3';

  static List<String> getCachedSounds() => [backgroundMusic.split('/').last];
}
