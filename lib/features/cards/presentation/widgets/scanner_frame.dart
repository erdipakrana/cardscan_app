import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class ScannerFrame extends StatelessWidget {
  const ScannerFrame({
    super.key,
    required this.width,
    required this.height,
    required this.isScanning,
  });

  final double width;
  final double height;
  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: -2,
            left: -2,
            child: ScannerFrameCorner(top: true, left: true),
          ),
          const Positioned(
            top: -2,
            right: -2,
            child: ScannerFrameCorner(top: true, left: false),
          ),
          const Positioned(
            bottom: -2,
            left: -2,
            child: ScannerFrameCorner(top: false, left: true),
          ),
          const Positioned(
            bottom: -2,
            right: -2,
            child: ScannerFrameCorner(top: false, left: false),
          ),
          if (isScanning) const Positioned.fill(child: ScanningLineAnimator()),
        ],
      ),
    );
  }
}

class ScannerFrameCorner extends StatelessWidget {
  const ScannerFrameCorner({super.key, required this.top, required this.left});

  final bool top;
  final bool left;

  @override
  Widget build(BuildContext context) {
    final cornerColor = context.intelligenceTeal;

    return Container(
      width: context.spaceLg,
      height: context.spaceLg,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: cornerColor.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _CornerPainter(
          top: top,
          left: left,
          thickness: 4,
          color: cornerColor,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter({
    required this.top,
    required this.left,
    required this.thickness,
    required this.color,
  });

  final bool top;
  final bool left;
  final double thickness;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (top && left) {
      path
        ..moveTo(0, size.height)
        ..lineTo(0, 0)
        ..lineTo(size.width, 0);
    } else if (top && !left) {
      path
        ..moveTo(size.width, size.height)
        ..lineTo(size.width, 0)
        ..lineTo(0, 0);
    } else if (!top && left) {
      path
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height);
    } else {
      path
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) {
    return top != oldDelegate.top ||
        left != oldDelegate.left ||
        thickness != oldDelegate.thickness ||
        color != oldDelegate.color;
  }
}

class ScanningLineAnimator extends StatefulWidget {
  const ScanningLineAnimator({super.key});

  @override
  State<ScanningLineAnimator> createState() => _ScanningLineAnimatorState();
}

class _ScanningLineAnimatorState extends State<ScanningLineAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(painter: _ScanningLinePainter(_controller.value));
      },
    );
  }
}

class _ScanningLinePainter extends CustomPainter {
  const _ScanningLinePainter(this.percent);

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF50DCFF).withValues(alpha: 0),
          const Color(0xFF50DCFF).withValues(alpha: 0.6),
          const Color(0xFF50DCFF).withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * percent, size.width, 4))
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(0, size.height * percent),
      Offset(size.width, size.height * percent),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanningLinePainter oldDelegate) {
    return percent != oldDelegate.percent;
  }
}
