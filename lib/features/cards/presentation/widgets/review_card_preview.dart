import 'dart:io' show File;

import 'package:flutter/material.dart';

class ReviewCardPreview extends StatelessWidget {
  const ReviewCardPreview({
    super.key,
    required this.imagePath,
    this.placeholderUrl = _defaultPlaceholderUrl,
  });

  static const _defaultPlaceholderUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCvP3wq0AoVuGJZywjjMsOmx2mXVsHhHgXVpR333CblM2-gWRNvz32hsjenS_xCO_tMPgZ8_wvtR5W85BeJD5KY4Jv3CLOUbYVE04dS77QTvVb9xWzFe8GgTaSfMOYbsBDHLev7PmoiOFjIJV9av4cRttsRsMOoWGBgAso2pSLLu1gxqj4gSOq4L7GV3_bteoB7c2vKEhtoeeNzF31azt48FcHrRvEylzydN4qZEkwGUC9JRP7umRpDBQ';

  final String? imagePath;
  final String placeholderUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1.75,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imagePath != null
                  ? Image.file(File(imagePath!), fit: BoxFit.cover)
                  : Image.network(placeholderUrl, fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  'Card Scan Preview',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
