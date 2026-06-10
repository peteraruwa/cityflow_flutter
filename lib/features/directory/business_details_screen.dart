import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhj_maps/mhj_maps.dart';

import '../../core/colors.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import '../emergency/emergency_service.dart';
import 'models/business.dart';

final businessDetailsProvider =
    FutureProvider.family<Business?, String>((ref, id) async {
  final placesJson = await rootBundle.loadString('assets/data/places.json');
  final businesses = (json.decode(placesJson) as List<dynamic>)
      .map((item) => Business.fromJson(item as Map<String, dynamic>))
      .where((business) => business.category != 'church')
      .toList();

  for (final business in businesses) {
    if (business.id == id) return business;
  }

  return null;
});

class BusinessDetailsScreen extends ConsumerWidget {
  const BusinessDetailsScreen({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(businessDetailsProvider(id));

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: businessAsync.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(businessDetailsProvider(id)),
          ),
          data: (business) {
            if (business == null) {
              return const Center(
                child: Text(
                  'Business not found',
                  style: TextStyle(color: kCream),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  business.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: kPurple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        _title(business.category),
                        style: const TextStyle(
                          color: kCream,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  business.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kCream.withValues(alpha: 0.72),
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  business.address.isEmpty
                      ? 'Address not available'
                      : business.address,
                  style: TextStyle(color: kCream.withValues(alpha: 0.64)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Open daily',
                  style: TextStyle(
                    color: kGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (business.phone.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => ref.read(emergencyServiceProvider).makeCall(
                          business.phone,
                          context: context,
                        ),
                    child: Text(
                      business.phone,
                      style: const TextStyle(
                        color: kGold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MhjMapsMap(
                      center:
                          MhjMapsLatLng(lat: business.lat, lng: business.lng),
                      zoom: 16,
                      interactive: false,
                      showAttribution: false,
                      theme: MhjMapsMapThemes.darkElegant,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _title(String value) {
  return value
      .split('_')
      .map((part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
