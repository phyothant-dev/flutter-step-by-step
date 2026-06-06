import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_phase_three/main.dart';

void main() {
  testWidgets('Crypto List UI Layout Test', (WidgetTester tester) async {
    await tester.pumpWidget(const CryptoApp());

    // Verify app structure loads cleanly
    expect(find.text('Live Crypto Tracker'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
