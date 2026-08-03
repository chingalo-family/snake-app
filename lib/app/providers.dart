import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_app/core/models/player_profile.dart';
import 'package:snake_app/core/offline_db/app_database.dart';
import 'package:snake_app/core/services/audio_service.dart';
import 'package:snake_app/core/services/haptic_service.dart';
import 'package:snake_app/core/services/preference_service.dart';
import 'package:snake_app/core/services/profile_repository.dart';
import 'package:snake_app/core/services/settings_service.dart';
import 'package:snake_app/core/services/update_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden at bootstrap');
});

final preferenceServiceProvider = Provider<PreferenceService>((ref) {
  return PreferenceService(ref.watch(sharedPreferencesProvider));
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref.watch(preferenceServiceProvider));
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(appDatabaseProvider));
});

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

final hapticServiceProvider = Provider<HapticService>((ref) {
  return HapticService();
});

final updateServiceProvider = Provider<UpdateService>((ref) {
  return UpdateService();
});

class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._service, this._audio, this._haptics)
      : super(_service.load()) {
    _applySideEffects();
  }

  final SettingsService _service;
  final AudioService _audio;
  final HapticService _haptics;

  Future<void> _persist() async {
    await _service.save(state);
    _applySideEffects();
  }

  void _applySideEffects() {
    _haptics.enabled = state.hapticsEnabled;
    _audio.applySettings(
      sfxEnabled: state.sfxEnabled,
      bgmEnabled: state.bgmEnabled,
    );
  }

  Future<void> setSfx(bool value) async {
    state = state.copyWith(sfxEnabled: value);
    await _persist();
  }

  Future<void> setBgm(bool value) async {
    state = state.copyWith(bgmEnabled: value);
    await _persist();
  }

  Future<void> setHaptics(bool value) async {
    state = state.copyWith(hapticsEnabled: value);
    await _persist();
  }

  Future<void> setControlHints(bool value) async {
    state = state.copyWith(showControlHints: value);
    await _persist();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _persist();
  }

  Future<void> setLocaleCode(String localeCode) async {
    state = state.copyWith(localeCode: localeCode);
    await _persist();
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingCompleted: true);
    await _persist();
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettings>((ref) {
  return SettingsController(
    ref.watch(settingsServiceProvider),
    ref.watch(audioServiceProvider),
    ref.watch(hapticServiceProvider),
  );
});

class ProfileState {
  const ProfileState({
    this.profile,
    this.progress,
    this.loading = true,
  });

  final PlayerProfile? profile;
  final PlayerProgress? progress;
  final bool loading;

  bool get hasProfile => profile != null;

  int get highestLevelUnlocked => progress?.highestLevelUnlocked ?? 1;
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(this._profileRepository) : super(const ProfileState()) {
    refresh();
  }

  final ProfileRepository _profileRepository;

  Future<void> refresh() async {
    state = const ProfileState(loading: true);
    final profile = await _profileRepository.getProfile();
    final progress = profile == null
        ? null
        : await _profileRepository.getProgress(profile.id);
    state = ProfileState(
      profile: profile,
      progress: progress,
      loading: false,
    );
  }

  Future<PlayerProfile> saveProfile({
    required String username,
    required String fullName,
    String? email,
    String? phone,
  }) async {
    final savedProfile = await _profileRepository.createOrUpdate(
      username: username,
      fullName: fullName,
      email: email,
      phone: phone,
    );
    await refresh();
    return savedProfile;
  }

  Future<ScoreSubmitResult> submitRun({
    required int level,
    required int score,
    required int bestCombo,
  }) async {
    final result = await _profileRepository.submitRun(
      level: level,
      score: score,
      bestCombo: bestCombo,
    );
    if (result.saved) await refresh();
    return result;
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController(ref.watch(profileRepositoryProvider));
});
