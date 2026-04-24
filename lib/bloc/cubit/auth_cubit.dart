import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

part '../state/auth_state.dart';

/// Cubit for managing authentication business logic
class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(const AuthInitial()) {
    _initAuthStateListener();
  }

  /// Initialize listening to auth state changes
  void _initAuthStateListener() {
    _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        emit(AuthAuthenticated(
          uid: user.uid,
          email: user.email ?? '',
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    }).onError((error, stackTrace) {
      emit(AuthError(
        'Error listening to auth state: $error',
        stackTrace: stackTrace,
      ));
    });
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      emit(const AuthLoading());
      print('🔐 Starting sign up for: $email');
      
      final userCredential = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      print('✅ Firebase Auth success and Firestore user created, UID: ${userCredential.user!.uid}');
      
      emit(AuthSignUpSuccess(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
      ));
    } catch (e, stackTrace) {
      print('❌ Error during sign up: $e');
      print('Stack trace: $stackTrace');
      emit(AuthError(
        'Error during sign up: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoading());
      final userCredential = await _authService.signIn(
        email: email,
        password: password,
      );
      emit(AuthSignInSuccess(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
      ));
    } catch (e, stackTrace) {
      emit(AuthError(
        'Error during sign in: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      emit(const AuthLoading());
      await _authService.signOut();
      emit(const AuthSignOutSuccess());
    } catch (e, stackTrace) {
      emit(AuthError(
        'Error during sign out: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      emit(const AuthLoading());
      await _authService.resetPassword(email);
      emit(AuthPasswordResetSent(email));
    } catch (e, stackTrace) {
      emit(AuthError(
        'Error sending password reset email: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Update the current user's display name
  Future<void> updateDisplayName(String displayName) {
    return _authService.updateDisplayName(displayName);
  }

  /// Update the current user's email after password re-authentication
  Future<void> updateEmailWithPassword({
    required String currentPassword,
    required String newEmail,
  }) {
    return _authService.updateEmailWithPassword(
      currentPassword: currentPassword,
      newEmail: newEmail,
    );
  }

  /// Update the current user's password after password re-authentication
  Future<void> updatePasswordWithPassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _authService.updatePasswordWithPassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  /// Delete the current account after password re-authentication
  Future<void> deleteCurrentAccount({
    required String currentPassword,
  }) async {
    try {
      emit(const AuthLoading());
      await _authService.deleteCurrentUserWithPassword(
        currentPassword: currentPassword,
      );
      emit(const AuthSignOutSuccess());
    } catch (e, stackTrace) {
      emit(AuthError(
        'Error deleting account: $e',
        stackTrace: stackTrace,
      ));
      rethrow;
    }
  }

  /// Get the current authenticated user
  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    final currentUser = _authService.getCurrentUser();
    return currentUser != null;
  }
}

