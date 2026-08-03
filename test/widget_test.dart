import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_app/app/app.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/offline_db/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SnakeApp boots to splash branding', (tester) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final testDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(testDatabase.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          appDatabaseProvider.overrideWithValue(testDatabase),
        ],
        child: const SnakeApp(),
      ),
    );
    await tester.pump();
    expect(find.text('Snake App'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();
  });
}
