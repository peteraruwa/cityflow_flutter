import 'package:flutter/material.dart';

import '../../../core/colors.dart';

class MapSearchBar extends StatelessWidget {
  const MapSearchBar({
    required this.onChanged,
    this.initialValue = '',
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      style: const TextStyle(color: kCream),
      cursorColor: kPurple,
      decoration: InputDecoration(
        filled: true,
        fillColor: kBackground,
        hintText: 'Search places',
        hintStyle: TextStyle(color: kCream.withValues(alpha: 0.6)),
        prefixIcon: const Icon(Icons.search, color: kCream),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kCream.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPurple, width: 2),
        ),
      ),
    );
  }
}
