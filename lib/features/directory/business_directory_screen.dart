import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'directory_controller.dart';
import 'models/business.dart';

const _tabDefs = [
  _TabDef(label: 'Restaurants', color: kGold),
  _TabDef(label: 'Hotels & Guest Houses', color: kBlue),
  _TabDef(label: 'Banks & ATMs', color: kSuccess),
  _TabDef(label: 'Shops & Services', color: kPurpleLight),
];

class _TabDef {
  const _TabDef({required this.label, required this.color});
  final String label;
  final Color color;
}

class BusinessDirectoryScreen extends ConsumerWidget {
  const BusinessDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directoryState = ref.watch(directoryControllerProvider);

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
                  Text(
                    'Business Directory',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: kCream,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                onChanged: ref
                    .read(directoryControllerProvider.notifier)
                    .setSearchQuery,
                style: const TextStyle(color: kCream),
                cursorColor: kPurple,
                decoration: InputDecoration(
                  hintText: 'Search directory…',
                  hintStyle: const TextStyle(color: kMutedText),
                  prefixIcon: const Icon(Icons.search, color: kMutedText),
                  filled: true,
                  fillColor: kSurface,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: kPurpleLight, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Category tabs
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemCount: _tabDefs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tab = _tabDefs[index];
                  return directoryState.when(
                    loading: () => _CategoryTab(
                        tab: tab, isActive: false, onTap: () {}),
                    error: (_, __) => _CategoryTab(
                        tab: tab, isActive: false, onTap: () {}),
                    data: (state) => _CategoryTab(
                      tab: tab,
                      isActive: state.selectedCategory == tab.label,
                      onTap: () => ref
                          .read(directoryControllerProvider.notifier)
                          .setCategory(tab.label),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: directoryState.when(
                loading: () => const LoadingView(),
                error: (error, _) => ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(directoryControllerProvider),
                ),
                data: (state) {
                  final businesses = state.filteredBusinesses;
                  if (businesses.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.search_off,
                      title: 'No businesses found',
                      subtitle: 'Try another search or category.',
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    itemCount: businesses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        _BusinessCard(business: businesses[index]),
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

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final _TabDef tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? tab.color.withValues(alpha: 0.2) : kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? tab.color.withValues(alpha: 0.5) : kBorder,
          ),
        ),
        child: Text(
          tab.label,
          style: TextStyle(
            color: isActive ? tab.color : kMutedText,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  const _BusinessCard({required this.business});
  final Business business;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.goNamed(
        'businessDetails',
        pathParameters: {'id': business.id},
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  business.name,
                  style: const TextStyle(
                    color: kCream,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                // Star rating
                Row(
                  children: const [
                    Icon(Icons.star, color: kGold, size: 13),
                    SizedBox(width: 2),
                    Text(
                      '4.2',
                      style: TextStyle(
                          color: kGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              business.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: kMutedText, fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_outlined,
                    color: kMutedText, size: 12),
                const SizedBox(width: 4),
                const Text(
                  'Open 8AM – 8PM',
                  style: TextStyle(color: kMutedText, fontSize: 11),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPurpleLight,
                    side:
                        BorderSide(color: kPurple.withValues(alpha: 0.4)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.phone_outlined, size: 13),
                  label: const Text('Call',
                      style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
