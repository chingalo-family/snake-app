import 'package:snake_app/core/services/preference_service.dart';

class ChallengeProgressStore {
  ChallengeProgressStore(this._preferenceStore);

  final PreferenceStore _preferenceStore;

  Map<String, int> bestsFor(int profileId) {
    final raw = _preferenceStore.getString(_bestKey(profileId));
    if (raw == null || raw.isEmpty) return {};
    final bests = <String, int>{};
    for (final part in raw.split('|')) {
      final bits = part.split('=');
      if (bits.length != 2) continue;
      final score = int.tryParse(bits[1]);
      if (score == null) continue;
      bests[bits[0]] = score;
    }
    return bests;
  }

  String? ghostFor({
    required int profileId,
    required String challengeId,
  }) {
    return _preferenceStore.getString(_ghostKey(profileId, challengeId));
  }

  Future<bool> saveBest({
    required int profileId,
    required String challengeId,
    required int score,
    String? ghostTrace,
  }) async {
    final bests = bestsFor(profileId);
    final previous = bests[challengeId] ?? 0;
    if (score <= previous) return false;
    bests[challengeId] = score;
    final encoded = bests.entries.map((entry) => '${entry.key}=${entry.value}').join('|');
    await _preferenceStore.setString(_bestKey(profileId), encoded);
    if (ghostTrace != null && ghostTrace.isNotEmpty) {
      final trimmed = ghostTrace.length > 4000
          ? ghostTrace.substring(ghostTrace.length - 4000)
          : ghostTrace;
      await _preferenceStore.setString(
        _ghostKey(profileId, challengeId),
        trimmed,
      );
    }
    return true;
  }

  String _bestKey(int profileId) => 'challenge_bests_$profileId';

  String _ghostKey(int profileId, String challengeId) =>
      'challenge_ghost_${profileId}_$challengeId';
}
