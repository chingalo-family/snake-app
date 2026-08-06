import 'package:drift/drift.dart';

@DataClassName('ProfileRow')
class Profiles extends Table {
  @override
  String get tableName => 'profile';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  TextColumn get fullName => text().named('full_name')();
  TextColumn get avatarId =>
      text().named('avatar_id').withDefault(const Constant('snake'))();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
}
