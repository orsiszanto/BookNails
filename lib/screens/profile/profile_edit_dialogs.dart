import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubit/auth_cubit.dart';
import '../../bloc/cubit/user_cubit.dart';
import '../../models/user.dart' as app_user;
import '../../shared/widgets/app_text_field.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

bool _isValidEmail(String value) {
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
}

String _authErrorText(Object error) {
  if (error is firebase_auth.FirebaseAuthException) {
    return error.message ?? error.code;
  }
  return error.toString();
}

Widget _dialogErrorText(String? message) {
  if (message == null || message.isEmpty) {
    return const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.only(top: AppSpacing.s),
    child: Text(
      message,
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
    ),
  );
}

Future<bool> showNameEditDialog(
  BuildContext context, {
  required app_user.User user,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _NameEditDialog(user: user),
      ) ??
      false;
}

class _NameEditDialog extends StatefulWidget {
  const _NameEditDialog({required this.user});

  final app_user.User user;

  @override
  State<_NameEditDialog> createState() => _NameEditDialogState();
}

class _NameEditDialogState extends State<_NameEditDialog> {
  late final TextEditingController nameController;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        errorMessage = 'A név megadása kötelező.';
      });
      return;
    }

    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      await context.read<UserCubit>().updateUser(
            uid: widget.user.uid,
            name: name,
          );

      if (context.read<UserCubit>().state is UserError) {
        if (!mounted) return;
        setState(() {
          isSaving = false;
          errorMessage = 'Nem sikerült menteni a profiladatokat.';
        });
        return;
      }

      await context.read<AuthCubit>().updateDisplayName(name);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isSaving = false;
        errorMessage = _authErrorText(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Név módosítása'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A név módosítása a felhasználói profil adatlapban és az azonosító fejlécben is megjelenik.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Név',
              hint: 'Pl. Szántó Orsolya',
              controller: nameController,
              prefixIcon: Icons.person,
            ),
            _dialogErrorText(errorMessage),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Mégse'),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Mentés'),
        ),
      ],
    );
  }
}

Future<bool> showPhoneNumberEditDialog(
  BuildContext context, {
  required app_user.User user,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _PhoneNumberEditDialog(user: user),
      ) ??
      false;
}

class _PhoneNumberEditDialog extends StatefulWidget {
  const _PhoneNumberEditDialog({required this.user});

  final app_user.User user;

  @override
  State<_PhoneNumberEditDialog> createState() => _PhoneNumberEditDialogState();
}

class _PhoneNumberEditDialogState extends State<_PhoneNumberEditDialog> {
  late final TextEditingController phoneController;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final phone = phoneController.text.trim();

    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      await context.read<UserCubit>().updateUser(
            uid: widget.user.uid,
            phoneNumber: phone.isEmpty ? null : phone,
          );

      if (context.read<UserCubit>().state is UserError) {
        if (!mounted) return;
        setState(() {
          isSaving = false;
          errorMessage = 'Nem sikerült menteni a telefonszámot.';
        });
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isSaving = false;
        errorMessage = _authErrorText(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Telefonszám módosítása'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A telefonszám külön menthető a profil adatlapra.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Telefonszám',
              hint: 'Pl. +36 30 123 4567',
              controller: phoneController,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            _dialogErrorText(errorMessage),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Mégse'),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Mentés'),
        ),
      ],
    );
  }
}

Future<bool> showEmailEditDialog(
  BuildContext context, {
  required app_user.User user,
  required firebase_auth.User firebaseUser,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _EmailEditDialog(user: user, firebaseUser: firebaseUser),
      ) ??
      false;
}

class _EmailEditDialog extends StatefulWidget {
  const _EmailEditDialog({required this.user, required this.firebaseUser});

  final app_user.User user;
  final firebase_auth.User firebaseUser;

  @override
  State<_EmailEditDialog> createState() => _EmailEditDialogState();
}

class _EmailEditDialogState extends State<_EmailEditDialog> {
  late final TextEditingController currentPasswordController;
  late final TextEditingController newEmailController;
  late final TextEditingController confirmEmailController;
  bool isSaving = false;
  String? errorMessage;

  String get _initialEmail => widget.user.email.isNotEmpty ? widget.user.email : (widget.firebaseUser.email ?? '');

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newEmailController = TextEditingController(text: _initialEmail);
    confirmEmailController = TextEditingController(text: _initialEmail);
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newEmailController.dispose();
    confirmEmailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final currentPassword = currentPasswordController.text;
    final newEmail = newEmailController.text.trim();
    final confirmEmail = confirmEmailController.text.trim();

