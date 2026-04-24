import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';

part '../state/appointment_state.dart';

/// Cubit for managing appointment business logic
class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentService _appointmentService;

  AppointmentCubit(this._appointmentService) : super(const AppointmentInitial());

  /// Fetch all appointments
  Future<void> fetchAppointments() async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _appointmentService.getAllAppointments();
      emit(AppointmentLoaded(appointments));
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error fetching appointments: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch a single appointment by ID
  Future<void> fetchAppointment(String appointmentId) async {
    try {
      emit(const AppointmentLoading());
      final appointment = await _appointmentService.getAppointment(appointmentId);
      if (appointment != null) {
        emit(AppointmentDetailLoaded(appointment));
      } else {
        emit(const AppointmentError('Appointment not found'));
      }
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error fetching appointment: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch appointments with optional filters
  Future<void> fetchAppointmentsByFilters({
    String? userId,
    String? status,
  }) async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _appointmentService.getAppointmentsByFilters(
        userId: userId,
        status: status,
      );
      emit(AppointmentLoaded(appointments));
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error fetching appointments by filters: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch appointments by user
  Future<void> fetchUserAppointments(String userId) async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _appointmentService.getAppointmentsByUser(userId);
      emit(AppointmentLoaded(appointments));
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error fetching user appointments: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch appointments by nail artist
  Future<void> fetchNailArtistAppointments(String nailArtistProfileId) async {
    try {
      emit(const AppointmentLoading());
      final appointments =
          await _appointmentService.getAppointmentsByNailArtist(nailArtistProfileId);
      emit(AppointmentLoaded(appointments));
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error fetching nail artist appointments: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Fetch appointments by status
  Future<void> fetchAppointmentsByStatus(String status) async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _appointmentService.getAppointmentsByStatus(status);
      emit(AppointmentLoaded(appointments));
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error fetching appointments by status: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Create a new appointment
  Future<void> createAppointment({
    required String userId,
    required String nailArtistProfileId,
    required String serviceId,
    required DateTime appointmentDate,
    required String startTime,
    required int requestedDurationMinutes,
    String? note,
  }) async {
    try {
      emit(const AppointmentLoading());
      final appointmentId = await _appointmentService.createAppointment(
        userId: userId,
        nailArtistProfileId: nailArtistProfileId,
        serviceId: serviceId,
        appointmentDate: appointmentDate,
        startTime: startTime,
        requestedDurationMinutes: requestedDurationMinutes,
        note: note,
      );
      emit(AppointmentCreated(appointmentId));
      // Refresh the list after creation
      await fetchAppointments();
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error creating appointment: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Update an existing appointment
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
      emit(const AppointmentLoading());
      await _appointmentService.updateAppointment(
        appointmentId: appointmentId,
        serviceId: serviceId,
        appointmentDate: appointmentDate,
        startTime: startTime,
        requestedDurationMinutes: requestedDurationMinutes,
        estimatedDurationMinutes: estimatedDurationMinutes,
        note: note,
        status: status,
      );
      final updatedAppointment = await _appointmentService.getAppointment(appointmentId);
      if (updatedAppointment != null) {
        emit(AppointmentUpdated(updatedAppointment));
        // Refresh the list after update
        await fetchAppointments();
      } else {
        emit(const AppointmentError('Failed to fetch updated appointment'));
      }
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error updating appointment: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Delete an appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      emit(const AppointmentLoading());
      await _appointmentService.deleteAppointment(appointmentId);
      emit(AppointmentDeleted(appointmentId));
      // Refresh the list after deletion
      await fetchAppointments();
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error deleting appointment: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch appointments as a stream
  void watchAppointments() {
    try {
      emit(const AppointmentLoading());
      _appointmentService.getAppointmentsStream().listen((appointments) {
        emit(AppointmentLoaded(appointments));
      }).onError((error, stackTrace) {
        emit(AppointmentError(
          'Error watching appointments: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error setting up appointment stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch appointments for a user as a stream
  void watchUserAppointments(String userId) {
    try {
      emit(const AppointmentLoading());
      _appointmentService.getAppointmentsByUserStream(userId).listen((appointments) {
        emit(AppointmentLoaded(appointments));
      }).onError((error, stackTrace) {
        emit(AppointmentError(
          'Error watching user appointments: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error setting up user appointments stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch appointments for a nail artist as a stream
  void watchNailArtistAppointments(String nailArtistProfileId) {
    try {
      emit(const AppointmentLoading());
      _appointmentService
          .getAppointmentsByNailArtistStream(nailArtistProfileId)
          .listen((appointments) {
        emit(AppointmentLoaded(appointments));
      }).onError((error, stackTrace) {
        emit(AppointmentError(
          'Error watching nail artist appointments: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error setting up nail artist appointments stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch appointments by status as a stream
  void watchAppointmentsByStatus(String status) {
    try {
      emit(const AppointmentLoading());
      _appointmentService.getAppointmentsByStatusStream(status).listen((appointments) {
        emit(AppointmentLoaded(appointments));
      }).onError((error, stackTrace) {
        emit(AppointmentError(
          'Error watching appointments by status: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error setting up appointments by status stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }

  /// Watch appointments with optional filters as a stream
  void watchAppointmentsByFilters({
    String? userId,
    String? status,
  }) {
    try {
      emit(const AppointmentLoading());
      _appointmentService
          .getAppointmentsStreamByFilters(
            userId: userId,
            status: status,
          )
          .listen((appointments) {
        emit(AppointmentLoaded(appointments));
      }).onError((error, stackTrace) {
        emit(AppointmentError(
          'Error watching appointments by filters: $error',
          stackTrace: stackTrace,
        ));
      });
    } catch (e, stackTrace) {
      emit(AppointmentError(
        'Error setting up appointments by filters stream: $e',
        stackTrace: stackTrace,
      ));
    }
  }
}

