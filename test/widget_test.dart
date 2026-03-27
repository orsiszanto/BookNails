// Flutter widget test for BookNails app
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:booknails/main.dart';

void main() {
  testWidgets('BookNails app loads and displays LoginScreen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('BookNails'), findsWidgets);

    // Verify that email and password fields are visible on login screen
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Jelszó'), findsOneWidget);

    // Verify that login button exists
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets('Login screen email field is interactive',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find and tap the email field
    await tester.tap(find.byType(TextField).first);
    await tester.pump();

    // Type an email
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    expect(find.text('test@example.com'), findsOneWidget);
  });
}
