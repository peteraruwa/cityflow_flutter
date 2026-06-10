import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/widgets/app_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(
            title: 'Explore',
            subtitle: 'Find places, services and facilities by category.',
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.88,
            children: _categories.map((category) {
              return _CategoryCard(category: category);
            }).toList(),
          ),
          const SizedBox(height: 22),
          const PremiumCard(
            child: Row(
              children: [
                IconTile(icon: Icons.lightbulb_outline, color: kGold),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tip: use the map quick action for nearby places and walking estimates.',
                    style: TextStyle(color: kMutedText, height: 1.4),
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

class _ExploreCategory {
  const _ExploreCategory({
    required this.label,
    required this.category,
    required this.icon,
    required this.color,
  });

  final String label;
  final String category;
  final IconData icon;
  final Color color;
}

const _categories = [
  _ExploreCategory(
    label: 'Churches',
    category: 'church',
    icon: Icons.account_balance_outlined,
    color: kPurpleLight,
  ),
  _ExploreCategory(
    label: 'Accommodation',
    category: 'accommodation',
    icon: Icons.hotel_outlined,
    color: kGold,
  ),
  _ExploreCategory(
    label: 'Medical',
    category: 'medical',
    icon: Icons.local_hospital_outlined,
    color: kDanger,
  ),
  _ExploreCategory(
    label: 'Education',
    category: 'education',
    icon: Icons.school_outlined,
    color: kPurple,
  ),
  _ExploreCategory(
    label: 'Shopping',
    category: 'shopping',
    icon: Icons.shopping_bag_outlined,
    color: kCream,
  ),
  _ExploreCategory(
    label: 'Dining',
    category: 'dining',
    icon: Icons.restaurant_outlined,
    color: kGold,
  ),
  _ExploreCategory(
    label: 'Banks',
    category: 'bank',
    icon: Icons.account_balance_wallet_outlined,
    color: kSuccess,
  ),
  _ExploreCategory(
    label: 'Parks',
    category: 'park',
    icon: Icons.park_outlined,
    color: kSuccess,
  ),
  _ExploreCategory(
    label: 'Admin',
    category: 'administration',
    icon: Icons.business_outlined,
    color: kMutedText,
  ),
];

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final _ExploreCategory category;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(10),
      color: category.color.withValues(alpha: 0.12),
      borderColor: category.color.withValues(alpha: 0.26),
      onTap: () => context.goNamed(
        'category',
        pathParameters: {'category': category.category},
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(category.icon, color: category.color, size: 29),
          const SizedBox(height: 9),
          Text(
            category.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: kCream,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
