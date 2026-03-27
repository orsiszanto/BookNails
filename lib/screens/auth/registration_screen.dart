import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Regisztráció képernyő
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  final bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    // TODO: Implement Firebase registration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Regisztráció placeholder')),
    );
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
              'Regisztráció',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
              semanticsLabel: 'Regisztráció - Alcím',
            ),
            const SizedBox(height: AppSpacing.xl),
            // Name field
            AppTextField(
              label: 'Teljes név',
              hint: 'Dr. Kiss Mária',
              controller: _nameController,
              keyboardType: TextInputType.name,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: AppSpacing.m),
            // Email field
            AppTextField(
              label: 'Email',
              hint: 'peldauser@example.com',
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
            // Confirm password field
            AppTextField(
              label: 'Jelszó megerősítés',
              hint: '••••••••',
              controller: _confirmPasswordController,
              obscureText: _isConfirmPasswordHidden,
              prefixIcon: Icons.lock,
              suffixIcon: _isConfirmPasswordHidden
                  ? Icons.visibility_off
                  : Icons.visibility,
              onSuffixIconPressed: () {
                setState(
                    () => _isConfirmPasswordHidden = !_isConfirmPasswordHidden);
              },
            ),
            const SizedBox(height: AppSpacing.l),
            // Registration button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegistration,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Regisztráció'),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            // Sign in link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Már van fiókom? '),
                TextButton(
                  onPressed: () {
                    context.goNamed('login');
                  },
                  child: const Text('Bejelentkezés'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
