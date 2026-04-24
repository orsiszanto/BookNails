import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/validators/auth_validators.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Regisztráció képernyő
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    context.read<AuthCubit>().signUp(
          email: email,
          password: password,
          name: name,
        );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeArea: true,
      padding: const EdgeInsets.all(AppSpacing.l),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            // Clear fields and navigate to home on successful registration
            _nameController.clear();
            _emailController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();
            context.goNamed('home');
          } else if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 4),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
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
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person,
                  validator: AuthValidators.validateName,
                ),
                const SizedBox(height: AppSpacing.m),
                // Email field
                AppTextField(
                  label: 'Email',
                  hint: 'peldauser@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email,
                  validator: AuthValidators.validateEmail,
                ),
                const SizedBox(height: AppSpacing.m),
                // Password field
                AppTextField(
                  label: 'Jelszó',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.lock,
                  suffixIcon: _isPasswordHidden
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onSuffixIconPressed: () {
                    setState(() => _isPasswordHidden = !_isPasswordHidden);
                  },
                  validator: AuthValidators.validateRegistrationPassword,
                ),
                const SizedBox(height: AppSpacing.m),
                // Confirm password field
                AppTextField(
                  label: 'Jelszó megerősítés',
                  hint: '••••••••',
                  controller: _confirmPasswordController,
                  obscureText: _isConfirmPasswordHidden,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock,
                  suffixIcon: _isConfirmPasswordHidden
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onSuffixIconPressed: () {
                    setState(
                        () => _isConfirmPasswordHidden = !_isConfirmPasswordHidden);
                  },
                  validator: (value) => AuthValidators.validateConfirmPassword(
                    password: _passwordController.text,
                    confirmPassword: value,
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                // Registration button with loading state
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;

                      return ElevatedButton(
                        onPressed: isLoading ? null : _handleRegistration,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Text('Regisztráció'),
                      );
                    },
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
        ),
      ),
    );
  }
}
