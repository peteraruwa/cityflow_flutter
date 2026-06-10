import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'events_controller.dart';
import 'models/event_detail.dart';

const _tags = ['All', 'Worship', 'Special', 'Youth', 'Music', 'Study'];

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: kCream),
                    style: IconButton.styleFrom(backgroundColor: kSurface),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Events',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: kCream,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      Text(
                        "What's on",
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: kMutedText,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Tag filters
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemCount: _tags.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tag = _tags[index];
                  return eventsState.when(
                    loading: () => _TagChip(
                      tag: tag,
                      isActive: tag == 'All',
                      onTap: () {},
                    ),
                    error: (_, __) => _TagChip(
                      tag: tag,
                      isActive: tag == 'All',
                      onTap: () {},
                    ),
                    data: (state) => _TagChip(
                      tag: tag,
                      isActive: tag == state.selectedCategory,
                      onTap: () => ref
                          .read(eventsControllerProvider.notifier)
                          .setCategory(tag),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: eventsState.when(
                loading: () => const LoadingView(),
                error: (error, _) => ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(eventsControllerProvider),
                ),
                data: (state) {
                  final events = state.filteredEvents;
                  if (events.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.event_busy,
                      title: 'No events found',
                      subtitle: 'Try another tag.',
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _EventCard(event: events[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
    required this.isActive,
    required this.onTap,
  });

  final String tag;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? kPurple : kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? kPurple : kBorder),
        ),
        child: Text(
          tag,
          style: TextStyle(
            color: isActive ? kCream : kMutedText,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final EventDetail event;

  Color get _tagColor {
    switch (event.category.toLowerCase()) {
      case 'services':
        return kPurple;
      case 'special':
        return kGold;
      case 'youth':
        return kSuccess;
      default:
        return kPurpleLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final parts = event.date.split('-');
    final day = parts.length >= 2 ? _monthName(int.tryParse(parts[1]) ?? 1) : '';
    final num = parts.length >= 3 ? parts[2] : '';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.goNamed(
        'eventDetails',
        pathParameters: {'id': event.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            // Date badge
            Container(
              width: 52,
              height: 60,
              decoration: BoxDecoration(
                color: _tagColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: _tagColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      color: _tagColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    num,
                    style: const TextStyle(
                      color: kCream,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: _tagColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(
                            color: _tagColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: kCream,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: kMutedText, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        event.venue,
                        style: const TextStyle(
                            color: kMutedText, fontSize: 11),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time_outlined,
                          color: kMutedText, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        event.time,
                        style: const TextStyle(
                            color: kMutedText, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }
}
