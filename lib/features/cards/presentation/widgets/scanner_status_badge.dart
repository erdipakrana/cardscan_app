import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class ScannerStatusBadge extends StatelessWidget {
  const ScannerStatusBadge({super.key, required this.isDetected});

  final bool isDetected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: context.spaceMd,
        vertical: context.spaceSm,
      ),
      decoration: BoxDecoration(
        color: const Color(
          0xFF005F71,
        ).withValues(alpha: isDetected ? 0.9 : 0.6),
        borderRadius: context.radiusFullAll,
        border: Border.all(
          color: const Color(
            0xFF50DCFF,
          ).withValues(alpha: isDetected ? 0.8 : 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDetected ? Icons.check_circle : Icons.center_focus_weak,
            size: context.iconSizeSm,
            color: context.intelligenceTeal,
          ),
          context.horizontalGapSm,
          Text(
            isDetected ? 'Card detected' : 'Align card',
            style: context.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: context.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
