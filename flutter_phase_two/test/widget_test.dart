import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_phase_two/main.dart'; // Make sure this matches your project folder name

void main() {
  testWidgets('Todo app layout test', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    // Verify our elements exist
    expect(find.text('My Habit Tracker'), findsOneWidget);
    expect(
      find.text('Enter a new habit...'),
      findsOneWidget,
    ); // Checks if input field exists
    expect(find.text('Buy groceries'), findsOneWidget);
  });
}
