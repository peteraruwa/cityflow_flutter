class Place {
  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.lat,
    required this.lng,
    required this.phone,
    required this.address,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final String subcategory;
  final double lat;
  final double lng;
  final String phone;
  final String address;

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subcategory: json['subcategory'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }
}
