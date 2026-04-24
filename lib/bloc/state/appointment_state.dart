part of '../cubit/appointment_cubit.dart';

/// Base state for appointment operations
abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

/// Loading state
class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

/// State when appointments are loaded successfully
class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  const AppointmentLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

/// State when a single appointment is loaded
class AppointmentDetailLoaded extends AppointmentState {
  final Appointment appointment;

  const AppointmentDetailLoaded(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

/// State when appointment creation is successful
class AppointmentCreated extends AppointmentState {
  final String appointmentId;

  const AppointmentCreated(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// State when appointment is updated successfully
class AppointmentUpdated extends AppointmentState {
  final Appointment appointment;

  const AppointmentUpdated(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

/// State when appointment is deleted successfully
class AppointmentDeleted extends AppointmentState {
  final String appointmentId;

  const AppointmentDeleted(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Error state
class AppointmentError extends AppointmentState {
  final String message;
  final StackTrace? stackTrace;

  const AppointmentError(this.message, {this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}

