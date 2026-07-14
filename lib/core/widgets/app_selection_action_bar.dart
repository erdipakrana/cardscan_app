import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class AppSelectionActionBar extends StatelessWidget {
  const AppSelectionActionBar({
    super.key,
    required this.selectedCount,
    required this.onCancel,
    required this.onShare,
    required this.onDelete,
  });

  final int selectedCount;
  final VoidCallback onCancel;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Container(
      margin: context.paddingMd,
      padding: EdgeInsets.symmetric(
        horizontal: context.spaceMd,
        vertical: context.spaceMd - context.spaceXs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: context.radiusLgAll,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                color: colorScheme.onInverseSurface,
                onPressed: onCancel,
              ),
              context.horizontalGapSm,
              Text(
                '$selectedCount Selected',
                style: context.titleSmall?.copyWith(
                  color: colorScheme.onInverseSurface,
                  fontWeight: context.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.share),
                color: colorScheme.onInverseSurface,
                onPressed: onShare,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: colorScheme.onInverseSurface,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
