import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/colors.dart';
import '../emergency/emergency_service.dart';
import 'lost_found_controller.dart';
import 'models/lost_item.dart';

class ItemDetailsScreen extends ConsumerWidget {
  const ItemDetailsScreen({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lostFoundControllerProvider);
    final item = _findItem(state, id);

    if (item == null) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: Center(
          child: Text('Item not found', style: TextStyle(color: kCream)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: kCream.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kPurple),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.imageUrl.isEmpty
                  ? const Icon(Icons.image_outlined, color: kGold, size: 56)
                  : Image.network(item.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 18),
            Text(
              item.title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: kCream,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              item.description,
              style: TextStyle(
                  color: kCream.withValues(alpha: 0.76), height: 1.45),
            ),
            const SizedBox(height: 16),
            _DetailLine(label: 'Category', value: item.category),
            _DetailLine(label: 'Date', value: item.dateLost),
            _DetailLine(label: 'Location', value: item.locationFound),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurple,
                foregroundColor: kCream,
              ),
              onPressed: () => ref.read(emergencyServiceProvider).makeCall(
                    item.contactPhone,
                    context: context,
                  ),
              icon: const Icon(Icons.call),
              label: const Text('Contact'),
            ),
          ],
        ),
      ),
    );
  }

  LostItem? _findItem(LostFoundState state, String id) {
    for (final item in state.items) {
      if (item.id == id) return item;
    }

    return null;
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(color: kCream),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: kGold,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
