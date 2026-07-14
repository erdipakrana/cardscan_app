import 'package:flutter/widgets.dart';

/// Spacing scale from the design system — a strict **4px baseline grid**.
///
/// Use these instead of raw numbers so vertical rhythm stays mathematical:
/// 16px between related fields, 32px between sections (DESIGN.md "Layout").
abstract final class AppSpacing {
  static const double base = 4;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// Column gutter for the mobile fluid grid.
  static const double gutter = 16;

  /// Side margins.
  static const double marginMobile = 20;
  static const double marginTablet = 32;

  /// Camera "Safe Area" inset so controls never overlap detection corners.
  static const double scannerSafeArea = 24;
}

/// Corner-radius scale — "Optimized Geometric" shape language.
abstract final class AppRadii {
  static const double sm = 4; // tags, selection indicators (crisp)
  static const double def = 8; // default containers
  static const double md = 12; // buttons, cards (premium card feel)
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius defAll = BorderRadius.all(Radius.circular(def));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
}
