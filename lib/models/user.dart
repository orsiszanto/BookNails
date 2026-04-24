class User {
  final String uid;
  final String name;
  final String email;
  final String role; // 'user' or 'nail_artist'
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a User from Firestore document data
  factory User.fromFirestore(Map<String, dynamic> data, String uid) {
    return User(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      phoneNumber: data['phoneNumber'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate(),
    );
  }

  /// Convert User to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  /// Create a copy of User with some fields replaced
  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}




