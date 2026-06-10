import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/colors.dart';

class DailyImageCard extends StatelessWidget {
  const DailyImageCard({
    required this.imageUrl,
    required this.date,
    super.key,
  });

  final String imageUrl;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGold, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => const ColoredBox(color: kPurple),
            errorWidget: (_, __, ___) => const ColoredBox(
              color: kBackground,
              child: Icon(Icons.image_not_supported, color: kGold),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 14,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: kBackground.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  DateFormat.yMMMMd().format(date),
                  style: const TextStyle(
                    color: kCream,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
