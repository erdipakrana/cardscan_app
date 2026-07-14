import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';
import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';

class QuickInsightCard extends StatelessWidget {
  const QuickInsightCard({
    super.key,
    required this.cards,
    required this.onViewInsights,
  });

  final List<VisitingCard> cards;
  final VoidCallback onViewInsights;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final insightText = _buildInsightText(cards);

    return Container(
      decoration: BoxDecoration(
        borderRadius: context.radiusXlAll,
        gradient: LinearGradient(
          colors: [colorScheme.primaryContainer, colorScheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: context.paddingLg,
      child: Stack(
        children: [
          Positioned(
            right: -context.spaceLg,
            top: -context.spaceLg,
            child: Container(
              width: context.spaceXl * 3,
              height: context.spaceXl * 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QUICK INSIGHT',
                style: context.labelSmall?.copyWith(
                  fontWeight: context.bold,
                  letterSpacing: 1.5,
                  color: colorScheme.onPrimary.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: context.spaceMd - context.spaceXs),
              Text(
                insightText,
                style: context.titleMedium?.copyWith(
                  fontWeight: context.semiBold,
                  color: colorScheme.onPrimary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: context.spaceMd + context.spaceXs),
              ElevatedButton(
                onPressed: onViewInsights,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: colorScheme.primary,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.horizontalMargin,
                    vertical: context.spaceMd - context.spaceXs,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.radiusMd),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Insights',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildInsightText(List<VisitingCard> cards) {
    var favoriteCompany = '';
    var maxCount = 0;
    final companyCounts = <String, int>{};

    for (final card in cards) {
      final company = card.company?.trim();
      if (company == null || company.isEmpty) continue;

      companyCounts[company] = (companyCounts[company] ?? 0) + 1;
      if (companyCounts[company]! > maxCount) {
        maxCount = companyCounts[company]!;
        favoriteCompany = company;
      }
    }

    if (maxCount == 0) {
      return 'Start scanning cards to see smart insights here.';
    }
    return "You've added $maxCount contacts from $favoriteCompany.";
  }
}
