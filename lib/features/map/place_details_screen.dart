import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/colors.dart';
import '../../core/location_service.dart';
import '../../shared/models/place.dart';
import 'map_service.dart';
import 'widgets/route_card.dart';

class PlaceDetailsScreen extends ConsumerWidget {
  const PlaceDetailsScreen({
    this.place,
    this.id = '',
    super.key,
  });

  final Place? place;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPlace = place;
    if (selectedPlace == null) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: Center(
          child: Text('Place not found', style: TextStyle(color: kCream)),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<double>(
          future: _distanceToPlace(ref, selectedPlace),
          builder: (context, snapshot) {
            final distanceMeters = snapshot.data ?? 0;
            final formattedDistance =
                ref.read(mapServiceProvider).formatDistance(distanceMeters);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: kCream.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  selectedPlace.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 10),
                DecoratedBox(
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
                      selectedPlace.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kCream,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  selectedPlace.address.isEmpty
                      ? 'Address not available'
                      : selectedPlace.address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kCream.withValues(alpha: 0.72),
                      ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Distance: $formattedDistance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kGold,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                RouteCard(distanceMeters: distanceMeters),
                if (selectedPlace.phone.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPurple,
                        foregroundColor: kCream,
                      ),
                      onPressed: () => _call(selectedPlace.phone),
                      icon: const Icon(Icons.call),
                      label: const Text('Call'),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<double> _distanceToPlace(WidgetRef ref, Place place) async {
    final position =
        await ref.read(locationServiceProvider).getCurrentPosition();
    return ref.read(mapServiceProvider).distanceInMeters(
          fromLat: position.latitude,
          fromLng: position.longitude,
          toLat: place.lat,
          toLng: place.lng,
        );
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
