import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/nail_artist_profile.dart';

/// Service for managing nail artist profiles in Firestore
class NailArtistProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'nail_artist_profiles';

  /// Create a new nail artist profile
  Future<String> createNailArtistProfile({
    required String userId,
    required String salonName,
    required String address,
    required String phoneNumber,
    String? profileImageUrl,
    required Map<String, dynamic> workingHours,
  }) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'userId': userId,
        'salonName': salonName,
        'address': address,
        'phoneNumber': phoneNumber,
        'profileImageUrl': profileImageUrl,
        'workingHours': workingHours,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error creating nail artist profile: $e');
      rethrow;
    }
  }

  /// Get a single nail artist profile by ID
  Future<NailArtistProfile?> getNailArtistProfile(String profileId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(profileId).get();
      if (doc.exists) {
        return NailArtistProfile.fromFirestore(doc.data() ?? {}, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching nail artist profile: $e');
      rethrow;
    }
  }

  /// Get nail artist profile by user ID
  Future<NailArtistProfile?> getNailArtistProfileByUserId(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return NailArtistProfile.fromFirestore(
          querySnapshot.docs.first.data(),
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching nail artist profile by user ID: $e');
      rethrow;
    }
  }

  /// Get all nail artist profiles
  Future<List<NailArtistProfile>> getAllNailArtistProfiles() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => NailArtistProfile.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching all nail artist profiles: $e');
      rethrow;
    }
  }

  /// Update a nail artist profile
  Future<void> updateNailArtistProfile({
    required String profileId,
    String? salonName,
    String? address,
    String? phoneNumber,
    String? profileImageUrl,
    Map<String, dynamic>? workingHours,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (salonName != null) updateData['salonName'] = salonName;
      if (address != null) updateData['address'] = address;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      if (workingHours != null) updateData['workingHours'] = workingHours;

      await _firestore.collection(_collection).doc(profileId).update(updateData);
    } catch (e) {
      print('Error updating nail artist profile: $e');
      rethrow;
    }
  }

  /// Delete a nail artist profile
  Future<void> deleteNailArtistProfile(String profileId) async {
    try {
      await _firestore.collection(_collection).doc(profileId).delete();
    } catch (e) {
      print('Error deleting nail artist profile: $e');
      rethrow;
    }
  }

  /// Get nail artist profiles as a real-time stream
  Stream<List<NailArtistProfile>> getNailArtistProfilesStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => NailArtistProfile.fromFirestore(doc.data() ?? {}, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching nail artist profiles stream: $error');
    });
  }

  /// Get a single nail artist profile as a real-time stream
  Stream<NailArtistProfile?> getNailArtistProfileStream(String profileId) {
    return _firestore
        .collection(_collection)
        .doc(profileId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return NailArtistProfile.fromFirestore(doc.data() ?? {}, doc.id);
      }
      return null;
    }).handleError((error) {
      print('Error fetching nail artist profile stream: $error');
    });
  }

  /// Get nail artist profile by user ID as a real-time stream
  Stream<NailArtistProfile?> getNailArtistProfileByUserIdStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return NailArtistProfile.fromFirestore(
          querySnapshot.docs.first.data() ?? {},
          querySnapshot.docs.first.id,
        );
      }
      return null;
    }).handleError((error) {
      print('Error fetching nail artist profile by user ID stream: $error');
    });
  }
}

