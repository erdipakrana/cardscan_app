import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: context.spaceXl * 3,
            height: context.spaceXl * 3,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: context.spaceLg * 2,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          context.verticalGapLg,
          Text(
            title,
            style: context.titleLarge?.copyWith(fontWeight: context.bold),
          ),
          context.verticalGapSm,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spaceLg * 2),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
