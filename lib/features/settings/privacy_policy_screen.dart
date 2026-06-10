import 'package:flutter/material.dart';

import '../../core/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: kCream,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              _policyText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kCream.withValues(alpha: 0.76),
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

const _policyText = '''
CityFlow helps visitors navigate Redemption City and discover useful services, events, churches, and emergency contacts.

This placeholder policy explains how the app intends to handle information. CityFlow may store basic preferences, profile details, and saved settings on your device so the app feels familiar when you return.

Location access may be requested to estimate distance to places within Redemption City. Location data is used on-device for navigation features unless a future backend feature clearly explains otherwise.

Emergency contact, directory, church, event, gallery, and map data are provided to help users find services quickly. Always confirm urgent information with official Redemption City or RCCG channels.

CityFlow does not sell personal information. Future versions that add accounts, cloud sync, or online submissions should update this policy before those features are enabled.
''';
