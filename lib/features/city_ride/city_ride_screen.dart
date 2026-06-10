import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/app_screen.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/empty_state_view.dart';
import 'ride_controller.dart';
import 'ride_service.dart';

class CityRideScreen extends ConsumerWidget {
  const CityRideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(rideServiceProvider).getRideOptions();

    return AppScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(
            title: 'CityRide',
            subtitle: 'Move between camp zones with quick ride requests.',
          ),
          const SizedBox(height: 16),
          const _RidePlannerCard(),
          const SizedBox(height: 22),
          const SectionHeader(title: 'Choose a ride'),
          const SizedBox(height: 10),
          if (options.isEmpty)
            const EmptyStateView(
              icon: Icons.directions_car_outlined,
              title: 'No ride options',
              subtitle: 'Ride options will appear here when available.',
            )
          else
            ...options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RideOptionCard(option: option),
              ),
            ),
        ],
      ),
    );
  }
}

class _RidePlannerCard extends StatelessWidget {
  const _RidePlannerCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      color: kGold.withValues(alpha: 0.12),
      borderColor: kGold.withValues(alpha: 0.28),
      child: Row(
        children: [
          const IconTile(icon: Icons.route_outlined, color: kGold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan your pickup',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Set pickup and drop-off inside Redemption City.',
                  style: TextStyle(color: kMutedText, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RideOptionCard extends ConsumerWidget {
  const _RideOptionCard({required this.option});

  final RideOption option;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumCard(
      child: Row(
        children: [
          IconTile(icon: _vehicleIcon(option.type), color: kPurpleLight),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.type,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${option.waitTime} wait • ${option.fareEstimate}',
                  style: const TextStyle(color: kMutedText),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 92,
            child: CustomButton(
              label: 'Request',
              onPressed: () {
                ref
                    .read(rideControllerProvider.notifier)
                    .setVehicleType(option.type);
                context.goNamed('requestRide');
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _vehicleIcon(String type) {
    if (type == 'Bus') return Icons.directions_bus;
    if (type == 'Shuttle') return Icons.airport_shuttle;
    return Icons.local_taxi;
  }
}
