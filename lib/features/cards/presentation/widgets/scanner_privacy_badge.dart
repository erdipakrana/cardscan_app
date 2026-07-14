import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class ScannerPrivacyBadge extends StatelessWidget {
  const ScannerPrivacyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spaceMd,
        vertical: context.spaceSm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: context.radiusFullAll,
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock, size: context.iconSizeSm, color: context.intelligenceTeal),
          context.horizontalGapSm,
          Text(
            'Processed privately on this device',
            style: context.labelSmall?.copyWith(
              color: Colors.white70,
              fontWeight: context.medium,
            ),
          ),
        ],
      ),
    );
  }
}
