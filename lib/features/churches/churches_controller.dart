import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/church.dart';

final churchesControllerProvider =
    AsyncNotifierProvider<ChurchesController, ChurchesState>(
  ChurchesController.new,
);

class ChurchesState {
  const ChurchesState({
    required this.churches,
    this.searchQuery = '',
  });

  final List<Church> churches;
  final String searchQuery;

  List<Church> get filteredChurches {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return churches;

    return churches
        .where((church) => church.name.toLowerCase().contains(query))
        .toList();
  }

  ChurchesState copyWith({
    List<Church>? churches,
    String? searchQuery,
  }) {
    return ChurchesState(
      churches: churches ?? this.churches,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ChurchesController extends AsyncNotifier<ChurchesState> {
  @override
  Future<ChurchesState> build() async {
    final churchesJson =
        await rootBundle.loadString('assets/data/churches.json');
    final churches = (json.decode(churchesJson) as List<dynamic>)
        .map((item) => Church.fromJson(item as Map<String, dynamic>))
        .toList();

    return ChurchesState(churches: churches);
  }

  void setSearchQuery(String query) {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(searchQuery: query));
  }
}
