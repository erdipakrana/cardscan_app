import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class ScannerActionButton extends StatelessWidget {
  const ScannerActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: context.radiusLgAll,
      child: Padding(
        padding: context.paddingSm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.minTapTarget,
              height: context.minTapTarget,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: context.iconSizeLg),
            ),
            SizedBox(height: context.spaceSm - 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: context.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerShutterButton extends StatelessWidget {
  const ScannerShutterButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: context.spaceLg * 3.5,
            height: context.spaceLg * 3.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Container(
            width: context.spaceLg * 3,
            height: context.spaceLg * 3,
            padding: context.paddingXs,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
