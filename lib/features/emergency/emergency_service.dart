import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final emergencyServiceProvider = Provider<EmergencyService>((ref) {
  return const EmergencyService();
});

class EmergencyService {
  const EmergencyService();

  Future<void> makeCall(
    String phone, {
    BuildContext? context,
  }) async {
    final messenger =
        context == null ? null : ScaffoldMessenger.maybeOf(context);

    if (phone.isEmpty) {
      _showError(messenger, 'No phone number available');
      return;
    }

    final uri = Uri(scheme: 'tel', path: phone);
    try {
      final launched = await launchUrl(uri);
      if (!launched) {
        log('Could not launch phone URL: $uri');
        _showError(messenger, 'Could not start call');
      }
    } catch (error, stackTrace) {
      log(
        'Could not launch phone URL: $uri',
        error: error,
        stackTrace: stackTrace,
      );
      _showError(messenger, 'Could not start call');
    }
  }

  void _showError(ScaffoldMessengerState? messenger, String message) {
    messenger?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
