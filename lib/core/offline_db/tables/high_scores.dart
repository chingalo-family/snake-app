import 'package:drift/drift.dart';

@DataClassName('HighScoreRow')
class HighScores extends Table {
  @override
  String get tableName => 'high_scores';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().named('profile_id')();
  IntColumn get level => integer()();
  IntColumn get score => integer()();
  DateTimeColumn get achievedAt => dateTime().named('achieved_at')();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {profileId, level},
      ];
}