    if (currentPassword.isEmpty) {
      setState(() {
        errorMessage = 'A jelenlegi jelszó megadása kötelező.';
      });
      return;
    }

    if (!_isValidEmail(newEmail)) {
      setState(() {
        errorMessage = 'Adj meg egy érvényes email címet.';
      });
      return;
    }

    if (newEmail != confirmEmail) {
      setState(() {
        errorMessage = 'Az email címek nem egyeznek.';
      });
      return;
    }

    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      await context.read<AuthCubit>().updateEmailWithPassword(
            currentPassword: currentPassword,
            newEmail: newEmail,
          );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isSaving = false;
        errorMessage = _authErrorText(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Email módosítása'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Biztonsági okból a jelenlegi jelszót is meg kell adnod.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Jelenlegi jelszó',
              hint: 'A bejelentkezéshez használt jelszó',
              controller: currentPasswordController,
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Új email cím',
              hint: 'pl. orsi@pelda.hu',
              controller: newEmailController,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Új email megerősítése',
              hint: 'Add meg még egyszer az email címet',
              controller: confirmEmailController,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _dialogErrorText(errorMessage),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Mégse'),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Mentés'),
        ),
      ],
    );
  }
}

Future<bool> showPasswordEditDialog(
  BuildContext context,
) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _PasswordEditDialog(),
      ) ??
      false;
}

class _PasswordEditDialog extends StatefulWidget {
  const _PasswordEditDialog();

  @override
  State<_PasswordEditDialog> createState() => _PasswordEditDialogState();
}

class _PasswordEditDialogState extends State<_PasswordEditDialog> {
  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (currentPassword.isEmpty) {
      setState(() {
        errorMessage = 'A jelenlegi jelszó megadása kötelező.';
      });
      return;
    }

    if (newPassword.length < 6) {
      setState(() {
        errorMessage = 'Az új jelszó legalább 6 karakter legyen.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        errorMessage = 'Az új jelszavak nem egyeznek.';
      });
      return;
    }

    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      await context.read<AuthCubit>().updatePasswordWithPassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isSaving = false;
        errorMessage = _authErrorText(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Jelszó módosítása'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Biztonsági okból itt is szükség van a jelenlegi jelszóra.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Jelenlegi jelszó',
              hint: 'A bejelentkezéshez használt jelszó',
              controller: currentPasswordController,
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Új jelszó',
              hint: 'Legalább 6 karakter',
              controller: newPasswordController,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Új jelszó megerősítése',
              hint: 'Add meg még egyszer az új jelszót',
              controller: confirmPasswordController,
              prefixIcon: Icons.lock_reset,
              obscureText: true,
            ),
            _dialogErrorText(errorMessage),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Mégse'),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Mentés'),
        ),
      ],
    );
  }
}

Future<bool> showDeleteAccountDialog(
  BuildContext context, {
  required app_user.User user,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _DeleteAccountDialog(user: user),
      ) ??
      false;
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({required this.user});

  final app_user.User user;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  late final TextEditingController passwordController;
  late final TextEditingController confirmController;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final password = passwordController.text;
    final confirmation = confirmController.text.trim().toUpperCase();

    if (password.isEmpty) {
      setState(() {
        errorMessage = 'A jelenlegi jelszó megadása kötelező.';
      });
      return;
    }

    if (confirmation != 'TÖRLÖM') {
      setState(() {
        errorMessage = 'A törléshez írd be: TÖRLÖM';
      });
      return;
    }

    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      await context.read<AuthCubit>().deleteCurrentAccount(
            currentPassword: password,
          );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isSaving = false;
        errorMessage = _authErrorText(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Profil törlése'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ez véglegesen törli a fiókodat és a profiladatokat.\nFelhasználó: ${widget.user.email.isNotEmpty ? widget.user.email : widget.user.name}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Jelenlegi jelszó',
              hint: 'A törlés megerősítéséhez',
              controller: passwordController,
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: 'Erősítés',
              hint: 'Írd be: TÖRLÖM',
              controller: confirmController,
              prefixIcon: Icons.warning_amber,
            ),
            _dialogErrorText(errorMessage),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Mégse'),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Törlés'),
        ),
      ],
    );
  }
}




