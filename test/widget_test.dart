import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardscan_app/main.dart';

void main() {
  testWidgets('App smoke test - verifies title is displayed', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the title of the home page is displayed.
    expect(find.text('Visiting Card Scanner'), findsOneWidget);
  });
}
