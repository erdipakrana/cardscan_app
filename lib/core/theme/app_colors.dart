import 'package:flutter/material.dart';

/// Raw color tokens from the "Core Intelligence" design system (DESIGN.md).
///
/// These are the source of truth. Do not use `Colors.*` or hard-coded hex
/// values in widgets — reference [AppColors] or, preferably, the resolved
/// `Theme.of(context).colorScheme` produced in [app_theme.dart].
abstract final class AppColors {
  // --- Brand accents (from the prose "Colors" section) ---------------------
  /// Key actions and brand presence.
  static const Color primaryBlue = Color(0xFF0052CC);

  /// "Active intelligence" — scan progress, OCR highlights, extraction pulses.
  static const Color intelligenceTeal = Color(0xFF00B8D9);

  /// Positive scanner feedback: a card edge has been detected.
  static const Color detectionGreen = Color(0xFF36B37E);

  /// Dark-mode base surface — "Deep Slate", not pure black.
  static const Color deepSlate = Color(0xFF161B22);

  /// Level-1 border in light mode (cards / list items).
  static const Color borderLight = Color(0xFFE1E4E8);

  // --- Material 3 scheme tokens (light) — from DESIGN.md frontmatter --------
  static const Color primary = Color(0xFF003D9B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0052CC);
  static const Color onPrimaryContainer = Color(0xFFC4D2FF);
  static const Color inversePrimary = Color(0xFFB2C5FF);

  static const Color secondary = Color(0xFF00687B);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF50DCFF);
  static const Color onSecondaryContainer = Color(0xFF005F71);

  static const Color tertiary = Color(0xFF7B2600);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFA33500);
  static const Color onTertiaryContainer = Color(0xFFFFC6B2);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color surface = Color(0xFFFAF9FF);
  static const Color onSurface = Color(0xFF051A3E);
  static const Color surfaceDim = Color(0xFFCCDAFF);
  static const Color surfaceBright = Color(0xFFFAF9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F3FF);
  static const Color surfaceContainer = Color(0xFFE9EDFF);
  static const Color surfaceContainerHigh = Color(0xFFE1E8FF);
  static const Color surfaceContainerHighest = Color(0xFFD8E2FF);
  static const Color onSurfaceVariant = Color(0xFF434654);
  static const Color surfaceTint = Color(0xFF0C56D0);

  static const Color outline = Color(0xFF737685);
  static const Color outlineVariant = Color(0xFFC3C6D6);

  static const Color inverseSurface = Color(0xFF1D3054);
  static const Color inverseOnSurface = Color(0xFFEDF0FF);
}
