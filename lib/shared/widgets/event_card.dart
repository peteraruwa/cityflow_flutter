import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/colors.dart';
import '../models/event.dart';
import 'app_screen.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event, this.onTap, super.key});

  final Event event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(event.date);
    final day = date == null ? '--' : DateFormat('dd').format(date);
    final month = date == null ? 'DATE' : DateFormat('MMM').format(date);

    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.all(13),
      borderColor: kGold.withValues(alpha: 0.28),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 58,
            decoration: BoxDecoration(
              color: kGold.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kGold.withValues(alpha: 0.26)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kGold,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Text(
                  month.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: kMutedText,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${event.time} • ${event.venue}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kMutedText,
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
