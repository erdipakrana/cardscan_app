import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class AppGlassIconButton extends StatelessWidget {
  const AppGlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size,
    this.iconSize,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double? size;
  final double? iconSize;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? context.minTapTarget;
    final resolvedIconSize = iconSize ?? context.iconSizeLg;

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: resolvedIconSize),
        onPressed: onPressed,
      ),
    );
  }
}
