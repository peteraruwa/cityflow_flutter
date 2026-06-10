import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveString(String key, String value) async {
    await (await _prefs).setString(key, value);
  }

  Future<String?> getString(String key) async {
    return (await _prefs).getString(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await (await _prefs).setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return (await _prefs).getBool(key);
  }

  Future<void> clearAll() async {
    await (await _prefs).clear();
  }
}
