import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _analyticsEnabled = true;
  bool _personalisedEnabled = false;

  @override
  Widget build(BuildContext context) {
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
                  'Privacy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Your data info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kPurple.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined,
                      color: kPurpleLight, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your data, your control',
                          style: TextStyle(
                            color: kCream,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'CityFlow only collects what\'s needed to make your experience better.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: kMutedText,
                                    height: 1.4,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle('Data Preferences'),
            const SizedBox(height: 10),
            _PrivacyToggle(
              label: 'Usage Analytics',
              subtitle: 'Help us improve the app',
              value: _analyticsEnabled,
              onChanged: (v) => setState(() => _analyticsEnabled = v),
            ),
            const SizedBox(height: 8),
            _PrivacyToggle(
              label: 'Personalised Suggestions',
              subtitle: 'Tailored content recommendations',
              value: _personalisedEnabled,
              onChanged: (v) => setState(() => _personalisedEnabled = v),
            ),
            const SizedBox(height: 24),
            _SectionTitle('Permissions'),
            const SizedBox(height: 10),
            _PermissionRow(
              icon: Icons.location_on_outlined,
              color: kSuccess,
              label: 'Location',
              status: 'Allowed while using',
            ),
            const SizedBox(height: 8),
            _PermissionRow(
              icon: Icons.notifications_none,
              color: kPurpleLight,
              label: 'Notifications',
              status: 'Allowed',
            ),
            const SizedBox(height: 8),
            _PermissionRow(
              icon: Icons.camera_alt_outlined,
              color: kGold,
              label: 'Camera',
              status: 'Not requested',
            ),
            const SizedBox(height: 28),
            // Request account deletion
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: kDanger,
                side: BorderSide(color: kDanger.withValues(alpha: 0.4)),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: kSurface,
                    title: const Text(
                      'Delete Account?',
                      style: TextStyle(color: kCream),
                    ),
                    content: const Text(
                      'This will permanently delete your account and all data. This cannot be undone.',
                      style: TextStyle(color: kMutedText),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: kDanger),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Request Account Deletion'),
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

class _PrivacyToggle extends StatelessWidget {
  const _PrivacyToggle({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

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

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.status,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String status;

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
            child: Text(
              label,
              style: const TextStyle(
                color: kCream,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            status,
            style: const TextStyle(color: kMutedText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
