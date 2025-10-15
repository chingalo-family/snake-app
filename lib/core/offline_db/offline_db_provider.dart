import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDbProvider {
  Database? _db;

  final String databaseName = 'snake_app';
  // Script for migrations as well as intialization of tables
  final List<String> initialQuery = [
    'CREATE TABLE IF NOT EXISTS user (id TEXT PRIMARY KEY, username TEXT, fullName TEXT, password TEXT, email TEXT, phoneNumber TEXT,userOrgUnitIds TEXT,gender TEXT, isLogin TEXT)',
    'CREATE TABLE IF NOT EXISTS dhis_event (id TEXT PRIMARY KEY,event TEXT,occurredAt TEXT,status TEXT,program TEXT,programStage TEXT,enrollment TEXT,trackedEntity TEXT,orgUnit TEXT,completedAt TEXT,completedBy TEXT,scheduledAt TEXT,syncStatus TEXT)',
    'CREATE TABLE IF NOT EXISTS dhis_data_value (id TEXT PRIMARY KEY,event TEXT,dataElement TEXT,value TEXT)',
  ];

  final List<String> migrationQuery = [];

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await init();
    return _db;
  }

  init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$databaseName.db');
    return await openDatabase(
      path,
      version: migrationQuery.length + 1,
      onUpgrade: onUpgrade,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
    );
  }

  onOpen(Database db) {}

  onDowngrade(Database db, int oldVersion, int newVersion) {}

  onConfigure(Database db) {}

  onCreate(Database db, int version) async {
    List queries = [...initialQuery, ...migrationQuery];
    for (String query in queries) {
      try {
        await db.execute(query);
      } catch (error) {
        //
      }
    }
  }

  onUpgrade(Database db, int oldVersion, int version) async {
    for (String query in migrationQuery) {
      try {
        await db.execute(query);
      } catch (error) {
        //
      }
    }
  }

  close() async {
    try {
      var dbClient = await db;
      dbClient!.close();
    } catch (e) {
      //
    }
  }
}
