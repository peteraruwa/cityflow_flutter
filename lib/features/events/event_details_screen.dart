import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  const EventDetailsScreen({required this.id, super.key});
  final String id;

  Color _tagColor(String category) {
    switch (category.toLowerCase()) {
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
                child: Text('Event not found',
                    style: TextStyle(color: kCream)),
              );
            }

            final color = _tagColor(event.category);
            final parts = event.date.split('-');
            final day = parts.length >= 2
                ? _monthName(int.tryParse(parts[1]) ?? 1)
                : '';
            final num = parts.length >= 3 ? parts[2] : '';

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
              children: [
                // Back button
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: kCream),
                      style: IconButton.styleFrom(
                          backgroundColor: kSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Hero card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withValues(alpha: 0.5),
                        color.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: color.withValues(alpha: 0.35)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              event.category,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: kCream,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: kSurface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  day,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  num,
                                  style: const TextStyle(
                                    color: kCream,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time_outlined,
                                      color: kMutedText, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.time,
                                    style: const TextStyle(
                                        color: kCream,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      color: kMutedText, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.venue,
                                    style: const TextStyle(
                                        color: kMutedText),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // About
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About this event',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: kCream,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        event.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: kMutedText,
                              height: 1.55,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Action button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reminder set!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none,
                        color: kCream),
                    label: const Text(
                      'Set a Reminder',
                      style: TextStyle(
                        color: kCream,
                        fontWeight: FontWeight.w700,
                      ),
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

  String _monthName(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }
}
