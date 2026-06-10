class Church {
  const Church({
    required this.id,
    required this.name,
    required this.description,
    required this.subcategory,
    required this.lat,
    required this.lng,
    required this.phone,
  });

  final String id;
  final String name;
  final String description;
  final String subcategory;
  final double lat;
  final double lng;
  final String phone;

  factory Church.fromJson(Map<String, dynamic> json) {
    return Church(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subcategory: json['subcategory'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
      phone: json['phone'] as String? ?? '',
    );
  }
}
