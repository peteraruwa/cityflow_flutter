import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage_service.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController(ref.read(storageServiceProvider));
});

class ProfileState {
  const ProfileState({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  ProfileState copyWith({
    String? name,
    String? email,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(this._storageService)
      : super(
          const ProfileState(
            name: 'CityFlow User',
            email: 'user@cityflow.ng',
          ),
        ) {
    _load();
  }

  static const _nameKey = 'profile_name';
  static const _emailKey = 'profile_email';

  final StorageService _storageService;

  Future<void> _load() async {
    final name = await _storageService.getString(_nameKey);
    final email = await _storageService.getString(_emailKey);

    state = state.copyWith(
      name: name ?? state.name,
      email: email ?? state.email,
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    await _storageService.saveString(_nameKey, name);
    await _storageService.saveString(_emailKey, email);
    state = state.copyWith(name: name, email: email);
  }
}
