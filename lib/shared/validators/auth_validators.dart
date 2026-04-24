class AuthValidators {
  static const String emailRequiredMessage = 'Kérem adja meg az email címét';
  static const String emailInvalidMessage = 'Érvénytelen email cím';
  static const String nameRequiredMessage = 'Kérem adja meg a teljes nevét';
  static const String passwordRequiredMessage = 'Kérem adja meg a jelszót';
  static const String confirmPasswordRequiredMessage =
      'Kérem adja meg a jelszó megerősítését';
  static const String passwordTooShortMessage = 'A jelszó legalább 8 karakter hosszú legyen';
  static const String passwordWeakMessage =
      'A jelszónak tartalmaznia kell kisbetűt, nagybetűt és számot';
  static const String passwordMismatchMessage = 'A jelszavak nem egyeznek';

  static final RegExp _emailPattern = RegExp(
    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
  );

  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emailRequiredMessage;
    if (!_emailPattern.hasMatch(trimmed)) return emailInvalidMessage;
    return null;
  }

  static String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return nameRequiredMessage;
    return null;
  }

  static String? validateRequiredPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return passwordRequiredMessage;
    return null;
  }

  static String? validateRegistrationPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return passwordRequiredMessage;
    if (password.length < 8) return passwordTooShortMessage;
    if (!RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'\d').hasMatch(password)) {
      return passwordWeakMessage;
    }
    return null;
  }

  static String? validateConfirmPassword({
    required String? password,
    required String? confirmPassword,
  }) {
    if ((confirmPassword ?? '').isEmpty) return confirmPasswordRequiredMessage;
    if (password != confirmPassword) return passwordMismatchMessage;
    return null;
  }
}


