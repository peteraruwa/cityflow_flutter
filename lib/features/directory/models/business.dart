class Business {
  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.address,
    required this.phone,
    required this.lat,
    required this.lng,
  });

  final String id;
  final String name;
  final String category;
  final String subcategory;
  final String description;
  final String address;
  final String phone;
  final double lat;
  final double lng;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subcategory: json['subcategory'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
    );
  }
}
