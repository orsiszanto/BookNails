part of '../cubit/auth_cubit.dart';

/// Base state for authentication operations
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial authentication state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during authentication process
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  final String uid;
  final String email;

  const AuthAuthenticated({
    required this.uid,
    required this.email,
  });

  @override
  List<Object?> get props => [uid, email];
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Sign up was successful
class AuthSignUpSuccess extends AuthState {
  final String uid;
  final String email;

  const AuthSignUpSuccess({
    required this.uid,
    required this.email,
  });

  @override
  List<Object?> get props => [uid, email];
}

/// Sign in was successful
class AuthSignInSuccess extends AuthState {
  final String uid;
  final String email;

  const AuthSignInSuccess({
    required this.uid,
    required this.email,
  });

  @override
  List<Object?> get props => [uid, email];
}

/// Sign out was successful
class AuthSignOutSuccess extends AuthState {
  const AuthSignOutSuccess();
}

/// Password reset email was sent
class AuthPasswordResetSent extends AuthState {
  final String email;

  const AuthPasswordResetSent(this.email);

  @override
  List<Object?> get props => [email];
}

/// Authentication error occurred
class AuthError extends AuthState {
  final String message;
  final StackTrace? stackTrace;

  const AuthError(this.message, {this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}

