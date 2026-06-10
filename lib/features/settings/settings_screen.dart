import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _activeLang = 'en';
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _soundsEnabled = false;

  static const _languages = [
    _LangOption(code: 'en', label: 'English', native: 'English'),
    _LangOption(code: 'fr', label: 'French', native: 'Francais'),
    _LangOption(code: 'yo', label: 'Yoruba', native: 'Yoruba'),
  ];

  @override
  Widget build(BuildContext context) {
    final notificationsEnabled = ref.watch(settingsControllerProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: kCream),
                  style: IconButton.styleFrom(backgroundColor: kSurface),
                ),
                const SizedBox(width: 12),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Language section
            _SectionTitle('Language'),
            const SizedBox(height: 10),
            ..._languages.map((lang) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _LangRow(
                    lang: lang,
                    isActive: _activeLang == lang.code,
                    onTap: () => setState(() => _activeLang = lang.code),
                  ),
                )),
            const SizedBox(height: 24),
            // Preferences section
            _SectionTitle('Preferences'),
            const SizedBox(height: 10),
            _ToggleTile(
              icon: Icons.notifications_none,
              color: kPurpleLight,
              label: 'Push Notifications',
              subtitle: 'Alerts for events and updates',
              value: notificationsEnabled,
              onChanged: ref
                  .read(settingsControllerProvider.notifier)
                  .setNotificationsEnabled,
            ),
            const SizedBox(height: 8),
            _ToggleTile(
              icon: Icons.location_on_outlined,
              color: kSuccess,
              label: 'Location Services',
              subtitle: 'Used for nearby places',
              value: _locationEnabled,
              onChanged: (v) => setState(() => _locationEnabled = v),
            ),
            const SizedBox(height: 8),
            _ToggleTile(
              icon: Icons.volume_up_outlined,
              color: kGold,
              label: 'In-app Sounds',
              subtitle: 'Sound effects and alerts',
              value: _soundsEnabled,
              onChanged: (v) => setState(() => _soundsEnabled = v),
            ),
            const SizedBox(height: 24),
            // Privacy
            _SectionTitle('Privacy'),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.privacy_tip_outlined,
              color: kMutedText,
              label: 'Privacy Policy',
              onTap: () => context.goNamed('privacyPolicy'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: kDimText,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
    );
  }
}

class _LangOption {
  const _LangOption({
    required this.code,
    required this.label,
    required this.native,
  });
  final String code;
  final String label;
  final String native;
}

class _LangRow extends StatelessWidget {
  const _LangRow({
    required this.lang,
    required this.isActive,
    required this.onTap,
  });

  final _LangOption lang;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive ? kPurple.withValues(alpha: 0.14) : kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? kPurpleLight.withValues(alpha: 0.5) : kBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isActive
                    ? kPurpleLight.withValues(alpha: 0.2)
                    : kSurfaceHigh,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  lang.code.toUpperCase(),
                  style: TextStyle(
                    color: isActive ? kPurpleLight : kMutedText,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.native,
                    style: const TextStyle(
                      color: kCream,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    lang.label,
                    style: const TextStyle(color: kMutedText, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (isActive)
              const Icon(Icons.check_circle, color: kPurpleLight, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
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
                Text(
                  subtitle,
                  style: const TextStyle(color: kMutedText, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: kGold,
            activeTrackColor: kGold.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: kCream,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: kDimText),
          ],
        ),
      ),
    );
  }
}
