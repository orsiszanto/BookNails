import 'package:booknails/shared/validators/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators', () {
    test('validateEmail returns required message for empty input', () {
      expect(AuthValidators.validateEmail(''), AuthValidators.emailRequiredMessage);
    });

    test('validateEmail returns invalid message for malformed email', () {
      expect(
        AuthValidators.validateEmail('invalid-email'),
        AuthValidators.emailInvalidMessage,
      );
    });

    test('validateEmail accepts a valid email', () {
      expect(AuthValidators.validateEmail('user@example.com'), isNull);
    });

    test('validateName returns required message for empty input', () {
      expect(AuthValidators.validateName('   '), AuthValidators.nameRequiredMessage);
    });

    test('validateName accepts a non-empty trimmed name', () {
      expect(AuthValidators.validateName(' Kiss Mária '), isNull);
    });

    test('validateRequiredPassword returns required message for empty password', () {
      expect(
        AuthValidators.validateRequiredPassword(''),
        AuthValidators.passwordRequiredMessage,
      );
    });

    test('validateRegistrationPassword rejects short passwords', () {
      expect(
        AuthValidators.validateRegistrationPassword('Aa1bcd'),
        AuthValidators.passwordTooShortMessage,
      );
    });

    test('validateRegistrationPassword rejects weak passwords', () {
      expect(
        AuthValidators.validateRegistrationPassword('abcdefgh'),
        AuthValidators.passwordWeakMessage,
      );
    });

    test('validateRegistrationPassword accepts a strong password', () {
      expect(AuthValidators.validateRegistrationPassword('Abcdef12'), isNull);
    });

    test('validateConfirmPassword returns mismatch message for different values', () {
      expect(
        AuthValidators.validateConfirmPassword(
          password: 'Abcdef12',
          confirmPassword: 'Abcdef13',
        ),
        AuthValidators.passwordMismatchMessage,
      );
    });

    test('validateConfirmPassword accepts matching values', () {
      expect(
        AuthValidators.validateConfirmPassword(
          password: 'Abcdef12',
          confirmPassword: 'Abcdef12',
        ),
        isNull,
      );
    });
  });
}

