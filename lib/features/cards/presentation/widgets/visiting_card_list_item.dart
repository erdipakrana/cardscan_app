import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';
import 'package:cardscan_app/core/utils/export_helper.dart';
import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/card_avatar.dart';

class VisitingCardListItem extends StatelessWidget {
  const VisitingCardListItem({
    super.key,
    required this.card,
    required this.isExpanded,
    required this.isSelecting,
    required this.isSelected,
    required this.onTap,
    required this.onCopy,
    required this.onSaveContact,
    required this.onDelete,
  });

  final VisitingCard card;
  final bool isExpanded;
  final bool isSelecting;
  final bool isSelected;
  final VoidCallback onTap;
  final void Function(String text, String label) onCopy;
  final Future<bool> Function(VisitingCard card) onSaveContact;
  final Future<void> Function(VisitingCard card) onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.only(bottom: context.spaceMd - context.spaceXs),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: context.radiusLgAll,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : const Color(0xFFC3C6D6).withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: context.radiusLgAll,
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: context.paddingMd,
                child: Row(
                  children: [
                    if (isSelecting) ...[
                      Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: context.spaceMd - context.spaceXs),
                    ],
                    CardAvatar(card: card),
                    context.horizontalGapMd,
                    Expanded(child: _CardSummary(card: card)),
                    if (!isSelecting) _QuickActions(card: card, onCopy: onCopy),
                  ],
                ),
              ),
            ),
            if (isExpanded && !isSelecting) ...[
              const Divider(height: 1),
              _ExpandedCardDetails(
                card: card,
                onCopy: onCopy,
                onSaveContact: onSaveContact,
                onDelete: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardSummary extends StatelessWidget {
  const _CardSummary({required this.card});

  final VisitingCard card;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.name,
          style: context.titleMedium?.copyWith(
            fontWeight: context.bold,
            color: colorScheme.onSurface,
          ),
        ),
        if (card.jobTitle != null && card.jobTitle!.isNotEmpty) ...[
          SizedBox(height: context.spaceXs / 2),
          Text(
            card.jobTitle!,
            style: context.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (card.company != null && card.company!.isNotEmpty) ...[
          context.verticalGapXs,
          Text(
            card.company!,
            style: context.labelSmall?.copyWith(
              fontWeight: context.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.card, required this.onCopy});

  final VisitingCard card;
  final void Function(String text, String label) onCopy;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (card.phone != null && card.phone!.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.call_outlined, size: 20),
            onPressed: () => onCopy(card.phone!, 'Phone number'),
          ),
        if (card.email != null && card.email!.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.mail_outlined, size: 20),
            onPressed: () => onCopy(card.email!, 'Email'),
          ),
      ],
    );
  }
}

class _ExpandedCardDetails extends StatelessWidget {
  const _ExpandedCardDetails({
    required this.card,
    required this.onCopy,
    required this.onSaveContact,
    required this.onDelete,
  });

  final VisitingCard card;
  final void Function(String text, String label) onCopy;
  final Future<bool> Function(VisitingCard card) onSaveContact;
  final Future<void> Function(VisitingCard card) onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Padding(
      padding: context.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (card.email != null && card.email!.isNotEmpty)
            _DetailRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: card.email!,
              onCopy: () => onCopy(card.email!, 'Email'),
            ),
          if (card.phone != null && card.phone!.isNotEmpty)
            _DetailRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: card.phone!,
              onCopy: () => onCopy(card.phone!, 'Phone'),
            ),
          if (card.website != null && card.website!.isNotEmpty)
            _DetailRow(
              icon: Icons.language_outlined,
              label: 'Website',
              value: card.website!,
              onCopy: () => onCopy(card.website!, 'Website'),
            ),
          SizedBox(height: context.spaceMd - context.spaceXs),
          const Divider(),
          SizedBox(height: context.spaceMd - context.spaceXs),
          Text(
            'Raw Extracted Text:',
            style: context.labelSmall?.copyWith(
              fontWeight: context.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spaceSm - 2),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.spaceMd - context.spaceXs),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              borderRadius: context.radiusDefaultAll,
            ),
            child: Text(
              card.details,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ),
          context.verticalGapMd,
          _CardActions(
            card: card,
            onSaveContact: onSaveContact,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spaceXs),
      child: Row(
        children: [
          Icon(
            icon,
            size: context.iconSizeMd,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          SizedBox(width: context.spaceMd - context.spaceXs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  value,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: context.medium,
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.copy, size: 16), onPressed: onCopy),
        ],
      ),
    );
  }
}

class _CardActions extends StatelessWidget {
  const _CardActions({
    required this.card,
    required this.onSaveContact,
    required this.onDelete,
  });

  final VisitingCard card;
  final Future<bool> Function(VisitingCard card) onSaveContact;
  final Future<void> Function(VisitingCard card) onDelete;

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final success = await onSaveContact(card);
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  success ? 'Saved to Contacts!' : 'Failed to save to Contacts',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.person_add_outlined, size: 18),
          label: const Text('Save Contact'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: context.spaceMd,
              vertical: context.spaceSm,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () => ExportHelper.shareAsVCard(card),
        ),
        TextButton.icon(
          onPressed: () async {
            await onDelete(card);
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Card deleted successfully!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
          label: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
