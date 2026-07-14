import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cardscan_app/core/widgets/app_glass_icon_button.dart';
import 'package:cardscan_app/features/cards/presentation/controllers/cards_providers.dart';
import 'package:cardscan_app/features/cards/presentation/pages/review_details_page.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/scanner_bottom_controls.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/scanner_camera_preview.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/scanner_frame.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/scanner_guide_text.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/scanner_overlay.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/scanner_status_badge.dart';

class CardScannerPage extends ConsumerStatefulWidget {
  const CardScannerPage({super.key});

  @override
  ConsumerState<CardScannerPage> createState() => _CardScannerPageState();
}

class _CardScannerPageState extends ConsumerState<CardScannerPage> {
  static const _cardAspectRatio = 1.75;
  static const _horizontalPadding = 20.0;

  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(cardScannerControllerProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(cardScannerControllerProvider);
    final scannerNotifier = ref.read(cardScannerControllerProvider.notifier);
    final scannerFrame = _ScannerFrameMetrics.fromMediaQuery(
      MediaQuery.of(context),
    );

    ref.listen<CardScannerState>(
      cardScannerControllerProvider,
      _handleScannerStateChanged,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ScannerCameraPreview(image: scannerState.image),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(
                cutoutWidth: scannerFrame.width,
                cutoutHeight: scannerFrame.height,
              ),
            ),
          ),
          Center(
            child: ScannerFrame(
              width: scannerFrame.width,
              height: scannerFrame.height,
              isScanning: scannerState.isLoading,
            ),
          ),
          Positioned(
            top: scannerFrame.guideTop,
            left: 0,
            right: 0,
            child: const Center(child: ScannerGuideText()),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ScannerTopBar(
                      isFlashOn: _isFlashOn,
                      isDetected:
                          scannerState.image != null || scannerState.isScanned,
                      onClose: () => Navigator.pop(context),
                      onToggleFlash: _toggleFlash,
                    ),
                    ScannerBottomControls(
                      isLoading: scannerState.isLoading,
                      onPickImage: (source) =>
                          scannerNotifier.scanCard(source: source),
                      onCapture: () =>
                          scannerNotifier.scanCard(source: ImageSource.camera),
                      onManualEntry: () => _navigateToReview(scannerState),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleScannerStateChanged(
    CardScannerState? previous,
    CardScannerState next,
  ) {
    final errorMessage = next.errorMessage;
    if (errorMessage != null && errorMessage != previous?.errorMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    final hasNewScan =
        next.isScanned &&
        !next.isLoading &&
        next.extractedText.isNotEmpty &&
        (previous?.isLoading == true);
    if (hasNewScan) {
      _navigateToReview(next);
    }
  }

  void _navigateToReview(CardScannerState state) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewDetailsPage(
          imagePath: state.image?.path,
          initialName: state.name,
          initialJobTitle: state.jobTitle,
          initialCompany: state.company,
          initialEmail: state.email,
          initialPhone: state.phone,
          initialWebsite: state.website,
          rawOcrText: state.extractedText,
        ),
      ),
    );
  }

  void _toggleFlash() {
    setState(() => _isFlashOn = !_isFlashOn);
  }
}

class _ScannerFrameMetrics {
  const _ScannerFrameMetrics({
    required this.width,
    required this.height,
    required this.guideTop,
  });

  final double width;
  final double height;
  final double guideTop;

  factory _ScannerFrameMetrics.fromMediaQuery(MediaQueryData mediaQuery) {
    final width = mediaQuery.size.width * 0.9;
    final height = width / _CardScannerPageState._cardAspectRatio;
    final guideTop = (mediaQuery.size.height / 2) - (height / 2) - 40;

    return _ScannerFrameMetrics(
      width: width,
      height: height,
      guideTop: guideTop,
    );
  }
}

class _ScannerTopBar extends StatelessWidget {
  const _ScannerTopBar({
    required this.isFlashOn,
    required this.isDetected,
    required this.onClose,
    required this.onToggleFlash,
  });

  final bool isFlashOn;
  final bool isDetected;
  final VoidCallback onClose;
  final VoidCallback onToggleFlash;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppGlassIconButton(icon: Icons.close, onPressed: onClose),
        ScannerStatusBadge(isDetected: isDetected),
        AppGlassIconButton(
          icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
          onPressed: onToggleFlash,
        ),
      ],
    );
  }
}
