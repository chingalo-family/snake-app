part of 'app_database.dart';

int get offlineDatabaseSchemaVersion => _offlineDatabaseMigrations.length + 1;

MigrationStrategy buildOfflineDatabaseMigrationStrategy(AppDatabase database) {
  return MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      await runOfflineDatabaseMigrations(
        migrator: migrator,
        database: database,
        from: from,
        to: to,
      );
    },
  );
}

Future<void> runOfflineDatabaseMigrations({
  required Migrator migrator,
  required AppDatabase database,
  required int from,
  required int to,
}) async {
  for (var migrationIndex = 0;
      migrationIndex < _offlineDatabaseMigrations.length;
      migrationIndex++) {
    final targetVersion = migrationIndex + 2;
    if (from < targetVersion && to >= targetVersion) {
      await _offlineDatabaseMigrations[migrationIndex](migrator, database);
    }
  }
}

typedef _OfflineDatabaseMigration = Future<void> Function(
  Migrator migrator,
  AppDatabase database,
);

final List<_OfflineDatabaseMigration> _offlineDatabaseMigrations = [
  (migrator, database) async {
    await migrator.addColumn(database.profiles, database.profiles.avatarId);
  },
];
