import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

/// Service for managing categories in Firestore
class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'categories';

  /// Create a new category
  Future<String> createCategory({
    required String name,
  }) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  /// Get a single category by ID
  Future<Category?> getCategory(String categoryId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(categoryId).get();
      if (doc.exists) {
        return Category.fromFirestore(doc.data() ?? {}, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching category: $e');
      rethrow;
    }
  }

  /// Get all categories
  Future<List<Category>> getAllCategories() async {
    try {
      final querySnapshot =
          await _firestore.collection(_collection).orderBy('createdAt', descending: true).get();
      return querySnapshot.docs
          .map((doc) => Category.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching all categories: $e');
      rethrow;
    }
  }

  /// Update a category
  Future<void> updateCategory({
    required String categoryId,
    required String name,
  }) async {
    try {
      await _firestore.collection(_collection).doc(categoryId).update({
        'name': name,
      });
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection(_collection).doc(categoryId).delete();
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  /// Get categories as a real-time stream
  Stream<List<Category>> getCategoriesStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Category.fromFirestore(doc.data(), doc.id))
          .toList();
    }).handleError((error) {
      print('Error fetching categories stream: $error');
    });
  }
}

