import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/place.dart';

final mapControllerProvider =
    AsyncNotifierProvider<CityMapController, CityMapState>(
  CityMapController.new,
);

class CityMapState {
  const CityMapState({
    required this.places,
    this.selectedPlace,
    this.searchText = '',
  });

  final List<Place> places;
  final Place? selectedPlace;
  final String searchText;

  List<Place> get filteredPlaces {
    final query = searchText.trim().toLowerCase();
    if (query.isEmpty) return places;

    return places.where((place) {
      return place.name.toLowerCase().contains(query) ||
          place.category.toLowerCase().contains(query) ||
          place.subcategory.toLowerCase().contains(query);
    }).toList();
  }

  CityMapState copyWith({
    List<Place>? places,
    Place? selectedPlace,
    bool clearSelectedPlace = false,
    String? searchText,
  }) {
    return CityMapState(
      places: places ?? this.places,
      selectedPlace:
          clearSelectedPlace ? null : selectedPlace ?? this.selectedPlace,
      searchText: searchText ?? this.searchText,
    );
  }
}

class CityMapController extends AsyncNotifier<CityMapState> {
  @override
  Future<CityMapState> build() async {
    final placesJson = await rootBundle.loadString('assets/data/places.json');
    final places = (json.decode(placesJson) as List<dynamic>)
        .map((item) => Place.fromJson(item as Map<String, dynamic>))
        .toList();

    return CityMapState(places: places);
  }

  void selectPlace(Place place) {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(selectedPlace: place));
  }

  void clearSelectedPlace() {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(clearSelectedPlace: true));
  }

  void setSearchText(String text) {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(searchText: text));
  }
}
