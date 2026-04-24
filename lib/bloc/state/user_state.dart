part of '../cubit/user_cubit.dart';

/// Base state for user operations
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UserInitial extends UserState {
  const UserInitial();
}

/// Loading state
class UserLoading extends UserState {
  const UserLoading();
}

/// State when users are loaded successfully
class UserLoaded extends UserState {
  final List<User> users;

  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

/// State when a single user is loaded
class UserDetailLoaded extends UserState {
  final User user;

  const UserDetailLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when user creation is successful
class UserCreated extends UserState {
  const UserCreated();
}

/// State when user is updated successfully
class UserUpdated extends UserState {
  final User user;

  const UserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when user is deleted successfully
class UserDeleted extends UserState {
  final String uid;

  const UserDeleted(this.uid);

  @override
  List<Object?> get props => [uid];
}

/// Error state
class UserError extends UserState {
  final String message;
  final StackTrace? stackTrace;

  const UserError(this.message, {this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}

