import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/lost_item.dart';

final lostFoundControllerProvider =
    StateNotifierProvider<LostFoundController, LostFoundState>((ref) {
  return LostFoundController();
});

class LostFoundState {
  const LostFoundState({
    required this.tabIndex,
    required this.items,
    required this.isLoading,
    this.errorMessage,
    this.title = '',
    this.description = '',
    this.category = 'Electronics',
    this.dateLost,
    this.locationFound = '',
    this.contactPhone = '',
  });

  final int tabIndex;
  final List<LostItem> items;
  final bool isLoading;
  final String? errorMessage;
  final String title;
  final String description;
  final String category;
  final DateTime? dateLost;
  final String locationFound;
  final String contactPhone;

  List<LostItem> get lostItems =>
      items.where((item) => item.status == LostItemStatus.lost).toList();

  List<LostItem> get foundItems =>
      items.where((item) => item.status == LostItemStatus.found).toList();

  LostFoundState copyWith({
    int? tabIndex,
    List<LostItem>? items,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? title,
    String? description,
    String? category,
    DateTime? dateLost,
    bool clearDateLost = false,
    String? locationFound,
    String? contactPhone,
  }) {
    return LostFoundState(
      tabIndex: tabIndex ?? this.tabIndex,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dateLost: clearDateLost ? null : dateLost ?? this.dateLost,
      locationFound: locationFound ?? this.locationFound,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }
}

class LostFoundController extends StateNotifier<LostFoundState> {
  LostFoundController()
      : super(
          const LostFoundState(
            tabIndex: 0,
            items: [],
            isLoading: true,
          ),
        ) {
    _loadItems();
  }

  Future<void> _loadItems() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final itemsJson =
          await rootBundle.loadString('assets/data/lost_items.json');
      final items = (json.decode(itemsJson) as List<dynamic>)
          .map((item) => LostItem.fromJson(item as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
        items: items,
        isLoading: false,
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> retryLoadItems() {
    return _loadItems();
  }

  void setTabIndex(int index) {
    state = state.copyWith(tabIndex: index);
  }

  void setTitle(String value) {
    state = state.copyWith(title: value);
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setCategory(String value) {
    state = state.copyWith(category: value);
  }

  void setDateLost(DateTime value) {
    state = state.copyWith(dateLost: value);
  }

  void setLocationFound(String value) {
    state = state.copyWith(locationFound: value);
  }

  void setContactPhone(String value) {
    state = state.copyWith(contactPhone: value);
  }

  void submitReport() {
    final item = LostItem(
      id: 'lost_${DateTime.now().microsecondsSinceEpoch}',
      title: state.title,
      description: state.description,
      category: state.category,
      dateLost:
          (state.dateLost ?? DateTime.now()).toIso8601String().split('T').first,
      locationFound: state.locationFound,
      imageUrl: '',
      status: LostItemStatus.lost,
      contactPhone: state.contactPhone,
    );

    state = state.copyWith(
      items: [item, ...state.items],
      title: '',
      description: '',
      category: 'Electronics',
      clearDateLost: true,
      locationFound: '',
      contactPhone: '',
    );
  }

  void addItem(LostItem item) {
    state = state.copyWith(items: [item, ...state.items]);
  }
}
