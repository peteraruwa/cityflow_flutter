import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhj_maps/mhj_maps.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/colors.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'models/church.dart';

final churchDetailsProvider =
    FutureProvider.family<Church?, String>((ref, id) async {
  final churchesJson = await rootBundle.loadString('assets/data/churches.json');
  final churches = (json.decode(churchesJson) as List<dynamic>)
      .map((item) => Church.fromJson(item as Map<String, dynamic>))
      .toList();

  for (final church in churches) {
    if (church.id == id) return church;
  }

  return null;
});

class ChurchDetailsScreen extends ConsumerWidget {
  const ChurchDetailsScreen({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final churchAsync = ref.watch(churchDetailsProvider(id));

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: churchAsync.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(churchDetailsProvider(id)),
          ),
          data: (church) {
            if (church == null) {
              return const Center(
                child: Text(
                  'Church not found',
                  style: TextStyle(color: kCream),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  church.name,
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
                      color: kGold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        church.subcategory,
                        style: const TextStyle(
                          color: kBackground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  church.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kCream.withValues(alpha: 0.72),
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MhjMapsMap(
                      center: MhjMapsLatLng(lat: church.lat, lng: church.lng),
                      zoom: 16,
                      interactive: false,
                      showAttribution: false,
                      theme: MhjMapsMapThemes.darkElegant,
                    ),
                  ),
                ),
                if (church.phone.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple,
                      foregroundColor: kCream,
                    ),
                    onPressed: () => _call(church.phone),
                    icon: const Icon(Icons.call),
                    label: const Text('Call'),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
