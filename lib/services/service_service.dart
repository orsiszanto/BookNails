import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service.dart';

class ServicePage {
  final List<Service> services;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  const ServicePage({
    required this.services,
    required this.lastDocument,
    required this.hasMore,
  });
}

/// Service for managing services in Firestore
class ServiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'services';

  /// Create a new service
  Future<String> createService({
    required String nailArtistProfileId,
    required String categoryId,
    required String name,
    required String description,
    required double price,
    required int durationMinutes,
    String? imageUrl,
    required bool isActive,
  }) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'nailArtistProfileId': nailArtistProfileId,
        'categoryId': categoryId,
        'name': name,
        'description': description,
        'price': price,
        'durationMinutes': durationMinutes,
        'imageUrl': imageUrl,
        'isActive': isActive,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error creating service: $e');
      rethrow;
    }
  }

  /// Get a single service by ID
  Future<Service?> getService(String serviceId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(serviceId).get();
      if (doc.exists) {
        return Service.fromFirestore(doc.data() ?? {}, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching service: $e');
      rethrow;
    }
  }

  /// Get all services - Simple query without ordering
  Future<List<Service>> getAllServices() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => Service.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching all services: $e');
      rethrow;
    }
  }

  /// Get a page of services for infinite scroll / pagination
  Future<ServicePage> getServicesPage({
    int limit = 8,
    DocumentSnapshot? startAfterDocument,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      final querySnapshot = await query.get();
      final services = querySnapshot.docs
          .map((doc) => Service.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return ServicePage(
        services: services,
        lastDocument: querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : startAfterDocument,
        hasMore: querySnapshot.docs.length == limit,
      );
    } catch (e) {
      print('Error fetching paged services: $e');
      rethrow;
    }
  }

  /// Get services filtered by nail artist and/or category
  /// Pass null for either parameter to skip that filter
  /// Simple query without complex ordering to avoid index requirements
  Future<List<Service>> getServicesByFilters({
    String? nailArtistProfileId,
    String? categoryId,
  }) async {
    try {
      Query query = _firestore.collection(_collection);

      if (nailArtistProfileId != null) {
        query = query.where('nailArtistProfileId', isEqualTo: nailArtistProfileId);
      }

      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => Service.fromFirestore(doc.data() as Map<String,dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching services by filters: $e');
      rethrow;
    }
  }

  /// Get services by nail artist profile (convenience method)
  Future<List<Service>> getServicesByNailArtist(String nailArtistProfileId) async {
    return getServicesByFilters(nailArtistProfileId: nailArtistProfileId);
  }

  /// Get services by category (convenience method)
  Future<List<Service>> getServicesByCategory(String categoryId) async {
    return getServicesByFilters(categoryId: categoryId);
  }

  /// Get active services - Simple query without complex ordering
  Future<List<Service>> getActiveServices() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Service.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching active services: $e');
      rethrow;
    }
  }

  /// Update a service
  Future<void> updateService({
    required String serviceId,
    String? categoryId,
    String? name,
    String? description,
    double? price,
    int? durationMinutes,
    String? imageUrl,
    bool? isActive,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (categoryId != null) updateData['categoryId'] = categoryId;
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (price != null) updateData['price'] = price;
      if (durationMinutes != null) updateData['durationMinutes'] = durationMinutes;
      if (imageUrl != null) updateData['imageUrl'] = imageUrl;
      if (isActive != null) updateData['isActive'] = isActive;

      await _firestore.collection(_collection).doc(serviceId).update(updateData);
    } catch (e) {
      print('Error updating service: $e');
      rethrow;
    }
  }

  /// Delete a service
  Future<void> deleteService(String serviceId) async {
    try {
      await _firestore.collection(_collection).doc(serviceId).delete();
    } catch (e) {
      print('Error deleting service: $e');
      rethrow;
    }
  }

  /// Get services as a real-time stream, filtered by nail artist and/or category
  /// Simple query without complex ordering to avoid index requirements
  Stream<List<Service>> getServicesStream({
    String? nailArtistProfileId,
    String? categoryId,
  }) {
    Query query = _firestore.collection(_collection);

    if (nailArtistProfileId != null) {
      query = query.where('nailArtistProfileId', isEqualTo: nailArtistProfileId);
    }

    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Service.fromFirestore(doc.data() as Map<String,dynamic>, doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching services stream: $error');
    });
  }

  /// Get services by nail artist as a real-time stream (convenience method)
  Stream<List<Service>> getServicesByNailArtistStream(String nailArtistProfileId) {
    return getServicesStream(nailArtistProfileId: nailArtistProfileId);
  }

  /// Get active services as a real-time stream - Simple query
  Stream<List<Service>> getActiveServicesStream() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Service.fromFirestore(doc.data(), doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching active services stream: $error');
    });
  }
}





