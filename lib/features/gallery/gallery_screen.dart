import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'gallery_controller.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gallery = ref.watch(galleryControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
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
                        'Picture Gallery',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: kCream,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      Text(
                        'Photos from around Redemption City',
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
            Expanded(
              child: gallery.when(
                loading: () => const LoadingView(),
                error: (error, _) => ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(galleryControllerProvider),
                ),
                data: (state) {
                  if (state.images.isEmpty) {
                    return const Center(
                      child: Text(
                        'No gallery images',
                        style: TextStyle(color: kMutedText),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: state.images.length,
                    itemBuilder: (context, index) {
                      final imageUrl = state.images[index];
                      return _GalleryCard(
                        imageUrl: imageUrl,
                        index: index,
                      );
                    },
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

const _galleryTitles = [
  'Sunday Sunrise Service',
  'Camp Aerial View',
  'Youth Convention',
  'Night Vigil',
  'Prayer Mountains',
  'Arena Worship',
  'Dawn Breaking',
  'Faith Walk',
  'City Lights',
  'Morning Glory',
];

const _galleryAuthors = [
  'Pastor Adeyemi',
  'Camp Media',
  'Youth Team',
  'Night Watch',
  'Camp Media',
  'Arena Staff',
  'City Crew',
  'Photo Ministry',
  'Camp Media',
  'City Crew',
];

const _gradients = [
  <Color>[kPurple, kPurpleDark],
  <Color>[kGold, kGoldDark],
  <Color>[kBlue, kBlue],
  <Color>[kSuccess, kSuccessDark],
  <Color>[kDanger, kDangerDark],
];

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.imageUrl, required this.index});

  final String imageUrl;
  final int index;

  @override
  Widget build(BuildContext context) {
    final title = _galleryTitles[index % _galleryTitles.length];
    final author = _galleryAuthors[index % _galleryAuthors.length];
    final gradient = _gradients[index % _gradients.length];
    final likeCount = 42 + (index * 7) % 300;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
            ),
          ),
          // Network image overlay (if available)
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
          // Gradient overlay for text
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC000000)],
                stops: [0.4, 1],
              ),
            ),
          ),
          // Like count top right
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite,
                      color: kDanger, size: 11),
                  const SizedBox(width: 3),
                  Text(
                    '$likeCount',
                    style: const TextStyle(
                      color: kCream,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Text at bottom
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kCream,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                Text(
                  author,
                  style: TextStyle(
                    color: kCream.withValues(alpha: 0.7),
                    fontSize: 10,
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
