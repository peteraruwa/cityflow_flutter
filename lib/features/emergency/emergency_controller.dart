import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'emergency_service.dart';

final emergencyControllerProvider =
    AsyncNotifierProvider<EmergencyController, List<EmergencyContact>>(
  EmergencyController.new,
);

class EmergencyContact {
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.isPrimary,
  });

  final String id;
  final String name;
  final String role;
  final String phone;
  final bool isPrimary;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }
}

class EmergencyController extends AsyncNotifier<List<EmergencyContact>> {
  @override
  Future<List<EmergencyContact>> build() async {
    final contactsJson =
        await rootBundle.loadString('assets/data/emergency_contacts.json');
    return (json.decode(contactsJson) as List<dynamic>)
        .map((item) => EmergencyContact.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> makeCall(String phone, BuildContext context) async {
    await ref.read(emergencyServiceProvider).makeCall(
          phone,
          context: context,
        );
  }
}
