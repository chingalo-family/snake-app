import 'package:flutter_test/flutter_test.dart';
import 'package:snake_app/main.dart';

void main() {
  testWidgets('Landing shows Snake App brand', (WidgetTester tester) async {
    await tester.pumpWidget(const SnakeApp());

    expect(find.text('Snake App'), findsOneWidget);
    expect(find.textContaining('coming soon'), findsOneWidget);
  });
}
