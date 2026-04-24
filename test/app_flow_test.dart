import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login to admin dashboard smoke flow', (tester) async {
    await tester.pumpWidget(const _TestApp());
    await tester.pumpAndSettle();

    expect(find.text('BookNails'), findsOneWidget);
    expect(find.text('Bejelentkezés'), findsOneWidget);

    await tester.tap(find.text('Bejelentkezés'));
    await tester.pumpAndSettle();

    expect(find.text('Admin dashboard'), findsOneWidget);
    expect(find.text('Kijelentkezés'), findsOneWidget);
    expect(find.text('Nail artist profil kezelése'), findsOneWidget);
    expect(find.text('Szolgáltatások kezelése'), findsOneWidget);
    expect(find.text('Időpontfoglalások kezelése'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _LoginPage(),
      routes: {
        '/admin': (_) => const _AdminDashboardPage(),
      },
    );
  }
}

class _LoginPage extends StatelessWidget {
  const _LoginPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BookNails')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/admin'),
          child: const Text('Bejelentkezés'),
        ),
      ),
    );
  }
}

class _AdminDashboardPage extends StatelessWidget {
  const _AdminDashboardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: Text('Kijelentkezés')),
          ),
        ],
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nail artist profil kezelése'),
          Text('Szolgáltatások kezelése'),
          Text('Időpontfoglalások kezelése'),
        ],
      ),
    );
  }
}

