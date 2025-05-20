import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Text styles
  static TextStyle get headingLarge => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      );

  static TextStyle get headingMedium => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      );

  static TextStyle get headingSmall => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        color: AppColors.white,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        color: AppColors.white,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        color: AppColors.label,
      );

  // Button styles
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  static ButtonStyle get secondaryButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.inputFill,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  // Card styles
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // Input decoration
  static InputDecoration get inputDecoration => InputDecoration(
        filled: true,
        fillColor: AppColors.inputFill,
        hintStyle: const TextStyle(color: AppColors.hint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      );

  // Animation durations
  static Duration get fastAnimation => const Duration(milliseconds: 200);
  static Duration get mediumAnimation => const Duration(milliseconds: 300);
  static Duration get slowAnimation => const Duration(milliseconds: 500);

  // Spacing
  static double get spacingXS => 4;
  static double get spacingS => 8;
  static double get spacingM => 16;
  static double get spacingL => 24;
  static double get spacingXL => 32;
  static double get spacingXXL => 48;
}
