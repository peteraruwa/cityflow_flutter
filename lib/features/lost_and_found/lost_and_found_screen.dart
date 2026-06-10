import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/app_screen.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'lost_found_controller.dart';
import 'models/lost_item.dart';

class LostAndFoundScreen extends ConsumerWidget {
  const LostAndFoundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lostFoundControllerProvider);

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: LoadingView(),
      );
    }

    if (state.errorMessage != null) {
      return Scaffold(
        backgroundColor: kBackground,
        body: ErrorView(
          message: state.errorMessage!,
          onRetry:
              ref.read(lostFoundControllerProvider.notifier).retryLoadItems,
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      initialIndex: state.tabIndex,
      child: AppScreen(
        scrollable: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenHeader(
              title: 'Community',
              subtitle: 'Lost and found reports around the camp.',
              trailing: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: kPurple,
                  foregroundColor: kCream,
                ),
                onPressed: () => context.goNamed('reportItem'),
                icon: const Icon(Icons.add),
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              indicatorColor: kGold,
              labelColor: kCream,
              unselectedLabelColor: kMutedText,
              onTap: ref.read(lostFoundControllerProvider.notifier).setTabIndex,
              tabs: const [
                Tab(text: 'Lost Items'),
                Tab(text: 'Found Items'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                children: [
                  _ItemList(items: state.lostItems),
                  _ItemList(items: state.foundItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({required this.items});

  final List<LostItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyStateView(
        icon: Icons.inventory_2_outlined,
        title: 'No items here',
        subtitle: 'Items will appear here when reported.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _LostItemCard(item: items[index]),
    );
  }
}

class _LostItemCard extends StatelessWidget {
  const _LostItemCard({required this.item});

  final LostItem item;

  @override
  Widget build(BuildContext context) {
    final isLost = item.status == LostItemStatus.lost;

    return PremiumCard(
      onTap: () => context.goNamed(
        'itemDetails',
        pathParameters: {'id': item.id},
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: kSurfaceHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: item.imageUrl.isEmpty
                ? const Icon(Icons.image_outlined, color: kGold)
                : Image.network(item.imageUrl, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: kCream,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.dateLost,
                  style: const TextStyle(color: kMutedText),
                ),
                const SizedBox(height: 8),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isLost ? kDanger : kSuccess,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    child: Text(
                      isLost ? 'Lost' : 'Found',
                      style: const TextStyle(
                        color: kCream,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
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
