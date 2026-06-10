import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'directory_controller.dart';
import 'models/business.dart';

class BusinessDirectoryScreen extends ConsumerWidget {
  const BusinessDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directoryState = ref.watch(directoryControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: directoryState.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(directoryControllerProvider),
          ),
          data: (state) {
            final grouped = state.groupedBusinesses;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: ref
                        .read(directoryControllerProvider.notifier)
                        .setSearchQuery,
                    style: const TextStyle(color: kCream),
                    cursorColor: kPurple,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kBackground,
                      hintText: 'Search directory',
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
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      final isActive = category == state.selectedCategory;

                      return ChoiceChip(
                        label: Text(_title(category)),
                        selected: isActive,
                        selectedColor: kPurple,
                        backgroundColor: kCream.withValues(alpha: 0.3),
                        labelStyle: TextStyle(
                          color: isActive ? kCream : kBackground,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (_) {
                          ref
                              .read(directoryControllerProvider.notifier)
                              .setCategory(category);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: grouped.isEmpty
                      ? const EmptyStateView(
                          icon: Icons.search_off,
                          title: 'No businesses found',
                          subtitle: 'Try another search or category.',
                        )
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: grouped.entries.expand((entry) {
                            return [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 8),
                                child: Text(
                                  _title(entry.key),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: kGold,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                              ...entry.value.map(
                                (business) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _BusinessTile(business: business),
                                ),
                              ),
                            ];
                          }).toList(),
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

class _BusinessTile extends StatelessWidget {
  const _BusinessTile({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: kCream.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: kPurple),
      ),
      title: Text(
        business.name,
        style: const TextStyle(
          color: kCream,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        business.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: kCream.withValues(alpha: 0.64)),
      ),
      onTap: () => context.goNamed(
        'businessDetails',
        pathParameters: {'id': business.id},
      ),
    );
  }
}

String _title(String value) {
  return value
      .split('_')
      .map((part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
