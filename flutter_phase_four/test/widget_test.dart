import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_phase_four/main.dart';

void main() {
  testWidgets('Object Argument Route Flow Verification', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RecipeApp());

    // Check baseline text renders
    expect(find.text('My Grandma\'s Cookbook'), findsOneWidget);
    expect(find.text('Spaghetti Carbonara'), findsOneWidget);

    // Trigger user navigation simulation click
    await tester.tap(find.text('Spaghetti Carbonara'));
    await tester.pumpAndSettle();

    // Verify detail screen components mapped from object parameters exist cleanly
    expect(
      find.text('⏱️ Cooking Time: 25 mins'),
      findsNothing,
    ); // Subtitle shouldn't be here
    expect(
      find.text('• 200g Spaghetti'),
      findsOneWidget,
    ); // Ingredient successfully caught
    expect(
      find.text('Boil pasta in salted water.'),
      findsOneWidget,
    ); // Step successfully caught
  });
}
