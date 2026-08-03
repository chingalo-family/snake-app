import 'package:drift/drift.dart';
import 'package:snake_app/core/offline_db/connection/connection.dart';
import 'package:snake_app/core/offline_db/database_path.dart';
import 'package:snake_app/core/offline_db/tables/high_scores.dart';
import 'package:snake_app/core/offline_db/tables/profiles.dart';
import 'package:snake_app/core/offline_db/tables/progress_entries.dart';

part 'app_database.g.dart';
part 'offline_database_migrations.dart';

@DriftDatabase(
  tables: [
    Profiles,
    ProgressEntries,
    HighScores,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  /// In-memory or custom executor for unit tests.
  AppDatabase.forTesting(super.e);

  static AppDatabase? _instance;

  static AppDatabase get instance =>
      _instance ??= AppDatabase._(openOfflineDatabaseConnection());

  /// Resets the singleton (tests only).
  static void resetInstanceForTesting() {
    _instance = null;
  }

  static const String databaseFileName = offlineDatabaseFileName;

  @override
  int get schemaVersion => offlineDatabaseSchemaVersion;

  @override
  MigrationStrategy get migration =>
      buildOfflineDatabaseMigrationStrategy(this);

  Future<void> closeAndResetInstance() async {
    await close();
    if (identical(_instance, this)) {
      _instance = null;
    }
  }
}
