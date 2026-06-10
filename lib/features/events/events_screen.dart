import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'events_controller.dart';
import 'models/event_detail.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  static const _filters = ['All', 'Services', 'Programs', 'Special'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: eventsState.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(eventsControllerProvider),
          ),
          data: (state) {
            final events = state.filteredEvents;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 58,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isActive = filter == state.selectedCategory;

                      return ChoiceChip(
                        label: Text(filter),
                        selected: isActive,
                        selectedColor: kPurple,
                        backgroundColor: kCream.withValues(alpha: 0.3),
                        labelStyle: TextStyle(
                          color: isActive ? kCream : kBackground,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (_) {
                          ref
                              .read(eventsControllerProvider.notifier)
                              .setCategory(filter);
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: events.isEmpty
                      ? const EmptyStateView(
                          icon: Icons.event_busy,
                          title: 'No events found',
                          subtitle: 'Try another event category.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: events.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _EventListTile(event: events[index]);
                          },
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

class _EventListTile extends StatelessWidget {
  const _EventListTile({required this.event});

  final EventDetail event;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse('${event.date} ${event.time}');
    final dateText = date == null
        ? '${event.date} ${event.time}'
        : DateFormat('EEE, MMM d - h:mm a').format(date);

    return ListTile(
      tileColor: kCream.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: kGold),
      ),
      title: Text(
        event.title,
        style: const TextStyle(
          color: kCream,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        '$dateText\n${event.venue}',
        style: TextStyle(color: kCream.withValues(alpha: 0.64)),
      ),
      isThreeLine: true,
      onTap: () => context.goNamed(
        'eventDetails',
        pathParameters: {'id': event.id},
      ),
    );
  }
}
