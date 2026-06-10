import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashControllerProvider = Provider<SplashController>((ref) {
  final controller = SplashController();
  ref.onDispose(controller.dispose);
  return controller;
});

class SplashController {
  Timer? _timer;

  void start(VoidCallback onComplete) {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), onComplete);
  }

  void dispose() {
    _timer?.cancel();
  }
}
