import 'package:drift/drift.dart';

@DataClassName('ProgressRow')
class ProgressEntries extends Table {
  @override
  String get tableName => 'progress';

  IntColumn get profileId => integer().named('profile_id')();
  IntColumn get highestLevelUnlocked =>
      integer().named('highest_level_unlocked').withDefault(const Constant(1))();
  IntColumn get gamesPlayed =>
      integer().named('games_played').withDefault(const Constant(0))();
  IntColumn get bestOverallScore =>
      integer().named('best_overall_score').withDefault(const Constant(0))();
  IntColumn get bestCombo =>
      integer().named('best_combo').withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}
