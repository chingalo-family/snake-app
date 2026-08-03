import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/offline_db/app_database.dart';
import 'package:snake_app/core/services/profile_repository.dart';

void main() {
  late AppDatabase database;
  late ProfileRepository profileRepository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    profileRepository = ProfileRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('submit without profile does not persist bests', () async {
    final result = await profileRepository.submitRun(
      level: 1,
      score: 500,
      bestCombo: 3,
    );
    expect(result.saved, isFalse);
    expect(await profileRepository.allHighScores(), isEmpty);
  });

  test('submit with profile upserts best and unlocks', () async {
    await profileRepository.createOrUpdate(
      username: 'maya',
      fullName: 'Maya Chingalo',
    );

    final lowScoreResult = await profileRepository.submitRun(
      level: 1,
      score: 50,
      bestCombo: 1,
    );
    expect(lowScoreResult.saved, isTrue);
    expect(lowScoreResult.isNewBest, isTrue);
    expect(lowScoreResult.unlockedNext, isFalse);

    final unlockScore = LevelsCatalog.byLevel(1).unlockScore;
    final unlockResult = await profileRepository.submitRun(
      level: 1,
      score: unlockScore,
      bestCombo: 4,
    );
    expect(unlockResult.saved, isTrue);
    expect(unlockResult.isNewBest, isTrue);
    expect(unlockResult.unlockedNext, isTrue);
    expect(unlockResult.highestUnlocked, 2);

    final lowerAgainResult = await profileRepository.submitRun(
      level: 1,
      score: 60,
      bestCombo: 1,
    );
    expect(lowerAgainResult.isNewBest, isFalse);
    expect(await profileRepository.bestForLevel(1), unlockScore);
  });
}
