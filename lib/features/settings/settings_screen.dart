import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(settingsControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: ListView(
          children: [
            SwitchListTile(
              activeThumbColor: kGold,
              title:
                  const Text('Notifications', style: TextStyle(color: kCream)),
              value: notificationsEnabled,
              onChanged: ref
                  .read(settingsControllerProvider.notifier)
                  .setNotificationsEnabled,
            ),
            SwitchListTile(
              activeThumbColor: kGold,
              title: const Text('Dark Mode', style: TextStyle(color: kCream)),
              subtitle: Text(
                'Always on',
                style: TextStyle(color: kCream.withValues(alpha: 0.6)),
              ),
              value: true,
              onChanged: null,
            ),
            ListTile(
              title: const Text('Language', style: TextStyle(color: kCream)),
              trailing: const Icon(Icons.chevron_right, color: kCream),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon')),
                );
              },
            ),
            ListTile(
              title:
                  const Text('About CityFlow', style: TextStyle(color: kCream)),
              trailing: const Icon(Icons.info_outline, color: kCream),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: kBackground,
                    title: const Text(
                      'CityFlow',
                      style: TextStyle(color: kCream),
                    ),
                    content: Text(
                      'Version $kAppVersion',
                      style: TextStyle(color: kCream),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title:
                  const Text('Privacy Policy', style: TextStyle(color: kCream)),
              trailing: const Icon(Icons.chevron_right, color: kCream),
              onTap: () => context.goNamed('privacyPolicy'),
            ),
          ],
        ),
      ),
    );
  }
}
