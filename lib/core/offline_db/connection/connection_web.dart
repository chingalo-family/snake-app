import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

LazyDatabase openOfflineDatabaseConnection() {
  return LazyDatabase(() async {
    // ignore: deprecated_member_use
    return WebDatabase('snake_app');
  });
}
