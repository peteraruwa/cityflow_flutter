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
  });

  final List<Place> places;
  final List<Event> events;
}

class HomeController extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() async {
    final placesJson = await rootBundle.loadString('assets/data/places.json');
    final eventsJson = await rootBundle.loadString('assets/data/events.json');

    final places = (json.decode(placesJson) as List<dynamic>)
        .map((item) => Place.fromJson(item as Map<String, dynamic>))
        .toList();
    final events = (json.decode(eventsJson) as List<dynamic>)
        .map((item) => Event.fromJson(item as Map<String, dynamic>))
        .toList();

    return HomeData(
      places: places,
      events: events,
    );
  }
}
