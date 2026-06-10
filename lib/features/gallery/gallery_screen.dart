import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'gallery_controller.dart';
import 'widgets/daily_image_card.dart';
import 'widgets/gallery_grid.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gallery = ref.watch(galleryControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: gallery.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(galleryControllerProvider),
          ),
          data: (state) {
            if (state.images.isEmpty) {
              return const EmptyStateView(
                icon: Icons.photo_library_outlined,
                title: 'No gallery images',
                subtitle: 'Photos will appear here when available.',
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Photo of the Day',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kGold,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                DailyImageCard(
                  imageUrl: state.featuredImage,
                  date: DateTime.now(),
                ),
                const SizedBox(height: 18),
                GalleryGrid(images: state.images),
              ],
            );
          },
        ),
      ),
    );
  }
}
