class NailArtistProfile {
  final String id;
  final String userId;
  final String salonName;
  final String address;
  final String phoneNumber;
  final String? profileImageUrl;
  final Map<String, dynamic> workingHours; // e.g., {"monday": {"start": "09:00", "end": "18:00"}}
  final DateTime createdAt;
  final DateTime? updatedAt;

  NailArtistProfile({
    required this.id,
    required this.userId,
    required this.salonName,
    required this.address,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.workingHours,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a NailArtistProfile from Firestore document data
  factory NailArtistProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return NailArtistProfile(
      id: id,
      userId: data['userId'] ?? '',
      salonName: data['salonName'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      workingHours: data['workingHours'] ?? {},
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate(),
    );
  }

  /// Convert NailArtistProfile to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'salonName': salonName,
      'address': address,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'workingHours': workingHours,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  /// Create a copy of NailArtistProfile with some fields replaced
  NailArtistProfile copyWith({
    String? id,
    String? userId,
    String? salonName,
    String? address,
    String? phoneNumber,
    String? profileImageUrl,
    Map<String, dynamic>? workingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NailArtistProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      salonName: salonName ?? this.salonName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      workingHours: workingHours ?? this.workingHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
