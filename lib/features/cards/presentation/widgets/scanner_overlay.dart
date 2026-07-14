import 'package:flutter/material.dart';

import 'package:cardscan_app/core/theme/app_spacing.dart';
import 'package:cardscan_app/core/theme/build_context_extensions.dart';

class ScannerOverlayPainter extends CustomPainter {
  const ScannerOverlayPainter({
    required this.cutoutWidth,
    required this.cutoutHeight,
  });

  final double cutoutWidth;
  final double cutoutHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.5);
    final cutoutRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: cutoutWidth,
        height: cutoutHeight,
      ),
      Radius.circular(AppRadii.lg),
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(cutoutRect),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return cutoutWidth != oldDelegate.cutoutWidth ||
        cutoutHeight != oldDelegate.cutoutHeight;
  }
}

class ScannerCornerBracket extends StatelessWidget {
  const ScannerCornerBracket({
    super.key,
    required this.top,
    required this.left,
  });

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
