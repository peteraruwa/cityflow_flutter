import 'package:flutter/material.dart';

import '../../../core/colors.dart';

class PlaceMarker extends StatelessWidget {
  const PlaceMarker({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.location_on, color: kPurple, size: 42),
          Positioned(
            top: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: kCream,
                shape: BoxShape.circle,
              ),
              child: SizedBox(width: 8, height: 8),
            ),
          ),
        ],
      ),
    );
  }
}
