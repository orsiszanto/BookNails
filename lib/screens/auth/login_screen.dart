import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../bloc/cubit/user_cubit.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kérem adja meg az email és jelszó mezőket'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    context.read<AuthCubit>().signIn(
          email: email,
          password: password,
        );
  }

  void _handlePasswordReset() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kérem adja meg az email címét'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    context.read<AuthCubit>().resetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeArea: true,
      padding: const EdgeInsets.all(AppSpacing.l),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignInSuccess) {
            () async {
              final userCubit = context.read<UserCubit>();
              await userCubit.fetchUser(state.uid);

              if (!context.mounted) return;

              _emailController.clear();
              _passwordController.clear();

              if (userCubit.state is UserDetailLoaded &&
                  (((userCubit.state as UserDetailLoaded).user.role == 'admin') ||
                      ((userCubit.state as UserDetailLoaded).user.role == 'nail_artist'))) {
                context.goNamed('admin-dashboard');
              } else {
                context.goNamed('home');
              }
            }();
          } else if (state is AuthError) {
            // Clear password field and show error message
            _passwordController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 4),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthPasswordResetSent) {
            // Show success message for password reset
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Jelszó visszaállítási email elküldve: ${state.email}',
                ),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
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
                  onPressed: _handlePasswordReset,
                  child: const Text('Elfelejtett jelszó?'),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              // Login button with loading state
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
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
                          : const Text('Bejelentkezés'),
                    );
                  },
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
      ),
    );
  }
}
