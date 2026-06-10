import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/models/place.dart';
import '../../shared/widgets/app_screen.dart';
import '../../shared/widgets/empty_state_view.dart';
import 'explore_controller.dart';

const _categories = [
  'All',
  'Worship',
  'Stay',
  'Dining',
  'Spiritual',
  'Transport',
  'Retail',
];

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String _activeCategory = 'All';
  String _query = '';

  List<Place> _filtered(List<Place> places) {
    return places.where((p) {
      final matchCat = _activeCategory == 'All' ||
          p.category.toLowerCase() == _activeCategory.toLowerCase();
      final matchQuery = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase());
      return matchCat && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(exploreControllerProvider);

    return AppScreen(
      scrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(
            title: 'Explore',
            subtitle: 'Discover Redemption City',
          ),
          const SizedBox(height: 16),
          // Search bar
          TextField(
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(color: kCream),
            cursorColor: kPurple,
            decoration: InputDecoration(
              hintText: 'Search places…',
              hintStyle: const TextStyle(color: kMutedText),
              prefixIcon: const Icon(Icons.search, color: kMutedText),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      onPressed: () => setState(() => _query = ''),
                      icon: const Icon(Icons.close, color: kMutedText),
                    )
                  : null,
              filled: true,
              fillColor: kSurface,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kPurpleLight, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Category chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isActive = cat == _activeCategory;
                return GestureDetector(
                  onTap: () => setState(() => _activeCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? kPurple : kSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? kPurple : kBorder,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isActive ? kCream : kMutedText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: placesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: kPurpleLight),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Failed to load places',
                  style: TextStyle(color: kMutedText),
                ),
              ),
              data: (data) {
                final filtered = _filtered(data.places);
                if (filtered.isEmpty) {
                  return const EmptyStateView(
                    icon: Icons.search_off,
                    title: 'No places found',
                    subtitle: 'Try another category or search term.',
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _PlaceCard(place: filtered[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place});
  final Place place;

  Color get _color {
    switch (place.category) {
      case 'church':
        return kPurple;
      case 'accommodation':
        return const kBlue;
      case 'medical':
        return kDanger;
      case 'dining':
        return kGold;
      case 'bank':
        return kSuccess;
      default:
        return kMutedText;
    }
  }

  IconData get _icon {
    switch (place.category) {
      case 'church':
        return Icons.account_balance_outlined;
      case 'accommodation':
        return Icons.hotel_outlined;
      case 'medical':
        return Icons.local_hospital_outlined;
      case 'dining':
        return Icons.restaurant_outlined;
      case 'bank':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.goNamed(
        'placeDetails',
        pathParameters: {'id': place.id},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon area
            Container(
              height: 76,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.14),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(13)),
              ),
              child: Center(
                child: Icon(_icon, color: _color, size: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kCream,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        place.category,
                        style:
                            const TextStyle(color: kMutedText, fontSize: 10),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: kSurfaceHigh,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star, color: kGold, size: 10),
                            SizedBox(width: 2),
                            Text(
                              '4.5',
                              style: TextStyle(
                                color: kGold,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
