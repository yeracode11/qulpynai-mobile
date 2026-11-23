import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.red,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.redSoft,
      onPrimaryContainer: AppColors.redDark,
      secondary: AppColors.teal,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.tealSoft,
      onSecondaryContainer: AppColors.tealDark,
      tertiary: AppColors.green,
      onTertiary: AppColors.white,
      error: AppColors.redDark,
      onError: AppColors.white,
      surface: AppColors.bg,
      onSurface: AppColors.ink,
      surfaceContainerLowest: AppColors.white,
      outline: AppColors.outline,
      outlineVariant: AppColors.line,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bg,
      fontFamily: 'Onest',
      splashFactory: InkSparkle.splashFactory,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.teal),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: const TextStyle(fontFamily: 'Onest', fontWeight: FontWeight.w600, color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
