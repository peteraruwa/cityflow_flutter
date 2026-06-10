import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../emergency_controller.dart';

class EmergencyContactCard extends StatelessWidget {
  const EmergencyContactCard({
    required this.contact,
    required this.onTap,
    super.key,
  });

  final EmergencyContact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCream.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: contact.isPrimary ? kGold : kPurple),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              contact.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kCream,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              contact.role,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: kCream.withValues(alpha: 0.64)),
            ),
            const SizedBox(height: 8),
            Text(
              contact.phone.isEmpty ? 'No phone listed' : contact.phone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kGold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
