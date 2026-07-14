import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class CardsHeader extends StatelessWidget {
  const CardsHeader({
    super.key,
    required this.totalCards,
    required this.isSelecting,
    required this.onToggleSelection,
  });

  final int totalCards;
  final bool isSelecting;
  final VoidCallback onToggleSelection;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cards',
              style: context.headlineMedium?.copyWith(
                fontWeight: context.bold,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: context.spaceXs / 2),
            Text(
              '$totalCards Cards stored locally',
              style: context.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: context.medium,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onToggleSelection,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            textStyle: context.labelLarge?.copyWith(fontWeight: context.bold),
          ),
          child: Text(isSelecting ? 'Cancel' : 'Select'),
        ),
      ],
    );
  }
}
