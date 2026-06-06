import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_phase_two/main.dart'; // Makes sure this matches your project name

void main() {
  testWidgets('Todo app display test', (WidgetTester tester) async {
    // 1. Tell Flutter to build our TodoApp inside the test environment
    await tester.pumpWidget(const TodoApp());

    // 2. Check if our custom app bar title "My Habit Tracker" is on the screen
    expect(find.text('My Habit Tracker'), findsOneWidget);

    // 3. Check if one of our initial tasks exists on the screen
    expect(find.text('Learn Flutter'), findsOneWidget);

    // 4. Verify that the old counter text "0" is NOT on the screen anymore
    expect(find.text('0'), findsNothing);
  });
}
