import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Bejelentkezés képernyő
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  final bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // TODO: Implement Firebase login
    context.pushNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeArea: true,
      padding: const EdgeInsets.all(AppSpacing.l),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.l),
            const Text(
              'BookNails',
              style: AppTextStyles.displayLarge,
              textAlign: TextAlign.center,
              semanticsLabel: 'BookNails - Oldal cím',
            ),
            const SizedBox(height: AppSpacing.s),
            const Text(
              'Körmös szalon foglalási rendszer',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
              semanticsLabel: 'Körmös szalon foglalási rendszer - Alcím',
            ),
            const SizedBox(height: AppSpacing.xl),
            // Email field
            AppTextField(
              label: 'Email',
              hint: 'jelszo@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: AppSpacing.m),
            // Password field
            AppTextField(
              label: 'Jelszó',
              hint: '••••••••',
              controller: _passwordController,
              obscureText: _isPasswordHidden,
              prefixIcon: Icons.lock,
              suffixIcon:
                  _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
              onSuffixIconPressed: () {
                setState(() => _isPasswordHidden = !_isPasswordHidden);
              },
            ),
            const SizedBox(height: AppSpacing.m),
            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement password reset
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset placeholder')),
                  );
                },
                child: const Text('Elfelejtett jelszó?'),
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Bejelentkezés'),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Nincs még fiókom? '),
                TextButton(
                  onPressed: () {
                    context.pushNamed('registration');
                  },
                  child: const Text('Regisztráció'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
