import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/colors.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> _sentSet = {};
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    setState(() => _sentSet.add(number));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: kCream),
                  style: IconButton.styleFrom(
                    backgroundColor: kSurface,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency / SOS',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: kCream,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    Text(
                      'Quick access to emergency services',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kMutedText,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Alert Banner
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) => Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: kDanger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kDanger.withValues(
                        alpha: 0.3 + _pulseController.value * 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: kDanger.withValues(
                            alpha:
                                0.5 + _pulseController.value * 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'In a life-threatening emergency, tap the number to call immediately. Your location will be shared.',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: kDanger,
                                  height: 1.4,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // SOS Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _SosCard(
                  icon: Icons.local_hospital_outlined,
                  label: 'Ambulance',
                  sub: 'Medical emergency',
                  number: '199',
                  color: kDanger,
                  sent: _sentSet.contains('199'),
                  onTap: () => _call('199'),
                ),
                _SosCard(
                  icon: Icons.local_police_outlined,
                  label: 'Police',
                  sub: 'Security & crime',
                  number: '112',
                  color: const Color(0xFF3B82F6),
                  sent: _sentSet.contains('112'),
                  onTap: () => _call('112'),
                ),
                _SosCard(
                  icon: Icons.local_fire_department_outlined,
                  label: 'Fire Service',
                  sub: 'Fire emergency',
                  number: '190',
                  color: const Color(0xFFF97316),
                  sent: _sentSet.contains('190'),
                  onTap: () => _call('190'),
                ),
                _SosCard(
                  icon: Icons.car_crash_outlined,
                  label: 'Road Safety',
                  sub: 'Traffic accident',
                  number: '122',
                  color: kGold,
                  sent: _sentSet.contains('122'),
                  onTap: () => _call('122'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // General Emergency card
            _GeneralEmergencyCard(
              onTap: () => _call('112'),
              sent: _sentSet.contains('112'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SosCard extends StatelessWidget {
  const _SosCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.number,
    required this.color,
    required this.sent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String sub;
  final String number;
  final Color color;
  final bool sent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                if (sent)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: kSuccess.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Location sent',
                      style: TextStyle(
                        color: kSuccess,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: kCream,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(color: kMutedText, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Text(
              number,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralEmergencyCard extends StatelessWidget {
  const _GeneralEmergencyCard({required this.onTap, required this.sent});

  final VoidCallback onTap;
  final bool sent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kDanger.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kDanger.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.sos_outlined, color: kDanger, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'General Emergency',
                    style: TextStyle(
                      color: kCream,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Connects to nearest emergency service',
                    style: TextStyle(color: kMutedText, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '112',
              style: TextStyle(
                color: kDanger,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
