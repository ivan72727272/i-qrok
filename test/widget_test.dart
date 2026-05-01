// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:i_qrok/main.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ECroApp());

    // Advance time by 4 seconds to allow the splash screen timer to finish
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify that we reached the HomeScreen
    expect(find.text('Belajar Iqra'), findsWidgets);
  });
}
