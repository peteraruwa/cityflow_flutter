import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/event.dart';
import '../../shared/models/place.dart';

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, HomeData>(HomeController.new);

class HomeData {
  const HomeData({
    required this.places,
    required this.events,
    required this.feed,
  });

  final List<Place> places;
  final List<Event> events;
  final Map<String, dynamic> feed;
}

class HomeController extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() async {
    final placesJson = await rootBundle.loadString('assets/data/places.json');
    final eventsJson = await rootBundle.loadString('assets/data/events.json');
    final feedJson = await rootBundle.loadString('assets/data/home_feed.json');

    final places = (json.decode(placesJson) as List<dynamic>)
        .map((item) => Place.fromJson(item as Map<String, dynamic>))
        .toList();
    final events = (json.decode(eventsJson) as List<dynamic>)
        .map((item) => Event.fromJson(item as Map<String, dynamic>))
        .toList();

    return HomeData(
      places: places,
      events: events,
      feed: json.decode(feedJson) as Map<String, dynamic>,
    );
  }
}
