import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_phase_eight/main.dart';

void main() {
  testWidgets('Nested Sub-Navigation Stack Router Verification Flow', (
    WidgetTester tester,
  ) async {
    // Render the nested routing architecture within the test context environment
    await tester.pumpWidget(const AdvancedNavigationApp());

    // 1. Initial State Assertions (Home Tab landing view)
    expect(find.text('Welcome to the Home Root Tab'), findsOneWidget);
    expect(find.text('Independent Tab Context Area'), findsNothing);

    // 2. Click the button to drill down into the nested details route
    await tester.tap(find.text('Drill Down into Nested Details'));
    await tester
        .pumpAndSettle(); // Wait for navigation slide animation frames to settle

    // 3. Verify nested view opened safely
    expect(find.text('Deep Child Viewport'), findsOneWidget);
    expect(find.text('Welcome to the Home Root Tab'), findsNothing);

    // 4. Switch over to the second tab (Settings) using the bottom bar icon
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // 5. Verify the settings tab content rendered correctly
    expect(find.text('Independent Tab Context Area'), findsOneWidget);
    expect(find.text('Deep Child Viewport'), findsNothing);
  });
}
