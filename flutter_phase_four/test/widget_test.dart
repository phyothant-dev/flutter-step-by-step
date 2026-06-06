import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_phase_four/main.dart'; // Matches your day 4 folder configuration

void main() {
  testWidgets('Recipe Navigation Flow Test', (WidgetTester tester) async {
    // 1. Render the initial home layout screen
    await tester.pumpWidget(const RecipeApp());

    // Expecting to find the homepage header title
    expect(find.text('My Grandma\'s Cookbook'), findsOneWidget);
    expect(find.text('Spaghetti Carbonara'), findsOneWidget);

    // 2. Simulate tapping on the Spaghetti item row card
    await tester.tap(find.text('Spaghetti Carbonara'));
    await tester
        .pumpAndSettle(); // Wait patiently for screen animations to finish moving!

    // 3. Verify that we have safely landed on our Detail page
    expect(find.text('How to cook Spaghetti Carbonara:'), findsOneWidget);

    // The main landing title text shouldn't exist anymore on top
    expect(find.text('My Grandma\'s Cookbook'), findsNothing);
  });
}
