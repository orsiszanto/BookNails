class Appointment {
  final String id;
  final String userId;
  final String nailArtistProfileId;
  final String serviceId;
  final DateTime appointmentDate;
  final String startTime; // HH:mm format
  final int requestedDurationMinutes;
  final int? estimatedDurationMinutes;
  final String? note;
  final String status; // 'pending', 'confirmed', 'modification_requested', 'cancel_requested', 'cancelled', 'rejected'
  final DateTime createdAt;
  final DateTime? updatedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.nailArtistProfileId,
    required this.serviceId,
    required this.appointmentDate,
    required this.startTime,
    required this.requestedDurationMinutes,
    this.estimatedDurationMinutes,
    this.note,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create an Appointment from Firestore document data
  factory Appointment.fromFirestore(Map<String, dynamic> data, String id) {
    return Appointment(
      id: id,
      userId: data['userId'] ?? '',
      nailArtistProfileId: data['nailArtistProfileId'] ?? '',
      serviceId: data['serviceId'] ?? '',
      appointmentDate: (data['appointmentDate'] as dynamic)?.toDate() ?? DateTime.now(),
      startTime: data['startTime'] ?? '',
      requestedDurationMinutes: data['requestedDurationMinutes'] ?? 0,
      estimatedDurationMinutes: data['estimatedDurationMinutes'],
      note: data['note'],
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate(),
    );
  }

  /// Convert Appointment to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nailArtistProfileId': nailArtistProfileId,
      'serviceId': serviceId,
      'appointmentDate': appointmentDate,
      'startTime': startTime,
      'requestedDurationMinutes': requestedDurationMinutes,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'note': note,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  /// Create a copy of Appointment with some fields replaced
  Appointment copyWith({
    String? id,
    String? userId,
    String? nailArtistProfileId,
    String? serviceId,
    DateTime? appointmentDate,
    String? startTime,
    int? requestedDurationMinutes,
    int? estimatedDurationMinutes,
    String? note,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nailArtistProfileId: nailArtistProfileId ?? this.nailArtistProfileId,
      serviceId: serviceId ?? this.serviceId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      requestedDurationMinutes: requestedDurationMinutes ?? this.requestedDurationMinutes,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
