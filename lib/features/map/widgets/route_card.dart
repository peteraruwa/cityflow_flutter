import 'package:flutter/material.dart';

import '../../../core/colors.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({
    required this.distanceMeters,
    super.key,
  });

  final double distanceMeters;

  @override
  Widget build(BuildContext context) {
    final walkMinutes = (distanceMeters / 80).ceil();
    final distanceText = distanceMeters < 1000
        ? '${distanceMeters.round()} m'
        : '${(distanceMeters / 1000).toStringAsFixed(1)} km';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPurple),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_walk, color: kGold),
          const SizedBox(width: 8),
          Text(
            '$distanceText - $walkMinutes min walk',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: kCream,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
