class EventDetail {
  const EventDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String venue;
  final String category;

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
