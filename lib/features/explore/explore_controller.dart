import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/place.dart';

final exploreControllerProvider =
    AsyncNotifierProvider<ExploreController, ExploreData>(
  ExploreController.new,
);

class ExploreData {
  const ExploreData({required this.places});

  final List<Place> places;

  Map<String, List<Place>> get groupedByCategory {
    final grouped = <String, List<Place>>{};
    for (final place in places) {
      grouped.putIfAbsent(place.category, () => []).add(place);
    }
    return grouped;
  }

  List<Place> filterByCategory(String category) {
    final normalized = category.toLowerCase();
    return places
        .where((place) => place.category.toLowerCase() == normalized)
        .toList();
  }
}

class ExploreController extends AsyncNotifier<ExploreData> {
  @override
  Future<ExploreData> build() async {
    final placesJson = await rootBundle.loadString('assets/data/places.json');
    final places = (json.decode(placesJson) as List<dynamic>)
        .map((item) => Place.fromJson(item as Map<String, dynamic>))
        .toList();

    return ExploreData(places: places);
  }
}
