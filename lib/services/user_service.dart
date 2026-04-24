import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

/// Service for managing users in Firestore
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  /// Create a new user
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String role,
    String? phoneNumber,
  }) async {
    try {
      await _firestore.collection(_collection).doc(uid).set({
        'name': name,
        'email': email,
        'role': role,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Get a single user by UID
  Future<User?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists) {
        return User.fromFirestore(doc.data() ?? {}, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  /// Get all users
  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot =
          await _firestore.collection(_collection).orderBy('createdAt', descending: true).get();
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching all users: $e');
      rethrow;
    }
  }

  /// Get users by role
  Future<List<User>> getUsersByRole(String role) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('role', isEqualTo: role)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching users by role: $e');
      rethrow;
    }
  }

  /// Get all nail artists
  Future<List<User>> getNailArtists() async {
    return getUsersByRole('nail_artist');
  }

  /// Get all regular users
  Future<List<User>> getRegularUsers() async {
    return getUsersByRole('user');
  }

  /// Update a user
  Future<void> updateUser({
    required String uid,
    String? name,
    String? email,
    String? role,
    String? phoneNumber,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (role != null) updateData['role'] = role;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;

      await _firestore.collection(_collection).doc(uid).update(updateData);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Delete a user
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Get users as a real-time stream
  Stream<List<User>> getUsersStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc.data() ?? {}, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching users stream: $error');
    });
  }

  /// Get a single user as a real-time stream
  Stream<User?> getUserStream(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return User.fromFirestore(doc.data() ?? {}, doc.id);
      }
      return null;
    }).handleError((error) {
      print('Error fetching user stream: $error');
    });
  }

  /// Get users by role as a real-time stream
  Stream<List<User>> getUsersByRoleStream(String role) {
    return _firestore
        .collection(_collection)
        .where('role', isEqualTo: role)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc.data() ?? {}, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching users by role stream: $error');
    });
  }

  /// Get nail artists as a real-time stream
  Stream<List<User>> getNailArtistsStream() {
    return getUsersByRoleStream('nail_artist');
  }

  /// Get regular users as a real-time stream
  Stream<List<User>> getRegularUsersStream() {
    return getUsersByRoleStream('user');
  }
}

