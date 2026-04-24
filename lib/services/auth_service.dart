import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared/validators/auth_validators.dart';

/// FirebaseAuth wrapper service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final emailError = AuthValidators.validateEmail(email);
      if (emailError != null) {
        throw FirebaseAuthException(code: 'invalid-email', message: emailError);
      }

      final nameError = AuthValidators.validateName(name);
      if (nameError != null) {
        throw FirebaseAuthException(code: 'invalid-name', message: nameError);
      }

      final passwordError = AuthValidators.validateRegistrationPassword(password);
      if (passwordError != null) {
        throw FirebaseAuthException(code: 'invalid-password', message: passwordError);
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);
      
      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': 'user',
        'phoneNumber': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      rethrow;
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final emailError = AuthValidators.validateEmail(email);
      if (emailError != null) {
        throw FirebaseAuthException(code: 'invalid-email', message: emailError);
      }

      final passwordError = AuthValidators.validateRequiredPassword(password);
      if (passwordError != null) {
        throw FirebaseAuthException(code: 'invalid-password', message: passwordError);
      }

      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      rethrow;
    }
  }

  Future<User> _requireCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Nincs bejelentkezett felhasználó.',
      );
    }
    return user;
  }

  Future<void> _reauthenticateWithPassword({
    required User user,
    required String currentPassword,
  }) async {
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-email',
        message: 'Az email cím hiányzik a hitelesítéshez.',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      final user = await _requireCurrentUser();
      await user.updateDisplayName(displayName);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      rethrow;
    }
  }

  Future<void> updateEmailWithPassword({
    required String currentPassword,
    required String newEmail,
  }) async {
    try {
      final user = await _requireCurrentUser();
      await _reauthenticateWithPassword(
        user: user,
        currentPassword: currentPassword,
      );
      await user.verifyBeforeUpdateEmail(newEmail);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      rethrow;
    }
  }

  Future<void> updatePasswordWithPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = await _requireCurrentUser();
      await _reauthenticateWithPassword(
        user: user,
        currentPassword: currentPassword,
      );
      await user.updatePassword(newPassword);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      rethrow;
    }
  }

  Future<void> deleteCurrentUserWithPassword({
    required String currentPassword,
  }) async {
    try {
      final user = await _requireCurrentUser();
      final uid = user.uid;

      await _reauthenticateWithPassword(
        user: user,
        currentPassword: currentPassword,
      );

      await _firestore.collection('users').doc(uid).delete();
      await user.delete();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      final emailError = AuthValidators.validateEmail(email);
      if (emailError != null) {
        throw FirebaseAuthException(code: 'invalid-email', message: emailError);
      }

      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  void _handleAuthException(FirebaseAuthException e) {
    // Avoid logging sensitive exception details in production-facing code.
    print('Auth error: ${e.code}');
  }
}
