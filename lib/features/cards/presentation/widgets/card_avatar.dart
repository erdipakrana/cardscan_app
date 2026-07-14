import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';
import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';

class CardAvatar extends StatelessWidget {
  const CardAvatar({
    super.key,
    required this.card,
    this.size,
    this.borderRadius,
  });

  final VisitingCard card;
  final double? size;
  final double? borderRadius;

  static const _backgroundColors = [
    Color(0xFF50DCFF),
    Color(0xFFFFB59B),
    Color(0xFFDAE2FF),
    Color(0xFFB2C5FF),
    Color(0xFFBFE9FF),
  ];

  static const _textColors = [
    Color(0xFF005F71),
    Color(0xFF380D00),
    Color(0xFF0040A2),
    Color(0xFF001848),
    Color(0xFF004E5D),
  ];

  @override
  Widget build(BuildContext context) {
    final colorIndex = card.name.hashCode.abs() % _backgroundColors.length;
    final resolvedSize = size ?? context.spaceLg + context.spaceXl;
    final resolvedRadius = borderRadius ?? context.radiusMd;

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        color: _backgroundColors[colorIndex],
        borderRadius: BorderRadius.circular(resolvedRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(card.name),
        style: TextStyle(
          color: _textColors[colorIndex],
          fontWeight: context.bold,
          fontSize: resolvedSize <= 36 ? 12 : 18,
        ),
      ),
    );
  }

  String _initials(String name) {
    final value = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join()
        .toUpperCase();

    return value.isNotEmpty ? value : '?';
  }
}
