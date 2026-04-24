class Service {
  final String id;
  final String nailArtistProfileId;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Service({
    required this.id,
    required this.nailArtistProfileId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a Service from Firestore document data
  factory Service.fromFirestore(Map<String, dynamic> data, String id) {
    return Service(
      id: id,
      nailArtistProfileId: data['nailArtistProfileId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      durationMinutes: data['durationMinutes'] ?? 0,
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate(),
    );
  }

  /// Convert Service to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'nailArtistProfileId': nailArtistProfileId,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'durationMinutes': durationMinutes,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  /// Create a copy of Service with some fields replaced
  Service copyWith({
    String? id,
    String? nailArtistProfileId,
    String? categoryId,
    String? name,
    String? description,
    double? price,
    int? durationMinutes,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      nailArtistProfileId: nailArtistProfileId ?? this.nailArtistProfileId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
