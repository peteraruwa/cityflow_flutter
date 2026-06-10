import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/event_detail.dart';

final eventsControllerProvider =
    AsyncNotifierProvider<EventsController, EventsState>(
  EventsController.new,
);

class EventsState {
  const EventsState({
    required this.events,
    this.selectedCategory = 'All',
  });

  final List<EventDetail> events;
  final String selectedCategory;

  List<EventDetail> get filteredEvents {
    final sortedEvents = [...events]
      ..sort((a, b) => _eventDateTime(a).compareTo(_eventDateTime(b)));

    if (selectedCategory == 'All') return sortedEvents;

    return sortedEvents.where((event) {
      return _filterCategory(event.category) == selectedCategory;
    }).toList();
  }

  EventsState copyWith({
    List<EventDetail>? events,
    String? selectedCategory,
  }) {
    return EventsState(
      events: events ?? this.events,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  static String _filterCategory(String value) {
    if (value == 'Services') return 'Services';
    if (value == 'Special' || value == 'Special Services') return 'Special';
    return 'Programs';
  }

  static DateTime _eventDateTime(EventDetail event) {
    return DateTime.tryParse('${event.date} ${event.time}') ??
        DateTime.tryParse(event.date) ??
        DateTime(9999);
  }
}

class EventsController extends AsyncNotifier<EventsState> {
  @override
  Future<EventsState> build() async {
    final eventsJson = await rootBundle.loadString('assets/data/events.json');
    final events = (json.decode(eventsJson) as List<dynamic>)
        .map((item) => EventDetail.fromJson(item as Map<String, dynamic>))
        .toList();

    return EventsState(events: events);
  }

  void setCategory(String category) {
    final value = state.valueOrNull;
    if (value == null) return;
    state = AsyncData(value.copyWith(selectedCategory: category));
  }
}
