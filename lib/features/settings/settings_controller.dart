import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage_service.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, bool>((ref) {
  return SettingsController(ref.read(storageServiceProvider));
});

class SettingsController extends StateNotifier<bool> {
  SettingsController(this._storageService) : super(true) {
    _load();
  }

  static const _notificationsKey = 'notifications_enabled';

  final StorageService _storageService;

  Future<void> _load() async {
    state = await _storageService.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _storageService.saveBool(_notificationsKey, value);
    state = value;
  }
}
