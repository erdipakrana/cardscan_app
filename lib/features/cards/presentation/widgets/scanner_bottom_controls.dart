import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/scanner_action_controls.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/scanner_privacy_badge.dart';

class ScannerBottomControls extends StatelessWidget {
  const ScannerBottomControls({
    super.key,
    required this.isLoading,
    required this.onPickImage,
    required this.onCapture,
    required this.onManualEntry,
  });

  final bool isLoading;
  final ValueChanged<ImageSource> onPickImage;
  final VoidCallback onCapture;
  final VoidCallback onManualEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          Padding(
            padding: EdgeInsets.only(bottom: context.spaceLg),
            child: CircularProgressIndicator(color: context.intelligenceTeal),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScannerActionButton(
                icon: Icons.image,
                label: 'Gallery',
                onPressed: () => onPickImage(ImageSource.gallery),
              ),
              ScannerShutterButton(onPressed: onCapture),
              ScannerActionButton(
                icon: Icons.edit_note,
                label: 'Manual',
                onPressed: onManualEntry,
              ),
            ],
          ),
        context.verticalGapLg,
        const ScannerPrivacyBadge(),
      ],
    );
  }
}
