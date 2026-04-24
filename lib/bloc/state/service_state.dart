part of '../cubit/service_cubit.dart';

/// Base state for service operations
abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ServiceInitial extends ServiceState {
  const ServiceInitial();
}

/// Loading state
class ServiceLoading extends ServiceState {
  const ServiceLoading();
}

/// State when services are loaded successfully
class ServiceLoaded extends ServiceState {
  final List<Service> services;

  const ServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

/// State for paginated service lists with infinite scroll support
class ServicePagedLoaded extends ServiceState {
  final List<Service> services;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  const ServicePagedLoaded(
    this.services, {
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  ServicePagedLoaded copyWith({
    List<Service>? services,
    bool? hasMore,
    bool? isLoadingMore,
    String? loadMoreError,
  }) {
    return ServicePagedLoaded(
      services ?? this.services,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError,
    );
  }

  @override
  List<Object?> get props => [services, hasMore, isLoadingMore, loadMoreError];
}

/// State when a single service is loaded
class ServiceDetailLoaded extends ServiceState {
  final Service service;

  const ServiceDetailLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

/// State when service creation is successful
class ServiceCreated extends ServiceState {
  final String serviceId;

  const ServiceCreated(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

/// State when service is updated successfully
class ServiceUpdated extends ServiceState {
  final Service service;

  const ServiceUpdated(this.service);

  @override
  List<Object?> get props => [service];
}

/// State when service is deleted successfully
class ServiceDeleted extends ServiceState {
  final String serviceId;

  const ServiceDeleted(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

/// Error state
class ServiceError extends ServiceState {
  final String message;
  final StackTrace? stackTrace;

  const ServiceError(this.message, {this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}


