import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/colors.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'models/event_detail.dart';

final eventDetailsProvider =
    FutureProvider.family<EventDetail?, String>((ref, id) async {
  final eventsJson = await rootBundle.loadString('assets/data/events.json');
  final events = (json.decode(eventsJson) as List<dynamic>)
      .map((item) => EventDetail.fromJson(item as Map<String, dynamic>))
      .toList();

  for (final event in events) {
    if (event.id == id) return event;
  }

  return null;
});

class EventDetailsScreen extends ConsumerWidget {
  const EventDetailsScreen({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailsProvider(id));

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: eventAsync.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(eventDetailsProvider(id)),
          ),
          data: (event) {
            if (event == null) {
              return const Center(
                child: Text(
                  'Event not found',
                  style: TextStyle(color: kCream),
                ),
              );
            }

            final date = DateTime.tryParse('${event.date} ${event.time}');
            final dateText = date == null
                ? '${event.date} ${event.time}'
                : DateFormat('EEEE, MMMM d, y - h:mm a').format(date);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 14),
                Text(
                  dateText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kGold,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  event.venue,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kCream.withValues(alpha: 0.72),
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kCream,
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    foregroundColor: kCream,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Calendar integration coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Add to Calendar'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
