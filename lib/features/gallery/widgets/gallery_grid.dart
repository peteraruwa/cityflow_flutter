import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/colors.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({
    required this.images,
    super.key,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: images[index],
            fit: BoxFit.cover,
            placeholder: (_, __) => const _PurplePlaceholder(),
            errorWidget: (_, __, ___) => const ColoredBox(
              color: kBackground,
              child: Icon(Icons.image_not_supported, color: kGold),
            ),
          ),
        );
      },
    );
  }
}

class _PurplePlaceholder extends StatelessWidget {
  const _PurplePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kPurple.withValues(alpha: 0.35),
      child: const Center(
        child: CircularProgressIndicator(color: kPurple),
      ),
    );
  }
}
