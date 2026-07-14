import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class CardFilterChips extends StatelessWidget {
  const CardFilterChips({
    super.key,
    required this.filters,
    required this.activeFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String activeFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var index = 0; index < filters.length; index++) ...[
            _CardFilterChip(
              label: filters[index],
              isSelected: activeFilter == filters[index],
              icon: index == 0 ? Icons.check : null,
              onSelected: () => onSelected(filters[index]),
            ),
            if (index < filters.length - 1) context.horizontalGapSm,
          ],
        ],
      ),
    );
  }
}

class _CardFilterChip extends StatelessWidget {
  const _CardFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      avatar: icon != null && isSelected
          ? Icon(icon, size: context.iconSizeSm, color: colorScheme.onPrimary)
          : null,
      onSelected: (value) {
        if (value) onSelected();
      },
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.3,
      ),
      labelStyle: context.labelSmall?.copyWith(
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
        fontWeight: context.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: context.radiusFullAll),
      side: BorderSide.none,
      showCheckmark: false,
    );
  }
}
