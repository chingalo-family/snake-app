/// Bundled audio filenames under [directory].
///
/// Drop matching files into `assets/audio/` (already listed in `pubspec.yaml`).
/// [AudioService] probes these at runtime and falls back to system sounds for
/// SFX when files are absent. BGM stays silent until [bgmBundlePath] exists.
class AudioAssets {
  AudioAssets._();

  static const directory = 'assets/audio';

  /// Full bundle paths for [rootBundle.load] / asset probing.
  static const bgmBundlePath = 'assets/audio/bgm.mp3';
  static const sfxEatBundlePath = 'assets/audio/sfx_eat.mp3';
  static const sfxEatHighBundlePath = 'assets/audio/sfx_eat_high.mp3';
  static const sfxCollisionBundlePath = 'assets/audio/sfx_collision.mp3';
  static const sfxUiBundlePath = 'assets/audio/sfx_ui.mp3';

  /// Paths for `audioplayers` [AssetSource] (relative to the assets root).
  static const bgm = 'audio/bgm.mp3';
  static const sfxEat = 'audio/sfx_eat.mp3';
  static const sfxEatHigh = 'audio/sfx_eat_high.mp3';
  static const sfxCollision = 'audio/sfx_collision.mp3';
  static const sfxUi = 'audio/sfx_ui.mp3';

  static const expectedBundlePaths = <String>[
    bgmBundlePath,
    sfxEatBundlePath,
    sfxEatHighBundlePath,
    sfxCollisionBundlePath,
    sfxUiBundlePath,
  ];
}
