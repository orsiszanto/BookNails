import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Firestore wrapper service
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String role, // 'user' or 'nail_artist'
    String? phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'id': uid,
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

  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  // Services - lista lekéréséhez
  Future<QuerySnapshot> getServices({String? nailArtistId}) async {
    try {
      Query query = _firestore.collection('services');
      if (nailArtistId != null) {
        query = query.where('nailArtistProfileId', isEqualTo: nailArtistId);
      }
      return await query.get();
    } catch (e) {
      print('Error fetching services: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> getService(String serviceId) async {
    try {
      return await _firestore.collection('services').doc(serviceId).get();
    } catch (e) {
      print('Error fetching service: $e');
      rethrow;
    }
  }

  // Appointments
  Future<void> createAppointment({
    required String userId,
    required String nailArtistProfileId,
    required String serviceId,
    required DateTime appointmentDate,
    required TimeOfDay startTime,
    required int durationMinutes,
    required String note,
  }) async {
    try {
      await _firestore.collection('appointments').add({
        'userId': userId,
        'nailArtistProfileId': nailArtistProfileId,
        'serviceId': serviceId,
        'appointmentDate': appointmentDate,
        'startTime': startTime.toString(),
        'requestedDurationMinutes': durationMinutes,
        'estimatedDurationMinutes': durationMinutes,
        'note': note,
        'status': 'pending', // pending, confirmed, cancelled, rejected
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating appointment: $e');
      rethrow;
    }
  }

  Future<QuerySnapshot> getUserAppointments(String userId) async {
    try {
      return await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('appointmentDate', descending: true)
          .get();
    } catch (e) {
      print('Error fetching user appointments: $e');
      rethrow;
    }
  }

  // Gallery
  Future<QuerySnapshot> getGalleryItems({String? nailArtistId}) async {
    try {
      Query query = _firestore.collection('galleryItems');
      if (nailArtistId != null) {
        query = query.where('nailArtistProfileId', isEqualTo: nailArtistId);
      }
      return await query.get();
    } catch (e) {
      print('Error fetching gallery items: $e');
      rethrow;
    }
  }

  // Real-time listeners
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getServicesStream({String? nailArtistId}) {
    Query query = _firestore.collection('services');
    if (nailArtistId != null) {
      query = query.where('nailArtistProfileId', isEqualTo: nailArtistId);
    }
    return query.snapshots();
  }
}
