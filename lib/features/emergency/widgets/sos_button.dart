import 'package:flutter/material.dart';

import '../../../core/colors.dart';

class SosButton extends StatefulWidget {
  const SosButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.96, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onPressed,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: kDanger,
            shape: BoxShape.circle,
            border: Border.all(color: kGold, width: 3),
          ),
          alignment: Alignment.center,
          child: const Text(
            'SOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
