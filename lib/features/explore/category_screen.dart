import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/place_card.dart';
import 'explore_controller.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({
    required this.category,
    super.key,
  });

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreData = ref.watch(exploreControllerProvider);
    final title = _categoryTitle(category);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: exploreData.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(exploreControllerProvider),
          ),
          data: (data) {
            final places = data.filterByCategory(category);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: kGold,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 16),
                if (places.isEmpty)
                  EmptyStateView(
                    icon: Icons.search_off,
                    title: 'No places found',
                    subtitle: 'There are no places in $title yet.',
                  )
                else
                  ...places.map(
                    (place) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PlaceCard(place: place),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _categoryTitle(String value) {
    return value
        .split('_')
        .map((part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
