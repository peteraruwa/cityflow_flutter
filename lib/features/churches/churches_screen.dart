import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'churches_controller.dart';

class ChurchesScreen extends ConsumerWidget {
  const ChurchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final churchesState = ref.watch(churchesControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: churchesState.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(churchesControllerProvider),
          ),
          data: (state) {
            final churches = state.filteredChurches;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: ref
                        .read(churchesControllerProvider.notifier)
                        .setSearchQuery,
                    style: const TextStyle(color: kCream),
                    cursorColor: kPurple,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kBackground,
                      hintText: 'Search churches',
                      hintStyle:
                          TextStyle(color: kCream.withValues(alpha: 0.6)),
                      prefixIcon: const Icon(Icons.search, color: kCream),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: kCream.withValues(alpha: 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kPurple, width: 2),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: churches.isEmpty
                      ? const EmptyStateView(
                          icon: Icons.search_off,
                          title: 'No churches found',
                          subtitle: 'Try another church name.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: churches.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final church = churches[index];
                            return ListTile(
                              tileColor: kCream.withValues(alpha: 0.06),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: kPurple),
                              ),
                              title: Text(
                                church.name,
                                style: const TextStyle(
                                  color: kCream,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                church.subcategory,
                                style: TextStyle(
                                  color: kCream.withValues(alpha: 0.6),
                                ),
                              ),
                              onTap: () => context.goNamed(
                                'churchDetails',
                                pathParameters: {'id': church.id},
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
