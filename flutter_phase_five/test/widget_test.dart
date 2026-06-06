import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phase_five/main.dart';

void main() {
  testWidgets('Global Provider State Operations Test', (
    WidgetTester tester,
  ) async {
    // Render the layout wrapped inside a fresh state provider container
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => CartProvider(),
        child: const ECommerceApp(),
      ),
    );

    // Baseline catalog check
    expect(find.text('Gadget Store'), findsOneWidget);
    expect(find.text('0'), findsNothing); // Badge shouldn't exist initially

    // Tap to add an item globally
    await tester.tap(find.text('Add to Cart').first);
    await tester.pump(); // Request frame re-paint cycle

    // Verify badge updates instantly via global notified listeners
    expect(find.text('1'), findsOneWidget);
  });
}
