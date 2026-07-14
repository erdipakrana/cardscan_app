import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class ScannerGuideText extends StatelessWidget {
  const ScannerGuideText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hold steady...',
      style: context.labelLarge?.copyWith(
        color: Colors.white,
        fontWeight: context.semiBold,
        shadows: const [
          Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
    );
  }
}
