enum LostItemStatus {
  lost,
  found;

  static LostItemStatus fromJson(String value) {
    return value == 'found' ? LostItemStatus.found : LostItemStatus.lost;
  }
}

class LostItem {
  const LostItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateLost,
    required this.locationFound,
    required this.imageUrl,
    required this.status,
    required this.contactPhone,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String dateLost;
  final String locationFound;
  final String imageUrl;
  final LostItemStatus status;
  final String contactPhone;

  factory LostItem.fromJson(Map<String, dynamic> json) {
    return LostItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      dateLost: json['dateLost'] as String? ?? '',
      locationFound: json['locationFound'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      status: LostItemStatus.fromJson(json['status'] as String? ?? ''),
      contactPhone: json['contactPhone'] as String? ?? '',
    );
  }
}
