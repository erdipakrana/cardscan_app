import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class ScannerCameraPreview extends StatelessWidget {
  const ScannerCameraPreview({
    super.key,
    required this.image,
    this.placeholderUrl = _defaultPlaceholderUrl,
  });

  static const _defaultPlaceholderUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBnSOhN_M7UaG0sO7gDQpSsZzuKnvrlJKcXgYRfNro5Yus96vDWk8a9nzjOt6jxw5RwLsYK24OFOjOXRgyMBmkgeLfQCTXmi5VxrrnkQbJOaRvZrElONBcocfrheQUdtEXhmcDAV5dCpOHmmthflMT7Wc5lSemAlOeUHpb1vSxzatin7Q-qzrTDUkS5RMxQuBm6mBqScLQYEnb1D11eorI22Ab6m1NQe3wx4D23r80VdO4QObfIrBb_Hw';

  final XFile? image;
  final String placeholderUrl;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: kIsWeb
                ? NetworkImage(image!.path)
                : FileImage(File(image!.path)) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Image.network(
      placeholderUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade900,
        child: Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.white54,
            size: context.spaceXl * 2,
          ),
        ),
      ),
    );
  }
}
