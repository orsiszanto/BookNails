import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';

part '../state/category_state.dart';

/// Cubit for managing category business logic
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService _categoryService;

  CategoryCubit(this._categoryService) : super(const CategoryInitial());

  /// Fetch all categories
  Future<void> fetchCategories() async {
    try {
      emit(const CategoryLoading());
      final categories = await _categoryService.getAllCategories();
      emit(CategoryLoaded(categories));
    } catch (e, stackTrace) {
      emit(CategoryError(
        'Error fetching categories: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch a single category by ID
  Future<void> fetchCategory(String categoryId) async {
    try {
      emit(const CategoryLoading());
      final category = await _categoryService.getCategory(categoryId);
      if (category != null) {
        emit(CategoryDetailLoaded(category));
      } else {
        emit(const CategoryError('Category not found'));
      }
    } catch (e, stackTrace) {
      emit(CategoryError(
        'Error fetching category: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Create a new category
  Future<void> createCategory(String name) async {
    try {
      emit(const CategoryLoading());
      final categoryId = await _categoryService.createCategory(name: name);
      emit(CategoryCreated(categoryId));
      // Refresh the list after creation
      await fetchCategories();
    } catch (e, stackTrace) {
      emit(CategoryError(
        'Error creating category: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Update an existing category
  Future<void> updateCategory(String categoryId, String name) async {
    try {
      emit(const CategoryLoading());
      await _categoryService.updateCategory(
        categoryId: categoryId,
        name: name,
      );
      final updatedCategory = await _categoryService.getCategory(categoryId);
      if (updatedCategory != null) {
        emit(CategoryUpdated(updatedCategory));
        // Refresh the list after update
        await fetchCategories();
      } else {
        emit(const CategoryError('Failed to fetch updated category'));
      }
    } catch (e, stackTrace) {
      emit(CategoryError(
        'Error updating category: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      emit(const CategoryLoading());
      await _categoryService.deleteCategory(categoryId);
      emit(CategoryDeleted(categoryId));
      // Refresh the list after deletion
      await fetchCategories();
    } catch (e, stackTrace) {
      emit(CategoryError(
        'Error deleting category: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch categories as a stream
  void watchCategories() {
    try {
      emit(const CategoryLoading());
      _categoryService.getCategoriesStream().listen((categories) {
        emit(CategoryLoaded(categories));
      }).onError((error, stackTrace) {
        emit(CategoryError(
          'Error watching categories: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(CategoryError(
        'Error setting up category stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }
}


