part of '../cubit/category_cubit.dart';



/// Base state for category operations
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

/// Loading state
class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// State when categories are loaded successfully
class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// State when a single category is loaded
class CategoryDetailLoaded extends CategoryState {
  final Category category;

  const CategoryDetailLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

/// State when category creation is successful
class CategoryCreated extends CategoryState {
  final String categoryId;

  const CategoryCreated(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// State when category is updated successfully
class CategoryUpdated extends CategoryState {
  final Category category;

  const CategoryUpdated(this.category);

  @override
  List<Object?> get props => [category];
}

/// State when category is deleted successfully
class CategoryDeleted extends CategoryState {
  final String categoryId;

  const CategoryDeleted(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Error state
class CategoryError extends CategoryState {
  final String message;
  final StackTrace? stackTrace;

  const CategoryError(this.message, {this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}


