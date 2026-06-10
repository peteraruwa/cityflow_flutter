import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../shared/widgets/app_screen.dart';
import 'profile_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return AppScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            title: 'More',
            subtitle: 'Account, info and support',
            trailing: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: kSurfaceHigh,
                foregroundColor: kGold,
              ),
              onPressed: () => context.goNamed('editProfile'),
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: 18),
          PremiumCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 31,
                  backgroundColor: kPurple.withValues(alpha: 0.24),
                  backgroundImage: const AssetImage(kRedemptionCityLogoAsset),
                  onBackgroundImageError: (_, __) {},
                  child: const Icon(Icons.person, color: kCream),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: kCream,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        profile.email,
                        style: const TextStyle(color: kMutedText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const _SectionTitle('Quick Contacts'),
          _MoreTile(
            icon: Icons.phone_in_talk_outlined,
            color: kGold,
            label: 'Emergency Contacts',
            subtitle: 'Hospital, security and urgent help',
            onTap: () => context.goNamed('emergency'),
          ),
          const SizedBox(height: 18),
          const _SectionTitle('Account'),
          _MoreTile(
            icon: Icons.person_outline,
            color: kPurpleLight,
            label: 'Profile',
            subtitle: 'Your account and saved history',
            onTap: () => context.goNamed('editProfile'),
          ),
          _MoreTile(
            icon: Icons.settings_outlined,
            color: kMutedText,
            label: 'Settings',
            subtitle: 'Preferences and app options',
            onTap: () => context.goNamed('settings'),
          ),
          _MoreTile(
            icon: Icons.notifications_none,
            color: kGold,
            label: 'Notifications',
            subtitle: 'Alerts and updates',
            onTap: () => _comingSoon(context, 'Notifications'),
          ),
          const SizedBox(height: 18),
          const _SectionTitle('Discover'),
          _MoreTile(
            icon: Icons.church_outlined,
            color: kPurple,
            label: 'Churches',
            subtitle: 'Worship centres and details',
            onTap: () => context.goNamed('churches'),
          ),
          _MoreTile(
            icon: Icons.storefront_outlined,
            color: kGold,
            label: 'Business Directory',
            subtitle: 'Food, banks, shops and services',
            onTap: () => context.goNamed('directory'),
          ),
          _MoreTile(
            icon: Icons.photo_library_outlined,
            color: kSuccess,
            label: 'Gallery',
            subtitle: 'Photos from around the city',
            onTap: () => context.goNamed('gallery'),
          ),
          _MoreTile(
            icon: Icons.smart_toy_outlined,
            color: kPurpleLight,
            label: 'AI Guide',
            subtitle: 'Ask CityFlow Assistant',
            onTap: () => context.goNamed('aiGuide'),
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title coming soon')),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: kDimText,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: PremiumCard(
        onTap: onTap,
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            IconTile(icon: icon, color: color, size: 38),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kCream,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kMutedText,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: kDimText, size: 18),
          ],
        ),
      ),
    );
  }
}
