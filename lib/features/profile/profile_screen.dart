import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
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
          const ScreenHeader(title: 'Profile'),
          const SizedBox(height: 20),
          // Avatar + info
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kPurple, kPurpleDark],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: kPurpleLight.withValues(alpha: 0.4),
                        width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _initials(profile.name),
                      style: const TextStyle(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kMutedText,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: kGold, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      'Redemption City',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kGold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Stats row
          PremiumCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _StatItem(label: 'CityRides', value: '12'),
                _Divider(),
                _StatItem(label: 'Events', value: '8'),
                _Divider(),
                _StatItem(label: 'L&F Reports', value: '2'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Menu items
          _MenuItem(
            icon: Icons.notifications_none,
            color: kPurpleLight,
            label: 'Notifications',
            subtitle: 'Manage alerts and updates',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.inventory_2_outlined,
            color: kGold,
            label: 'My L&F Reports',
            subtitle: 'Track your reports',
            onTap: () => context.goNamed('lostAndFound'),
          ),
          _MenuItem(
            icon: Icons.history_outlined,
            color: kBlue,
            label: 'Booking History',
            subtitle: 'Past rides and bookings',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.help_outline,
            color: kSuccess,
            label: 'Help & Support',
            subtitle: 'FAQs and contact',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.settings_outlined,
            color: kMutedText,
            label: 'Settings',
            subtitle: 'App preferences',
            onTap: () => context.goNamed('settings'),
          ),
          const SizedBox(height: 16),
          // Sign out
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => context.goNamed('login'),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: kDanger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kDanger.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: kDanger, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: kDanger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'P';
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: kCream,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: kMutedText, fontSize: 12),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: kBorder,
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
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
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: kCream,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: kMutedText, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: kDimText),
          ],
        ),
      ),
    );
  }
}
