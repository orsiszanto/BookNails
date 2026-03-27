import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Error Screen - Ismeretlen útvonal vagy hiba esetén
class ErrorScreen extends StatelessWidget {
  final String? message;

  const ErrorScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hiba'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'Ismeretlen oldal',
                style: AppTextStyles.heading1,
                textAlign: TextAlign.center,
                semanticsLabel: 'Ismeretlen oldal - Hibacím',
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                message ?? 'Sajnáljuk, ez az oldal nem létezik.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.l),
              ElevatedButton.icon(
                onPressed: () {
                  context.goNamed('login');
                },
                icon: const Icon(Icons.home),
                label: const Text('Vissza a főoldalra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
