import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:snake_app/core/constants/audio_assets.dart';

/// Minimal player surface so unit tests avoid platform channels.
abstract class GameAudioPlayer {
  PlayerState get state;

  Future<void> setReleaseMode(ReleaseMode mode);

  Future<void> setVolume(double volume);

  Future<void> play(Source source);

  Future<void> stop();

  Future<void> pause();

  Future<void> resume();

  Future<void> dispose();
}

class AudioplayersGameAudioPlayer implements GameAudioPlayer {
  AudioplayersGameAudioPlayer([AudioPlayer? player])
      : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  PlayerState get state => _player.state;

  @override
  Future<void> setReleaseMode(ReleaseMode mode) =>
      _player.setReleaseMode(mode);

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  @override
  Future<void> play(Source source) => _player.play(source);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> resume() => _player.resume();

  @override
  Future<void> dispose() => _player.dispose();
}

@visibleForTesting
class FakeGameAudioPlayer implements GameAudioPlayer {
  PlayerState _state = PlayerState.stopped;
  int playCount = 0;
  int stopCount = 0;
  int pauseCount = 0;
  int resumeCount = 0;

  @override
  PlayerState get state => _state;

  @override
  Future<void> setReleaseMode(ReleaseMode mode) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> play(Source source) async {
    playCount++;
    _state = PlayerState.playing;
  }

  @override
  Future<void> stop() async {
    stopCount++;
    _state = PlayerState.stopped;
  }

  @override
  Future<void> pause() async {
    pauseCount++;
    _state = PlayerState.paused;
  }

  @override
  Future<void> resume() async {
    resumeCount++;
    _state = PlayerState.playing;
  }

  @override
  Future<void> dispose() async {
    _state = PlayerState.disposed;
  }
}

/// Separate SFX and BGM channels.
///
/// SFX prefers bundled clips under `assets/audio/`, then falls back to
/// [SystemSound]. BGM loops [AudioAssets.bgm] when present; otherwise stays
/// silent (no placeholder tone).
class AudioService {
  AudioService({
    AssetBundle? assetBundle,
    GameAudioPlayer? bgmPlayer,
    GameAudioPlayer? sfxPlayer,
  })  : _assetBundle = assetBundle ?? rootBundle,
        _bgmPlayer = bgmPlayer ?? AudioplayersGameAudioPlayer(),
        _sfxPlayer = sfxPlayer ?? AudioplayersGameAudioPlayer();

  final AssetBundle _assetBundle;
  final GameAudioPlayer _bgmPlayer;
  final GameAudioPlayer _sfxPlayer;

  bool _sfxEnabled = true;
  bool _bgmEnabled = false;
  bool _bgmStarted = false;
  bool _assetsProbed = false;
  bool _hasBgmAsset = false;
  bool _hasEatAsset = false;
  bool _hasEatHighAsset = false;
  bool _hasCollisionAsset = false;
  bool _hasUiAsset = false;

  @visibleForTesting
  bool get hasBundledBgm => _hasBgmAsset;

  @visibleForTesting
  bool get hasBundledEatSfx => _hasEatAsset;

  @visibleForTesting
  bool get isSfxEnabled => _sfxEnabled;

  @visibleForTesting
  bool get isBgmEnabled => _bgmEnabled;

  @visibleForTesting
  bool get isBgmStarted => _bgmStarted;

  Future<void> applySettings({
    required bool sfxEnabled,
    required bool bgmEnabled,
  }) async {
    _sfxEnabled = sfxEnabled;
    final wasBgmEnabled = _bgmEnabled;
    _bgmEnabled = bgmEnabled;
    if (!_bgmEnabled) {
      await _bgmPlayer.stop();
      return;
    }
    if (!_bgmStarted) return;
    if (!wasBgmEnabled) {
      await _playBundledBgm();
    } else {
      await _bgmPlayer.resume();
    }
  }

  Future<void> playSfx({bool isHighValue = false}) async {
    if (!_sfxEnabled) return;
    await _probeAssetsIfNeeded();
    final preferredSource = isHighValue && _hasEatHighAsset
        ? AudioAssets.sfxEatHigh
        : (_hasEatAsset ? AudioAssets.sfxEat : null);
    if (preferredSource != null) {
      final played = await _tryPlaySfx(preferredSource);
      if (played) return;
    }
    await SystemSound.play(SystemSoundType.click);
  }

  Future<void> playCollision() async {
    if (!_sfxEnabled) return;
    await _probeAssetsIfNeeded();
    if (_hasCollisionAsset) {
      final played = await _tryPlaySfx(AudioAssets.sfxCollision);
      if (played) return;
    }
    await SystemSound.play(SystemSoundType.alert);
  }

  Future<void> playUiTap() async {
    if (!_sfxEnabled) return;
    await _probeAssetsIfNeeded();
    if (_hasUiAsset) {
      final played = await _tryPlaySfx(AudioAssets.sfxUi);
      if (played) return;
    }
    await SystemSound.play(SystemSoundType.click);
  }

  /// Starts (or restarts) looping BGM when the bundled track is available.
  Future<void> startBgm() async {
    _bgmStarted = true;
    await _probeAssetsIfNeeded();
    if (!_bgmEnabled) return;
    await _playBundledBgm();
  }

  Future<void> pauseBgm() async {
    if (_bgmPlayer.state == PlayerState.playing) {
      await _bgmPlayer.pause();
    }
  }

  Future<void> resumeBgm() async {
    if (_bgmEnabled && _bgmStarted && _hasBgmAsset) {
      await _bgmPlayer.resume();
    }
  }

  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
  }

  Future<void> _playBundledBgm() async {
    if (!_hasBgmAsset) return;
    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(0.45);
      await _bgmPlayer.play(AssetSource(AudioAssets.bgm));
    } catch (error, stackTrace) {
      debugPrint('BGM play failed: $error\n$stackTrace');
    }
  }

  Future<bool> _tryPlaySfx(String assetSource) async {
    try {
      await _sfxPlayer.play(AssetSource(assetSource));
      return true;
    } catch (error, stackTrace) {
      debugPrint('SFX play failed ($assetSource): $error\n$stackTrace');
      return false;
    }
  }

  Future<void> _probeAssetsIfNeeded() async {
    if (_assetsProbed) return;
    _assetsProbed = true;
    _hasBgmAsset = await _assetExists(AudioAssets.bgmBundlePath);
    _hasEatAsset = await _assetExists(AudioAssets.sfxEatBundlePath);
    _hasEatHighAsset = await _assetExists(AudioAssets.sfxEatHighBundlePath);
    _hasCollisionAsset = await _assetExists(AudioAssets.sfxCollisionBundlePath);
    _hasUiAsset = await _assetExists(AudioAssets.sfxUiBundlePath);
  }

  Future<bool> _assetExists(String bundlePath) async {
    try {
      await _assetBundle.load(bundlePath);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Re-probe assets (tests / hot-added files in debug).
  @visibleForTesting
  Future<void> probeAssetsForTest() async {
    _assetsProbed = false;
    await _probeAssetsIfNeeded();
  }
}
