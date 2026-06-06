import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_phase_seven/main.dart';

void main() {
  testWidgets('Riverpod 3 Notifier Counter UI state modification test', (
    WidgetTester tester,
  ) async {
    // Render our app structure wrapped securely in a test ProviderScope
    await tester.pumpWidget(const ProviderScope(child: RiverpodStateApp()));

    // 1. Verify original initial value is starting at 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 2. Tap the increment button (using its specific icon)
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // Rebuild the frames with the updated state emission

    // 3. Verify modifications are caught down the stream
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);

    // 4. Tap the decrement button
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // 5. Verify it returns back down to 0
    expect(find.text('0'), findsOneWidget);
  });
}
