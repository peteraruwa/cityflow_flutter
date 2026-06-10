import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'churches_controller.dart';
import 'models/church.dart';

class ChurchesScreen extends ConsumerWidget {
  const ChurchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final churchesState = ref.watch(churchesControllerProvider);

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
                  Expanded(
                    child: churchesState.maybeWhen(
                      data: (state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find a Church',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: kCream,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            '${state.filteredChurches.length} parishes nearby',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: kMutedText),
                          ),
                        ],
                      ),
                      orElse: () => Text(
                        'Find a Church',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              color: kCream,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                onChanged: ref
                    .read(churchesControllerProvider.notifier)
                    .setSearchQuery,
                style: const TextStyle(color: kCream),
                cursorColor: kPurple,
                decoration: InputDecoration(
                  hintText: 'Search churches…',
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
            Expanded(
              child: churchesState.when(
                loading: () => const LoadingView(),
                error: (error, _) => ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(churchesControllerProvider),
                ),
                data: (state) {
                  final churches = state.filteredChurches;
                  if (churches.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.search_off,
                      title: 'No churches found',
                      subtitle: 'Try another name.',
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    itemCount: churches.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final church = churches[index];
                      return _ChurchCard(
                        church: church,
                        onTap: () => context.goNamed(
                          'churchDetails',
                          pathParameters: {'id': church.id},
                        ),
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

class _ChurchCard extends StatelessWidget {
  const _ChurchCard({required this.church, required this.onTap});

  final Church church;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kPurple.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kPurple.withValues(alpha: 0.25)),
              ),
              child: const Icon(Icons.account_balance_outlined,
                  color: kPurpleLight, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    church.name,
                    style: const TextStyle(
                      color: kCream,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    church.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: kMutedText, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _ChipBadge(
                        label: 'Sun 7:00 AM',
                        color: kPurple,
                      ),
                      const SizedBox(width: 8),
                      _ChipBadge(
                        label: '0.3 km',
                        color: kGold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: kPurpleLight,
                side: BorderSide(color: kPurple.withValues(alpha: 0.4)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {},
              child: const Text('Directions', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipBadge extends StatelessWidget {
  const _ChipBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
