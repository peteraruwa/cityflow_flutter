import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/locations.dart';
import '../../shared/widgets/app_screen.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/event_card.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/place_card.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeControllerProvider);

    return homeData.when(
      loading: () => const Scaffold(
        backgroundColor: kBackground,
        body: LoadingView(),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: kBackground,
        body: ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(homeControllerProvider),
        ),
      ),
      data: (data) => AppScreen(
        scrollable: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(homeControllerProvider);
            await ref.read(homeControllerProvider.future);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _HomeHeader(date: DateTime.now()),
              const SizedBox(height: 18),
              const _HeroStatusCard(),
              const SizedBox(height: 18),
              const _QuickActions(),
              const SizedBox(height: 22),
              SectionHeader(
                title: 'Featured Places',
                actionLabel: 'Map',
                onAction: () => context.goNamed('map'),
              ),
              const SizedBox(height: 10),
              if (data.places.isEmpty)
                const EmptyStateView(
                  icon: Icons.place_outlined,
                  title: 'No featured places',
                  subtitle: 'Places will appear here when available.',
                )
              else
                SizedBox(
                  height: 126,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.places.take(8).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 306,
                        child: PlaceCard(place: data.places[index]),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 22),
              SectionHeader(
                title: 'Upcoming Events',
                actionLabel: 'See all',
                onAction: () => context.goNamed('events'),
              ),
              const SizedBox(height: 10),
              if (data.events.isEmpty)
                const EmptyStateView(
                  icon: Icons.event_busy,
                  title: 'No upcoming events',
                  subtitle: 'Events will appear here when available.',
                )
              else
                ...data.events.take(3).map(
                      (event) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EventCard(event: event),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          kRedemptionCityLogoAsset,
          width: 46,
          height: 46,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.location_city,
            color: kGold,
            size: 36,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kRedemptionCityName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: kCream,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('EEEE, MMM d').format(date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kMutedText,
                    ),
              ),
            ],
          ),
        ),
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: kSurfaceHigh,
            foregroundColor: kGold,
          ),
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}

class _HeroStatusCard extends StatelessWidget {
  const _HeroStatusCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      color: kPurple.withValues(alpha: 0.18),
      borderColor: kPurpleLight.withValues(alpha: 0.34),
      child: Row(
        children: [
          const IconTile(icon: Icons.navigation_outlined, color: kGold),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'City guidance is live',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Maps, rides, events and help around Redemption City.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kMutedText,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.86,
      children: const [
        _QuickAction(
          icon: Icons.map_outlined,
          label: 'Map',
          routeName: 'map',
          color: kPurpleLight,
        ),
        _QuickAction(
          icon: Icons.directions_car_outlined,
          label: 'Ride',
          routeName: 'cityRide',
          color: kGold,
        ),
        _QuickAction(
          icon: Icons.event_outlined,
          label: 'Events',
          routeName: 'events',
          color: kPurple,
        ),
        _QuickAction(
          icon: Icons.local_hospital_outlined,
          label: 'SOS',
          routeName: 'emergency',
          color: kDanger,
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.routeName,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String routeName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      onTap: () => context.goNamed(routeName),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTile(icon: icon, color: color, size: 38),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: kCream,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
