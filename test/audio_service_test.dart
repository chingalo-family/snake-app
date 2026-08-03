import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_app/core/constants/audio_assets.dart';
import 'package:snake_app/core/services/audio_service.dart';

class _RecordingAssetBundle extends CachingAssetBundle {
  _RecordingAssetBundle(this.presentPaths);

  final Set<String> presentPaths;

  @override
  Future<ByteData> load(String key) async {
    if (!presentPaths.contains(key)) {
      throw FlutterError('Unable to load asset: $key');
    }
    return ByteData(0);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('audio asset paths match the documented drop-in filenames', () {
    expect(AudioAssets.bgmBundlePath, 'assets/audio/bgm.mp3');
    expect(AudioAssets.sfxEatBundlePath, 'assets/audio/sfx_eat.mp3');
    expect(AudioAssets.sfxEatHighBundlePath, 'assets/audio/sfx_eat_high.mp3');
    expect(AudioAssets.sfxCollisionBundlePath, 'assets/audio/sfx_collision.mp3');
    expect(AudioAssets.sfxUiBundlePath, 'assets/audio/sfx_ui.mp3');
    expect(AudioAssets.bgm, 'audio/bgm.mp3');
    expect(AudioAssets.expectedBundlePaths, hasLength(5));
  });

  test('probes report missing BGM when no audio files are bundled', () async {
    final audio = AudioService(
      assetBundle: _RecordingAssetBundle({}),
      bgmPlayer: FakeGameAudioPlayer(),
      sfxPlayer: FakeGameAudioPlayer(),
    );
    addTearDown(audio.dispose);

    await audio.probeAssetsForTest();
    expect(audio.hasBundledBgm, isFalse);
    expect(audio.hasBundledEatSfx, isFalse);
  });

  test('probes detect bundled BGM when the asset path loads', () async {
    final audio = AudioService(
      assetBundle: _RecordingAssetBundle({AudioAssets.bgmBundlePath}),
      bgmPlayer: FakeGameAudioPlayer(),
      sfxPlayer: FakeGameAudioPlayer(),
    );
    addTearDown(audio.dispose);

    await audio.probeAssetsForTest();
    expect(audio.hasBundledBgm, isTrue);
  });

  test('BGM stays off by default until settings enable it', () async {
    final bgmPlayer = FakeGameAudioPlayer();
    final audio = AudioService(
      assetBundle: _RecordingAssetBundle({AudioAssets.bgmBundlePath}),
      bgmPlayer: bgmPlayer,
      sfxPlayer: FakeGameAudioPlayer(),
    );
    addTearDown(audio.dispose);

    expect(audio.isBgmEnabled, isFalse);
    await audio.startBgm();
    expect(audio.isBgmStarted, isTrue);
    expect(bgmPlayer.playCount, 0);
  });

  test('settings mute SFX and keep BGM start intent when music is re-enabled',
      () async {
    final bgmPlayer = FakeGameAudioPlayer();
    final audio = AudioService(
      assetBundle: _RecordingAssetBundle({AudioAssets.bgmBundlePath}),
      bgmPlayer: bgmPlayer,
      sfxPlayer: FakeGameAudioPlayer(),
    );
    addTearDown(audio.dispose);

    await audio.applySettings(sfxEnabled: true, bgmEnabled: true);
    await audio.startBgm();
    expect(audio.isBgmStarted, isTrue);
    expect(bgmPlayer.playCount, 1);

    await audio.applySettings(sfxEnabled: false, bgmEnabled: false);
    expect(audio.isSfxEnabled, isFalse);
    expect(audio.isBgmEnabled, isFalse);
    expect(audio.isBgmStarted, isTrue);
    expect(bgmPlayer.stopCount, 1);

    await audio.applySettings(sfxEnabled: true, bgmEnabled: true);
    expect(audio.isSfxEnabled, isTrue);
    expect(audio.isBgmEnabled, isTrue);
    expect(bgmPlayer.playCount, 2);
  });
}
