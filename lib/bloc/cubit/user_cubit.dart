import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';

part '../state/user_state.dart';

/// Cubit for managing user business logic
class UserCubit extends Cubit<UserState> {
  final UserService _userService;

  UserCubit(this._userService) : super(const UserInitial());

  /// Fetch all users
  Future<void> fetchUsers() async {
    try {
      emit(const UserLoading());
      final users = await _userService.getAllUsers();
      emit(UserLoaded(users));
    } catch (e, stackTrace) {
      emit(UserError(
        'Error fetching users: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch a single user by UID
  Future<void> fetchUser(String uid) async {
    try {
      emit(const UserLoading());
      final user = await _userService.getUser(uid);
      if (user != null) {
        emit(UserDetailLoaded(user));
      } else {
        emit(const UserError('User not found'));
      }
    } catch (e, stackTrace) {
      emit(UserError(
        'Error fetching user: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch users by role
  Future<void> fetchUsersByRole(String role) async {
    try {
      emit(const UserLoading());
      final users = await _userService.getUsersByRole(role);
      emit(UserLoaded(users));
    } catch (e, stackTrace) {
      emit(UserError(
        'Error fetching users by role: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch all nail artists
  Future<void> fetchNailArtists() async {
    return fetchUsersByRole('nail_artist');
  }

  /// Fetch all regular users
  Future<void> fetchRegularUsers() async {
    return fetchUsersByRole('user');
  }

  /// Create a new user
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String role,
    String? phoneNumber,
  }) async {
    try {
      emit(const UserLoading());
      await _userService.createUser(
        uid: uid,
        name: name,
        email: email,
        role: role,
        phoneNumber: phoneNumber,
      );
      emit(const UserCreated());
      // Refresh the list after creation
      await fetchUsers();
    } catch (e, stackTrace) {
      emit(UserError(
        'Error creating user: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Update an existing user
  Future<void> updateUser({
    required String uid,
    String? name,
    String? email,
    String? role,
    String? phoneNumber,
  }) async {
    try {
      emit(const UserLoading());
      await _userService.updateUser(
        uid: uid,
        name: name,
        email: email,
        role: role,
        phoneNumber: phoneNumber,
      );
      final updatedUser = await _userService.getUser(uid);
      if (updatedUser != null) {
        emit(UserUpdated(updatedUser));
        // Refresh the list after update
        await fetchUsers();
      } else {
        emit(const UserError('Failed to fetch updated user'));
      }
    } catch (e, stackTrace) {
      emit(UserError(
        'Error updating user: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Delete a user
  Future<void> deleteUser(String uid) async {
    try {
      emit(const UserLoading());
      await _userService.deleteUser(uid);
      emit(UserDeleted(uid));
      // Refresh the list after deletion
      await fetchUsers();
    } catch (e, stackTrace) {
      emit(UserError(
        'Error deleting user: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch users as a stream
  void watchUsers() {
    try {
      emit(const UserLoading());
      _userService.getUsersStream().listen((users) {
        emit(UserLoaded(users));
      }).onError((error, stackTrace) {
        emit(UserError(
          'Error watching users: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(UserError(
        'Error setting up users stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch a single user as a stream
  void watchUser(String uid) {
    try {
      emit(const UserLoading());
      _userService.getUserStream(uid).listen((user) {
        if (user != null) {
          emit(UserDetailLoaded(user));
        } else {
          emit(const UserError('User not found'));
        }
      }).onError((error, stackTrace) {
        emit(UserError(
          'Error watching user: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(UserError(
        'Error setting up user stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch users by role as a stream
  void watchUsersByRole(String role) {
    try {
      emit(const UserLoading());
      _userService.getUsersByRoleStream(role).listen((users) {
        emit(UserLoaded(users));
      }).onError((error, stackTrace) {
        emit(UserError(
          'Error watching users by role: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(UserError(
        'Error setting up users by role stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch nail artists as a stream
  void watchNailArtists() {
    return watchUsersByRole('nail_artist');
  }

  /// Watch regular users as a stream
  void watchRegularUsers() {
    return watchUsersByRole('user');
  }
}

