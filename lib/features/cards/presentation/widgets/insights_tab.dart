import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';
import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/card_avatar.dart';

class InsightsTab extends StatelessWidget {
  const InsightsTab({super.key, required this.cards});

  final List<VisitingCard> cards;

  @override
  Widget build(BuildContext context) {
    final totalCards = cards.length;
    final companies = cards
        .map((card) => card.company)
        .where((company) => company != null && company.isNotEmpty)
        .toSet()
        .length;

    return SingleChildScrollView(
      padding: context.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insights',
            style: context.headlineMedium?.copyWith(fontWeight: context.bold),
          ),
          context.verticalGapSm,
          Text(
            'Analyze your scanned connections',
            style: TextStyle(color: context.colors.onSurfaceVariant),
          ),
          context.verticalGapLg,
          Row(
            children: [
              Expanded(
                child: _InsightStatCard(
                  label: 'Total Cards',
                  value: '$totalCards',
                  icon: Icons.style,
                  color: Colors.blue,
                ),
              ),
              context.horizontalGapMd,
              Expanded(
                child: _InsightStatCard(
                  label: 'Companies',
                  value: '$companies',
                  icon: Icons.business,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          context.verticalGapLg,
          _RecentlyScannedCard(cards: cards),
        ],
      ),
    );
  }
}

class _InsightStatCard extends StatelessWidget {
  const _InsightStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Container(
      padding: EdgeInsets.all(context.horizontalMargin),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: context.radiusLgAll,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: context.paddingSm,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: context.iconSizeLg),
          ),
          context.verticalGapMd,
          Text(
            value,
            style: context.headlineSmall?.copyWith(fontWeight: context.bold),
          ),
          context.verticalGapXs,
          Text(
            label,
            style: context.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentlyScannedCard extends StatelessWidget {
  const _RecentlyScannedCard({required this.cards});

  final List<VisitingCard> cards;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.horizontalMargin),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: context.radiusLgAll,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recently Scanned',
            style: context.titleMedium?.copyWith(fontWeight: context.bold),
          ),
          context.verticalGapMd,
          if (cards.isEmpty)
            const Text('No stats available yet.')
          else
            ...cards.take(3).map((card) => _RecentlyScannedTile(card: card)),
        ],
      ),
    );
  }
}

class _RecentlyScannedTile extends StatelessWidget {
  const _RecentlyScannedTile({required this.card});

  final VisitingCard card;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spaceSm),
      child: Row(
        children: [
          CardAvatar(
            card: card,
            size: context.spaceXl,
            borderRadius: context.radiusLg,
          ),
          SizedBox(width: context.spaceMd - context.spaceXs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.name,
                  style: context.labelLarge?.copyWith(
                    fontWeight: context.semiBold,
                  ),
                ),
                if (card.company != null && card.company!.isNotEmpty)
                  Text(
                    card.company!,
                    style: context.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
