import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardscan_app/features/cards/presentation/controllers/cards_providers.dart';
import 'package:cardscan_app/features/cards/presentation/pages/card_scanner_page.dart';
import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';

class SavedCardsPage extends ConsumerWidget {
  const SavedCardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(cardsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visiting Card Scanner'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Scan a new card',
        child: const Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CardScannerPage(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: cardsAsync.when(
          data: (cards) {
            if (cards.isEmpty) {
              return const _EmptyStateWidget();
            }
            return ListView.separated(
              itemCount: cards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final card = cards[index];
                return _CardItem(card: card);
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error loading cards: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.contact_mail_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No cards saved yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the camera icon to scan a visiting card.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardItem extends ConsumerWidget {
  final VisitingCard card;

  const _CardItem({required this.card});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleText = [
      if (card.jobTitle != null && card.jobTitle!.isNotEmpty) card.jobTitle,
      if (card.company != null && card.company!.isNotEmpty) card.company,
    ].join(' @ ');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        shape: const Border(), // Remove default expansion tile borders
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withAlpha(26),
          child: Text(
            card.name.isNotEmpty ? card.name[0].toUpperCase() : '?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        title: Text(
          card.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        subtitle: subtitleText.isNotEmpty
            ? Text(
                subtitleText,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              )
            : null,
        childrenPadding: const EdgeInsets.all(16),
        children: [
          // Structured Details List
          if (card.email != null && card.email!.isNotEmpty)
            _buildDetailRow(
              context,
              icon: Icons.email_outlined,
              label: 'Email',
              value: card.email!,
              onCopy: () => _copyToClipboard(context, card.email!, 'Email'),
            ),
          if (card.phone != null && card.phone!.isNotEmpty)
            _buildDetailRow(
              context,
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: card.phone!,
              onCopy: () => _copyToClipboard(context, card.phone!, 'Phone number'),
            ),
          if (card.website != null && card.website!.isNotEmpty)
            _buildDetailRow(
              context,
              icon: Icons.web_outlined,
              label: 'Website',
              value: card.website!,
              onCopy: () => _copyToClipboard(context, card.website!, 'Website link'),
            ),

          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          // Raw OCR Text section
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Raw Extracted Text:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    card.details,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.grey.shade800,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                icon: const Icon(Icons.delete_outline, size: 20),
                label: const Text('Delete'),
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  await ref.read(cardsRepositoryProvider).deleteCard(card.id);
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Card deleted successfully!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            color: Theme.of(context).primaryColor,
            tooltip: 'Copy $label',
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}
