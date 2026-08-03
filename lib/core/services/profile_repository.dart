import 'package:drift/drift.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/models/player_profile.dart';
import 'package:snake_app/core/offline_db/app_database.dart';

class ProfileRepository {
  ProfileRepository(this._database);

  final AppDatabase _database;

  Future<PlayerProfile?> getProfile() async {
    final row = await (_database.select(_database.profiles)..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return _mapProfile(row);
  }

  Future<PlayerProgress?> getProgress(int profileId) async {
    final row = await (_database.select(_database.progressEntries)
          ..where((table) => table.profileId.equals(profileId)))
        .getSingleOrNull();
    if (row == null) return null;
    return _mapProgress(row);
  }

  Future<PlayerProfile> createOrUpdate({
    required String username,
    required String fullName,
    String? email,
    String? phone,
  }) async {
    final now = DateTime.now();
    final trimmedEmail =
        email?.trim().isEmpty == true ? null : email?.trim();
    final trimmedPhone =
        phone?.trim().isEmpty == true ? null : phone?.trim();
    final existing = await getProfile();

    if (existing == null) {
      final profileId = await _database.into(_database.profiles).insert(
            ProfilesCompanion.insert(
              username: username.trim(),
              fullName: fullName.trim(),
              email: Value(trimmedEmail),
              phone: Value(trimmedPhone),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _database.into(_database.progressEntries).insert(
            ProgressEntriesCompanion.insert(
              profileId: Value(profileId),
            ),
          );
      return (await getProfile())!;
    }

    await (_database.update(_database.profiles)
          ..where((table) => table.id.equals(existing.id)))
        .write(
      ProfilesCompanion(
        username: Value(username.trim()),
        fullName: Value(fullName.trim()),
        email: Value(trimmedEmail),
        phone: Value(trimmedPhone),
        updatedAt: Value(now),
      ),
    );
    return (await getProfile())!;
  }

  /// Persist score/unlocks only when a profile exists.
  Future<ScoreSubmitResult> submitRun({
    required int level,
    required int score,
    required int bestCombo,
  }) async {
    final profile = await getProfile();
    if (profile == null) {
      return const ScoreSubmitResult(
        saved: false,
        isNewBest: false,
        unlockedNext: false,
        highestUnlocked: 1,
      );
    }

    final progress =
        await getProgress(profile.id) ?? PlayerProgress.empty(profile.id);

    final existingBest = await bestForLevel(level);
    final isNewBest = score > (existingBest ?? 0);

    if (isNewBest) {
      final existingRow = await (_database.select(_database.highScores)
            ..where(
              (table) =>
                  table.profileId.equals(profile.id) &
                  table.level.equals(level),
            ))
          .getSingleOrNull();
      if (existingRow == null) {
        await _database.into(_database.highScores).insert(
              HighScoresCompanion.insert(
                profileId: profile.id,
                level: level,
                score: score,
                achievedAt: DateTime.now(),
              ),
            );
      } else {
        await (_database.update(_database.highScores)
              ..where((table) => table.id.equals(existingRow.id)))
            .write(
          HighScoresCompanion(
            score: Value(score),
            achievedAt: Value(DateTime.now()),
          ),
        );
      }
    }

    var highestLevelUnlocked = progress.highestLevelUnlocked;
    var unlockedNext = false;
    if (LevelsCatalog.canUnlockNext(
      completedLevel: level,
      scoreOnLevel: score,
      highestUnlocked: highestLevelUnlocked,
    )) {
      highestLevelUnlocked = (level + 1).clamp(1, AppConstants.totalLevels);
      unlockedNext = true;
    }

    final updatedProgress = PlayerProgress(
      profileId: profile.id,
      highestLevelUnlocked: highestLevelUnlocked,
      gamesPlayed: progress.gamesPlayed + 1,
      bestOverallScore: score > progress.bestOverallScore
          ? score
          : progress.bestOverallScore,
      bestCombo:
          bestCombo > progress.bestCombo ? bestCombo : progress.bestCombo,
    );

    await _database.into(_database.progressEntries).insertOnConflictUpdate(
          ProgressEntriesCompanion(
            profileId: Value(updatedProgress.profileId),
            highestLevelUnlocked: Value(updatedProgress.highestLevelUnlocked),
            gamesPlayed: Value(updatedProgress.gamesPlayed),
            bestOverallScore: Value(updatedProgress.bestOverallScore),
            bestCombo: Value(updatedProgress.bestCombo),
          ),
        );

    return ScoreSubmitResult(
      saved: true,
      isNewBest: isNewBest,
      unlockedNext: unlockedNext,
      highestUnlocked: highestLevelUnlocked,
    );
  }

  Future<List<HighScoreRecord>> allHighScores() async {
    final profile = await getProfile();
    if (profile == null) return const [];
    final rows = await (_database.select(_database.highScores)
          ..where((table) => table.profileId.equals(profile.id))
          ..orderBy([(table) => OrderingTerm.asc(table.level)]))
        .get();
    return rows.map(_mapHighScore).toList();
  }

  Future<int?> bestForLevel(int level) async {
    final profile = await getProfile();
    if (profile == null) return null;
    final row = await (_database.select(_database.highScores)
          ..where(
            (table) =>
                table.profileId.equals(profile.id) &
                table.level.equals(level),
          )
          ..limit(1))
        .getSingleOrNull();
    return row?.score;
  }

  PlayerProfile _mapProfile(ProfileRow row) {
    return PlayerProfile(
      id: row.id,
      username: row.username,
      fullName: row.fullName,
      email: row.email,
      phone: row.phone,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  PlayerProgress _mapProgress(ProgressRow row) {
    return PlayerProgress(
      profileId: row.profileId,
      highestLevelUnlocked: row.highestLevelUnlocked,
      gamesPlayed: row.gamesPlayed,
      bestOverallScore: row.bestOverallScore,
      bestCombo: row.bestCombo,
    );
  }

  HighScoreRecord _mapHighScore(HighScoreRow row) {
    return HighScoreRecord(
      id: row.id,
      profileId: row.profileId,
      level: row.level,
      score: row.score,
      achievedAt: row.achievedAt,
    );
  }
}

class ScoreSubmitResult {
  const ScoreSubmitResult({
    required this.saved,
    required this.isNewBest,
    required this.unlockedNext,
    required this.highestUnlocked,
  });

  final bool saved;
  final bool isNewBest;
  final bool unlockedNext;
  final int highestUnlocked;
}
