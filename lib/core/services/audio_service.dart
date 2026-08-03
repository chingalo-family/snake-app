import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Separate SFX and BGM channels. Uses system click as SFX fallback when
/// bundled audio assets are unavailable.
class AudioService {
  AudioService();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  bool _sfxEnabled = true;
  bool _bgmEnabled = true;
  bool _bgmStarted = false;

  Future<void> applySettings({
    required bool sfxEnabled,
    required bool bgmEnabled,
  }) async {
    _sfxEnabled = sfxEnabled;
    _bgmEnabled = bgmEnabled;
    if (!_bgmEnabled) {
      await _bgmPlayer.stop();
      _bgmStarted = false;
    } else if (_bgmStarted) {
      await _bgmPlayer.resume();
    }
  }

  Future<void> playSfx({bool isHighValue = false}) async {
    if (!_sfxEnabled) return;
    await SystemSound.play(SystemSoundType.click);
  }

  Future<void> playCollision() async {
    if (!_sfxEnabled) return;
    await SystemSound.play(SystemSoundType.alert);
  }

  Future<void> playUiTap() async {
    if (!_sfxEnabled) return;
    await SystemSound.play(SystemSoundType.click);
  }

  /// Soft looping placeholder — no-ops until a BGM asset is shipped.
  Future<void> startBgm() async {
    _bgmStarted = true;
    if (!_bgmEnabled) return;
    // Asset path reserved for future: assets/audio/bgm.mp3
  }

  Future<void> pauseBgm() async {
    if (_bgmPlayer.state == PlayerState.playing) {
      await _bgmPlayer.pause();
    }
  }

  Future<void> resumeBgm() async {
    if (_bgmEnabled && _bgmStarted) {
      await _bgmPlayer.resume();
    }
  }

  Future<void> dispose() async {
    await _bgmPlayer.dispose();
  }
}
