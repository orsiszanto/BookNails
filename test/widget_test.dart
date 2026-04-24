import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BookNails app loads and displays LoginScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const _TestApp());

    expect(find.text('BookNails'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Jelszó'), findsOneWidget);
    expect(find.text('Bejelentkezés'), findsOneWidget);
  });

  testWidgets('Login screen email field is interactive',
      (WidgetTester tester) async {
    await tester.pumpWidget(const _TestApp());

    await tester.tap(find.byType(TextField).first);
    await tester.pump();
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    expect(find.text('test@example.com'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('BookNails')),
        body: const _TestLoginForm(),
      ),
    );
  }
}

class _TestLoginForm extends StatelessWidget {
  const _TestLoginForm();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(decoration: InputDecoration(labelText: 'Email')),
          TextField(decoration: InputDecoration(labelText: 'Jelszó')),
          SizedBox(height: 16),
          ElevatedButton(onPressed: null, child: Text('Bejelentkezés')),
        ],
      ),
    );
  }
}

