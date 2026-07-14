import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Convenient accessors for app-wide UI values from any [BuildContext].
///
/// Prefer these helpers in widgets to keep theme, spacing, sizing, and shape
/// usage consistent across the app.
extension AppBuildContextX on BuildContext {
  // Theme -------------------------------------------------------------------
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textStyles => theme.textTheme;
  IconThemeData get icons => theme.iconTheme;
  AppBarThemeData get appBar => theme.appBarTheme;
  CardThemeData get cards => theme.cardTheme;
  InputDecorationThemeData get inputs => theme.inputDecorationTheme;
  ElevatedButtonThemeData get elevatedButtons => theme.elevatedButtonTheme;
  FloatingActionButtonThemeData get floatingActionButtons =>
      theme.floatingActionButtonTheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => theme.brightness == Brightness.light;

  // Media -------------------------------------------------------------------
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  Orientation get orientation => mediaQuery.orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // Breakpoints -------------------------------------------------------------
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  // App color tokens --------------------------------------------------------
  Color get primaryBlue => AppColors.primaryBlue;
  Color get intelligenceTeal => AppColors.intelligenceTeal;
  Color get detectionGreen => AppColors.detectionGreen;
  Color get scannerGreen => AppColors.detectionGreen;
  Color get deepSlate => AppColors.deepSlate;
  Color get borderLight => AppColors.borderLight;

  // Frequently used Material colors ----------------------------------------
  Color get primaryColor => colors.primary;
  Color get onPrimaryColor => colors.onPrimary;
  Color get secondaryColor => colors.secondary;
  Color get onSecondaryColor => colors.onSecondary;
  Color get tertiaryColor => colors.tertiary;
  Color get onTertiaryColor => colors.onTertiary;
  Color get surfaceColor => colors.surface;
  Color get onSurfaceColor => colors.onSurface;
  Color get surfaceVariantColor => colors.surfaceContainerHighest;
  Color get onSurfaceVariantColor => colors.onSurfaceVariant;
  Color get outlineColor => colors.outline;
  Color get outlineVariantColor => colors.outlineVariant;
  Color get errorColor => colors.error;
  Color get onErrorColor => colors.onError;

  // Text styles -------------------------------------------------------------
  TextStyle? get displayLarge => textStyles.displayLarge;
  TextStyle? get displayMedium => textStyles.displayMedium;
  TextStyle? get displaySmall => textStyles.displaySmall;
  TextStyle? get headlineLarge => textStyles.headlineLarge;
  TextStyle? get headlineMedium => textStyles.headlineMedium;
  TextStyle? get headlineSmall => textStyles.headlineSmall;
  TextStyle? get titleLarge => textStyles.titleLarge;
  TextStyle? get titleMedium => textStyles.titleMedium;
  TextStyle? get titleSmall => textStyles.titleSmall;
  TextStyle? get bodyLarge => textStyles.bodyLarge;
  TextStyle? get bodyMedium => textStyles.bodyMedium;
  TextStyle? get bodySmall => textStyles.bodySmall;
  TextStyle? get labelLarge => textStyles.labelLarge;
  TextStyle? get labelMedium => textStyles.labelMedium;
  TextStyle? get labelSmall => textStyles.labelSmall;

  FontWeight get regular => FontWeight.w400;
  FontWeight get medium => FontWeight.w500;
  FontWeight get semiBold => FontWeight.w600;
  FontWeight get bold => FontWeight.w700;

  // Spacing -----------------------------------------------------------------
  double get spaceBase => AppSpacing.base;
  double get spaceXs => AppSpacing.xs;
  double get spaceSm => AppSpacing.sm;
  double get spaceMd => AppSpacing.md;
  double get spaceLg => AppSpacing.lg;
  double get spaceXl => AppSpacing.xl;
  double get gutter => AppSpacing.gutter;
  double get horizontalMargin =>
      isTablet || isDesktop ? AppSpacing.marginTablet : AppSpacing.marginMobile;
  double get scannerSafeArea => AppSpacing.scannerSafeArea;

  EdgeInsets get paddingXs => const EdgeInsets.all(AppSpacing.xs);
  EdgeInsets get paddingSm => const EdgeInsets.all(AppSpacing.sm);
  EdgeInsets get paddingMd => const EdgeInsets.all(AppSpacing.md);
  EdgeInsets get paddingLg => const EdgeInsets.all(AppSpacing.lg);
  EdgeInsets get paddingXl => const EdgeInsets.all(AppSpacing.xl);
  EdgeInsets get pagePadding =>
      EdgeInsets.symmetric(horizontal: horizontalMargin);
  EdgeInsets get sectionPadding => const EdgeInsets.all(AppSpacing.xl);
  EdgeInsets get cardPadding => const EdgeInsets.all(AppSpacing.md);

  SizedBox get gapXs => const SizedBox.square(dimension: AppSpacing.xs);
  SizedBox get gapSm => const SizedBox.square(dimension: AppSpacing.sm);
  SizedBox get gapMd => const SizedBox.square(dimension: AppSpacing.md);
  SizedBox get gapLg => const SizedBox.square(dimension: AppSpacing.lg);
  SizedBox get gapXl => const SizedBox.square(dimension: AppSpacing.xl);
  SizedBox get verticalGapXs => const SizedBox(height: AppSpacing.xs);
  SizedBox get verticalGapSm => const SizedBox(height: AppSpacing.sm);
  SizedBox get verticalGapMd => const SizedBox(height: AppSpacing.md);
  SizedBox get verticalGapLg => const SizedBox(height: AppSpacing.lg);
  SizedBox get verticalGapXl => const SizedBox(height: AppSpacing.xl);
  SizedBox get horizontalGapXs => const SizedBox(width: AppSpacing.xs);
  SizedBox get horizontalGapSm => const SizedBox(width: AppSpacing.sm);
  SizedBox get horizontalGapMd => const SizedBox(width: AppSpacing.md);
  SizedBox get horizontalGapLg => const SizedBox(width: AppSpacing.lg);
  SizedBox get horizontalGapXl => const SizedBox(width: AppSpacing.xl);

  // Shape and sizing --------------------------------------------------------
  double get radiusSm => AppRadii.sm;
  double get radiusDefault => AppRadii.def;
  double get radiusMd => AppRadii.md;
  double get radiusLg => AppRadii.lg;
  double get radiusXl => AppRadii.xl;
  double get radiusFull => AppRadii.full;

  BorderRadius get radiusSmAll => AppRadii.smAll;
  BorderRadius get radiusDefaultAll => AppRadii.defAll;
  BorderRadius get radiusMdAll => AppRadii.mdAll;
  BorderRadius get radiusLgAll => AppRadii.lgAll;
  BorderRadius get radiusXlAll => BorderRadius.circular(AppRadii.xl);
  BorderRadius get radiusFullAll => BorderRadius.circular(AppRadii.full);

  double get iconSizeSm => 16;
  double get iconSizeMd => 20;
  double get iconSizeLg => 24;
  double get minTapTarget => kMinInteractiveDimension;
  double get bottomSafeSpacing => safeAreaPadding.bottom + AppSpacing.md;
  double get topSafeSpacing => safeAreaPadding.top + AppSpacing.md;

  BorderSide get defaultBorder => BorderSide(color: outlineVariantColor);
  BorderSide get strongBorder => BorderSide(color: outlineColor);
  BoxShadow get softShadow => BoxShadow(
    color: Colors.black.withValues(alpha: isDarkMode ? 0.30 : 0.08),
    blurRadius: 24,
    offset: const Offset(0, 12),
  );
}
