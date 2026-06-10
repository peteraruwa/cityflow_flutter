import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../models/place.dart';
import 'app_screen.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    required this.place,
    this.imageUrl,
    this.onTap,
    super.key,
  });

  final Place place;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          SizedBox(
            width: 96,
            height: 104,
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (_, __) => const ColoredBox(color: kSurfaceHigh),
              errorWidget: (_, __, ___) => const ColoredBox(
                color: kSurfaceHigh,
                child: Icon(Icons.place_outlined, color: kGold),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: kCream,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 9),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: kPurple.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: kPurpleLight.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      child: Text(
                        place.category,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: kPurpleLight,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
