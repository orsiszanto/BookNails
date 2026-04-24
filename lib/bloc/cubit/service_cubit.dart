import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/service.dart';
import '../../services/service_service.dart';

part '../state/service_state.dart';

/// Cubit for managing service business logic
class ServiceCubit extends Cubit<ServiceState> {
  final ServiceService _serviceService;

  ServiceCubit(this._serviceService) : super(const ServiceInitial());

  /// Fetch all services
  Future<void> fetchServices() async {
    try {
      emit(const ServiceLoading());
      final services = await _serviceService.getAllServices();
      emit(ServiceLoaded(services));
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error fetching services: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch a single service by ID
  Future<void> fetchService(String serviceId) async {
    try {
      emit(const ServiceLoading());
      final service = await _serviceService.getService(serviceId);
      if (service != null) {
        emit(ServiceDetailLoaded(service));
      } else {
        emit(const ServiceError('Service not found'));
      }
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error fetching service: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch services with optional filters
  Future<void> fetchServicesByFilters({
    String? nailArtistProfileId,
    String? categoryId,
  }) async {
    try {
      emit(const ServiceLoading());
      final services = await _serviceService.getServicesByFilters(
        nailArtistProfileId: nailArtistProfileId,
        categoryId: categoryId,
      );
      emit(ServiceLoaded(services));
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error fetching services by filters: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch active services only
  Future<void> fetchActiveServices() async {
    try {
      emit(const ServiceLoading());
      final services = await _serviceService.getActiveServices();
      emit(ServiceLoaded(services));
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error fetching active services: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Create a new service
  Future<void> createService({
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
      emit(const ServiceLoading());
      final serviceId = await _serviceService.createService(
        nailArtistProfileId: nailArtistProfileId,
        categoryId: categoryId,
        name: name,
        description: description,
        price: price,
        durationMinutes: durationMinutes,
        imageUrl: imageUrl,
        isActive: isActive,
      );
      emit(ServiceCreated(serviceId));
      // Refresh the list after creation
      await fetchServices();
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error creating service: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Update an existing service
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
      emit(const ServiceLoading());
      await _serviceService.updateService(
        serviceId: serviceId,
        categoryId: categoryId,
        name: name,
        description: description,
        price: price,
        durationMinutes: durationMinutes,
        imageUrl: imageUrl,
        isActive: isActive,
      );
      final updatedService = await _serviceService.getService(serviceId);
      if (updatedService != null) {
        emit(ServiceUpdated(updatedService));
        // Refresh the list after update
        await fetchServices();
      } else {
        emit(const ServiceError('Failed to fetch updated service'));
      }
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error updating service: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Delete a service
  Future<void> deleteService(String serviceId) async {
    try {
      emit(const ServiceLoading());
      await _serviceService.deleteService(serviceId);
      emit(ServiceDeleted(serviceId));
      // Refresh the list after deletion
      await fetchServices();
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error deleting service: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch services as a stream with optional filters
  void watchServices({
    String? nailArtistProfileId,
    String? categoryId,
  }) {
    try {
      emit(const ServiceLoading());
      _serviceService
          .getServicesStream(
            nailArtistProfileId: nailArtistProfileId,
            categoryId: categoryId,
          )
          .listen((services) {
        emit(ServiceLoaded(services));
      }).onError((error, stackTrace) {
        emit(ServiceError(
          'Error watching services: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error setting up service stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch active services as a stream
  void watchActiveServices() {
    try {
      emit(const ServiceLoading());
      _serviceService.getActiveServicesStream().listen((services) {
        emit(ServiceLoaded(services));
      }).onError((error, stackTrace) {
        emit(ServiceError(
          'Error watching active services: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(ServiceError(
        'Error setting up active services stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }
}


