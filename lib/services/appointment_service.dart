import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment.dart';

/// Service for managing appointments in Firestore
class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'appointments';

  /// Create a new appointment
  Future<String> createAppointment({
    required String userId,
    required String nailArtistProfileId,
    required String serviceId,
    required DateTime appointmentDate,
    required String startTime,
    required int requestedDurationMinutes,
    String? note,
    String status = 'pending',
  }) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'userId': userId,
        'nailArtistProfileId': nailArtistProfileId,
        'serviceId': serviceId,
        'appointmentDate': appointmentDate,
        'startTime': startTime,
        'requestedDurationMinutes': requestedDurationMinutes,
        'estimatedDurationMinutes': null,
        'note': note,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error creating appointment: $e');
      rethrow;
    }
  }

  /// Get a single appointment by ID
  Future<Appointment?> getAppointment(String appointmentId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(appointmentId).get();
      if (doc.exists) {
        return Appointment.fromFirestore(doc.data() ?? {}, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching appointment: $e');
      rethrow;
    }
  }

  /// Get all appointments
  Future<List<Appointment>> getAllAppointments() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('appointmentDate', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching all appointments: $e');
      rethrow;
    }
  }

  /// Get appointments by user
  Future<List<Appointment>> getAppointmentsByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('appointmentDate', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching appointments by user: $e');
      rethrow;
    }
  }

  /// Get appointments by nail artist
  Future<List<Appointment>> getAppointmentsByNailArtist(
      String nailArtistProfileId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('nailArtistProfileId', isEqualTo: nailArtistProfileId)
          .orderBy('appointmentDate', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching appointments by nail artist: $e');
      rethrow;
    }
  }

  /// Get appointments by status
  Future<List<Appointment>> getAppointmentsByStatus(String status) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: status)
          .orderBy('appointmentDate', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching appointments by status: $e');
      rethrow;
    }
  }

  /// Get appointments filtered by user and/or status
  /// Pass null for either parameter to skip that filter
  Future<List<Appointment>> getAppointmentsByFilters({
    String? userId,
    String? status,
  }) async {
    try {
      Query query = _firestore.collection(_collection);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      final querySnapshot = await query.orderBy('appointmentDate', descending: true).get();
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data() as Map<String,dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching appointments by filters: $e');
      rethrow;
    }
  }

  /// Update an appointment
  Future<void> updateAppointment({
    required String appointmentId,
    String? serviceId,
    DateTime? appointmentDate,
    String? startTime,
    int? requestedDurationMinutes,
    int? estimatedDurationMinutes,
    String? note,
    String? status,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (serviceId != null) updateData['serviceId'] = serviceId;
      if (appointmentDate != null) updateData['appointmentDate'] = appointmentDate;
      if (startTime != null) updateData['startTime'] = startTime;
      if (requestedDurationMinutes != null) {
        updateData['requestedDurationMinutes'] = requestedDurationMinutes;
      }
      if (estimatedDurationMinutes != null) {
        updateData['estimatedDurationMinutes'] = estimatedDurationMinutes;
      }
      if (note != null) updateData['note'] = note;
      if (status != null) updateData['status'] = status;

      await _firestore.collection(_collection).doc(appointmentId).update(updateData);
    } catch (e) {
      print('Error updating appointment: $e');
      rethrow;
    }
  }

  /// Delete an appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection(_collection).doc(appointmentId).delete();
    } catch (e) {
      print('Error deleting appointment: $e');
      rethrow;
    }
  }

  /// Get appointments as a real-time stream
  Stream<List<Appointment>> getAppointmentsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data() ?? {}, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching appointments stream: $error');
    });
  }

  /// Get appointments by user as a real-time stream
  Stream<List<Appointment>> getAppointmentsByUserStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data() ?? {}, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching appointments by user stream: $error');
    });
  }

  /// Get appointments by nail artist as a real-time stream
  Stream<List<Appointment>> getAppointmentsByNailArtistStream(
      String nailArtistProfileId) {
    return _firestore
        .collection(_collection)
        .where('nailArtistProfileId', isEqualTo: nailArtistProfileId)
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data() ?? {}, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching appointments by nail artist stream: $error');
    });
  }

  /// Get appointments by status as a real-time stream
  Stream<List<Appointment>> getAppointmentsByStatusStream(String status) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: status)
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data() ?? {}, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching appointments by status stream: $error');
    });
  }

  /// Get appointments filtered by user and/or status as a real-time stream
  /// Pass null for either parameter to skip that filter
  Stream<List<Appointment>> getAppointmentsStreamByFilters({
    String? userId,
    String? status,
  }) {
    Query query = _firestore.collection(_collection);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc.data() as Map<String,dynamic>, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching appointments by filters stream: $error');
    });
  }
}

