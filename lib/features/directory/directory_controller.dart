import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/business.dart';

final directoryControllerProvider =
    AsyncNotifierProvider<DirectoryController, DirectoryState>(
  DirectoryController.new,
);

class DirectoryState {
  const DirectoryState({
    required this.businesses,
    this.searchQuery = '',
    this.selectedCategory = 'All',
  });

  final List<Business> businesses;
  final String searchQuery;
  final String selectedCategory;

  List<String> get categories {
    return [
      'All',
      ...businesses.map((business) => business.category).toSet().toList()
        ..sort(),
    ];
  }

  List<Business> get filteredBusinesses {
    final query = searchQuery.trim().toLowerCase();

    return businesses.where((business) {
      final matchesSearch = query.isEmpty ||
          business.name.toLowerCase().contains(query) ||
          business.description.toLowerCase().contains(query) ||
          business.category.toLowerCase().contains(query);
      final matchesCategory =
          selectedCategory == 'All' || business.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Map<String, List<Business>> get groupedBusinesses {
    final grouped = <String, List<Business>>{};
    for (final business in filteredBusinesses) {
      grouped.putIfAbsent(business.category, () => []).add(business);
    }
    return grouped;
  }

  DirectoryState copyWith({
    List<Business>? businesses,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return DirectoryState(
      businesses: businesses ?? this.businesses,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class DirectoryController extends AsyncNotifier<DirectoryState> {
  @override
  Future<DirectoryState> build() async {
    final placesJson = await rootBundle.loadString('assets/data/places.json');
    final businesses = (json.decode(placesJson) as List<dynamic>)
        .map((item) => Business.fromJson(item as Map<String, dynamic>))
        .where((business) => business.category != 'church')
        .toList();

    return DirectoryState(businesses: businesses);
  }

  void setSearchQuery(String query) {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(searchQuery: query));
  }

  void setCategory(String category) {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(selectedCategory: category));
  }
}
