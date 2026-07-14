import 'package:flutter/material.dart';

class ReviewOcrPanel extends StatelessWidget {
  const ReviewOcrPanel({
    super.key,
    required this.rawOcrText,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  final String rawOcrText;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        InkWell(
          onTap: onToggleVisibility,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'RAW OCR VERIFICATION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.outline,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isVisible ? Icons.expand_less : Icons.expand_more,
                  color: colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          child: isVisible
              ? _OcrContent(rawOcrText: rawOcrText)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _OcrContent extends StatelessWidget {
  const _OcrContent({required this.rawOcrText});

  final String rawOcrText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rawOcrText,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              height: 1.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '[CONFIDENCE SCORE: 98.4%]',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
