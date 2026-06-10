import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mhj_maps/mhj_maps.dart';

import '../../core/colors.dart';
import '../../core/locations.dart';
import 'ride_controller.dart';

class RequestRideScreen extends ConsumerWidget {
  const RequestRideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideState = ref.watch(rideControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _RideTextField(
              label: 'Pickup Location',
              onChanged: ref.read(rideControllerProvider.notifier).setPickup,
            ),
            const SizedBox(height: 14),
            _RideTextField(
              label: 'Drop-off Location',
              onChanged: ref.read(rideControllerProvider.notifier).setDropoff,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const MhjMapsMap(
                  center: MhjMapsLatLng(
                    lat: kRedemptionCityLat,
                    lng: kRedemptionCityLon,
                  ),
                  zoom: 15,
                  interactive: false,
                  showAttribution: false,
                  theme: MhjMapsMapThemes.darkElegant,
                ),
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurple,
                foregroundColor: kCream,
              ),
              onPressed: () => _showBookingSummary(context, rideState),
              child: const Text('Confirm Ride'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingSummary(BuildContext context, RideState state) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: kCream,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 14),
              _SummaryRow(label: 'Vehicle', value: state.selectedVehicleType),
              _SummaryRow(label: 'Pickup', value: state.pickup),
              _SummaryRow(label: 'Drop-off', value: state.dropoff),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    foregroundColor: kCream,
                  ),
                  onPressed: () => context.goNamed('cityRide'),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RideTextField extends StatelessWidget {
  const _RideTextField({
    required this.label,
    required this.onChanged,
  });

  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: kCream),
      cursorColor: kPurple,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kCream.withValues(alpha: 0.7)),
        filled: true,
        fillColor: kCream.withValues(alpha: 0.06),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kCream.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPurple, width: 2),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$label: ${value.isEmpty ? 'Not set' : value}',
        style: TextStyle(color: kCream.withValues(alpha: 0.8)),
      ),
    );
  }
}
