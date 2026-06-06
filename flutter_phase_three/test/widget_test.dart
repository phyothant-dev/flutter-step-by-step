import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_phase_three/main.dart'; // Makes sure this matches your day 3 project folder name

void main() {
  testWidgets('Crypto Tracker App Layout and Loading Test', (
    WidgetTester tester,
  ) async {
    // 1. Tell Flutter to build our CryptoApp inside the virtual test environment
    await tester.pumpWidget(const CryptoApp());

    // 2. Check if our custom app bar title "Live Crypto Tracker" is on the screen
    expect(find.text('Live Crypto Tracker'), findsOneWidget);

    // 3. Verify that the app starts with a native spinning loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 4. Double check that our old habit tracker elements are NOT on this screen
    expect(find.text('My Habit Tracker'), findsNothing);
  });
}
